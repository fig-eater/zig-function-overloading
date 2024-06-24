// separate file for tests since these are a bit exhaustive
// frame and anyframe types are not tested as they are not currently supported by the language

const std = @import("std");
const testing = std.testing;
const isConvertibleTo = @import("overloading.zig").isConvertibleTo;

test "isConvertibleTo type" {
    try testing.expect(isConvertibleTo(type, type));
    try testing.expect(isConvertibleTo(type, ?type));

    try testing.expect(!isConvertibleTo(?type, type));
    try testing.expect(!isConvertibleTo(*type, type));
    try testing.expect(!isConvertibleTo([*]type, type));
    try testing.expect(!isConvertibleTo([*:type]type, type));
    try testing.expect(!isConvertibleTo([2]type, type));

    try testing.expect(!isConvertibleTo(void, type));
    try testing.expect(!isConvertibleTo(bool, type));
    try testing.expect(!isConvertibleTo(noreturn, type));
    try testing.expect(!isConvertibleTo(i32, type));
    try testing.expect(!isConvertibleTo(u32, type));
    try testing.expect(!isConvertibleTo(f32, type));
    try testing.expect(!isConvertibleTo(struct {}, type));
    try testing.expect(!isConvertibleTo(comptime_float, type));
    try testing.expect(!isConvertibleTo(comptime_int, type));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), type));
    try testing.expect(!isConvertibleTo(@TypeOf(null), type));
    try testing.expect(!isConvertibleTo(anyerror!u32, type));
    try testing.expect(!isConvertibleTo(error{}, type));
    try testing.expect(!isConvertibleTo(enum {}, type));
    try testing.expect(!isConvertibleTo(union {}, type));
    try testing.expect(!isConvertibleTo(fn () void, type));
    try testing.expect(!isConvertibleTo(anyopaque, type));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), type));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), type));
}

test "isConvertibleTo void" {
    try testing.expect(isConvertibleTo(void, void));
    try testing.expect(isConvertibleTo(void, ?void));

    try testing.expect(!isConvertibleTo(?void, void));
    try testing.expect(!isConvertibleTo(*void, void));
    try testing.expect(!isConvertibleTo([*]void, void));
    try testing.expect(!isConvertibleTo([*:{}]void, void));
    try testing.expect(!isConvertibleTo([2]void, void));

    try testing.expect(!isConvertibleTo(type, void));
    try testing.expect(!isConvertibleTo(bool, void));
    try testing.expect(!isConvertibleTo(noreturn, void));
    try testing.expect(!isConvertibleTo(i32, void));
    try testing.expect(!isConvertibleTo(u32, void));
    try testing.expect(!isConvertibleTo(f32, void));
    try testing.expect(!isConvertibleTo(struct {}, void));
    try testing.expect(!isConvertibleTo(comptime_float, void));
    try testing.expect(!isConvertibleTo(comptime_int, void));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), void));
    try testing.expect(!isConvertibleTo(@TypeOf(null), void));
    try testing.expect(!isConvertibleTo(anyerror!u32, void));
    try testing.expect(!isConvertibleTo(error{}, void));
    try testing.expect(!isConvertibleTo(enum {}, void));
    try testing.expect(!isConvertibleTo(union {}, void));
    try testing.expect(!isConvertibleTo(fn () void, void));
    try testing.expect(!isConvertibleTo(anyopaque, void));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), void));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), void));
}

test "isConvertibleTo bool" {
    try testing.expect(isConvertibleTo(bool, bool));
    try testing.expect(isConvertibleTo(bool, ?bool));

    try testing.expect(!isConvertibleTo(?bool, bool));
    try testing.expect(!isConvertibleTo(*bool, bool));
    try testing.expect(!isConvertibleTo([*]bool, bool));
    try testing.expect(!isConvertibleTo([*:true]bool, bool));
    try testing.expect(!isConvertibleTo([*c]bool, bool));
    try testing.expect(!isConvertibleTo([2]bool, bool));

    try testing.expect(!isConvertibleTo(type, bool));
    try testing.expect(!isConvertibleTo(void, bool));
    try testing.expect(!isConvertibleTo(noreturn, bool));
    try testing.expect(!isConvertibleTo(i32, bool));
    try testing.expect(!isConvertibleTo(u32, bool));
    try testing.expect(!isConvertibleTo(f32, bool));
    try testing.expect(!isConvertibleTo(struct {}, bool));
    try testing.expect(!isConvertibleTo(comptime_float, bool));
    try testing.expect(!isConvertibleTo(comptime_int, bool));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), bool));
    try testing.expect(!isConvertibleTo(@TypeOf(null), bool));
    try testing.expect(!isConvertibleTo(anyerror!u32, bool));
    try testing.expect(!isConvertibleTo(error{}, bool));
    try testing.expect(!isConvertibleTo(enum {}, bool));
    try testing.expect(!isConvertibleTo(union {}, bool));
    try testing.expect(!isConvertibleTo(fn () void, bool));
    try testing.expect(!isConvertibleTo(anyopaque, bool));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), bool));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), bool));
}

test "isConvertibleTo noreturn" {
    try testing.expect(isConvertibleTo(noreturn, noreturn));
}

test "isConvertibleTo int" {
    try testing.expect(isConvertibleTo(u32, u32));
    try testing.expect(isConvertibleTo(i32, i32));
    try testing.expect(isConvertibleTo(u32, ?u32));
    try testing.expect(isConvertibleTo(comptime_int, u32));
    try testing.expect(isConvertibleTo(comptime_int, i32));

    try testing.expect(!isConvertibleTo(u32, u64));

    try testing.expect(!isConvertibleTo(?u32, u32));
    try testing.expect(!isConvertibleTo(*u32, u32));
    try testing.expect(!isConvertibleTo([*]u32, u32));
    try testing.expect(!isConvertibleTo([*:0]u32, u32));
    try testing.expect(!isConvertibleTo([*c]u32, u32));
    try testing.expect(!isConvertibleTo([2]u32, u32));

    try testing.expect(!isConvertibleTo(type, u32));
    try testing.expect(!isConvertibleTo(void, u32));
    try testing.expect(!isConvertibleTo(bool, u32));
    try testing.expect(!isConvertibleTo(noreturn, u32));
    try testing.expect(!isConvertibleTo(i32, u32));
    try testing.expect(!isConvertibleTo(f32, u32));
    try testing.expect(!isConvertibleTo(struct {}, u32));
    try testing.expect(!isConvertibleTo(comptime_float, u32));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), u32));
    try testing.expect(!isConvertibleTo(@TypeOf(null), u32));
    try testing.expect(!isConvertibleTo(anyerror!u32, u32));
    try testing.expect(!isConvertibleTo(error{}, u32));
    try testing.expect(!isConvertibleTo(enum {}, u32));
    try testing.expect(!isConvertibleTo(union {}, u32));
    try testing.expect(!isConvertibleTo(fn () void, u32));
    try testing.expect(!isConvertibleTo(anyopaque, u32));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), u32));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), u32));
}

test "isConvertibleTo float" {
    try testing.expect(isConvertibleTo(f32, f32));
    try testing.expect(isConvertibleTo(f32, ?f32));
    try testing.expect(isConvertibleTo(comptime_float, f32));

    try testing.expect(!isConvertibleTo(f32, f64));

    try testing.expect(!isConvertibleTo(?f32, f32));
    try testing.expect(!isConvertibleTo(*f32, f32));
    try testing.expect(!isConvertibleTo([*]f32, f32));
    try testing.expect(!isConvertibleTo([*:0.0]f32, f32));
    try testing.expect(!isConvertibleTo([*c]f32, f32));
    try testing.expect(!isConvertibleTo([2]f32, f32));

    try testing.expect(!isConvertibleTo(type, f32));
    try testing.expect(!isConvertibleTo(void, f32));
    try testing.expect(!isConvertibleTo(bool, f32));
    try testing.expect(!isConvertibleTo(noreturn, f32));
    try testing.expect(!isConvertibleTo(i32, f32));
    try testing.expect(!isConvertibleTo(u32, f32));
    try testing.expect(!isConvertibleTo(struct {}, f32));
    try testing.expect(!isConvertibleTo(comptime_int, f32));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), f32));
    try testing.expect(!isConvertibleTo(@TypeOf(null), f32));
    try testing.expect(!isConvertibleTo(anyerror!u32, f32));
    try testing.expect(!isConvertibleTo(error{}, f32));
    try testing.expect(!isConvertibleTo(enum {}, f32));
    try testing.expect(!isConvertibleTo(union {}, f32));
    try testing.expect(!isConvertibleTo(fn () void, f32));
    try testing.expect(!isConvertibleTo(anyopaque, f32));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), f32));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), f32));
}

test "isConvertibleTo pointer" {
    try testing.expect(!isConvertibleTo(?*u32, *u32));
    try testing.expect(!isConvertibleTo(**u32, *u32));
    try testing.expect(!isConvertibleTo([*]*u32, *u32));
    try testing.expect(!isConvertibleTo([*:@ptrFromInt(4)]*u32, *u32));
    try testing.expect(!isConvertibleTo([*c]*u32, *u32));
    try testing.expect(!isConvertibleTo([2]*u32, *u32));

    try testing.expect(!isConvertibleTo(type, *u32));
    try testing.expect(!isConvertibleTo(void, *u32));
    try testing.expect(!isConvertibleTo(bool, *u32));
    try testing.expect(!isConvertibleTo(noreturn, *u32));
    try testing.expect(!isConvertibleTo(i32, *u32));
    try testing.expect(!isConvertibleTo(u32, *u32));
    try testing.expect(!isConvertibleTo(f32, *u32));
    try testing.expect(!isConvertibleTo(struct {}, *u32));
    try testing.expect(!isConvertibleTo(comptime_float, *u32));
    try testing.expect(!isConvertibleTo(comptime_int, *u32));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), *u32));
    try testing.expect(!isConvertibleTo(@TypeOf(null), *u32));
    try testing.expect(!isConvertibleTo(anyerror!u32, *u32));
    try testing.expect(!isConvertibleTo(error{}, *u32));
    try testing.expect(!isConvertibleTo(enum {}, *u32));
    try testing.expect(!isConvertibleTo(union {}, *u32));
    try testing.expect(!isConvertibleTo(fn () void, *u32));
    try testing.expect(!isConvertibleTo(anyopaque, *u32));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), *u32));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), *u32));

    // to pointer
    try testing.expect(isConvertibleTo(*u32, *u32));
    try testing.expect(!isConvertibleTo([*]u32, *u32));
    // to optional pointer
    try testing.expect(isConvertibleTo(?*u32, ?*u32));
    try testing.expect(isConvertibleTo(*u32, ?*u32));
    try testing.expect(isConvertibleTo([*c]u32, ?*u32));
    try testing.expect(!isConvertibleTo([*]u32, ?*u32));
    try testing.expect(!isConvertibleTo([]u32, ?*u32));
    // to c pointer
    try testing.expect(isConvertibleTo(*u32, [*c]u32));
    try testing.expect(isConvertibleTo(?*u32, [*c]u32));
    // to pointer to many
    try testing.expect(isConvertibleTo([*:0]u32, [*]u32));
    try testing.expect(!isConvertibleTo(*u32, [*]u32));
    // to slice
    try testing.expect(isConvertibleTo([:0]u32, []u32));
    try testing.expect(!isConvertibleTo(*u32, []u32));
    try testing.expect(!isConvertibleTo(*[2]u32, []u32));
    // to sentinel terminated slice
    try testing.expect(isConvertibleTo([:0]u32, [:0]u32));
    try testing.expect(isConvertibleTo([:0]u32, [:0]const u32));
    try testing.expect(!isConvertibleTo([:0]const u32, [:0]u32));
    try testing.expect(!isConvertibleTo([:1]u32, [:0]u32));
    try testing.expect(!isConvertibleTo(*u32, [:0]u32));
    try testing.expect(!isConvertibleTo([]u32, [:0]u32));
    try testing.expect(!isConvertibleTo([*:0]u32, [:0]u32));
    try testing.expect(!isConvertibleTo(*u32, [:0]u32));

    // to sentinel terminated pointers
    try testing.expect(isConvertibleTo([*:0]u32, [*:0]u32));
    try testing.expect(!isConvertibleTo([*]u32, [*:0]u32));
    try testing.expect(!isConvertibleTo(*u32, [*:0]u32));
}

test "isConvertibleTo array" {}

test "isConvertibleTo struct" {}

test "isConvertibleTo comptime_float" {}

test "isConvertibleTo comptime_int" {}

test "isConvertibleTo undefined" {}

test "isConvertibleTo null" {}

test "isConvertibleTo optional" {}

test "isConvertibleTo error union" {}

test "isConvertibleTo error set" {}

test "isConvertibleTo enum" {}

test "isConvertibleTo union" {}

test "isConvertibleTo fn" {}

test "isConvertibleTo opaque" {}

test "isConvertibleTo vector" {}

test "isConvertibleTo enum literal" {}

// // types should only be convertible to types

// try testing.expect(isConvertibleTo(void, void));
// try testing.expect(isConvertibleTo(void, ?void));
// try notConvertible(void, [_]type{
//     ?void,

//     type,
//     bool,
//     noreturn,
//     i32,
//     u32,
//     f32,
//     //pointer
//     *u32,
//     [*]u32,
//     [*:0]u32,
//     [*c]u32,
//     [2]u32,
//     struct {},
//     comptime_float,
//     comptime_int,
//     @TypeOf(undefined),
//     @TypeOf(null),
//     anyerror!u32,
//     error{},
//     union {},
//     fn () void,
//     anyopaque,
//     @Vector(4, i32),
//     @TypeOf(enum { val }.val),
// });

// try testing.expect(isConvertibleTo(bool, bool));
// try testing.expect(isConvertibleTo(bool, ?bool));
// try notConvertible(bool, [_]type{
//     ?bool,

//     type,
//     void,
//     noreturn,
//     i32,
//     u32,
//     f32,
//     //pointer
//     *u32,
//     [*]u32,
//     [*:0]u32,
//     [*c]u32,
//     [2]u32,
//     struct {},
//     comptime_float,
//     comptime_int,
//     @TypeOf(undefined),
//     @TypeOf(null),
//     anyerror!u32,
//     error{},
//     union {},
//     fn () void,
//     anyopaque,
//     @Vector(4, i32),
//     @TypeOf(enum { val }.val),
// });

// // noreturn isn't allowed as a parameter
// try testing.expect(isConvertibleTo(noreturn, noreturn));

// try testing.expect(isConvertibleTo(i32, i32));
// try testing.expect(isConvertibleTo(u32, u32));
// try testing.expect(isConvertibleTo(i32, ?i32));
// try testing.expect(isConvertibleTo(u32, ?u32));
// try testing.expect(isConvertibleTo(comptime_int, u32));
// try testing.expect(isConvertibleTo(comptime_int, ?u32));
// try notConvertible(i32, [_]type{
//     ?i32,
//     i64,
//     u32,

//     type,
//     void,
//     bool,
//     noreturn,
//     f32,
//     //pointer
//     *u32,
//     [*]u32,
//     [*:0]u32,
//     [*c]u32,
//     [2]u32,
//     struct {},
//     comptime_float,
//     @TypeOf(undefined),
//     @TypeOf(null),
//     anyerror!u32,
//     error{},
//     union {},
//     fn () void,
//     anyopaque,
//     @Vector(4, i32),
//     @TypeOf(enum { val }.val),
// });

// try testing.expect(isConvertibleTo(f32, f32));
// try testing.expect(isConvertibleTo(f32, ?f32));
// try testing.expect(isConvertibleTo(comptime_float, ?f32));
// try testing.expect(isConvertibleTo(comptime_float, ?f32));
// try notConvertible(f32, [_]type{
//     ?f32,
//     f64,

//     type,
//     void,
//     bool,
//     noreturn,
//     i32,
//     u32,
//     //pointer
//     *u32,
//     [*]u32,
//     [*:0]u32,
//     [*c]u32,
//     [2]u32,
//     struct {},
//     comptime_int,
//     @TypeOf(undefined),
//     @TypeOf(null),
//     anyerror!u32,
//     error{},
//     union {},
//     fn () void,
//     anyopaque,
//     @Vector(4, i32),
//     @TypeOf(enum { val }.val),
// });

// // to pointer
// try testing.expect(isConvertibleTo(*u32, *u32));
// try testing.expect(!isConvertibleTo([*]u32, *u32));
// // to optional pointer
// try testing.expect(isConvertibleTo(*u32, ?*u32));
// try testing.expect(isConvertibleTo([*c]u32, ?*u32));
// // to c pointer
// try testing.expect(isConvertibleTo(*u32, [*c]u32));
// try testing.expect(isConvertibleTo(?*u32, [*c]u32));
// // to pointer to many
// try testing.expect(isConvertibleTo([*:0]u32, [*]u32));
// try testing.expect(!isConvertibleTo(*u32, [*]u32));
// // to slice
// try testing.expect(isConvertibleTo([:0]u32, []u32));
// try testing.expect(!isConvertibleTo(*u32, []u32));
// try testing.expect(!isConvertibleTo(*[2]u32, []u32));
// // to sentinel terminated slice
// try testing.expect(isConvertibleTo([:0]u32, [:0]u32));
// try testing.expect(isConvertibleTo([:0]u32, [:0]const u32));
// try testing.expect(!isConvertibleTo([:0]const u32, [:0]u32));
// try testing.expect(!isConvertibleTo([:1]u32, [:0]u32));
// try testing.expect(!isConvertibleTo(*u32, [:0]u32));
// try testing.expect(!isConvertibleTo([]u32, [:0]u32));
// try testing.expect(!isConvertibleTo([*:0]u32, [:0]u32));
// // try testing.expect(!isConvertibleTo(*u32, [:0]u32));

// // to sentinel terminated pointers
// // try testing.expect(isConvertibleTo([*:0]u32, [*:0]u32));
// // try testing.expect(!isConvertibleTo([*]u32, [*:0]u32));
// // try testing.expect(!isConvertibleTo(*u32, [*:0]u32));

// const a: [:5]const u32 = @ptrCast(&[_]u32{ 2, 3, 5, 6 });
// const b: [:5]const u32 = a;
// std.debug.print("{any}\n", .{b});
