const std = @import("std");
const builtin = @import("builtin");

const program_name = "zig-template";

// Must match the `version` in `build.zig.zon`.
const version: std.SemanticVersion = .{ .major = 0, .minor = 0, .patch = 0 };

const release_targets = [_]std.Target.Query{
    .{ .cpu_arch = .aarch64, .os_tag = .macos },
    .{ .cpu_arch = .aarch64, .os_tag = .linux },
    .{ .cpu_arch = .x86_64, .os_tag = .linux },
    .{ .cpu_arch = .x86_64, .os_tag = .windows },
};

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});

    const single_threaded = b.option(bool, "single-threaded", "Build a single threaded Executable");
    const pie = b.option(bool, "pie", "Build a Position Independent Executable");
    const strip = b.option(bool, "strip", "Strip executable");
    const use_llvm = b.option(bool, "use-llvm", "Use Zig's llvm code backend");

    const build_options = blk: {
        const options = b.addOptions();
        options.addOption(std.SemanticVersion, "version", version);
        options.addOption([]const u8, "version_string", b.fmt("{f}", .{version}));
        break :blk options.createModule();
    };

    // zig build release
    var release_artifacts: [release_targets.len]*std.Build.Step.Compile = undefined;
    for (release_targets, &release_artifacts) |target_query, *artifact| {
        const release_target = b.resolveTargetQuery(target_query);

        const exe_module = b.createModule(.{
            .root_source_file = b.path("src/main.zig"),
            .target = release_target,
            .optimize = .ReleaseFast,
            .single_threaded = single_threaded,
            .pic = pie,
            .strip = strip,
            .imports = &.{
                .{ .name = "build_options", .module = build_options },
            },
        });

        artifact.* = b.addExecutable(.{
            .name = program_name,
            .root_module = exe_module,
            .use_llvm = use_llvm,
            .use_lld = use_llvm,
        });
    }
    release(b, &release_artifacts);

    const exe_module = b.createModule(.{
        .root_source_file = b.path("src/main.zig"),
        .target = target,
        .optimize = optimize,
        .single_threaded = single_threaded,
        .pic = pie,
        .strip = strip,
        .imports = &.{
            .{ .name = "build_options", .module = build_options },
        },
    });

    // zig build
    const exe = b.addExecutable(.{
        .name = program_name,
        .root_module = exe_module,
        .use_llvm = use_llvm,
        .use_lld = use_llvm,
    });
    b.installArtifact(exe);

    // zib build run
    const run_cmd = b.addRunArtifact(exe);
    run_cmd.step.dependOn(b.getInstallStep());
    if (b.args) |args| {
        run_cmd.addArgs(args);
    }
    const run_step = b.step("run", "Run the app");
    run_step.dependOn(&run_cmd.step);

    // zib build test
    const tests = b.addTest(.{ .root_module = exe_module });
    const run_tests = b.addRunArtifact(tests);
    const test_step = b.step("test", "Run tests");
    test_step.dependOn(&run_tests.step);

    // zig build fmt
    const fmt_step = b.step("fmt", "Format all source files");
    fmt_step.dependOn(&b.addFmt(.{ .paths = &.{ "build.zig", "src" } }).step);
}

/// Original from https://github.com/zigtools/zls/blob/master/build.zig
/// - compile binaries with different targets
/// - compress them (.tar.xz or .zip)
/// - install artifacts to `./zig-out`
fn release(b: *std.Build, release_artifacts: []const *std.Build.Step.Compile) void {
    const release_step = b.step("release", "Build all release artifacts. (requires tar and 7z)");
    const install_dir: std.Build.InstallDir = .{ .custom = "artifacts" };
    const FileExtension = enum { zip, @"tar.xz" };

    for (release_artifacts) |exe| {
        const resolved_target = exe.root_module.resolved_target.?.result;
        const is_windows = resolved_target.os.tag == .windows;
        const exe_name = b.fmt("{s}{s}", .{ exe.name, resolved_target.exeFileExt() });
        const extension: FileExtension = if (is_windows) .zip else .@"tar.xz";

        const cpu_arch_name = @tagName(resolved_target.cpu.arch);
        const file_name = b.fmt(program_name ++ "-{t}-{s}-{f}.{t}", .{
            resolved_target.os.tag,
            cpu_arch_name,
            version,
            extension,
        });
        var file_path: std.Build.LazyPath = undefined;

        const compress_cmd = std.Build.Step.Run.create(b, "compress artifact");
        compress_cmd.clearEnvironment();
        switch (extension) {
            .zip => {
                compress_cmd.addArgs(&.{ "7z", "a", "-mx=9" });
                file_path = compress_cmd.addOutputFileArg(file_name);
                compress_cmd.addArtifactArg(exe);
                compress_cmd.addFileArg(exe.getEmittedPdb());
                compress_cmd.addFileArg(b.path("LICENSE"));
                compress_cmd.addFileArg(b.path("README.md"));
            },
            .@"tar.xz" => {
                compress_cmd.setEnvironmentVariable("PATH", b.graph.env_map.get("PATH") orelse "");
                compress_cmd.setEnvironmentVariable("XZ_OPT", "-9");
                compress_cmd.addArgs(&.{ "tar", "caf" });
                file_path = compress_cmd.addOutputFileArg(file_name);
                compress_cmd.addPrefixedDirectoryArg("-C", exe.getEmittedBinDirectory());
                compress_cmd.addArg(exe_name);

                compress_cmd.addPrefixedDirectoryArg("-C", b.path("."));
                compress_cmd.addArg("LICENSE");
                compress_cmd.addArg("README.md");

                compress_cmd.addArgs(&.{
                    "--sort=name",
                    "--numeric-owner",
                    "--owner=0",
                    "--group=0",
                    "--mtime=1970-01-01",
                });
            },
        }

        const install_tarball = b.addInstallFileWithDir(file_path, install_dir, file_name);
        release_step.dependOn(&install_tarball.step);
    }
}
