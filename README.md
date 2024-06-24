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
const overloading = @import("overloading");

fn add0() i32 {
    return 0;
}
fn add1(a: i32) i32 {
    return a;
}
fn add2(a: i32, b: i32) i32 {
    return a + b;
}
fn add3(a: i32, b: i32, c: i32) i32 {
    return a + b + c;
}
fn add4(_:void) i32 {
    return 123;
}

// create the overloaded add function
const add = overloading.make(.{
    add0,
    add1,
    add2,
    add3,
    add4,
});

// add({})             returns 0
// add(3)              returns 3
// add(.{50, 2})       returns 52
// add(.{100, 20, 20}) returns 140
// add(.{{}})          returns 123 // special case for functions which take in void
```
See [example.zig](src/example.zig) for another example.

## License

Licensed under the Unlicense see included [LICENSE](./LICENSE) file or
https://unlicense.org
Attribution to fig / fig-eater / groakgames is appreciated but not required.
