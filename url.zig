const std = @import("std");

pub const URL = struct {
    href: []const u8,
    origin: []const u8,
    protocol: []const u8,
    username: []const u8,
    password: []const u8,
    host: []const u8,
    hostname: []const u8,
    port: []const u8,
    pathname: []const u8,
    search: []const u8,
    hash: []const u8,

    /// Caller owns memory and is responsible for freeing `url.href`.
    pub fn parse(alloc: std.mem.Allocator, input: []const u8, base: ?[]const u8) !URL {
        var u: URL = .{ .href = "", .origin = "", .protocol = "", .username = "", .password = "", .host = "", .hostname = "", .port = "", .pathname = "", .search = "", .hash = "" };
        _ = &u;
        _ = alloc;
        _ = input;
        _ = base;
        return error.SkipZigTest;
    }
};
