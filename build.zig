const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const overloading_module = b.addModule("overloading", .{ .root_source_Wfile = .{
        .src_path = .{
            .owner = b,
            .sub_path = "src/overloading.zig",
        },
    } });

    const example_exe = b.addExecutable(.{
        .name = "overloading-example",
        .root_source_file = b.path("src/example.zig"),
        .target = target,
        .optimize = optimize,
    });

    // add overloading module import to example build
    example_exe.root_module.addImport("overloading", overloading_module);

    b.installArtifact(example_exe);

    const run_cmd = b.addRunArtifact(example_exe);
    run_cmd.step.dependOn(b.getInstallStep());

    // This allows the user to pass arguments to the application in the build
    // command itself, like this: `zig build run -- arg1 arg2 etc`
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }

    const run_step = b.step("run", "Run the example");
    run_step.dependOn(&run_cmd.step);
}
