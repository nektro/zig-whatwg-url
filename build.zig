const std = @import("std");
const deps = @import("./deps.zig");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const mode = b.option(std.builtin.Mode, "mode", "") orelse .Debug;
    const disable_llvm = b.option(bool, "disable_llvm", "use the non-llvm zig codegen") orelse false;

    const gen_step = b.step("generate", "");
    const gen_cmd = b.addSystemCommand(&.{ "bun", "./generate.ts" });
    const gen_out = gen_cmd.addOutputFileArg("test.zig");
    const gen_install = b.addInstallFile(gen_out, "test.zig");
    gen_cmd.setCwd(b.path("."));
    gen_cmd.addFileInput(b.path("generate.ts"));
    gen_step.dependOn(&gen_install.step);

    const tests = b.addTest(.{
        .root_source_file = b.path("test.zig"),
        .target = target,
        .optimize = mode,
    });
    deps.addAllTo(tests);
    tests.use_llvm = !disable_llvm;
    tests.use_lld = !disable_llvm;

    const test_step = b.step("test", "Run all library tests");
    const tests_run = b.addRunArtifact(tests);
    tests_run.setCwd(b.path("."));
    tests_run.has_side_effects = true;
    test_step.dependOn(&tests_run.step);
}
