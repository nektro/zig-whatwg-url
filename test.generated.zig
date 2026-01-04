const std = @import("std");
const url = @import("url");
const expect = @import("expect").expect;

// zig fmt: off

pub fn parseFail(input: []const u8, base: ?[]const u8) !void {
    const allocator = std.testing.allocator;
    _ = url.URL.parse(allocator, input, base) catch return;
    return error.FailZigTest;
}

pub fn parsePass(input: []const u8, base: ?[]const u8, href: []const u8, origin: []const u8, protocol: []const u8, username: []const u8, password: []const u8, host: []const u8, hostname: []const u8, port: []const u8, pathname: []const u8, search: []const u8, hash: []const u8) !void {
    const allocator = std.testing.allocator;
    const u = try url.URL.parse(allocator, input, base);
    try expect(u.href).toEqualString(href);
    try expect(u.origin).toEqualString(origin);
    try expect(u.protocol).toEqualString(protocol);
    try expect(u.username).toEqualString(username);
    try expect(u.password).toEqualString(password);
    try expect(u.host).toEqualString(host);
    try expect(u.hostname).toEqualString(hostname);
    try expect(u.port).toEqualString(port);
    try expect(u.pathname).toEqualString(pathname);
    try expect(u.search).toEqualString(search);
    try expect(u.hash).toEqualString(hash);
}

pub fn parseIDNAFail(input: []const u8) !void {
    _ = input;
    // new URL('https://{idnaTest.input}/x')
    return error.SkipZigTest;
}

pub fn parseIDNAPass(input: []const u8, output: []const u8) !void {
    _ = input;
    _ = output;
    // new URL('https://{idnaTest.input}/x');
    // assert_equals(url.host, idnaTest.output);
    // assert_equals(url.hostname, idnaTest.output);
    // assert_equals(url.pathname, "/x");
    // assert_equals(url.href, 'https://{idnaTest.output}/x');
    return error.SkipZigTest;
}






