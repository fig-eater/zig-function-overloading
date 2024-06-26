// Created by fig / fig-eater / groakgames.
// https://github.com/fig-eater/zig-function-overloading
//
// This file is licensed under Unlicense
// See included LICENSE file or https://unlicense.org
// Attribution is appreciated but not required.

/// Explicit Function Overloading for Zig
///
/// Usage:
///
/// Import the `overloading` module or `overloading.zig` if saved locally.
/// Call `overloading.make` with a tuple of functions, `make` will return a function which when
/// called will call a function in the tuple with corresponding argument types.
///
/// All functions passed in the tuple must have the same return type.
/// Functions in the tuple cannot have the same arguments as others in the tuple.
/// If a function takes no arguments, pass `{}` into the overloaded function to call it.
/// If a function takes multiple arguments pass the arguments in a tuple.
/// If a function takes void as it's only argument pass in `.{{}}` into the overloaded function to
/// call it
///
/// Example:
///
///     const std = @import("std");
///     const overloading = @import("overloading");
///     fn addNoArgs() u32 {
///         return 0;
///     }
///     fn addU32(a: u32) u32 {
///         return a;
///     }
///     fn addU8Slice(as: []const u8) u32 {
///         var total: u32 = 0;
///         for (as) |a| total +|= a;
///         return total;
///     }
///     fn addOptionalU32(a: ?u32) u32 {
///         return if (a) |a_val| return a_val else 0;
///     }
///     fn addPtrU32(a_ptr: *u32) u32 {
///         return a_ptr.*;
///     }
///     fn addU32I32(a: u32, b: i32) u32 {
///         return a + @as(u32, @intCast(b));
///     }
///
///     fn printNoArgs() void {
///         std.debug.print("no args\n", .{});
///     }
///     fn printVoid(_: void) void {
///         std.debug.print("void\n", .{});
///     }
///     fn printU32(a: u32) void {
///         std.debug.print("{d}\n", .{a});
///     }
///     fn printU8Slice(a: []const u8) void {
///         std.debug.print("{s}\n", .{a});
///     }
///     fn printU32U32(a: u32, b: u32) void {
///         std.debug.print("{d} {d}\n", .{ a, b });
///     }
///
///     const myAdd = overloading.make(.{
///         addNoArgs,
///         addU32,
///         addU8Slice,
///         addOptionalU32,
///         addPtrU32,
///         addU32I32,
///     });
///
///     const myPrint = overloading.make(.{
///         printNoArgs,
///         printVoid,
///         printU32,
///         printU8Slice,
///         printU32U32,
///     });
///
///     pub fn main() void {
///         const optional_with_val: ?u32 = 555;
///         const optional_with_null: ?u32 = null;
///         var a: u32 = 5;
///         _ = myAdd({}); // returns 0
///         _ = myAdd(2); // returns 2
///         _ = myAdd("abc"); // returns 294
///         _ = myAdd(optional_with_val); // returns 555
///         _ = myAdd(optional_with_null); // returns 0
///         _ = myAdd(&a); // returns 5
///         _ = myAdd(.{ 5, 20 }); // returns 25
///
///         myPrint({}); // prints "no args"
///         myPrint(.{{}}); // prints "void"
///         myPrint(2); // prints "2"
///         myPrint("hello"); // prints "hello"
///         myPrint(.{ 3, 4 }); // prints "3 4"
///     }
pub fn make(comptime functions: anytype) fn (args: anytype) OverloadedFnReturnType(functions) {
    comptime {
        const ReturnType = OverloadedFnReturnType(functions);

        // get function entries from the functions tuple
        const function_entries = functions_fields: {
            switch (@typeInfo(@TypeOf(functions))) {
                .Struct => |s| if (s.is_tuple) break :functions_fields s.fields,
                else => {},
            }
            @compileError("Expected `functions` to be tuple found " ++
                @typeName(@TypeOf(functions)));
        };

        // Check for inconsistent function return types, make sure the tuple only has functions,
        // and set these function lists
        var void_function: ?usize = null;
        var void_arg_function: ?usize = null;
        var single_arg_functions: []const usize = &.{};
        var multi_arg_functions: []const usize = &.{};
        for (function_entries, 0..) |entry, i| {
            switch (@typeInfo(entry.type)) {
                .Fn => |func| {
                    if (func.return_type != ReturnType)
                        @compileError("inconsistent function return types, expected " ++
                            @typeName(ReturnType) ++ " found " ++ @typeName(func.return_type));

                    switch (func.params.len) {
                        0 => void_function = i,
                        1 => if (func.params[0].type == void) {
                            void_arg_function = i;
                        } else {
                            single_arg_functions = single_arg_functions ++ .{i};
                        },
                        else => multi_arg_functions = multi_arg_functions ++ .{i},
                    }
                },
                else => @compileError("Expected `functions` to be tuple of functions, found " ++
                    @typeName(entry.type)),
            }
        }

        // check for ambiguous function overloads
        if (function_entries.len > 1) {
            for (function_entries[0 .. function_entries.len - 1], 1..) |entry1, i| {
                for (function_entries[i..]) |entry2| {
                    if (hasSameArgs(entry1.type, entry2.type)) {
                        @compileError("Ambiguous function overload. Function " ++
                            @typeName(entry1.type) ++ " and " ++ @typeName(entry2.type) ++
                            " have same argument types");
                    }
                }
            }
        }

        const MatchingFunctionType = enum { none, single, multiple };

        return struct {
            fn overloadedFn(args: anytype) ReturnType {
                const func, const matching_type: MatchingFunctionType = comptime is_single_block: {
                    const ArgsType = @TypeOf(args);
                    const args_ti = @typeInfo(ArgsType);
                    if (args_ti == .Void) {
                        if (void_function) |func_idx| {
                            break :is_single_block .{ functions[func_idx], .none };
                        }
                        @compileError("no zero argument function overload");
                    }

                    for (single_arg_functions) |func_idx| {
                        const func_ti = @typeInfo(@TypeOf(functions[func_idx])).Fn;
                        if (isConvertibleTo(ArgsType, func_ti.params[0].type.?)) {
                            break :is_single_block .{ functions[func_idx], .single };
                        }
                    }

                    if (args_ti == .Struct) {
                        multi_arg_function_loop: for (multi_arg_functions) |func_idx| {
                            const func_ti = @typeInfo(@TypeOf(functions[func_idx])).Fn;
                            if (func_ti.params.len == args_ti.Struct.fields.len) {
                                for (
                                    args_ti.Struct.fields,
                                    func_ti.params,
                                ) |arg_field, func_param| {
                                    if (!isConvertibleTo(arg_field.type, func_param.type.?)) {
                                        continue :multi_arg_function_loop;
                                    }
                                }
                                break :is_single_block .{ functions[func_idx], .multiple };
                            }
                        }
                    }

                    // special case for if function takes in void as argument
                    if (void_arg_function != null and args_ti == .Struct and args_ti.Struct.is_tuple) {
                        const args_struct = args_ti.Struct;
                        if (args_struct.fields.len == 1 and args_struct.fields[0].type == void) {
                            break :is_single_block .{ functions[void_arg_function.?], .multiple };
                        }
                    }

                    @compileError("no matching function overload for " ++ @typeName(ArgsType));
                };

                switch (matching_type) {
                    .none => return @call(.auto, func, .{}),
                    .single => return @call(.auto, func, .{args}),
                    .multiple => return @call(.auto, func, args),
                }
            }
        }.overloadedFn;
    }
}

fn hasSameArgs(comptime a: anytype, comptime b: anytype) bool {
    if (a == b) return true;
    const ati = @typeInfo(a);
    const bti = @typeInfo(b);
    if (ati != .Fn or bti != .Fn) @compileError("a and b must be functions");

    if (ati.Fn.params.len != bti.Fn.params.len) return false;

    for (ati.Fn.params, bti.Fn.params) |ap, bp| {
        if (ap.type != bp.type) return false;
    }
    return true;
}

fn OverloadedFnReturnType(comptime functions: anytype) type {
    comptime switch (@typeInfo(@TypeOf(functions))) {
        .Struct => |s| {
            if (s.fields.len <= 0) return noreturn;
            switch (@typeInfo(s.fields[0].type)) {
                .Fn => |f| return if (f.return_type) |rt| rt else void,
                else => return noreturn,
            }
        },
        else => return noreturn,
    };
}

pub fn isConvertibleTo(comptime From: type, comptime To: type) bool {
    return comptime return_block: {
        if (From == To) break :return_block true;
        const from_type_info = @typeInfo(From);
        const to_type_info = @typeInfo(To);

        break :return_block switch (to_type_info) {
            .Optional => |to| {
                if (isConvertibleTo(From, to.child)) break :return_block true;

                // check if converting c-pointer to optional pointer
                if (from_type_info == .Pointer and from_type_info.Pointer.is_allowzero) {
                    break :return_block isPointerConvertibleTo(From, to.child, false, false);
                }
                break :return_block false;
            },
            .ComptimeInt, .ComptimeFloat => To == From, // this should be handled above From == To
            .Int => |to| switch (from_type_info) {
                .Int => |from| from.bits == to.bits and
                    from.signedness == to.signedness,
                .ComptimeInt => true,
                else => false,
            },
            .Float => |to| switch (from_type_info) {
                .Float => |from| from.bits == to.bits,
                .ComptimeFloat => true,
                else => false,
            },
            .Pointer => |_| switch (from_type_info) {
                // BAD BAD BAD
                // .Array => |from| {
                //     if (!isConvertibleTo(from.child, to.child)) break :return_block false;
                //     break :return_block true;
                // },
                .Pointer => isPointerConvertibleTo(From, To, true, false),
                .Optional => |from| if (@typeInfo(from.child) == .Pointer)
                    isPointerConvertibleTo(from.child, To, false, true)
                else
                    false,
                else => false,
            },
            // .Array => |to| switch (from_type_info) {
            //     .Array => |from| from.
            // },
            .ErrorUnion => |to| isConvertibleTo(From, to.error_set) or
                isConvertibleTo(From, to.payload),
            else => false,
        };
    };
}

fn isPointerConvertibleTo(
    comptime From: type,
    comptime To: type,
    comptime check_allowzero_match: bool,
    comptime only_allow_to_c_ptr: bool,
) bool {
    return comptime return_block: {
        const from = @typeInfo(From).Pointer;
        const to = @typeInfo(To).Pointer;

        const from_child_type_info = @typeInfo(from.child);
        const from_array_ptr_to_slice = from_child_type_info == .Array and
            isConvertibleTo(from_child_type_info.Array.child, to.child);

        // if FROM is const, make sure TO is const
        if (from.is_const and !to.is_const) break :return_block false;

        // if TO is expected to be volatile make sure FROM is volatile
        if (to.is_volatile and !from.is_volatile) break :return_block false;

        // make sure alignment matches
        if (to.alignment != from.alignment) break :return_block false;

        // make sure address space matches
        if (to.address_space != from.address_space) break :return_block false;

        // if FROM can allow zero, make sure TO can allow zero
        if (check_allowzero_match and (from.is_allowzero and !to.is_allowzero))
            break :return_block false;

        // if assigning to a pointer with a sentinel
        // make sure from has a matching sentinel
        // otherwise, they are not convertible
        if (to.sentinel) |to_sentinel| {
            if (if (from_array_ptr_to_slice)
                from_child_type_info.Array.sentinel
            else
                from.sentinel) |from_sentinel|
            {
                if (!@import("std").mem.eql(
                    to.child,
                    @as(*const to.child, @ptrCast(@alignCast(from_sentinel)))[0..1],
                    @as(*const to.child, @ptrCast(@alignCast(to_sentinel)))[0..1],
                )) break :return_block false;
            } else break :return_block false;
        }

        if (!from_array_ptr_to_slice) {
            if (only_allow_to_c_ptr) {
                if (to.size != .C) break :return_block false;
                switch (from.size) {
                    .One => {},
                    .Many => {},
                    .Slice => break :return_block false,
                    .C => {},
                }
            } else if (!switch (from.size) {
                .One => switch (to.size) {
                    .One => true,
                    .Many => false,
                    .Slice => false,
                    .C => true,
                },
                .Many => switch (to.size) {
                    .One => false,
                    .Many => true,
                    .Slice => false,
                    .C => true,
                },
                .Slice => switch (to.size) {
                    .One => false,
                    // slice to many is only convertible they both have matching
                    // sentinels. the matching sentinel check is done above. so if
                    // to has a sentinel then from has a matching sentinel.
                    .Many => to.sentinel != null,
                    .Slice => true,
                    .C => false,
                },
                .C => switch (to.size) {
                    // although C pointers ARE convertible to single pointers and
                    // many pointers,
                    // if they are null, they will cause an error when converting
                    // so we won't allow this by default, only when check_allowzero_match is false.
                    .One => !check_allowzero_match,
                    .Many => !check_allowzero_match,
                    .Slice => false,
                    .C => true,
                },
            }) break :return_block false;

            // if pointer to array
            if (!isConvertibleTo(from.child, to.child)) break :return_block false;
        }

        break :return_block true;
    };
}
