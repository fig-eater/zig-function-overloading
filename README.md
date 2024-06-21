# Explicit Function Overloading for Zig

Simple one-file, no-dependency, explicit function overloading for zig.
This all runs during compile time so running overloaded functions shouldn't have
any runtime overhead.

## Install

run `zig fetch --save URL` within your project directory

or

Download [src/overloading.zig](./src/overloading.zig)


## Usage

Call `make` with a touple of functions, `make` will return a function which when
called will call a function in the touple with corresponding argument types.
All functions passed in the touple must have the same return type.
Functions in the touple cannot have the same arguments as others in the touple.
If a function takes no arguments, pass `{}` into the overloaded function to call it.

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
// create the overloaded add function
const add = overloading.make(.{
    add0,
    add1,
    add2,
    add3,
});
// add({})          returns 0
// add(50, 2)       returns 52
// add(3)           returns 3
// add(100, 20, 20) returns 140
```

## License

Licensed under the Unlicense see included [LICENSE](./LICENSE) file or
https://unlicense.org
Attribution to fig / fig-eater / groakgames is appreciated but not required.