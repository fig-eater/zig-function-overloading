const std = @import("std");
const Build = std.Build;
const Step = Build.Step;
const ResolvedTarget = Build.ResolvedTarget;
const OptimizeMode = std.builtin.OptimizeMode;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const overloading_module = buildModule(b);

    _ = buildRunExampleStep(b, overloading_module, target, optimize);
    _ = buildRunTestStep(b, target, optimize);
}

pub fn buildModule(b: *Build) *Build.Module {

    // register overloading.zig as a module
    const overloading_module = b.addModule("overloading", .{ .root_source_file = .{
        .src_path = .{
            .owner = b,
            .sub_path = "src/overloading.zig",
        },
    } });

    return overloading_module;
}

pub fn buildRunExampleStep(
    b: *Build,
    overloading_module: *Build.Module,
    target: ResolvedTarget,
    optimize: OptimizeMode,
) *Step {
    const run_step = b.step("run", "Run the example");

    const example_exe = b.addExecutable(.{
        .name = "overloading-example",
        .root_source_file = b.path("src/example.zig"),
        .target = target,
        .optimize = optimize,
    });

    // add overloading module import to example build
    example_exe.root_module.addImport("overloading", overloading_module);

    const run_cmd = b.addRunArtifact(example_exe);
    run_step.dependOn(&run_cmd.step);

    return run_step;
}

pub fn buildRunTestStep(b: *Build, target: ResolvedTarget, optimize: OptimizeMode) *Step {
    const test_step = b.step("test", "Run tests");

    const overloading_tests_compile = b.addTest(.{
        .root_source_file = b.path("src/test.zig"),
        .target = target,
        .optimize = optimize,
    });

    const run_overloading_tests = b.addRunArtifact(overloading_tests_compile);
    test_step.dependOn(&run_overloading_tests.step);

    return test_step;
}
