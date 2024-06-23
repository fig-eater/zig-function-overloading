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
///
/// Example:
///
///     const overloading = @import("overloading");
///
///     fn add0() i32 {
///         return 0;
///     }
///     fn add1(a: i32) i32 {
///         return a;
///     }
///     fn add2(a: i32, b: i32) i32 {
///         return a + b;
///     }
///     fn add3(a: i32, b: i32, c: i32) i32 {
///         return a + b + c;
///     }
///
///     // create the overloaded add function
///     const add = overloading.make(.{
///         add0,
///         add1,
///         add2,
///         add3,
///     });
///
///     // add({})             returns 0
///     // add(3)              returns 3
///     // add(.{50, 2})       returns 52
///     // add(.{100, 20, 20}) returns 140
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
                        1 => single_arg_functions = single_arg_functions ++ .{i},
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
            .Optional => |to| isConvertibleTo(From, to.child),
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
            .Pointer => |to| switch (from_type_info) {
                .Array => |from| {
                    // from.
                    if (!isConvertibleTo(from.child, to.child)) break :return_block false;
                    break :return_block true;
                },
                .Pointer => |from| {
                    if (to.alignment != from.alignment) break :return_block false;

                    // // is_allowzero is for [*c] pointers
                    // // if TO is a [*c] pointer make sure from is one too
                    // if (to.is_allowzero and !from.is_allowzero) break :return_block false;

                    // if FROM is const, make sure TO is const
                    if (from.is_const and !to.is_const) break :return_block false;

                    // if TO is expected to be volatile make sure FROM is volatile
                    if (to.is_volatile and !from.is_volatile) break :return_block false;

                    // if (to.sentinel) |s| {
                    // if (from.sentinel) |s2| {
                    //     // @ptrCast(value: anytype)
                    // }
                    // }

                    if (to.address_space != from.address_space) break :return_block false;

                    if (to.size == .C) {}

                    // if pointer to array
                    if (@typeInfo(from.child) == .Array) {
                        if (!isConvertibleTo(from.child, To)) break :return_block false;
                    } else {
                        if (!isConvertibleTo(from.child, to.child)) break :return_block false;
                    }

                    break :return_block true;
                },
                else => false,
            },
            // .Array => |to| switch (from_type_info) {
            //     .Array => |from| from.
            // },
            else => false,
        };
    };
}
