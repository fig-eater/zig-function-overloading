// separate file for tests since these are a bit exhaustive
// frame and anyframe types are not tested as they are not currently supported by the language

const std = @import("std");
const testing = std.testing;
const overloading = @import("overloading.zig");
const isConvertibleTo = overloading.isConvertibleTo;

test "general 1" {
    const overloaded = struct {
        fn foo_0() u32 {
            return 0.0;
        }

        fn foo_1(a: u32) u32 {
            return a;
        }

        fn foo_2(a: f32) u32 {
            return @intFromFloat(a);
        }

        fn foo_3(a: u32, b: u32) u32 {
            return a + b;
        }

        fn foo_4(a: []const u8) u32 {
            var total: u32 = 0;
            for (a) |i| total += i;
            return @intCast(total);
        }

        fn foo_5(_: void) u32 {
            return 555;
        }

        const overloaded = overloading.make(.{
            foo_0,
            foo_1,
            foo_2,
            foo_3,
            foo_4,
            foo_5,
        });
    }.overloaded;

    const u32_2: u32 = 2;
    const f32_2: f32 = 2.0;
    const str_slice_3: []const u8 = "\x03";

    try testing.expect(overloaded({}) == 0);
    try testing.expect(overloaded(u32_2) == 2);
    try testing.expect(overloaded(2) == 2);
    try testing.expect(overloaded(f32_2) == 2);
    try testing.expect(overloaded(1.0) == 1);
    try testing.expect(overloaded(.{ 1, 2 }) == 3);
    try testing.expect(overloaded(.{ u32_2, u32_2 }) == 4);
    try testing.expect(overloaded(str_slice_3) == 3);
    try testing.expect(overloaded(&[_]u8{ 10, 20, 30 }) == 60);
    try testing.expect(overloaded(.{{}}) == 555);
}

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

test "isConvertibleTo pointer" { // writing these and getting it working makes me cry
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
    try testing.expect(isConvertibleTo(*[2]u32, [*c]u32));
    try testing.expect(isConvertibleTo(*u32, [*c]u32));
    try testing.expect(isConvertibleTo(?*u32, [*c]u32));
    // to pointer to many
    try testing.expect(isConvertibleTo([*:0]u32, [*]u32));
    try testing.expect(!isConvertibleTo(*u32, [*]u32));
    try testing.expect(isConvertibleTo(*[2]u32, [*]u32));
    // to slice
    try testing.expect(isConvertibleTo(*[2]u32, []u32));
    try testing.expect(isConvertibleTo(*[2:0]u32, [:0]u32));
    try testing.expect(isConvertibleTo([:0]u32, []u32));
    try testing.expect(!isConvertibleTo(*[2]u32, [:0]u32));
    try testing.expect(!isConvertibleTo(*u32, []u32));
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

test "isConvertibleTo array" {
    const ex = comptime [2]u32{ 0, 1 };
    try testing.expect(isConvertibleTo([2]u32, [2]u32));
    try testing.expect(isConvertibleTo([2]u32, ?[2]u32));

    try testing.expect(!isConvertibleTo([2]u32, [3]u32));
    try testing.expect(!isConvertibleTo([2]u32, [2]u64));

    try testing.expect(!isConvertibleTo(?[2]u32, [2]u32));
    try testing.expect(!isConvertibleTo(*[2]u32, [2]u32));
    try testing.expect(!isConvertibleTo([*][2]u32, [2]u32));
    try testing.expect(!isConvertibleTo([*:ex][2]u32, [2]u32));
    try testing.expect(!isConvertibleTo([*c][2]u32, [2]u32));
    try testing.expect(!isConvertibleTo([2][2]u32, [2]u32));

    try testing.expect(!isConvertibleTo(type, [2]u32));
    try testing.expect(!isConvertibleTo(void, [2]u32));
    try testing.expect(!isConvertibleTo(bool, [2]u32));
    try testing.expect(!isConvertibleTo(noreturn, [2]u32));
    try testing.expect(!isConvertibleTo(i32, [2]u32));
    try testing.expect(!isConvertibleTo(u32, [2]u32));
    try testing.expect(!isConvertibleTo(f32, [2]u32));
    try testing.expect(!isConvertibleTo(struct {}, [2]u32));
    try testing.expect(!isConvertibleTo(comptime_float, [2]u32));
    try testing.expect(!isConvertibleTo(comptime_int, [2]u32));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), [2]u32));
    try testing.expect(!isConvertibleTo(@TypeOf(null), [2]u32));
    try testing.expect(!isConvertibleTo(anyerror!u32, [2]u32));
    try testing.expect(!isConvertibleTo(error{}, [2]u32));
    try testing.expect(!isConvertibleTo(enum {}, [2]u32));
    try testing.expect(!isConvertibleTo(union {}, [2]u32));
    try testing.expect(!isConvertibleTo(fn () void, [2]u32));
    try testing.expect(!isConvertibleTo(anyopaque, [2]u32));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), [2]u32));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), [2]u32));
}

test "isConvertibleTo struct" {
    const Ex = struct {};
    const ex = comptime Ex{};

    try testing.expect(isConvertibleTo(Ex, Ex));
    try testing.expect(isConvertibleTo(Ex, ?Ex));

    try testing.expect(!isConvertibleTo(?Ex, Ex));
    try testing.expect(!isConvertibleTo(*Ex, Ex));
    try testing.expect(!isConvertibleTo([*]Ex, Ex));
    try testing.expect(!isConvertibleTo([*:ex]Ex, Ex));
    try testing.expect(!isConvertibleTo([*c]Ex, Ex));
    try testing.expect(!isConvertibleTo([2]Ex, Ex));

    try testing.expect(!isConvertibleTo(type, Ex));
    try testing.expect(!isConvertibleTo(void, Ex));
    try testing.expect(!isConvertibleTo(bool, Ex));
    try testing.expect(!isConvertibleTo(noreturn, Ex));
    try testing.expect(!isConvertibleTo(i32, Ex));
    try testing.expect(!isConvertibleTo(u32, Ex));
    try testing.expect(!isConvertibleTo(f32, Ex));
    try testing.expect(!isConvertibleTo(struct {}, Ex));
    try testing.expect(!isConvertibleTo(comptime_float, Ex));
    try testing.expect(!isConvertibleTo(comptime_int, Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(null), Ex));
    try testing.expect(!isConvertibleTo(anyerror!u32, Ex));
    try testing.expect(!isConvertibleTo(error{}, Ex));
    try testing.expect(!isConvertibleTo(enum {}, Ex));
    try testing.expect(!isConvertibleTo(union {}, Ex));
    try testing.expect(!isConvertibleTo(fn () void, Ex));
    try testing.expect(!isConvertibleTo(anyopaque, Ex));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), Ex));
}

test "isConvertibleTo comptime_float" {
    const ex: comptime_float = 2.0;

    try testing.expect(isConvertibleTo(comptime_float, comptime_float));
    try testing.expect(isConvertibleTo(comptime_float, ?comptime_float));

    try testing.expect(!isConvertibleTo(?comptime_float, comptime_float));
    try testing.expect(!isConvertibleTo(*comptime_float, comptime_float));
    try testing.expect(!isConvertibleTo([*]comptime_float, comptime_float));
    try testing.expect(!isConvertibleTo([*:ex]comptime_float, comptime_float));
    try testing.expect(!isConvertibleTo([2]comptime_float, comptime_float));

    try testing.expect(!isConvertibleTo(type, comptime_float));
    try testing.expect(!isConvertibleTo(void, comptime_float));
    try testing.expect(!isConvertibleTo(bool, comptime_float));
    try testing.expect(!isConvertibleTo(noreturn, comptime_float));
    try testing.expect(!isConvertibleTo(i32, comptime_float));
    try testing.expect(!isConvertibleTo(u32, comptime_float));
    try testing.expect(!isConvertibleTo(f32, comptime_float));
    try testing.expect(!isConvertibleTo(struct {}, comptime_float));
    try testing.expect(!isConvertibleTo(comptime_int, comptime_float));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), comptime_float));
    try testing.expect(!isConvertibleTo(@TypeOf(null), comptime_float));
    try testing.expect(!isConvertibleTo(anyerror!u32, comptime_float));
    try testing.expect(!isConvertibleTo(error{}, comptime_float));
    try testing.expect(!isConvertibleTo(enum {}, comptime_float));
    try testing.expect(!isConvertibleTo(union {}, comptime_float));
    try testing.expect(!isConvertibleTo(fn () void, comptime_float));
    try testing.expect(!isConvertibleTo(anyopaque, comptime_float));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), comptime_float));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), comptime_float));
}

test "isConvertibleTo comptime_int" {
    const ex: comptime_int = 2;

    try testing.expect(isConvertibleTo(comptime_int, comptime_int));
    try testing.expect(isConvertibleTo(comptime_int, ?comptime_int));

    try testing.expect(!isConvertibleTo(?comptime_int, comptime_int));
    try testing.expect(!isConvertibleTo(*comptime_int, comptime_int));
    try testing.expect(!isConvertibleTo([*]comptime_int, comptime_int));
    try testing.expect(!isConvertibleTo([*:ex]comptime_int, comptime_int));
    try testing.expect(!isConvertibleTo([2]comptime_int, comptime_int));

    try testing.expect(!isConvertibleTo(type, comptime_int));
    try testing.expect(!isConvertibleTo(void, comptime_int));
    try testing.expect(!isConvertibleTo(bool, comptime_int));
    try testing.expect(!isConvertibleTo(noreturn, comptime_int));
    try testing.expect(!isConvertibleTo(i32, comptime_int));
    try testing.expect(!isConvertibleTo(u32, comptime_int));
    try testing.expect(!isConvertibleTo(f32, comptime_int));
    try testing.expect(!isConvertibleTo(struct {}, comptime_int));
    try testing.expect(!isConvertibleTo(comptime_float, comptime_int));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), comptime_int));
    try testing.expect(!isConvertibleTo(@TypeOf(null), comptime_int));
    try testing.expect(!isConvertibleTo(anyerror!u32, comptime_int));
    try testing.expect(!isConvertibleTo(error{}, comptime_int));
    try testing.expect(!isConvertibleTo(enum {}, comptime_int));
    try testing.expect(!isConvertibleTo(union {}, comptime_int));
    try testing.expect(!isConvertibleTo(fn () void, comptime_int));
    try testing.expect(!isConvertibleTo(anyopaque, comptime_int));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), comptime_int));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), comptime_int));
}

test "isConvertibleTo undefined" {
    try testing.expect(isConvertibleTo(@TypeOf(undefined), @TypeOf(undefined)));
    try testing.expect(isConvertibleTo(@TypeOf(undefined), ?@TypeOf(undefined)));

    try testing.expect(!isConvertibleTo(?@TypeOf(undefined), @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(*@TypeOf(undefined), @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo([*]@TypeOf(undefined), @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo([2]@TypeOf(undefined), @TypeOf(undefined)));

    try testing.expect(!isConvertibleTo(type, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(void, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(bool, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(noreturn, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(i32, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(u32, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(f32, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(struct {}, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(comptime_float, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(comptime_int, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(@TypeOf(null), @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(anyerror!u32, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(error{}, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(enum {}, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(union {}, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(fn () void, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(anyopaque, @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), @TypeOf(undefined)));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), @TypeOf(undefined)));
}

test "isConvertibleTo null" {
    try testing.expect(isConvertibleTo(@TypeOf(null), @TypeOf(null)));

    try testing.expect(!isConvertibleTo(*@TypeOf(null), @TypeOf(null)));
    try testing.expect(!isConvertibleTo([*]@TypeOf(null), @TypeOf(null)));
    try testing.expect(!isConvertibleTo([*:null]@TypeOf(null), @TypeOf(null)));
    try testing.expect(!isConvertibleTo([2]@TypeOf(null), @TypeOf(null)));

    try testing.expect(!isConvertibleTo(type, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(void, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(bool, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(noreturn, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(i32, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(u32, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(f32, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(struct {}, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(comptime_float, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(comptime_int, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), @TypeOf(null)));
    try testing.expect(!isConvertibleTo(anyerror!u32, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(error{}, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(enum {}, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(union {}, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(fn () void, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(anyopaque, @TypeOf(null)));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), @TypeOf(null)));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), @TypeOf(null)));
}

test "isConvertibleTo optional" {
    try testing.expect(isConvertibleTo([*c]u32, ?*u32));
    try testing.expect(isConvertibleTo(?void, ?void));

    try testing.expect(!isConvertibleTo(??void, ?void));
    try testing.expect(!isConvertibleTo(*?void, ?void));
    try testing.expect(!isConvertibleTo([*]?void, ?void));
    try testing.expect(!isConvertibleTo([*:null]?void, ?void));
    try testing.expect(!isConvertibleTo([2]?void, ?void));

    try testing.expect(!isConvertibleTo(type, ?void));
    try testing.expect(!isConvertibleTo(bool, ?void));
    try testing.expect(!isConvertibleTo(noreturn, ?void));
    try testing.expect(!isConvertibleTo(i32, ?void));
    try testing.expect(!isConvertibleTo(u32, ?void));
    try testing.expect(!isConvertibleTo(f32, ?void));
    try testing.expect(!isConvertibleTo(struct {}, ?void));
    try testing.expect(!isConvertibleTo(comptime_float, ?void));
    try testing.expect(!isConvertibleTo(comptime_int, ?void));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), ?void));
    try testing.expect(!isConvertibleTo(@TypeOf(null), ?void));
    try testing.expect(!isConvertibleTo(anyerror!u32, ?void));
    try testing.expect(!isConvertibleTo(error{}, ?void));
    try testing.expect(!isConvertibleTo(enum {}, ?void));
    try testing.expect(!isConvertibleTo(union {}, ?void));
    try testing.expect(!isConvertibleTo(fn () void, ?void));
    try testing.expect(!isConvertibleTo(anyopaque, ?void));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), ?void));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), ?void));
}

test "isConvertibleTo error union" {
    const ErrorSet = error{err};
    const Ex = ErrorSet!u32;

    try testing.expect(isConvertibleTo(Ex, Ex));
    try testing.expect(isConvertibleTo(Ex, ?Ex));
    try testing.expect(isConvertibleTo(u32, Ex));
    try testing.expect(isConvertibleTo(comptime_int, Ex));
    try testing.expect(isConvertibleTo(comptime_float, ErrorSet!f32));
    try testing.expect(isConvertibleTo(@TypeOf(ErrorSet.err), Ex));

    try testing.expect(!isConvertibleTo(?Ex, Ex));
    try testing.expect(!isConvertibleTo(*Ex, Ex));
    try testing.expect(!isConvertibleTo([*]Ex, Ex));
    try testing.expect(!isConvertibleTo([*:2]Ex, Ex));
    try testing.expect(!isConvertibleTo([2]Ex, Ex));

    try testing.expect(!isConvertibleTo(type, Ex));
    try testing.expect(!isConvertibleTo(void, Ex));
    try testing.expect(!isConvertibleTo(bool, Ex));
    try testing.expect(!isConvertibleTo(noreturn, Ex));
    try testing.expect(!isConvertibleTo(i64, Ex));
    try testing.expect(!isConvertibleTo(u64, Ex));
    try testing.expect(!isConvertibleTo(f32, Ex));
    try testing.expect(!isConvertibleTo(struct {}, Ex));
    try testing.expect(!isConvertibleTo(comptime_float, Ex));
    try testing.expect(!isConvertibleTo(comptime_int, error{}!void));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(null), Ex));
    try testing.expect(!isConvertibleTo(anyerror!u32, Ex));
    try testing.expect(!isConvertibleTo(error{}, Ex));
    try testing.expect(!isConvertibleTo(enum {}, Ex));
    try testing.expect(!isConvertibleTo(union {}, Ex));
    try testing.expect(!isConvertibleTo(fn () void, Ex));
    try testing.expect(!isConvertibleTo(anyopaque, Ex));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), Ex));
}

test "isConvertibleTo error set" {
    const ErrorSet = error{err};

    try testing.expect(isConvertibleTo(ErrorSet, ErrorSet));
    try testing.expect(isConvertibleTo(ErrorSet, ?ErrorSet));

    try testing.expect(!isConvertibleTo(?ErrorSet, ErrorSet));
    try testing.expect(!isConvertibleTo(*ErrorSet, ErrorSet));
    try testing.expect(!isConvertibleTo([*]ErrorSet, ErrorSet));
    try testing.expect(!isConvertibleTo([2]ErrorSet, ErrorSet));

    try testing.expect(!isConvertibleTo(type, ErrorSet));
    try testing.expect(!isConvertibleTo(void, ErrorSet));
    try testing.expect(!isConvertibleTo(bool, ErrorSet));
    try testing.expect(!isConvertibleTo(noreturn, ErrorSet));
    try testing.expect(!isConvertibleTo(i32, ErrorSet));
    try testing.expect(!isConvertibleTo(u32, ErrorSet));
    try testing.expect(!isConvertibleTo(f32, ErrorSet));
    try testing.expect(!isConvertibleTo(struct {}, ErrorSet));
    try testing.expect(!isConvertibleTo(comptime_float, ErrorSet));
    try testing.expect(!isConvertibleTo(comptime_int, ErrorSet));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), ErrorSet));
    try testing.expect(!isConvertibleTo(@TypeOf(null), ErrorSet));
    try testing.expect(!isConvertibleTo(anyerror!u32, ErrorSet));
    try testing.expect(!isConvertibleTo(error{}, ErrorSet));
    try testing.expect(!isConvertibleTo(enum {}, ErrorSet));
    try testing.expect(!isConvertibleTo(union {}, ErrorSet));
    try testing.expect(!isConvertibleTo(fn () void, ErrorSet));
    try testing.expect(!isConvertibleTo(anyopaque, ErrorSet));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), ErrorSet));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), ErrorSet));
}

test "isConvertibleTo enum" {
    const Ex = enum { a, b, c };

    try testing.expect(isConvertibleTo(Ex, Ex));
    try testing.expect(isConvertibleTo(Ex, ?Ex));

    try testing.expect(!isConvertibleTo(?Ex, Ex));
    try testing.expect(!isConvertibleTo(*Ex, Ex));
    try testing.expect(!isConvertibleTo([*]Ex, Ex));
    try testing.expect(!isConvertibleTo([*:Ex.a]Ex, Ex));
    try testing.expect(!isConvertibleTo([2]Ex, Ex));

    try testing.expect(!isConvertibleTo(type, Ex));
    try testing.expect(!isConvertibleTo(void, Ex));
    try testing.expect(!isConvertibleTo(bool, Ex));
    try testing.expect(!isConvertibleTo(noreturn, Ex));
    try testing.expect(!isConvertibleTo(i32, Ex));
    try testing.expect(!isConvertibleTo(u32, Ex));
    try testing.expect(!isConvertibleTo(f32, Ex));
    try testing.expect(!isConvertibleTo(struct {}, Ex));
    try testing.expect(!isConvertibleTo(comptime_float, Ex));
    try testing.expect(!isConvertibleTo(comptime_int, Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(null), Ex));
    try testing.expect(!isConvertibleTo(anyerror!u32, Ex));
    try testing.expect(!isConvertibleTo(error{}, Ex));
    try testing.expect(!isConvertibleTo(enum {}, Ex));
    try testing.expect(!isConvertibleTo(union {}, Ex));
    try testing.expect(!isConvertibleTo(fn () void, Ex));
    try testing.expect(!isConvertibleTo(anyopaque, Ex));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), Ex));
}

test "isConvertibleTo union" {
    const Ex = extern union { a: u32, b: void, c: bool };

    try testing.expect(isConvertibleTo(Ex, Ex));
    try testing.expect(isConvertibleTo(Ex, ?Ex));

    try testing.expect(!isConvertibleTo(?Ex, Ex));
    try testing.expect(!isConvertibleTo(*Ex, Ex));
    try testing.expect(!isConvertibleTo([*]Ex, Ex));
    try testing.expect(!isConvertibleTo([*:Ex{ .a = 0 }]Ex, Ex));
    try testing.expect(!isConvertibleTo([*c]Ex, Ex));
    try testing.expect(!isConvertibleTo([2]Ex, Ex));

    try testing.expect(!isConvertibleTo(type, Ex));
    try testing.expect(!isConvertibleTo(void, Ex));
    try testing.expect(!isConvertibleTo(bool, Ex));
    try testing.expect(!isConvertibleTo(noreturn, Ex));
    try testing.expect(!isConvertibleTo(i32, Ex));
    try testing.expect(!isConvertibleTo(u32, Ex));
    try testing.expect(!isConvertibleTo(f32, Ex));
    try testing.expect(!isConvertibleTo(struct {}, Ex));
    try testing.expect(!isConvertibleTo(comptime_float, Ex));
    try testing.expect(!isConvertibleTo(comptime_int, Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(null), Ex));
    try testing.expect(!isConvertibleTo(anyerror!u32, Ex));
    try testing.expect(!isConvertibleTo(error{}, Ex));
    try testing.expect(!isConvertibleTo(enum {}, Ex));
    try testing.expect(!isConvertibleTo(union {}, Ex));
    try testing.expect(!isConvertibleTo(fn () void, Ex));
    try testing.expect(!isConvertibleTo(anyopaque, Ex));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), Ex));
}

test "isConvertibleTo fn" {
    const foo = struct {
        fn foo() void {}
    }.foo;

    try testing.expect(isConvertibleTo(@TypeOf(foo), @TypeOf(foo)));
    try testing.expect(isConvertibleTo(@TypeOf(foo), ?@TypeOf(foo)));

    try testing.expect(!isConvertibleTo(?@TypeOf(foo), @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(*@TypeOf(foo), @TypeOf(foo)));
    try testing.expect(!isConvertibleTo([2]@TypeOf(foo), @TypeOf(foo)));

    try testing.expect(!isConvertibleTo(type, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(void, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(bool, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(noreturn, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(i32, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(u32, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(f32, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(struct {}, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(comptime_float, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(comptime_int, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(@TypeOf(null), @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(anyerror!u32, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(error{}, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(enum {}, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(union {}, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(anyopaque, @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), @TypeOf(foo)));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), @TypeOf(foo)));
}

test "isConvertibleTo opaque" {
    const Ex = opaque {};

    try testing.expect(isConvertibleTo(Ex, Ex));

    try testing.expect(!isConvertibleTo(*Ex, Ex));

    try testing.expect(!isConvertibleTo(type, Ex));
    try testing.expect(!isConvertibleTo(void, Ex));
    try testing.expect(!isConvertibleTo(bool, Ex));
    try testing.expect(!isConvertibleTo(noreturn, Ex));
    try testing.expect(!isConvertibleTo(i32, Ex));
    try testing.expect(!isConvertibleTo(u32, Ex));
    try testing.expect(!isConvertibleTo(f32, Ex));
    try testing.expect(!isConvertibleTo(struct {}, Ex));
    try testing.expect(!isConvertibleTo(comptime_float, Ex));
    try testing.expect(!isConvertibleTo(comptime_int, Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(null), Ex));
    try testing.expect(!isConvertibleTo(anyerror!u32, Ex));
    try testing.expect(!isConvertibleTo(error{}, Ex));
    try testing.expect(!isConvertibleTo(enum {}, Ex));
    try testing.expect(!isConvertibleTo(union {}, Ex));
    try testing.expect(!isConvertibleTo(fn () void, Ex));
    try testing.expect(!isConvertibleTo(anyopaque, Ex));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), Ex));
}

test "isConvertibleTo vector" {
    const Ex = @Vector(4, i32);

    try testing.expect(isConvertibleTo(Ex, Ex));
    try testing.expect(isConvertibleTo(Ex, ?Ex));

    try testing.expect(!isConvertibleTo(?Ex, Ex));
    try testing.expect(!isConvertibleTo(*Ex, Ex));
    try testing.expect(!isConvertibleTo([*]Ex, Ex));
    try testing.expect(!isConvertibleTo([*:Ex{ 2, 3, 4, 5 }]Ex, Ex));
    try testing.expect(!isConvertibleTo([*c]Ex, Ex));
    try testing.expect(!isConvertibleTo([2]Ex, Ex));

    try testing.expect(!isConvertibleTo(type, Ex));
    try testing.expect(!isConvertibleTo(void, Ex));
    try testing.expect(!isConvertibleTo(bool, Ex));
    try testing.expect(!isConvertibleTo(noreturn, Ex));
    try testing.expect(!isConvertibleTo(i32, Ex));
    try testing.expect(!isConvertibleTo(u32, Ex));
    try testing.expect(!isConvertibleTo(f32, Ex));
    try testing.expect(!isConvertibleTo(struct {}, Ex));
    try testing.expect(!isConvertibleTo(comptime_float, Ex));
    try testing.expect(!isConvertibleTo(comptime_int, Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(null), Ex));
    try testing.expect(!isConvertibleTo(anyerror!u32, Ex));
    try testing.expect(!isConvertibleTo(error{}, Ex));
    try testing.expect(!isConvertibleTo(enum {}, Ex));
    try testing.expect(!isConvertibleTo(union {}, Ex));
    try testing.expect(!isConvertibleTo(fn () void, Ex));
    try testing.expect(!isConvertibleTo(anyopaque, Ex));
    try testing.expect(!isConvertibleTo(@Vector(4, i64), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), Ex));
}

test "isConvertibleTo enum literal" {
    const EnumType = enum { a };
    const Ex = @TypeOf(EnumType.a);

    try testing.expect(isConvertibleTo(Ex, Ex));
    try testing.expect(isConvertibleTo(Ex, ?Ex));

    try testing.expect(!isConvertibleTo(?Ex, Ex));
    try testing.expect(!isConvertibleTo(*Ex, Ex));
    try testing.expect(!isConvertibleTo([*]Ex, Ex));
    try testing.expect(!isConvertibleTo([*:EnumType.a]Ex, Ex));
    try testing.expect(!isConvertibleTo([*c]Ex, Ex));
    try testing.expect(!isConvertibleTo([2]Ex, Ex));

    try testing.expect(!isConvertibleTo(type, Ex));
    try testing.expect(!isConvertibleTo(void, Ex));
    try testing.expect(!isConvertibleTo(bool, Ex));
    try testing.expect(!isConvertibleTo(noreturn, Ex));
    try testing.expect(!isConvertibleTo(i32, Ex));
    try testing.expect(!isConvertibleTo(u32, Ex));
    try testing.expect(!isConvertibleTo(f32, Ex));
    try testing.expect(!isConvertibleTo(struct {}, Ex));
    try testing.expect(!isConvertibleTo(comptime_float, Ex));
    try testing.expect(!isConvertibleTo(comptime_int, Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(undefined), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(null), Ex));
    try testing.expect(!isConvertibleTo(anyerror!u32, Ex));
    try testing.expect(!isConvertibleTo(error{}, Ex));
    try testing.expect(!isConvertibleTo(enum {}, Ex));
    try testing.expect(!isConvertibleTo(union {}, Ex));
    try testing.expect(!isConvertibleTo(fn () void, Ex));
    try testing.expect(!isConvertibleTo(anyopaque, Ex));
    try testing.expect(!isConvertibleTo(@Vector(4, i32), Ex));
    try testing.expect(!isConvertibleTo(@TypeOf(enum { val }.val), Ex));
}
