# Explicit Function Overloading for Zig

Simple one-file, no-dependency, explicit function overloading for zig.
This all runs during compile time so running overloaded functions shouldn't have
any runtime overhead.

## Install

### Using Zig Package Manager

Run `zig fetch --save https://github.com/fig-eater/zig-function-overloading/archive/refs/heads/main.tar.gz`
within your project directory. Run this again if you ever want to update the dependency.

Then add an import to the module which needs overloading to your `build.zig`

This code is an example of how you might do this:

```zig

const overloading_dependency = b.dependency("overloading", .{
    .target = target,
    .optimize = optimize,
});

// in a default project `compile_step` might be `lib` or `exe`.
// replace the first "overloading" here to avoid namespace conflicts or to change the name of the import for your project.
compile_step.root_module.addImport("overloading", overloading_dependency.module("overloading"));

```

### Manually

Download [src/overloading.zig](./src/overloading.zig) and save in your project.

Import directly using `@import("path/to/overloading.zig")`

*or*

See [build.zig](./build.zig) for an example of how to use this as a local
module.

## Usage

- Import the `overloading` module or `overloading.zig` if saved locally.
- Call `overloading.make` with a tuple of functions, `make` will return a function which when
called will call a function in the tuple with corresponding argument types.
- All functions passed in the tuple must have the same return type.
- Functions in the tuple cannot have the same arguments as others in the tuple.
- If a function takes no arguments, pass `{}` into the overloaded function to call it.
- If a function takes multiple arguments pass the arguments in a tuple.
- If a function takes void as it's only argument pass in `.{{}}` into the overloaded function to call it

Example:
```zig
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
```
See [example.zig](src/example.zig) for another example.

## License

Licensed under the Unlicense see included [LICENSE](./LICENSE) file or
https://unlicense.org
Attribution to fig / fig-eater / groakgames is appreciated but not required.
