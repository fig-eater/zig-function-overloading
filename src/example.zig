// Created by fig / fig-eater / groakgames.
// https://github.com/fig-eater/zig-function-overloading
//
// This file is licensed under Unlicense
// See included LICENSE file or https://unlicense.org
// Attribution is appreciated but not required.

const std = @import("std");
const overloading = @import("overloading");

fn addNoArgs() u32 {
    return 0;
}
fn addU32(a: u32) u32 {
    return a;
}
fn addU8Slice(as: []const u8) u32 {
    var total: u32 = 0;
    for (as) |a| total +|= a;
    return total;
}
fn addOptionalU32(a: ?u32) u32 {
    return if (a) |a_val| return a_val else 0;
}
fn addPtrU32(a_ptr: *u32) u32 {
    return a_ptr.*;
}
fn addU32I32(a: u32, b: i32) u32 {
    return a + @as(u32, @intCast(b));
}

fn printNoArgs() void {
    std.debug.print("no args\n", .{});
}
fn printVoid(_: void) void {
    std.debug.print("void\n", .{});
}
fn printU32(a: u32) void {
    std.debug.print("{d}\n", .{a});
}
fn printU8Slice(a: []const u8) void {
    std.debug.print("{s}\n", .{a});
}
fn printU32U32(a: u32, b: u32) void {
    std.debug.print("{d} {d}\n", .{ a, b });
}

const myAdd = overloading.make(.{
    addNoArgs,
    addU32,
    addU8Slice,
    addOptionalU32,
    addPtrU32,
    addU32I32,
});

const myPrint = overloading.make(.{
    printNoArgs,
    printVoid,
    printU32,
    printU8Slice,
    printU32U32,
});

pub fn main() void {
    const optional_with_val: ?u32 = 555;
    const optional_with_null: ?u32 = null;
    var a: u32 = 5;
    _ = myAdd({}); // returns 0
    _ = myAdd(2); // returns 2
    _ = myAdd("abc"); // returns 294
    _ = myAdd(optional_with_val); // returns 555
    _ = myAdd(optional_with_null); // returns 0
    _ = myAdd(&a); // returns 5
    _ = myAdd(.{ 5, 20 }); // returns 25

    myPrint({}); // prints "no args"
    myPrint(.{{}}); // prints "void"
    myPrint(2); // prints "2"
    myPrint("hello"); // prints "hello"
    myPrint(.{ 3, 4 }); // prints "3 4"
}
