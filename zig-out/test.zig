const std = @import("std");
const url = @import("url");
const expect = @import("expect").expect;

// zig fmt: off

pub fn parseFail(input: []const u8, base: ?[]const u8) !void {
    const allocator = std.testing.allocator;
    _ = url.URL.parse(allocator, input, base) catch |err| switch (err) {
        error.InvalidURL => return,
        error.OutOfMemory => return error.OutOfMemory,
    };
    return error.FailZigTest;
}

pub fn parsePass(input: []const u8, base: ?[]const u8, href: []const u8, origin: []const u8, protocol: []const u8, username: []const u8, password: []const u8, host: []const u8, hostname: []const u8, port: []const u8, pathname: []const u8, search: []const u8, hash: []const u8) !void {
    const allocator = std.testing.allocator;
    const u = try url.URL.parse(allocator, input, base);
    defer allocator.free(u.href);
    _ = href;
    _ = origin;
    try expect(u.protocol).toEqualString(protocol);
    try expect(u.username).toEqualString(username);
    try expect(u.password).toEqualString(password);
    _ = host;
    _ = hostname;
    try expect(u.port).toEqualString(port);
    _ = pathname;
    try expect(u.search).toEqualString(search);
    _ = hash;
}

pub fn parseIDNAFail(comptime input: []const u8) !void {
    const allocator = std.testing.allocator;
    _ = url.URL.parse(allocator, "https://" ++ input ++ "/x", null) catch |err| switch (err) {
        error.InvalidURL => return,
        error.OutOfMemory => return error.OutOfMemory,
    };
    return error.FailZigTest;
}

pub fn parseIDNAPass(comptime input: []const u8, comptime output: []const u8) !void {
    _ = output;
    // new URL('https://{idnaTest.input}/x');
    const allocator = std.testing.allocator;
    const u = try url.URL.parse(allocator, "https://" ++ input ++ "/x", null);
    defer allocator.free(u.href);
    // assert_equals(url.host, idnaTest.output);
    // assert_equals(url.hostname, idnaTest.output);
    // assert_equals(url.pathname, "/x");
    // assert_equals(url.href, 'https://{idnaTest.output}/x');
}

test { try parseFail("file://example:1/", null); }
test { try parseFail("file://example:test/", null); }
test { try parseFail("file://example%/", null); }
test { try parseFail("file://[example]/", null); }
test { try parseFail("http://user:pass@/", null); }
test { try parseFail("http://foo:-80/", null); }
test { try parseFail("http:/:@/www.example.com", null); }
test { try parseFail("http://user@/www.example.com", null); }
test { try parseFail("http:@/www.example.com", null); }
test { try parseFail("http:/@/www.example.com", null); }
test { try parseFail("http://@/www.example.com", null); }
test { try parseFail("https:@/www.example.com", null); }
test { try parseFail("http:a:b@/www.example.com", null); }
test { try parseFail("http:/a:b@/www.example.com", null); }
test { try parseFail("http://a:b@/www.example.com", null); }
test { try parseFail("http::@/www.example.com", null); }
test { try parseFail("http:@:www.example.com", null); }
test { try parseFail("http:/@:www.example.com", null); }
test { try parseFail("http://@:www.example.com", null); }
test { try parseFail("https://\xef\xbf\xbd", null); }
test { try parseFail("https://%EF%BF%BD", null); }
test { try parseFail("http://a.b.c.xn--pokxncvks", null); }
test { try parseFail("http://10.0.0.xn--pokxncvks", null); }
test { try parseFail("http://a.b.c.XN--pokxncvks", null); }
test { try parseFail("http://a.b.c.Xn--pokxncvks", null); }
test { try parseFail("http://10.0.0.XN--pokxncvks", null); }
test { try parseFail("http://10.0.0.xN--pokxncvks", null); }
test { try parseFail("https://x x:12", null); }
test { try parseFail("http://[www.google.com]/", null); }
test { try parseFail("sc://@/", null); }
test { try parseFail("sc://te@s:t@/", null); }
test { try parseFail("sc://:/", null); }
test { try parseFail("sc://:12/", null); }
test { try parseFail("sc://a\x00b/", null); }
test { try parseFail("sc://a b/", null); }
test { try parseFail("sc://a<b", null); }
test { try parseFail("sc://a>b", null); }
test { try parseFail("sc://a[b/", null); }
test { try parseFail("sc://a\\b/", null); }
test { try parseFail("sc://a]b/", null); }
test { try parseFail("sc://a^b", null); }
test { try parseFail("sc://a|b/", null); }
test { try parseFail("http://a\x00b/", null); }
test { try parseFail("http://a\x01b/", null); }
test { try parseFail("http://a\x02b/", null); }
test { try parseFail("http://a\x03b/", null); }
test { try parseFail("http://a\x04b/", null); }
test { try parseFail("http://a\x05b/", null); }
test { try parseFail("http://a\x06b/", null); }
test { try parseFail("http://a\x07b/", null); }
test { try parseFail("http://a\x08b/", null); }
test { try parseFail("http://a\x0bb/", null); }
test { try parseFail("http://a\x0cb/", null); }
test { try parseFail("http://a\x0eb/", null); }
test { try parseFail("http://a\x0fb/", null); }
test { try parseFail("http://a\x10b/", null); }
test { try parseFail("http://a\x11b/", null); }
test { try parseFail("http://a\x12b/", null); }
test { try parseFail("http://a\x13b/", null); }
test { try parseFail("http://a\x14b/", null); }
test { try parseFail("http://a\x15b/", null); }
test { try parseFail("http://a\x16b/", null); }
test { try parseFail("http://a\x17b/", null); }
test { try parseFail("http://a\x18b/", null); }
test { try parseFail("http://a\x19b/", null); }
test { try parseFail("http://a\x1ab/", null); }
test { try parseFail("http://a\x1bb/", null); }
test { try parseFail("http://a\x1cb/", null); }
test { try parseFail("http://a\x1db/", null); }
test { try parseFail("http://a\x1eb/", null); }
test { try parseFail("http://a\x1fb/", null); }
test { try parseFail("http://a b/", null); }
test { try parseFail("http://a%b/", null); }
test { try parseFail("http://a<b", null); }
test { try parseFail("http://a>b", null); }
test { try parseFail("http://a[b/", null); }
test { try parseFail("http://a]b/", null); }
test { try parseFail("http://a^b", null); }
test { try parseFail("http://a|b/", null); }
test { try parseFail("http://a\x7fb/", null); }
test { try parseFail("http://ho%00st/", null); }
test { try parseFail("http://ho%01st/", null); }
test { try parseFail("http://ho%02st/", null); }
test { try parseFail("http://ho%03st/", null); }
test { try parseFail("http://ho%04st/", null); }
test { try parseFail("http://ho%05st/", null); }
test { try parseFail("http://ho%06st/", null); }
test { try parseFail("http://ho%07st/", null); }
test { try parseFail("http://ho%08st/", null); }
test { try parseFail("http://ho%09st/", null); }
test { try parseFail("http://ho%0Ast/", null); }
test { try parseFail("http://ho%0Bst/", null); }
test { try parseFail("http://ho%0Cst/", null); }
test { try parseFail("http://ho%0Dst/", null); }
test { try parseFail("http://ho%0Est/", null); }
test { try parseFail("http://ho%0Fst/", null); }
test { try parseFail("http://ho%10st/", null); }
test { try parseFail("http://ho%11st/", null); }
test { try parseFail("http://ho%12st/", null); }
test { try parseFail("http://ho%13st/", null); }
test { try parseFail("http://ho%14st/", null); }
test { try parseFail("http://ho%15st/", null); }
test { try parseFail("http://ho%16st/", null); }
test { try parseFail("http://ho%17st/", null); }
test { try parseFail("http://ho%18st/", null); }
test { try parseFail("http://ho%19st/", null); }
test { try parseFail("http://ho%1Ast/", null); }
test { try parseFail("http://ho%1Bst/", null); }
test { try parseFail("http://ho%1Cst/", null); }
test { try parseFail("http://ho%1Dst/", null); }
test { try parseFail("http://ho%1Est/", null); }
test { try parseFail("http://ho%1Fst/", null); }
test { try parseFail("http://ho%20st/", null); }
test { try parseFail("http://ho%23st/", null); }
test { try parseFail("http://ho%25st/", null); }
test { try parseFail("http://ho%2Fst/", null); }
test { try parseFail("http://ho%3Ast/", null); }
test { try parseFail("http://ho%3Cst/", null); }
test { try parseFail("http://ho%3Est/", null); }
test { try parseFail("http://ho%3Fst/", null); }
test { try parseFail("http://ho%40st/", null); }
test { try parseFail("http://ho%5Bst/", null); }
test { try parseFail("http://ho%5Cst/", null); }
test { try parseFail("http://ho%5Dst/", null); }
test { try parseFail("http://ho%7Cst/", null); }
test { try parseFail("http://ho%7Fst/", null); }
test { try parseFail("ftp://example.com%80/", null); }
test { try parseFail("ftp://example.com%A0/", null); }
test { try parseFail("https://example.com%80/", null); }
test { try parseFail("https://example.com%A0/", null); }
test { try parseFail("https://0x100000000/test", null); }
test { try parseFail("https://256.0.0.1/test", null); }
test { try parseFail("file://%43%3A", null); }
test { try parseFail("file://%43%7C", null); }
test { try parseFail("file://%43|", null); }
test { try parseFail("file://C%7C", null); }
test { try parseFail("file://%43%7C/", null); }
test { try parseFail("https://%43%7C/", null); }
test { try parseFail("asdf://%43|/", null); }
test { try parseFail("\\\\\\.\\Y:", null); }
test { try parseFail("\\\\\\.\\y:", null); }
test { try parseFail("https://[0::0::0]", null); }
test { try parseFail("https://[0:.0]", null); }
test { try parseFail("https://[0:0:]", null); }
test { try parseFail("https://[0:1:2:3:4:5:6:7.0.0.0.1]", null); }
test { try parseFail("https://[0:1.00.0.0.0]", null); }
test { try parseFail("https://[0:1.290.0.0.0]", null); }
test { try parseFail("https://[0:1.23.23]", null); }
test { try parseFail("http://?", null); }
test { try parseFail("http://#", null); }
test { try parseFail("non-special://[:80/", null); }
test { try parseFail("http://[::127.0.0.0.1]", null); }
test { try parseFail("a", null); }
test { try parseFail("a/", null); }
test { try parseFail("a//", null); }
test { try parseFail("file://\xc2\xad/p", null); }
test { try parseFail("file://%C2%AD/p", null); }
test { try parseFail("file://xn--/p", null); }
test { try parseFail("#", null); }
test { try parseFail("?", null); }
test { try parseFail("http://0..0x300/", null); }
test { try parseFail("http://0..0x300./", null); }
test { try parseFail("http://1.2.3.08", null); }
test { try parseFail("http://1.2.3.08.", null); }
test { try parseFail("http://1.2.3.09", null); }
test { try parseFail("http://09.2.3.4", null); }
test { try parseFail("http://09.2.3.4.", null); }
test { try parseFail("http://01.2.3.4.5", null); }
test { try parseFail("http://01.2.3.4.5.", null); }
test { try parseFail("http://0x100.2.3.4", null); }
test { try parseFail("http://0x100.2.3.4.", null); }
test { try parseFail("http://0x1.2.3.4.5", null); }
test { try parseFail("http://0x1.2.3.4.5.", null); }
test { try parseFail("http://foo.1.2.3.4", null); }
test { try parseFail("http://foo.1.2.3.4.", null); }
test { try parseFail("http://foo.2.3.4", null); }
test { try parseFail("http://foo.2.3.4.", null); }
test { try parseFail("http://foo.09", null); }
test { try parseFail("http://foo.09.", null); }
test { try parseFail("http://foo.0x4", null); }
test { try parseFail("http://foo.0x4.", null); }
test { try parseFail("http://0999999999999999999/", null); }
test { try parseFail("http://foo.0x", null); }
test { try parseFail("http://foo.0XFfFfFfFfFfFfFfFfFfAcE123", null); }
test { try parseFail("http://\xf0\x9f\x92\xa9.123/", null); }
test { try parseFail("https://\x00y", null); }
test { try parseFail("https://\xef\xbf\xbfy", null); }
test { try parseFail("", null); }
test { try parseFail("https://\xc2\xad/", null); }
test { try parseFail("https://%C2%AD/", null); }
test { try parseFail("https://xn--/", null); }
test { try parseFail("data://:443", null); }
test { try parseFail("data://test:test", null); }
test { try parseFail("data://[:1]", null); }
test { try parseFail("javascript://:443", null); }
test { try parseFail("javascript://test:test", null); }
test { try parseFail("javascript://[:1]", null); }
test { try parseFail("mailto://:443", null); }
test { try parseFail("mailto://test:test", null); }
test { try parseFail("mailto://[:1]", null); }
test { try parseFail("intent://:443", null); }
test { try parseFail("intent://test:test", null); }
test { try parseFail("intent://[:1]", null); }
test { try parseFail("urn://:443", null); }
test { try parseFail("urn://test:test", null); }
test { try parseFail("urn://[:1]", null); }
test { try parseFail("turn://:443", null); }
test { try parseFail("turn://test:test", null); }
test { try parseFail("turn://[:1]", null); }
test { try parseFail("stun://:443", null); }
test { try parseFail("stun://test:test", null); }
test { try parseFail("stun://[:1]", null); }
test { try parseFail("non-special://host\\a", null); }


test { try parsePass("https://test:@test", null, "https://test@test/", "https://test", "https:", "test", "", "test", "test", "", "/", "", ""); }
test { try parsePass("https://:@test", null, "https://test/", "https://test", "https:", "", "", "test", "test", "", "/", "", ""); }
test { try parsePass("non-special://test:@test/x", null, "non-special://test@test/x", "null", "non-special:", "test", "", "test", "test", "", "/x", "", ""); }
test { try parsePass("non-special://:@test/x", null, "non-special://test/x", "null", "non-special:", "", "", "test", "test", "", "/x", "", ""); }
test { try parsePass("lolscheme:x x#x x", null, "lolscheme:x x#x%20x", "", "lolscheme:", "", "", "", "", "", "x x", "", "#x%20x"); }
test { try parsePass("http://a:b@c\\", null, "http://a:b@c/", "http://c", "http:", "a", "b", "c", "c", "", "/", "", ""); }
test { try parsePass("ws://a@b\\c", null, "ws://a@b/c", "ws://b", "ws:", "a", "", "b", "b", "", "/c", "", ""); }
test { try parsePass("file:///w|m", null, "file:///w|m", "", "file:", "", "", "", "", "", "/w|m", "", ""); }
test { try parsePass("file:///w||m", null, "file:///w||m", "", "file:", "", "", "", "", "", "/w||m", "", ""); }
test { try parsePass("file:///w|/m", null, "file:///w:/m", "", "file:", "", "", "", "", "", "/w:/m", "", ""); }
test { try parsePass("file:C|/m/", null, "file:///C:/m/", "", "file:", "", "", "", "", "", "/C:/m/", "", ""); }
test { try parsePass("file:C||/m/", null, "file:///C||/m/", "", "file:", "", "", "", "", "", "/C||/m/", "", ""); }
test { try parsePass("http://example.com/././foo", null, "http://example.com/foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo", "", ""); }
test { try parsePass("http://example.com/./.foo", null, "http://example.com/.foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/.foo", "", ""); }
test { try parsePass("http://example.com/foo/.", null, "http://example.com/foo/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/", "", ""); }
test { try parsePass("http://example.com/foo/./", null, "http://example.com/foo/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/", "", ""); }
test { try parsePass("http://example.com/foo/bar/..", null, "http://example.com/foo/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/", "", ""); }
test { try parsePass("http://example.com/foo/bar/../", null, "http://example.com/foo/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/", "", ""); }
test { try parsePass("http://example.com/foo/..bar", null, "http://example.com/foo/..bar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/..bar", "", ""); }
test { try parsePass("http://example.com/foo/bar/../ton", null, "http://example.com/foo/ton", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/ton", "", ""); }
test { try parsePass("http://example.com/foo/bar/../ton/../../a", null, "http://example.com/a", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/a", "", ""); }
test { try parsePass("http://example.com/foo/../../..", null, "http://example.com/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("http://example.com/foo/../../../ton", null, "http://example.com/ton", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/ton", "", ""); }
test { try parsePass("http://example.com/foo/%2e", null, "http://example.com/foo/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/", "", ""); }
test { try parsePass("http://example.com/foo/%2e%2", null, "http://example.com/foo/%2e%2", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/%2e%2", "", ""); }
test { try parsePass("http://example.com/foo/%2e./%2e%2e/.%2e/%2e.bar", null, "http://example.com/%2e.bar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%2e.bar", "", ""); }
test { try parsePass("http://example.com////../..", null, "http://example.com//", "http://example.com", "http:", "", "", "example.com", "example.com", "", "//", "", ""); }
test { try parsePass("http://example.com/foo/bar//../..", null, "http://example.com/foo/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/", "", ""); }
test { try parsePass("http://example.com/foo/bar//..", null, "http://example.com/foo/bar/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo/bar/", "", ""); }
test { try parsePass("http://example.com/foo", null, "http://example.com/foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo", "", ""); }
test { try parsePass("http://example.com/%20foo", null, "http://example.com/%20foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%20foo", "", ""); }
test { try parsePass("http://example.com/foo%", null, "http://example.com/foo%", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%", "", ""); }
test { try parsePass("http://example.com/foo%2", null, "http://example.com/foo%2", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%2", "", ""); }
test { try parsePass("http://example.com/foo%2zbar", null, "http://example.com/foo%2zbar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%2zbar", "", ""); }
test { try parsePass("http://example.com/foo%2\xc3\x82\xc2\xa9zbar", null, "http://example.com/foo%2%C3%82%C2%A9zbar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%2%C3%82%C2%A9zbar", "", ""); }
test { try parsePass("http://example.com/foo%41%7a", null, "http://example.com/foo%41%7a", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%41%7a", "", ""); }
test { try parsePass("http://example.com/foo\t\xc2\x91%91", null, "http://example.com/foo%C2%91%91", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%C2%91%91", "", ""); }
test { try parsePass("http://example.com/foo%00%51", null, "http://example.com/foo%00%51", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%00%51", "", ""); }
test { try parsePass("http://example.com/(%28:%3A%29)", null, "http://example.com/(%28:%3A%29)", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/(%28:%3A%29)", "", ""); }
test { try parsePass("http://example.com/%3A%3a%3C%3c", null, "http://example.com/%3A%3a%3C%3c", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%3A%3a%3C%3c", "", ""); }
test { try parsePass("http://example.com/foo\tbar", null, "http://example.com/foobar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foobar", "", ""); }
test { try parsePass("http://example.com\\\\foo\\\\bar", null, "http://example.com//foo//bar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "//foo//bar", "", ""); }
test { try parsePass("http://example.com/%7Ffp3%3Eju%3Dduvgw%3Dd", null, "http://example.com/%7Ffp3%3Eju%3Dduvgw%3Dd", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%7Ffp3%3Eju%3Dduvgw%3Dd", "", ""); }
test { try parsePass("http://example.com/@asdf%40", null, "http://example.com/@asdf%40", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/@asdf%40", "", ""); }
test { try parsePass("http://example.com/\xe4\xbd\xa0\xe5\xa5\xbd\xe4\xbd\xa0\xe5\xa5\xbd", null, "http://example.com/%E4%BD%A0%E5%A5%BD%E4%BD%A0%E5%A5%BD", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%E4%BD%A0%E5%A5%BD%E4%BD%A0%E5%A5%BD", "", ""); }
test { try parsePass("http://example.com/\xe2\x80\xa5/foo", null, "http://example.com/%E2%80%A5/foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%E2%80%A5/foo", "", ""); }
test { try parsePass("http://example.com/\xef\xbb\xbf/foo", null, "http://example.com/%EF%BB%BF/foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%EF%BB%BF/foo", "", ""); }
test { try parsePass("http://example.com/\xe2\x80\xae/foo/\xe2\x80\xad/bar", null, "http://example.com/%E2%80%AE/foo/%E2%80%AD/bar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%E2%80%AE/foo/%E2%80%AD/bar", "", ""); }
test { try parsePass("http://www.google.com/foo?bar=baz#", null, "http://www.google.com/foo?bar=baz#", "http://www.google.com", "http:", "", "", "www.google.com", "www.google.com", "", "/foo", "?bar=baz", ""); }
test { try parsePass("http://www.google.com/foo?bar=baz# \xc2\xbb", null, "http://www.google.com/foo?bar=baz#%20%C2%BB", "http://www.google.com", "http:", "", "", "www.google.com", "www.google.com", "", "/foo", "?bar=baz", "#%20%C2%BB"); }
test { try parsePass("data:test# \xc2\xbb", null, "data:test#%20%C2%BB", "null", "data:", "", "", "", "", "", "test", "", "#%20%C2%BB"); }
test { try parsePass("http://www.google.com", null, "http://www.google.com/", "http://www.google.com", "http:", "", "", "www.google.com", "www.google.com", "", "/", "", ""); }
test { try parsePass("http://192.0x00A80001", null, "http://192.168.0.1/", "http://192.168.0.1", "http:", "", "", "192.168.0.1", "192.168.0.1", "", "/", "", ""); }
test { try parsePass("http://www/foo%2Ehtml", null, "http://www/foo%2Ehtml", "http://www", "http:", "", "", "www", "www", "", "/foo%2Ehtml", "", ""); }
test { try parsePass("http://www/foo/%2E/html", null, "http://www/foo/html", "http://www", "http:", "", "", "www", "www", "", "/foo/html", "", ""); }
test { try parsePass("http://%25DOMAIN:foobar@foodomain.com/", null, "http://%25DOMAIN:foobar@foodomain.com/", "http://foodomain.com", "http:", "%25DOMAIN", "foobar", "foodomain.com", "foodomain.com", "", "/", "", ""); }
test { try parsePass("http:\\\\www.google.com\\foo", null, "http://www.google.com/foo", "http://www.google.com", "http:", "", "", "www.google.com", "www.google.com", "", "/foo", "", ""); }
test { try parsePass("http://foo:80/", null, "http://foo/", "http://foo", "http:", "", "", "foo", "foo", "", "/", "", ""); }
test { try parsePass("http://foo:81/", null, "http://foo:81/", "http://foo:81", "http:", "", "", "foo:81", "foo", "81", "/", "", ""); }
test { try parsePass("httpa://foo:80/", null, "httpa://foo:80/", "null", "httpa:", "", "", "foo:80", "foo", "80", "/", "", ""); }
test { try parsePass("https://foo:443/", null, "https://foo/", "https://foo", "https:", "", "", "foo", "foo", "", "/", "", ""); }
test { try parsePass("https://foo:80/", null, "https://foo:80/", "https://foo:80", "https:", "", "", "foo:80", "foo", "80", "/", "", ""); }
test { try parsePass("ftp://foo:21/", null, "ftp://foo/", "ftp://foo", "ftp:", "", "", "foo", "foo", "", "/", "", ""); }
test { try parsePass("ftp://foo:80/", null, "ftp://foo:80/", "ftp://foo:80", "ftp:", "", "", "foo:80", "foo", "80", "/", "", ""); }
test { try parsePass("gopher://foo:70/", null, "gopher://foo:70/", "null", "gopher:", "", "", "foo:70", "foo", "70", "/", "", ""); }
test { try parsePass("gopher://foo:443/", null, "gopher://foo:443/", "null", "gopher:", "", "", "foo:443", "foo", "443", "/", "", ""); }
test { try parsePass("ws://foo:80/", null, "ws://foo/", "ws://foo", "ws:", "", "", "foo", "foo", "", "/", "", ""); }
test { try parsePass("ws://foo:81/", null, "ws://foo:81/", "ws://foo:81", "ws:", "", "", "foo:81", "foo", "81", "/", "", ""); }
test { try parsePass("ws://foo:443/", null, "ws://foo:443/", "ws://foo:443", "ws:", "", "", "foo:443", "foo", "443", "/", "", ""); }
test { try parsePass("ws://foo:815/", null, "ws://foo:815/", "ws://foo:815", "ws:", "", "", "foo:815", "foo", "815", "/", "", ""); }
test { try parsePass("wss://foo:80/", null, "wss://foo:80/", "wss://foo:80", "wss:", "", "", "foo:80", "foo", "80", "/", "", ""); }
test { try parsePass("wss://foo:81/", null, "wss://foo:81/", "wss://foo:81", "wss:", "", "", "foo:81", "foo", "81", "/", "", ""); }
test { try parsePass("wss://foo:443/", null, "wss://foo/", "wss://foo", "wss:", "", "", "foo", "foo", "", "/", "", ""); }
test { try parsePass("wss://foo:815/", null, "wss://foo:815/", "wss://foo:815", "wss:", "", "", "foo:815", "foo", "815", "/", "", ""); }
test { try parsePass("http:/example.com/", null, "http://example.com/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("ftp:/example.com/", null, "ftp://example.com/", "ftp://example.com", "ftp:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("https:/example.com/", null, "https://example.com/", "https://example.com", "https:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("madeupscheme:/example.com/", null, "madeupscheme:/example.com/", "null", "madeupscheme:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("file:/example.com/", null, "file:///example.com/", "", "file:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("ftps:/example.com/", null, "ftps:/example.com/", "null", "ftps:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("gopher:/example.com/", null, "gopher:/example.com/", "null", "gopher:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("ws:/example.com/", null, "ws://example.com/", "ws://example.com", "ws:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("wss:/example.com/", null, "wss://example.com/", "wss://example.com", "wss:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("data:/example.com/", null, "data:/example.com/", "null", "data:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("javascript:/example.com/", null, "javascript:/example.com/", "null", "javascript:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("mailto:/example.com/", null, "mailto:/example.com/", "null", "mailto:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("http:example.com/", null, "http://example.com/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("ftp:example.com/", null, "ftp://example.com/", "ftp://example.com", "ftp:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("https:example.com/", null, "https://example.com/", "https://example.com", "https:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("madeupscheme:example.com/", null, "madeupscheme:example.com/", "null", "madeupscheme:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("ftps:example.com/", null, "ftps:example.com/", "null", "ftps:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("gopher:example.com/", null, "gopher:example.com/", "null", "gopher:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("ws:example.com/", null, "ws://example.com/", "ws://example.com", "ws:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("wss:example.com/", null, "wss://example.com/", "wss://example.com", "wss:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("data:example.com/", null, "data:example.com/", "null", "data:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("javascript:example.com/", null, "javascript:example.com/", "null", "javascript:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("mailto:example.com/", null, "mailto:example.com/", "null", "mailto:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("https://example.com/aaa/bbb/%2e%2e?query", null, "https://example.com/aaa/?query", "https://example.com", "https:", "", "", "example.com", "example.com", "", "/aaa/", "?query", ""); }
test { try parsePass("http:@www.example.com", null, "http://www.example.com/", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http:/@www.example.com", null, "http://www.example.com/", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http://@www.example.com", null, "http://www.example.com/", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http:a:b@www.example.com", null, "http://a:b@www.example.com/", "http://www.example.com", "http:", "a", "b", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http:/a:b@www.example.com", null, "http://a:b@www.example.com/", "http://www.example.com", "http:", "a", "b", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http://a:b@www.example.com", null, "http://a:b@www.example.com/", "http://www.example.com", "http:", "a", "b", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http://@pple.com", null, "http://pple.com/", "http://pple.com", "http:", "", "", "pple.com", "pple.com", "", "/", "", ""); }
test { try parsePass("http::b@www.example.com", null, "http://:b@www.example.com/", "http://www.example.com", "http:", "", "b", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http:/:b@www.example.com", null, "http://:b@www.example.com/", "http://www.example.com", "http:", "", "b", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http://:b@www.example.com", null, "http://:b@www.example.com/", "http://www.example.com", "http:", "", "b", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http:a:@www.example.com", null, "http://a@www.example.com/", "http://www.example.com", "http:", "a", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http:/a:@www.example.com", null, "http://a@www.example.com/", "http://www.example.com", "http:", "a", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http://a:@www.example.com", null, "http://a@www.example.com/", "http://www.example.com", "http:", "a", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("http://www.@pple.com", null, "http://www.@pple.com/", "http://pple.com", "http:", "www.", "", "pple.com", "pple.com", "", "/", "", ""); }
test { try parsePass("http://:@www.example.com", null, "http://www.example.com/", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("file:.", null, "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("\x00\x1b\x04\x12 http://example.com/\x1f \r ", null, "http://example.com/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("non-special:opaque  ", null, "non-special:opaque", "null", "non-special:", "", "", "", "", "", "opaque", "", ""); }
test { try parsePass("non-special:opaque  ?hi", null, "non-special:opaque %20?hi", "null", "non-special:", "", "", "", "", "", "opaque %20", "?hi", ""); }
test { try parsePass("non-special:opaque  #hi", null, "non-special:opaque %20#hi", "null", "non-special:", "", "", "", "", "", "opaque %20", "", "#hi"); }
test { try parsePass("non-special:opaque  x?hi", null, "non-special:opaque  x?hi", "null", "non-special:", "", "", "", "", "", "opaque  x", "?hi", ""); }
test { try parsePass("non-special:opaque  x#hi", null, "non-special:opaque  x#hi", "null", "non-special:", "", "", "", "", "", "opaque  x", "", "#hi"); }
test { try parsePass("non-special:opaque \t\t  \t#hi", null, "non-special:opaque  %20#hi", "null", "non-special:", "", "", "", "", "", "opaque  %20", "", "#hi"); }
test { try parsePass("non-special:opaque \t\t  #hi", null, "non-special:opaque  %20#hi", "null", "non-special:", "", "", "", "", "", "opaque  %20", "", "#hi"); }
test { try parsePass("non-special:opaque\t\t  \r #hi", null, "non-special:opaque  %20#hi", "null", "non-special:", "", "", "", "", "", "opaque  %20", "", "#hi"); }
test { try parsePass("https://x/\xef\xbf\xbd?\xef\xbf\xbd#\xef\xbf\xbd", null, "https://x/%EF%BF%BD?%EF%BF%BD#%EF%BF%BD", "https://x", "https:", "", "", "x", "x", "", "/%EF%BF%BD", "?%EF%BF%BD", "#%EF%BF%BD"); }
test { try parsePass("https://fa\xc3\x9f.ExAmPlE/", null, "https://xn--fa-hia.example/", "https://xn--fa-hia.example", "https:", "", "", "xn--fa-hia.example", "xn--fa-hia.example", "", "/", "", ""); }
test { try parsePass("sc://fa\xc3\x9f.ExAmPlE/", null, "sc://fa%C3%9F.ExAmPlE/", "null", "sc:", "", "", "fa%C3%9F.ExAmPlE", "fa%C3%9F.ExAmPlE", "", "/", "", ""); }
test { try parsePass("http://./", null, "http://./", "http://.", "http:", "", "", ".", ".", "", "/", "", ""); }
test { try parsePass("http://../", null, "http://../", "http://..", "http:", "", "", "..", "..", "", "/", "", ""); }
test { try parsePass("h://.", null, "h://.", "null", "h:", "", "", ".", ".", "", "", "", ""); }
test { try parsePass("http://host/?'", null, "http://host/?%27", "http://host", "http:", "", "", "host", "host", "", "/", "?%27", ""); }
test { try parsePass("notspecial://host/?'", null, "notspecial://host/?'", "null", "notspecial:", "", "", "host", "host", "", "/", "?'", ""); }
test { try parsePass("about:/../", null, "about:/", "null", "about:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("data:/../", null, "data:/", "null", "data:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("javascript:/../", null, "javascript:/", "null", "javascript:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("mailto:/../", null, "mailto:/", "null", "mailto:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("sc://\xc3\xb1.test/", null, "sc://%C3%B1.test/", "null", "sc:", "", "", "%C3%B1.test", "%C3%B1.test", "", "/", "", ""); }
test { try parsePass("sc://%/", null, "sc://%/", "", "sc:", "", "", "%", "%", "", "/", "", ""); }
test { try parsePass("sc:\\../", null, "sc:\\../", "null", "sc:", "", "", "", "", "", "\\../", "", ""); }
test { try parsePass("sc::a@example.net", null, "sc::a@example.net", "null", "sc:", "", "", "", "", "", ":a@example.net", "", ""); }
test { try parsePass("wow:%NBD", null, "wow:%NBD", "null", "wow:", "", "", "", "", "", "%NBD", "", ""); }
test { try parsePass("wow:%1G", null, "wow:%1G", "null", "wow:", "", "", "", "", "", "%1G", "", ""); }
test { try parsePass("wow:\xef\xbf\xbf", null, "wow:%EF%BF%BF", "null", "wow:", "", "", "", "", "", "%EF%BF%BF", "", ""); }
test { try parsePass("foo://ho\tst/", null, "foo://host/", "", "foo:", "", "", "host", "host", "", "/", "", ""); }
test { try parsePass("foo://ho\nst/", null, "foo://host/", "", "foo:", "", "", "host", "host", "", "/", "", ""); }
test { try parsePass("foo://ho\rst/", null, "foo://host/", "", "foo:", "", "", "host", "host", "", "/", "", ""); }
test { try parsePass("http://ho\tst/", null, "http://host/", "", "http:", "", "", "host", "host", "", "/", "", ""); }
test { try parsePass("http://ho\nst/", null, "http://host/", "", "http:", "", "", "host", "host", "", "/", "", ""); }
test { try parsePass("http://ho\rst/", null, "http://host/", "", "http:", "", "", "host", "host", "", "/", "", ""); }
test { try parsePass("http://!\"$&'()*+,-.;=_`{}~/", null, "http://!\"$&'()*+,-.;=_`{}~/", "http://!\"$&'()*+,-.;=_`{}~", "http:", "", "", "!\"$&'()*+,-.;=_`{}~", "!\"$&'()*+,-.;=_`{}~", "", "/", "", ""); }
test { try parsePass("sc://\x01\x02\x03\x04\x05\x06\x07\x08\x0b\x0c\x0e\x0f\x10\x11\x12\x13\x14\x15\x16\x17\x18\x19\x1a\x1b\x1c\x1d\x1e\x1f\x7f!\"$%&'()*+,-.;=_`{}~/", null, "sc://%01%02%03%04%05%06%07%08%0B%0C%0E%0F%10%11%12%13%14%15%16%17%18%19%1A%1B%1C%1D%1E%1F%7F!\"$%&'()*+,-.;=_`{}~/", "null", "sc:", "", "", "%01%02%03%04%05%06%07%08%0B%0C%0E%0F%10%11%12%13%14%15%16%17%18%19%1A%1B%1C%1D%1E%1F%7F!\"$%&'()*+,-.;=_`{}~", "%01%02%03%04%05%06%07%08%0B%0C%0E%0F%10%11%12%13%14%15%16%17%18%19%1A%1B%1C%1D%1E%1F%7F!\"$%&'()*+,-.;=_`{}~", "", "/", "", ""); }
test { try parsePass("ftp://%e2%98%83", null, "ftp://xn--n3h/", "ftp://xn--n3h", "ftp:", "", "", "xn--n3h", "xn--n3h", "", "/", "", ""); }
test { try parsePass("https://%e2%98%83", null, "https://xn--n3h/", "https://xn--n3h", "https:", "", "", "xn--n3h", "xn--n3h", "", "/", "", ""); }
test { try parsePass("http://127.0.0.1:10100/relative_import.html", null, "http://127.0.0.1:10100/relative_import.html", "http://127.0.0.1:10100", "http:", "", "", "127.0.0.1:10100", "127.0.0.1", "10100", "/relative_import.html", "", ""); }
test { try parsePass("http://facebook.com/?foo=%7B%22abc%22", null, "http://facebook.com/?foo=%7B%22abc%22", "http://facebook.com", "http:", "", "", "facebook.com", "facebook.com", "", "/", "?foo=%7B%22abc%22", ""); }
test { try parsePass("https://localhost:3000/jqueryui@1.2.3", null, "https://localhost:3000/jqueryui@1.2.3", "https://localhost:3000", "https:", "", "", "localhost:3000", "localhost", "3000", "/jqueryui@1.2.3", "", ""); }
test { try parsePass("h\tt\nt\rp://h\to\ns\rt:9\t0\n0\r0/p\ta\nt\rh?q\tu\ne\rry#f\tr\na\rg", null, "http://host:9000/path?query#frag", "http://host:9000", "http:", "", "", "host:9000", "host", "9000", "/path", "?query", "#frag"); }
test { try parsePass("http://foo.bar/baz?qux#foo\x08bar", null, "http://foo.bar/baz?qux#foo%08bar", "http://foo.bar", "http:", "", "", "foo.bar", "foo.bar", "", "/baz", "?qux", "#foo%08bar"); }
test { try parsePass("http://foo.bar/baz?qux#foo\"bar", null, "http://foo.bar/baz?qux#foo%22bar", "http://foo.bar", "http:", "", "", "foo.bar", "foo.bar", "", "/baz", "?qux", "#foo%22bar"); }
test { try parsePass("http://foo.bar/baz?qux#foo<bar", null, "http://foo.bar/baz?qux#foo%3Cbar", "http://foo.bar", "http:", "", "", "foo.bar", "foo.bar", "", "/baz", "?qux", "#foo%3Cbar"); }
test { try parsePass("http://foo.bar/baz?qux#foo>bar", null, "http://foo.bar/baz?qux#foo%3Ebar", "http://foo.bar", "http:", "", "", "foo.bar", "foo.bar", "", "/baz", "?qux", "#foo%3Ebar"); }
test { try parsePass("http://foo.bar/baz?qux#foo`bar", null, "http://foo.bar/baz?qux#foo%60bar", "http://foo.bar", "http:", "", "", "foo.bar", "foo.bar", "", "/baz", "?qux", "#foo%60bar"); }
test { try parsePass("https://0x.0x.0", null, "https://0.0.0.0/", "https://0.0.0.0", "https:", "", "", "0.0.0.0", "0.0.0.0", "", "/", "", ""); }
test { try parsePass("file:///C%3A/", null, "file:///C%3A/", "", "file:", "", "", "", "", "", "/C%3A/", "", ""); }
test { try parsePass("file:///C%7C/", null, "file:///C%7C/", "", "file:", "", "", "", "", "", "/C%7C/", "", ""); }
test { try parsePass("asdf://%43%7C/", null, "asdf://%43%7C/", "null", "asdf:", "", "", "%43%7C", "%43%7C", "", "/", "", ""); }
test { try parsePass("file:\\\\//", null, "file:////", "", "file:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("file:\\\\\\\\", null, "file:////", "", "file:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("file:\\\\\\\\?fox", null, "file:////?fox", "", "file:", "", "", "", "", "", "//", "?fox", ""); }
test { try parsePass("file:\\\\\\\\#guppy", null, "file:////#guppy", "", "file:", "", "", "", "", "", "//", "", "#guppy"); }
test { try parsePass("file://spider///", null, "file://spider///", "", "file:", "", "", "spider", "spider", "", "///", "", ""); }
test { try parsePass("file:\\\\localhost//", null, "file:////", "", "file:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("file:///localhost//cat", null, "file:///localhost//cat", "", "file:", "", "", "", "", "", "/localhost//cat", "", ""); }
test { try parsePass("file://\\/localhost//cat", null, "file:////localhost//cat", "", "file:", "", "", "", "", "", "//localhost//cat", "", ""); }
test { try parsePass("file://localhost//a//../..//", null, "file://///", "", "file:", "", "", "", "", "", "///", "", ""); }
test { try parsePass("file://example.net/C:/", null, "file://example.net/C:/", "", "file:", "", "", "example.net", "example.net", "", "/C:/", "", ""); }
test { try parsePass("file://1.2.3.4/C:/", null, "file://1.2.3.4/C:/", "", "file:", "", "", "1.2.3.4", "1.2.3.4", "", "/C:/", "", ""); }
test { try parsePass("file://[1::8]/C:/", null, "file://[1::8]/C:/", "", "file:", "", "", "[1::8]", "[1::8]", "", "/C:/", "", ""); }
test { try parsePass("file:/C|/", null, "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("file://C|/", null, "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("file:", null, "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("file:?q=v", null, "file:///?q=v", "", "file:", "", "", "", "", "", "/", "?q=v", ""); }
test { try parsePass("file:#frag", null, "file:///#frag", "", "file:", "", "", "", "", "", "/", "", "#frag"); }
test { try parsePass("file:///Y:", null, "file:///Y:", "", "file:", "", "", "", "", "", "/Y:", "", ""); }
test { try parsePass("file:///Y:/", null, "file:///Y:/", "", "file:", "", "", "", "", "", "/Y:/", "", ""); }
test { try parsePass("file:///./Y", null, "file:///Y", "", "file:", "", "", "", "", "", "/Y", "", ""); }
test { try parsePass("file:///./Y:", null, "file:///Y:", "", "file:", "", "", "", "", "", "/Y:", "", ""); }
test { try parsePass("file:///y:", null, "file:///y:", "", "file:", "", "", "", "", "", "/y:", "", ""); }
test { try parsePass("file:///y:/", null, "file:///y:/", "", "file:", "", "", "", "", "", "/y:/", "", ""); }
test { try parsePass("file:///./y", null, "file:///y", "", "file:", "", "", "", "", "", "/y", "", ""); }
test { try parsePass("file:///./y:", null, "file:///y:", "", "file:", "", "", "", "", "", "/y:", "", ""); }
test { try parsePass("file://localhost//a//../..//foo", null, "file://///foo", "", "file:", "", "", "", "", "", "///foo", "", ""); }
test { try parsePass("file://localhost////foo", null, "file://////foo", "", "file:", "", "", "", "", "", "////foo", "", ""); }
test { try parsePass("file:////foo", null, "file:////foo", "", "file:", "", "", "", "", "", "//foo", "", ""); }
test { try parsePass("file:.//p", null, "file:////p", "", "file:", "", "", "", "", "", "//p", "", ""); }
test { try parsePass("file:/.//p", null, "file:////p", "", "file:", "", "", "", "", "", "//p", "", ""); }
test { try parsePass("sc://\xc3\xb1", null, "sc://%C3%B1", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "", ""); }
test { try parsePass("sc://\xc3\xb1?x", null, "sc://%C3%B1?x", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "?x", ""); }
test { try parsePass("sc://\xc3\xb1#x", null, "sc://%C3%B1#x", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "", "#x"); }
test { try parsePass("sc://?", null, "sc://?", "", "sc:", "", "", "", "", "", "", "", ""); }
test { try parsePass("sc://#", null, "sc://#", "", "sc:", "", "", "", "", "", "", "", ""); }
test { try parsePass("tftp://foobar.com/someconfig;mode=netascii", null, "tftp://foobar.com/someconfig;mode=netascii", "null", "tftp:", "", "", "foobar.com", "foobar.com", "", "/someconfig;mode=netascii", "", ""); }
test { try parsePass("telnet://user:pass@foobar.com:23/", null, "telnet://user:pass@foobar.com:23/", "null", "telnet:", "user", "pass", "foobar.com:23", "foobar.com", "23", "/", "", ""); }
test { try parsePass("ut2004://10.10.10.10:7777/Index.ut2", null, "ut2004://10.10.10.10:7777/Index.ut2", "null", "ut2004:", "", "", "10.10.10.10:7777", "10.10.10.10", "7777", "/Index.ut2", "", ""); }
test { try parsePass("redis://foo:bar@somehost:6379/0?baz=bam&qux=baz", null, "redis://foo:bar@somehost:6379/0?baz=bam&qux=baz", "null", "redis:", "foo", "bar", "somehost:6379", "somehost", "6379", "/0", "?baz=bam&qux=baz", ""); }
test { try parsePass("rsync://foo@host:911/sup", null, "rsync://foo@host:911/sup", "null", "rsync:", "foo", "", "host:911", "host", "911", "/sup", "", ""); }
test { try parsePass("git://github.com/foo/bar.git", null, "git://github.com/foo/bar.git", "null", "git:", "", "", "github.com", "github.com", "", "/foo/bar.git", "", ""); }
test { try parsePass("irc://myserver.com:6999/channel?passwd", null, "irc://myserver.com:6999/channel?passwd", "null", "irc:", "", "", "myserver.com:6999", "myserver.com", "6999", "/channel", "?passwd", ""); }
test { try parsePass("dns://fw.example.org:9999/foo.bar.org?type=TXT", null, "dns://fw.example.org:9999/foo.bar.org?type=TXT", "null", "dns:", "", "", "fw.example.org:9999", "fw.example.org", "9999", "/foo.bar.org", "?type=TXT", ""); }
test { try parsePass("ldap://localhost:389/ou=People,o=JNDITutorial", null, "ldap://localhost:389/ou=People,o=JNDITutorial", "null", "ldap:", "", "", "localhost:389", "localhost", "389", "/ou=People,o=JNDITutorial", "", ""); }
test { try parsePass("git+https://github.com/foo/bar", null, "git+https://github.com/foo/bar", "null", "git+https:", "", "", "github.com", "github.com", "", "/foo/bar", "", ""); }
test { try parsePass("urn:ietf:rfc:2648", null, "urn:ietf:rfc:2648", "null", "urn:", "", "", "", "", "", "ietf:rfc:2648", "", ""); }
test { try parsePass("tag:joe@example.org,2001:foo/bar", null, "tag:joe@example.org,2001:foo/bar", "null", "tag:", "", "", "", "", "", "joe@example.org,2001:foo/bar", "", ""); }
test { try parsePass("non-spec:/.//", null, "non-spec:/.//", "", "non-spec:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("non-spec:/..//", null, "non-spec:/.//", "", "non-spec:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("non-spec:/a/..//", null, "non-spec:/.//", "", "non-spec:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("non-spec:/.//path", null, "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("non-spec:/..//path", null, "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("non-spec:/a/..//path", null, "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("non-special://%E2%80%A0/", null, "non-special://%E2%80%A0/", "", "non-special:", "", "", "%E2%80%A0", "%E2%80%A0", "", "/", "", ""); }
test { try parsePass("non-special://H%4fSt/path", null, "non-special://H%4fSt/path", "", "non-special:", "", "", "H%4fSt", "H%4fSt", "", "/path", "", ""); }
test { try parsePass("non-special://[1:2:0:0:5:0:0:0]/", null, "non-special://[1:2:0:0:5::]/", "", "non-special:", "", "", "[1:2:0:0:5::]", "[1:2:0:0:5::]", "", "/", "", ""); }
test { try parsePass("non-special://[1:2:0:0:0:0:0:3]/", null, "non-special://[1:2::3]/", "", "non-special:", "", "", "[1:2::3]", "[1:2::3]", "", "/", "", ""); }
test { try parsePass("non-special://[1:2::3]:80/", null, "non-special://[1:2::3]:80/", "", "non-special:", "", "", "[1:2::3]:80", "[1:2::3]", "80", "/", "", ""); }
test { try parsePass("blob:https://example.com:443/", null, "blob:https://example.com:443/", "https://example.com", "blob:", "", "", "", "", "", "https://example.com:443/", "", ""); }
test { try parsePass("blob:http://example.org:88/", null, "blob:http://example.org:88/", "http://example.org:88", "blob:", "", "", "", "", "", "http://example.org:88/", "", ""); }
test { try parsePass("blob:d3958f5c-0777-0845-9dcf-2cb28783acaf", null, "blob:d3958f5c-0777-0845-9dcf-2cb28783acaf", "null", "blob:", "", "", "", "", "", "d3958f5c-0777-0845-9dcf-2cb28783acaf", "", ""); }
test { try parsePass("blob:", null, "blob:", "null", "blob:", "", "", "", "", "", "", "", ""); }
test { try parsePass("blob:blob:", null, "blob:blob:", "null", "blob:", "", "", "", "", "", "blob:", "", ""); }
test { try parsePass("blob:blob:https://example.org/", null, "blob:blob:https://example.org/", "null", "blob:", "", "", "", "", "", "blob:https://example.org/", "", ""); }
test { try parsePass("blob:about:blank", null, "blob:about:blank", "null", "blob:", "", "", "", "", "", "about:blank", "", ""); }
test { try parsePass("blob:file://host/path", null, "blob:file://host/path", "", "blob:", "", "", "", "", "", "file://host/path", "", ""); }
test { try parsePass("blob:ftp://host/path", null, "blob:ftp://host/path", "null", "blob:", "", "", "", "", "", "ftp://host/path", "", ""); }
test { try parsePass("blob:ws://example.org/", null, "blob:ws://example.org/", "null", "blob:", "", "", "", "", "", "ws://example.org/", "", ""); }
test { try parsePass("blob:wss://example.org/", null, "blob:wss://example.org/", "null", "blob:", "", "", "", "", "", "wss://example.org/", "", ""); }
test { try parsePass("blob:http%3a//example.org/", null, "blob:http%3a//example.org/", "null", "blob:", "", "", "", "", "", "http%3a//example.org/", "", ""); }
test { try parsePass("http://0x7f.0.0.0x7g", null, "http://0x7f.0.0.0x7g/", "", "http:", "", "", "0x7f.0.0.0x7g", "0x7f.0.0.0x7g", "", "/", "", ""); }
test { try parsePass("http://0X7F.0.0.0X7G", null, "http://0x7f.0.0.0x7g/", "", "http:", "", "", "0x7f.0.0.0x7g", "0x7f.0.0.0x7g", "", "/", "", ""); }
test { try parsePass("http://[0:1:0:1:0:1:0:1]", null, "http://[0:1:0:1:0:1:0:1]/", "", "http:", "", "", "[0:1:0:1:0:1:0:1]", "[0:1:0:1:0:1:0:1]", "", "/", "", ""); }
test { try parsePass("http://[1:0:1:0:1:0:1:0]", null, "http://[1:0:1:0:1:0:1:0]/", "", "http:", "", "", "[1:0:1:0:1:0:1:0]", "[1:0:1:0:1:0:1:0]", "", "/", "", ""); }
test { try parsePass("http://example.org/test?\"", null, "http://example.org/test?%22", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%22", ""); }
test { try parsePass("http://example.org/test?#", null, "http://example.org/test?#", "", "http:", "", "", "example.org", "example.org", "", "/test", "", ""); }
test { try parsePass("http://example.org/test?<", null, "http://example.org/test?%3C", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%3C", ""); }
test { try parsePass("http://example.org/test?>", null, "http://example.org/test?%3E", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%3E", ""); }
test { try parsePass("http://example.org/test?\xe2\x8c\xa3", null, "http://example.org/test?%E2%8C%A3", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%E2%8C%A3", ""); }
test { try parsePass("http://example.org/test?%23%23", null, "http://example.org/test?%23%23", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%23%23", ""); }
test { try parsePass("http://example.org/test?%GH", null, "http://example.org/test?%GH", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%GH", ""); }
test { try parsePass("http://example.org/test?a#%EF", null, "http://example.org/test?a#%EF", "", "http:", "", "", "example.org", "example.org", "", "/test", "?a", "#%EF"); }
test { try parsePass("http://example.org/test?a#%GH", null, "http://example.org/test?a#%GH", "", "http:", "", "", "example.org", "example.org", "", "/test", "?a", "#%GH"); }
test { try parsePass("http://example.org/test?a#b\x00c", null, "http://example.org/test?a#b%00c", "", "http:", "", "", "example.org", "example.org", "", "/test", "?a", "#b%00c"); }
test { try parsePass("non-spec://example.org/test?a#b\x00c", null, "non-spec://example.org/test?a#b%00c", "", "non-spec:", "", "", "example.org", "example.org", "", "/test", "?a", "#b%00c"); }
test { try parsePass("non-spec:/test?a#b\x00c", null, "non-spec:/test?a#b%00c", "", "non-spec:", "", "", "", "", "", "/test", "?a", "#b%00c"); }
test { try parsePass("file://a\xc2\xadb/p", null, "file://ab/p", "", "file:", "", "", "ab", "ab", "", "/p", "", ""); }
test { try parsePass("file://a%C2%ADb/p", null, "file://ab/p", "", "file:", "", "", "ab", "ab", "", "/p", "", ""); }
test { try parsePass("file://loC\xf0\x9d\x90\x80\xf0\x9d\x90\x8b\xf0\x9d\x90\x87\xf0\x9d\x90\xa8\xf0\x9d\x90\xac\xf0\x9d\x90\xad/usr/bin", null, "file:///usr/bin", "", "file:", "", "", "", "", "", "/usr/bin", "", ""); }
test { try parsePass("non-special:cannot-be-a-base-url-\x00\x01\x1f\x1e~\x7f\xc2\x80", null, "non-special:cannot-be-a-base-url-%00%01%1F%1E~%7F%C2%80", "null", "non-special:", "", "", "", "", "", "cannot-be-a-base-url-%00%01%1F%1E~%7F%C2%80", "", ""); }
test { try parsePass("non-special:cannot-be-a-base-url-!\"$%&'()*+,-.;<=>@[\\]^_`{|}~@/", null, "non-special:cannot-be-a-base-url-!\"$%&'()*+,-.;<=>@[\\]^_`{|}~@/", "null", "non-special:", "", "", "", "", "", "cannot-be-a-base-url-!\"$%&'()*+,-.;<=>@[\\]^_`{|}~@/", "", ""); }
test { try parsePass("https://www.example.com/path{\x7fpath.html?query'\x7f=query#fragment<\x7ffragment", null, "https://www.example.com/path%7B%7Fpath.html?query%27%7F=query#fragment%3C%7Ffragment", "https://www.example.com", "https:", "", "", "www.example.com", "www.example.com", "", "/path%7B%7Fpath.html", "?query%27%7F=query", "#fragment%3C%7Ffragment"); }
test { try parsePass("foo:// !\"$%&'()*+,-.;<=>@[\\]^_`{|}~@host/", null, "foo://%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~@host/", "null", "foo:", "%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~", "", "host", "host", "", "/", "", ""); }
test { try parsePass("wss:// !\"$%&'()*+,-.;<=>@[]^_`{|}~@host/", null, "wss://%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~@host/", "wss://host", "wss:", "%20!%22$%&'()*+,-.%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~", "", "host", "host", "", "/", "", ""); }
test { try parsePass("foo://joe: !\"$%&'()*+,-.:;<=>@[\\]^_`{|}~@host/", null, "foo://joe:%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~@host/", "null", "foo:", "joe", "%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5C%5D%5E_%60%7B%7C%7D~", "host", "host", "", "/", "", ""); }
test { try parsePass("wss://joe: !\"$%&'()*+,-.:;<=>@[]^_`{|}~@host/", null, "wss://joe:%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~@host/", "wss://host", "wss:", "joe", "%20!%22$%&'()*+,-.%3A%3B%3C%3D%3E%40%5B%5D%5E_%60%7B%7C%7D~", "host", "host", "", "/", "", ""); }
test { try parsePass("foo://!\"$%&'()*+,-.;=_`{}~/", null, "foo://!\"$%&'()*+,-.;=_`{}~/", "null", "foo:", "", "", "!\"$%&'()*+,-.;=_`{}~", "!\"$%&'()*+,-.;=_`{}~", "", "/", "", ""); }
test { try parsePass("wss://!\"$&'()*+,-.;=_`{}~/", null, "wss://!\"$&'()*+,-.;=_`{}~/", "wss://!\"$&'()*+,-.;=_`{}~", "wss:", "", "", "!\"$&'()*+,-.;=_`{}~", "!\"$&'()*+,-.;=_`{}~", "", "/", "", ""); }
test { try parsePass("foo://host/ !\"$%&'()*+,-./:;<=>@[\\]^_`{|}~", null, "foo://host/%20!%22$%&'()*+,-./:;%3C=%3E@[\\]%5E_%60%7B|%7D~", "null", "foo:", "", "", "host", "host", "", "/%20!%22$%&'()*+,-./:;%3C=%3E@[\\]%5E_%60%7B|%7D~", "", ""); }
test { try parsePass("wss://host/ !\"$%&'()*+,-./:;<=>@[\\]^_`{|}~", null, "wss://host/%20!%22$%&'()*+,-./:;%3C=%3E@[/]%5E_%60%7B|%7D~", "wss://host", "wss:", "", "", "host", "host", "", "/%20!%22$%&'()*+,-./:;%3C=%3E@[/]%5E_%60%7B|%7D~", "", ""); }
test { try parsePass("foo://host/dir/? !\"$%&'()*+,-./:;<=>?@[\\]^_`{|}~", null, "foo://host/dir/?%20!%22$%&'()*+,-./:;%3C=%3E?@[\\]^_`{|}~", "null", "foo:", "", "", "host", "host", "", "/dir/", "?%20!%22$%&'()*+,-./:;%3C=%3E?@[\\]^_`{|}~", ""); }
test { try parsePass("wss://host/dir/? !\"$%&'()*+,-./:;<=>?@[\\]^_`{|}~", null, "wss://host/dir/?%20!%22$%&%27()*+,-./:;%3C=%3E?@[\\]^_`{|}~", "wss://host", "wss:", "", "", "host", "host", "", "/dir/", "?%20!%22$%&%27()*+,-./:;%3C=%3E?@[\\]^_`{|}~", ""); }
test { try parsePass("foo://host/dir/# !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~", null, "foo://host/dir/#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\\]^_%60{|}~", "null", "foo:", "", "", "host", "host", "", "/dir/", "", "#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\\]^_%60{|}~"); }
test { try parsePass("wss://host/dir/# !\"#$%&'()*+,-./:;<=>?@[\\]^_`{|}~", null, "wss://host/dir/#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\\]^_%60{|}~", "wss://host", "wss:", "", "", "host", "host", "", "/dir/", "", "#%20!%22#$%&'()*+,-./:;%3C=%3E?@[\\]^_%60{|}~"); }
test { try parsePass("http://foo.09..", null, "http://foo.09../", "", "http:", "", "", "foo.09..", "foo.09..", "", "/", "", ""); }
test { try parsePass("https://x/\x00y", null, "https://x/%00y", "", "https:", "", "", "x", "x", "", "/%00y", "", ""); }
test { try parsePass("https://x/?\x00y", null, "https://x/?%00y", "", "https:", "", "", "x", "x", "", "/", "?%00y", ""); }
test { try parsePass("https://x/?#\x00y", null, "https://x/?#%00y", "", "https:", "", "", "x", "x", "", "/", "", "#%00y"); }
test { try parsePass("https://x/\xef\xbf\xbfy", null, "https://x/%EF%BF%BFy", "", "https:", "", "", "x", "x", "", "/%EF%BF%BFy", "", ""); }
test { try parsePass("https://x/?\xef\xbf\xbfy", null, "https://x/?%EF%BF%BFy", "", "https:", "", "", "x", "x", "", "/", "?%EF%BF%BFy", ""); }
test { try parsePass("https://x/?#\xef\xbf\xbfy", null, "https://x/?#%EF%BF%BFy", "", "https:", "", "", "x", "x", "", "/", "", "#%EF%BF%BFy"); }
test { try parsePass("non-special:\x00y", null, "non-special:%00y", "", "non-special:", "", "", "", "", "", "%00y", "", ""); }
test { try parsePass("non-special:x/\x00y", null, "non-special:x/%00y", "", "non-special:", "", "", "", "", "", "x/%00y", "", ""); }
test { try parsePass("non-special:x/?\x00y", null, "non-special:x/?%00y", "", "non-special:", "", "", "", "", "", "x/", "?%00y", ""); }
test { try parsePass("non-special:x/?#\x00y", null, "non-special:x/?#%00y", "", "non-special:", "", "", "", "", "", "x/", "", "#%00y"); }
test { try parsePass("non-special:\xef\xbf\xbfy", null, "non-special:%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "%EF%BF%BFy", "", ""); }
test { try parsePass("non-special:x/\xef\xbf\xbfy", null, "non-special:x/%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "x/%EF%BF%BFy", "", ""); }
test { try parsePass("non-special:x/?\xef\xbf\xbfy", null, "non-special:x/?%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "x/", "?%EF%BF%BFy", ""); }
test { try parsePass("non-special:x/?#\xef\xbf\xbfy", null, "non-special:x/?#%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "x/", "", "#%EF%BF%BFy"); }
test { try parsePass("https://example.com/\"quoted\"", null, "https://example.com/%22quoted%22", "https://example.com", "https:", "", "", "example.com", "example.com", "", "/%22quoted%22", "", ""); }
test { try parsePass("https://a%C2%ADb/", null, "https://ab/", "https://ab", "https:", "", "", "ab", "ab", "", "/", "", ""); }
test { try parsePass("data://example.com:8080/pathname?search#hash", null, "data://example.com:8080/pathname?search#hash", "null", "data:", "", "", "example.com:8080", "example.com", "8080", "/pathname", "?search", "#hash"); }
test { try parsePass("data:///test", null, "data:///test", "null", "data:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("data://test/a/../b", null, "data://test/b", "null", "data:", "", "", "test", "test", "", "/b", "", ""); }
test { try parsePass("javascript://example.com:8080/pathname?search#hash", null, "javascript://example.com:8080/pathname?search#hash", "null", "javascript:", "", "", "example.com:8080", "example.com", "8080", "/pathname", "?search", "#hash"); }
test { try parsePass("javascript:///test", null, "javascript:///test", "null", "javascript:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("javascript://test/a/../b", null, "javascript://test/b", "null", "javascript:", "", "", "test", "test", "", "/b", "", ""); }
test { try parsePass("mailto://example.com:8080/pathname?search#hash", null, "mailto://example.com:8080/pathname?search#hash", "null", "mailto:", "", "", "example.com:8080", "example.com", "8080", "/pathname", "?search", "#hash"); }
test { try parsePass("mailto:///test", null, "mailto:///test", "null", "mailto:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("mailto://test/a/../b", null, "mailto://test/b", "null", "mailto:", "", "", "test", "test", "", "/b", "", ""); }
test { try parsePass("intent://example.com:8080/pathname?search#hash", null, "intent://example.com:8080/pathname?search#hash", "null", "intent:", "", "", "example.com:8080", "example.com", "8080", "/pathname", "?search", "#hash"); }
test { try parsePass("intent:///test", null, "intent:///test", "null", "intent:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("intent://test/a/../b", null, "intent://test/b", "null", "intent:", "", "", "test", "test", "", "/b", "", ""); }
test { try parsePass("urn://example.com:8080/pathname?search#hash", null, "urn://example.com:8080/pathname?search#hash", "null", "urn:", "", "", "example.com:8080", "example.com", "8080", "/pathname", "?search", "#hash"); }
test { try parsePass("urn:///test", null, "urn:///test", "null", "urn:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("urn://test/a/../b", null, "urn://test/b", "null", "urn:", "", "", "test", "test", "", "/b", "", ""); }
test { try parsePass("turn://example.com:8080/pathname?search#hash", null, "turn://example.com:8080/pathname?search#hash", "null", "turn:", "", "", "example.com:8080", "example.com", "8080", "/pathname", "?search", "#hash"); }
test { try parsePass("turn:///test", null, "turn:///test", "null", "turn:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("turn://test/a/../b", null, "turn://test/b", "null", "turn:", "", "", "test", "test", "", "/b", "", ""); }
test { try parsePass("stun://example.com:8080/pathname?search#hash", null, "stun://example.com:8080/pathname?search#hash", "null", "stun:", "", "", "example.com:8080", "example.com", "8080", "/pathname", "?search", "#hash"); }
test { try parsePass("stun:///test", null, "stun:///test", "null", "stun:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("stun://test/a/../b", null, "stun://test/b", "null", "stun:", "", "", "test", "test", "", "/b", "", ""); }
test { try parsePass("w://x:0", null, "w://x:0", "null", "w:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("west://x:0", null, "west://x:0", "null", "west:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("android://x:0/a", null, "android://x:0/a", "null", "android:", "", "", "x:0", "x", "0", "/a", "", ""); }
test { try parsePass("drivefs://x:0/a", null, "drivefs://x:0/a", "null", "drivefs:", "", "", "x:0", "x", "0", "/a", "", ""); }
test { try parsePass("chromeos-steam://x:0/a", null, "chromeos-steam://x:0/a", "null", "chromeos-steam:", "", "", "x:0", "x", "0", "/a", "", ""); }
test { try parsePass("steam://x:0/a", null, "steam://x:0/a", "null", "steam:", "", "", "x:0", "x", "0", "/a", "", ""); }
test { try parsePass("materialized-view://x:0/a", null, "materialized-view://x:0/a", "null", "materialized-view:", "", "", "x:0", "x", "0", "/a", "", ""); }
test { try parsePass("android-app://x:0", null, "android-app://x:0", "null", "android-app:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("chrome-distiller://x:0", null, "chrome-distiller://x:0", "null", "chrome-distiller:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("chrome-extension://x:0", null, "chrome-extension://x:0", "null", "chrome-extension:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("chrome-native://x:0", null, "chrome-native://x:0", "null", "chrome-native:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("chrome-resource://x:0", null, "chrome-resource://x:0", "null", "chrome-resource:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("chrome-search://x:0", null, "chrome-search://x:0", "null", "chrome-search:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("fuchsia-dir://x:0", null, "fuchsia-dir://x:0", "null", "fuchsia-dir:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("isolated-app://x:0", null, "isolated-app://x:0", "null", "isolated-app:", "", "", "x:0", "x", "0", "", "", ""); }
test { try parsePass("non-special:\\\\opaque", null, "non-special:\\\\opaque", "null", "non-special:", "", "", "", "", "", "\\\\opaque", "", ""); }
test { try parsePass("non-special:\\\\opaque/path", null, "non-special:\\\\opaque/path", "null", "non-special:", "", "", "", "", "", "\\\\opaque/path", "", ""); }
test { try parsePass("non-special:\\\\opaque\\path", null, "non-special:\\\\opaque\\path", "null", "non-special:", "", "", "", "", "", "\\\\opaque\\path", "", ""); }
test { try parsePass("non-special:\\/opaque", null, "non-special:\\/opaque", "null", "non-special:", "", "", "", "", "", "\\/opaque", "", ""); }
test { try parsePass("non-special:/\\path", null, "non-special:/\\path", "null", "non-special:", "", "", "", "", "", "/\\path", "", ""); }
test { try parsePass("non-special://host/a\\b", null, "non-special://host/a\\b", "null", "non-special:", "", "", "host", "host", "", "/a\\b", "", ""); }


test { try parseIDNAFail("a\xe2\x80\x8cb"); }
test { try parseIDNAFail("A\xe2\x80\x8cB"); }
test { try parseIDNAFail("A\xe2\x80\x8cb"); }
test { try parseIDNAFail("xn--ab-j1t"); }
test { try parseIDNAFail("a\xe2\x80\x8db"); }
test { try parseIDNAFail("A\xe2\x80\x8dB"); }
test { try parseIDNAFail("A\xe2\x80\x8db"); }
test { try parseIDNAFail("xn--ab-m1t"); }
test { try parseIDNAFail("xn--u-ccb"); }
test { try parseIDNAFail("a\xe2\x92\x88com"); }
test { try parseIDNAFail("A\xe2\x92\x88COM"); }
test { try parseIDNAFail("A\xe2\x92\x88Com"); }
test { try parseIDNAFail("xn--acom-0w1b"); }
test { try parseIDNAFail("xn--a-ecp.ru"); }
test { try parseIDNAFail("xn--0.pt"); }
test { try parseIDNAFail("xn--a.pt"); }
test { try parseIDNAFail("xn--a-\xc3\x84.pt"); }
test { try parseIDNAFail("xn--a-A\xcc\x88.pt"); }
test { try parseIDNAFail("xn--a-a\xcc\x88.pt"); }
test { try parseIDNAFail("xn--a-\xc3\xa4.pt"); }
test { try parseIDNAFail("XN--A-\xc3\x84.PT"); }
test { try parseIDNAFail("XN--A-A\xcc\x88.PT"); }
test { try parseIDNAFail("Xn--A-A\xcc\x88.pt"); }
test { try parseIDNAFail("Xn--A-\xc3\x84.pt"); }
test { try parseIDNAFail("xn--xn--a--gua.pt"); }
test { try parseIDNAFail("1.a\xc3\x9f\xe2\x80\x8c\xe2\x80\x8db\xe2\x80\x8c\xe2\x80\x8dc\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fd\xcf\x82\xcf\x83\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fe\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fx\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fy\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xcc\x82\xc3\x9fz"); }
test { try parseIDNAFail("1.ASS\xe2\x80\x8c\xe2\x80\x8dB\xe2\x80\x8c\xe2\x80\x8dCSSSSSSSSD\xce\xa3\xce\xa3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSSS\xcc\x82SSZ"); }
test { try parseIDNAFail("1.ASS\xe2\x80\x8c\xe2\x80\x8dB\xe2\x80\x8c\xe2\x80\x8dCSSSSSSSSD\xce\xa3\xce\xa3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSS\xc5\x9cSSZ"); }
test { try parseIDNAFail("1.ass\xe2\x80\x8c\xe2\x80\x8db\xe2\x80\x8c\xe2\x80\x8dcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\xc5\x9dssz"); }
test { try parseIDNAFail("1.ass\xe2\x80\x8c\xe2\x80\x8db\xe2\x80\x8c\xe2\x80\x8dcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\xcc\x82ssz"); }
test { try parseIDNAFail("1.Ass\xe2\x80\x8c\xe2\x80\x8db\xe2\x80\x8c\xe2\x80\x8dcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\xcc\x82ssz"); }
test { try parseIDNAFail("1.Ass\xe2\x80\x8c\xe2\x80\x8db\xe2\x80\x8c\xe2\x80\x8dcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\xc5\x9dssz"); }
test { try parseIDNAFail("1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa69989dba9gc"); }
test { try parseIDNAFail("1.A\xc3\x9f\xe2\x80\x8c\xe2\x80\x8db\xe2\x80\x8c\xe2\x80\x8dc\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fd\xcf\x82\xcf\x83\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fe\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fx\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9fy\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xc3\x9f\xcc\x82\xc3\x9fz"); }
test { try parseIDNAFail("1.xn--abcdexyz-qyacaaabaaaaaaabaaaaaaaaabaaaaaaaaabaaaaaaaa010ze2isb1140zba8cc"); }
test { try parseIDNAFail("\xe2\x80\x8cx\xe2\x80\x8dn\xe2\x80\x8c-\xe2\x80\x8d-b\xc3\x9f"); }
test { try parseIDNAFail("\xe2\x80\x8cX\xe2\x80\x8dN\xe2\x80\x8c-\xe2\x80\x8d-BSS"); }
test { try parseIDNAFail("\xe2\x80\x8cx\xe2\x80\x8dn\xe2\x80\x8c-\xe2\x80\x8d-bss"); }
test { try parseIDNAFail("\xe2\x80\x8cX\xe2\x80\x8dn\xe2\x80\x8c-\xe2\x80\x8d-Bss"); }
test { try parseIDNAFail("xn--xn--bss-7z6ccid"); }
test { try parseIDNAFail("\xe2\x80\x8cX\xe2\x80\x8dn\xe2\x80\x8c-\xe2\x80\x8d-B\xc3\x9f"); }
test { try parseIDNAFail("xn--xn--b-pqa5796ccahd"); }
test { try parseIDNAFail("xn--xn---epa"); }
test { try parseIDNAFail("a.b.\xcc\x88c.d"); }
test { try parseIDNAFail("A.B.\xcc\x88C.D"); }
test { try parseIDNAFail("A.b.\xcc\x88c.d"); }
test { try parseIDNAFail("a.b.xn--c-bcb.d"); }
test { try parseIDNAFail("\xe0\xae\xb9\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--dmc225h"); }
test { try parseIDNAFail("\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--1ug"); }
test { try parseIDNAFail("\xe0\xae\xb9\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--dmc025h"); }
test { try parseIDNAFail("\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--0ug"); }
test { try parseIDNAFail("\xdb\xaf\xe2\x80\x8c\xdb\xaf"); }
test { try parseIDNAFail("xn--cmba004q"); }
test { try parseIDNAFail("a\xef\xbf\xbdz"); }
test { try parseIDNAFail("A\xef\xbf\xbdZ"); }
test { try parseIDNAFail("xn--"); }
test { try parseIDNAFail("xn---"); }
test { try parseIDNAFail("xn--ASCII-"); }
test { try parseIDNAFail("xn--unicode-.org"); }
test { try parseIDNAFail("\xe2\x92\x95\xe2\x88\x9d\xd9\x9f\xf2\x93\xa4\xa6\xef\xbc\x8e-\xf3\xa0\x84\xaf"); }
test { try parseIDNAFail("14.\xe2\x88\x9d\xd9\x9f\xf2\x93\xa4\xa6.-\xf3\xa0\x84\xaf"); }
test { try parseIDNAFail("14.xn--7hb713l3v90n.-"); }
test { try parseIDNAFail("xn--7hb713lfwbi1311b.-"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x89\xa0\xe1\xa2\x99\xe2\x89\xaf.\xec\x86\xa3-\xe1\xa1\xb4\xe1\x82\xa0"); }
test { try parseIDNAFail("\xe2\x80\x8d=\xcc\xb8\xe1\xa2\x99>\xcc\xb8.\xe1\x84\x89\xe1\x85\xa9\xe1\x86\xbe-\xe1\xa1\xb4\xe1\x82\xa0"); }
test { try parseIDNAFail("\xe2\x80\x8d=\xcc\xb8\xe1\xa2\x99>\xcc\xb8.\xe1\x84\x89\xe1\x85\xa9\xe1\x86\xbe-\xe1\xa1\xb4\xe2\xb4\x80"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x89\xa0\xe1\xa2\x99\xe2\x89\xaf.\xec\x86\xa3-\xe1\xa1\xb4\xe2\xb4\x80"); }
test { try parseIDNAFail("xn--jbf929a90b0b.xn----p9j493ivi4l"); }
test { try parseIDNAFail("xn--jbf911clb.xn----6zg521d196p"); }
test { try parseIDNAFail("xn--jbf929a90b0b.xn----6zg521d196p"); }
test { try parseIDNAFail("\xf1\xaf\x9e\x9c\xef\xbc\x8e\xf0\x90\xbf\x87\xe0\xbe\xa2\xdd\xbd\xd8\x80"); }
test { try parseIDNAFail("\xf1\xaf\x9e\x9c\xef\xbc\x8e\xf0\x90\xbf\x87\xe0\xbe\xa1\xe0\xbe\xb7\xdd\xbd\xd8\x80"); }
test { try parseIDNAFail("\xf1\xaf\x9e\x9c.\xf0\x90\xbf\x87\xe0\xbe\xa1\xe0\xbe\xb7\xdd\xbd\xd8\x80"); }
test { try parseIDNAFail("xn--gw68a.xn--ifb57ev2psc6027m"); }
test { try parseIDNAFail("\xf0\xa3\xb3\x94\xcc\x83.\xf0\x91\x93\x82"); }
test { try parseIDNAFail("xn--nsa95820a.xn--wz1d"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf2\x85\x8e\xad.\xe1\x82\xb2\xf0\x91\x87\x80"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf2\x85\x8e\xad.\xe2\xb4\x92\xf0\x91\x87\x80"); }
test { try parseIDNAFail("xn--bn95b.xn--9kj2034e"); }
test { try parseIDNAFail("xn--0ug15083f.xn--9kj2034e"); }
test { try parseIDNAFail("xn--bn95b.xn--qnd6272k"); }
test { try parseIDNAFail("xn--0ug15083f.xn--qnd6272k"); }
test { try parseIDNAFail("\xe7\xb9\xb1\xf0\x91\x96\xbf\xe2\x80\x8d.\xef\xbc\x98\xef\xb8\x92"); }
test { try parseIDNAFail("xn--gl0as212a.xn--8-o89h"); }
test { try parseIDNAFail("xn--1ug6928ac48e.xn--8-o89h"); }
test { try parseIDNAFail("\xf3\xa0\x86\xbe\xef\xbc\x8e\xf0\x9e\x80\x88"); }
test { try parseIDNAFail("\xf3\xa0\x86\xbe.\xf0\x9e\x80\x88"); }
test { try parseIDNAFail(".xn--ph4h"); }
test { try parseIDNAFail("\xc3\x9f\xdb\xab\xe3\x80\x82\xe2\x80\x8d"); }
test { try parseIDNAFail("SS\xdb\xab\xe3\x80\x82\xe2\x80\x8d"); }
test { try parseIDNAFail("ss\xdb\xab\xe3\x80\x82\xe2\x80\x8d"); }
test { try parseIDNAFail("Ss\xdb\xab\xe3\x80\x82\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--ss-59d.xn--1ug"); }
test { try parseIDNAFail("xn--zca012a.xn--1ug"); }
test { try parseIDNAFail("\xf3\xa0\x90\xb5\xe2\x80\x8c\xe2\x92\x88\xef\xbc\x8e\xf3\xa0\x8e\x87"); }
test { try parseIDNAFail("\xf3\xa0\x90\xb5\xe2\x80\x8c1..\xf3\xa0\x8e\x87"); }
test { try parseIDNAFail("xn--1-bs31m..xn--tv36e"); }
test { try parseIDNAFail("xn--1-rgn37671n..xn--tv36e"); }
test { try parseIDNAFail("xn--tshz2001k.xn--tv36e"); }
test { try parseIDNAFail("xn--0ug88o47900b.xn--tv36e"); }
test { try parseIDNAFail("\xf3\x9f\x88\xa3\xd9\x9f\xea\xaa\xb2\xc3\x9f\xe3\x80\x82\xf3\x8c\x93\xa7"); }
test { try parseIDNAFail("\xf3\x9f\x88\xa3\xd9\x9f\xea\xaa\xb2SS\xe3\x80\x82\xf3\x8c\x93\xa7"); }
test { try parseIDNAFail("\xf3\x9f\x88\xa3\xd9\x9f\xea\xaa\xb2ss\xe3\x80\x82\xf3\x8c\x93\xa7"); }
test { try parseIDNAFail("\xf3\x9f\x88\xa3\xd9\x9f\xea\xaa\xb2Ss\xe3\x80\x82\xf3\x8c\x93\xa7"); }
test { try parseIDNAFail("xn--ss-3xd2839nncy1m.xn--bb79d"); }
test { try parseIDNAFail("xn--zca92z0t7n5w96j.xn--bb79d"); }
test { try parseIDNAFail("\xdd\xb4\xe2\x80\x8c\xf0\x9e\xa4\xbf\xe3\x80\x82\xf0\xbd\x98\x90\xe4\x89\x9c\xe2\x80\x8d\xf1\xbf\xa4\xbc"); }
test { try parseIDNAFail("\xdd\xb4\xe2\x80\x8c\xf0\x9e\xa4\x9d\xe3\x80\x82\xf0\xbd\x98\x90\xe4\x89\x9c\xe2\x80\x8d\xf1\xbf\xa4\xbc"); }
test { try parseIDNAFail("xn--4pb2977v.xn--z0nt555ukbnv"); }
test { try parseIDNAFail("xn--4pb607jjt73a.xn--1ug236ke314donv1a"); }
test { try parseIDNAFail("\xe3\x85\xa4\xe0\xa5\x8d\xe1\x82\xa0\xe1\x9f\x90.\xe1\xa0\x8b"); }
test { try parseIDNAFail("\xe1\x85\xa0\xe0\xa5\x8d\xe1\x82\xa0\xe1\x9f\x90.\xe1\xa0\x8b"); }
test { try parseIDNAFail("\xe1\x85\xa0\xe0\xa5\x8d\xe2\xb4\x80\xe1\x9f\x90.\xe1\xa0\x8b"); }
test { try parseIDNAFail("xn--n3b445e53p."); }
test { try parseIDNAFail("\xe3\x85\xa4\xe0\xa5\x8d\xe2\xb4\x80\xe1\x9f\x90.\xe1\xa0\x8b"); }
test { try parseIDNAFail("xn--n3b742bkqf4ty."); }
test { try parseIDNAFail("xn--n3b468aoqa89r."); }
test { try parseIDNAFail("xn--n3b445e53po6d."); }
test { try parseIDNAFail("xn--n3b468azngju2a."); }
test { try parseIDNAFail("\xe2\x9d\xa3\xe2\x80\x8d\xef\xbc\x8e\xe0\xa7\x8d\xf0\x91\xb0\xbd\xd8\x92\xea\xa4\xa9"); }
test { try parseIDNAFail("\xe2\x9d\xa3\xe2\x80\x8d.\xe0\xa7\x8d\xf0\x91\xb0\xbd\xd8\x92\xea\xa4\xa9"); }
test { try parseIDNAFail("xn--pei.xn--0fb32q3w7q2g4d"); }
test { try parseIDNAFail("xn--1ugy10a.xn--0fb32q3w7q2g4d"); }
test { try parseIDNAFail("\xcd\x89\xe3\x80\x82\xf0\xa7\xa1\xab"); }
test { try parseIDNAFail("xn--nua.xn--bc6k"); }
test { try parseIDNAFail("\xf0\x91\xb0\xbf\xf3\xa0\x85\xa6\xef\xbc\x8e\xe1\x85\xa0"); }
test { try parseIDNAFail("\xf0\x91\xb0\xbf\xf3\xa0\x85\xa6.\xe1\x85\xa0"); }
test { try parseIDNAFail("xn--ok3d."); }
test { try parseIDNAFail("xn--ok3d.xn--psd"); }
test { try parseIDNAFail("\xe8\x94\x8f\xef\xbd\xa1\xf0\x91\xb0\xba"); }
test { try parseIDNAFail("\xe8\x94\x8f\xe3\x80\x82\xf0\x91\xb0\xba"); }
test { try parseIDNAFail("xn--uy1a.xn--jk3d"); }
test { try parseIDNAFail("xn--8g1d12120a.xn--5l6h"); }
test { try parseIDNAFail("\xf0\x91\x8b\xa7\xea\xa7\x802\xef\xbd\xa1\xe3\xa7\x89\xf2\x92\x96\x84"); }
test { try parseIDNAFail("\xf0\x91\x8b\xa7\xea\xa7\x802\xe3\x80\x82\xe3\xa7\x89\xf2\x92\x96\x84"); }
test { try parseIDNAFail("xn--2-5z4eu89y.xn--97l02706d"); }
test { try parseIDNAFail("\xe2\xa4\xb8\xcf\x82\xf0\xba\xb1\x80\xef\xbd\xa1\xef\xbe\xa0"); }
test { try parseIDNAFail("\xe2\xa4\xb8\xcf\x82\xf0\xba\xb1\x80\xe3\x80\x82\xe1\x85\xa0"); }
test { try parseIDNAFail("\xe2\xa4\xb8\xce\xa3\xf0\xba\xb1\x80\xe3\x80\x82\xe1\x85\xa0"); }
test { try parseIDNAFail("\xe2\xa4\xb8\xcf\x83\xf0\xba\xb1\x80\xe3\x80\x82\xe1\x85\xa0"); }
test { try parseIDNAFail("xn--4xa192qmp03d."); }
test { try parseIDNAFail("xn--3xa392qmp03d."); }
test { try parseIDNAFail("\xe2\xa4\xb8\xce\xa3\xf0\xba\xb1\x80\xef\xbd\xa1\xef\xbe\xa0"); }
test { try parseIDNAFail("\xe2\xa4\xb8\xcf\x83\xf0\xba\xb1\x80\xef\xbd\xa1\xef\xbe\xa0"); }
test { try parseIDNAFail("xn--4xa192qmp03d.xn--psd"); }
test { try parseIDNAFail("xn--3xa392qmp03d.xn--psd"); }
test { try parseIDNAFail("xn--4xa192qmp03d.xn--cl7c"); }
test { try parseIDNAFail("xn--3xa392qmp03d.xn--cl7c"); }
test { try parseIDNAFail("\xe2\x80\x8d\xf3\xaf\x91\x96\xf3\xa0\x81\x90\xef\xbc\x8e\xd6\xbd\xf0\x99\xae\xb0\xea\xa1\x9d\xf0\x90\x8b\xa1"); }
test { try parseIDNAFail("\xe2\x80\x8d\xf3\xaf\x91\x96\xf3\xa0\x81\x90.\xd6\xbd\xf0\x99\xae\xb0\xea\xa1\x9d\xf0\x90\x8b\xa1"); }
test { try parseIDNAFail("xn--b726ey18m.xn--ldb8734fg0qcyzzg"); }
test { try parseIDNAFail("xn--1ug66101lt8me.xn--ldb8734fg0qcyzzg"); }
test { try parseIDNAFail("\xe3\x80\x82\xf4\x83\x88\xb5\xcf\x82\xf1\x80\xa0\x87\xe3\x80\x82\xf0\x90\xae\x88"); }
test { try parseIDNAFail("\xe3\x80\x82\xf4\x83\x88\xb5\xce\xa3\xf1\x80\xa0\x87\xe3\x80\x82\xf0\x90\xae\x88"); }
test { try parseIDNAFail("\xe3\x80\x82\xf4\x83\x88\xb5\xcf\x83\xf1\x80\xa0\x87\xe3\x80\x82\xf0\x90\xae\x88"); }
test { try parseIDNAFail(".xn--4xa68573c7n64d.xn--f29c"); }
test { try parseIDNAFail(".xn--3xa88573c7n64d.xn--f29c"); }
test { try parseIDNAFail("\xe2\x92\x89\xf3\xa0\x8a\x93\xe2\x89\xa0\xef\xbd\xa1\xe1\x82\xbf\xe2\xac\xa3\xe1\x82\xa8"); }
test { try parseIDNAFail("\xe2\x92\x89\xf3\xa0\x8a\x93=\xcc\xb8\xef\xbd\xa1\xe1\x82\xbf\xe2\xac\xa3\xe1\x82\xa8"); }
test { try parseIDNAFail("2.\xf3\xa0\x8a\x93\xe2\x89\xa0\xe3\x80\x82\xe1\x82\xbf\xe2\xac\xa3\xe1\x82\xa8"); }
test { try parseIDNAFail("2.\xf3\xa0\x8a\x93=\xcc\xb8\xe3\x80\x82\xe1\x82\xbf\xe2\xac\xa3\xe1\x82\xa8"); }
test { try parseIDNAFail("2.\xf3\xa0\x8a\x93=\xcc\xb8\xe3\x80\x82\xe2\xb4\x9f\xe2\xac\xa3\xe2\xb4\x88"); }
test { try parseIDNAFail("2.\xf3\xa0\x8a\x93\xe2\x89\xa0\xe3\x80\x82\xe2\xb4\x9f\xe2\xac\xa3\xe2\xb4\x88"); }
test { try parseIDNAFail("2.xn--1chz4101l.xn--45iz7d6b"); }
test { try parseIDNAFail("\xe2\x92\x89\xf3\xa0\x8a\x93=\xcc\xb8\xef\xbd\xa1\xe2\xb4\x9f\xe2\xac\xa3\xe2\xb4\x88"); }
test { try parseIDNAFail("\xe2\x92\x89\xf3\xa0\x8a\x93\xe2\x89\xa0\xef\xbd\xa1\xe2\xb4\x9f\xe2\xac\xa3\xe2\xb4\x88"); }
test { try parseIDNAFail("xn--1ch07f91401d.xn--45iz7d6b"); }
test { try parseIDNAFail("2.xn--1chz4101l.xn--gnd9b297j"); }
test { try parseIDNAFail("xn--1ch07f91401d.xn--gnd9b297j"); }
test { try parseIDNAFail("-\xf3\xa0\x89\x96\xea\xa1\xa7\xef\xbc\x8e\xf3\xa0\x8a\x82\xf1\x87\x86\x83\xf0\x9f\x84\x89"); }
test { try parseIDNAFail("-\xf3\xa0\x89\x96\xea\xa1\xa7.\xf3\xa0\x8a\x82\xf1\x87\x86\x838,"); }
test { try parseIDNAFail("xn----hg4ei0361g.xn--8,-k362evu488a"); }
test { try parseIDNAFail("xn----hg4ei0361g.xn--207ht163h7m94c"); }
test { try parseIDNAFail("\xe2\x80\x8c\xef\xbd\xa1\xcd\x94"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe3\x80\x82\xcd\x94"); }
test { try parseIDNAFail(".xn--yua"); }
test { try parseIDNAFail("xn--0ug.xn--yua"); }
test { try parseIDNAFail("xn--de6h.xn--mnd799a"); }
test { try parseIDNAFail("\xe0\xbe\xa4\xf1\xb1\xa4\xaf\xef\xbc\x8e\xf0\x9d\x9f\xad\xe1\x82\xbb"); }
test { try parseIDNAFail("\xe0\xbe\xa4\xf1\xb1\xa4\xaf.1\xe1\x82\xbb"); }
test { try parseIDNAFail("\xe0\xbe\xa4\xf1\xb1\xa4\xaf.1\xe2\xb4\x9b"); }
test { try parseIDNAFail("xn--0fd40533g.xn--1-tws"); }
test { try parseIDNAFail("\xe0\xbe\xa4\xf1\xb1\xa4\xaf\xef\xbc\x8e\xf0\x9d\x9f\xad\xe2\xb4\x9b"); }
test { try parseIDNAFail("xn--0fd40533g.xn--1-q1g"); }
test { try parseIDNAFail("\xcf\x82\xf2\x85\x9c\x8c\xef\xbc\x98.\xf0\x9e\xad\xa4"); }
test { try parseIDNAFail("\xcf\x82\xf2\x85\x9c\x8c8.\xf0\x9e\xad\xa4"); }
test { try parseIDNAFail("\xce\xa3\xf2\x85\x9c\x8c8.\xf0\x9e\xad\xa4"); }
test { try parseIDNAFail("\xcf\x83\xf2\x85\x9c\x8c8.\xf0\x9e\xad\xa4"); }
test { try parseIDNAFail("xn--8-zmb14974n.xn--su6h"); }
test { try parseIDNAFail("xn--8-xmb44974n.xn--su6h"); }
test { try parseIDNAFail("\xce\xa3\xf2\x85\x9c\x8c\xef\xbc\x98.\xf0\x9e\xad\xa4"); }
test { try parseIDNAFail("\xcf\x83\xf2\x85\x9c\x8c\xef\xbc\x98.\xf0\x9e\xad\xa4"); }
test { try parseIDNAFail("\xe2\x80\x8c\xea\xb8\x83.\xe6\xa6\xb6-"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x84\x80\xe1\x85\xb3\xe1\x86\xb2.\xe6\xa6\xb6-"); }
test { try parseIDNAFail("xn--0ug3307c.xn----d87b"); }
test { try parseIDNAFail("\xeb\x89\x93\xe6\xb3\x93\xf0\x9c\xb5\xbd.\xe0\xa7\x8d\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe1\x84\x82\xe1\x85\xb0\xe1\x86\xbe\xe6\xb3\x93\xf0\x9c\xb5\xbd.\xe0\xa7\x8d\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--lwwp69lqs7m.xn--b7b"); }
test { try parseIDNAFail("xn--lwwp69lqs7m.xn--b7b605i"); }
test { try parseIDNAFail("\xe1\xad\x84\xef\xbc\x8e\xe1\xae\xaa-\xe2\x89\xae\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe1\xad\x84\xef\xbc\x8e\xe1\xae\xaa-<\xcc\xb8=\xcc\xb8"); }
test { try parseIDNAFail("\xe1\xad\x84.\xe1\xae\xaa-\xe2\x89\xae\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe1\xad\x84.\xe1\xae\xaa-<\xcc\xb8=\xcc\xb8"); }
test { try parseIDNAFail("xn--1uf.xn----nmlz65aub"); }
test { try parseIDNAFail("\xe1\xaf\xb3\xe1\x82\xb1\xe1\x85\x9f\xef\xbc\x8e\xf0\x91\x84\xb4\xe2\x84\xb2"); }
test { try parseIDNAFail("\xe1\xaf\xb3\xe1\x82\xb1\xe1\x85\x9f.\xf0\x91\x84\xb4\xe2\x84\xb2"); }
test { try parseIDNAFail("\xe1\xaf\xb3\xe2\xb4\x91\xe1\x85\x9f.\xf0\x91\x84\xb4\xe2\x85\x8e"); }
test { try parseIDNAFail("\xe1\xaf\xb3\xe1\x82\xb1\xe1\x85\x9f.\xf0\x91\x84\xb4\xe2\x85\x8e"); }
test { try parseIDNAFail("xn--1zf224e.xn--73g3065g"); }
test { try parseIDNAFail("\xe1\xaf\xb3\xe2\xb4\x91\xe1\x85\x9f\xef\xbc\x8e\xf0\x91\x84\xb4\xe2\x85\x8e"); }
test { try parseIDNAFail("\xe1\xaf\xb3\xe1\x82\xb1\xe1\x85\x9f\xef\xbc\x8e\xf0\x91\x84\xb4\xe2\x85\x8e"); }
test { try parseIDNAFail("xn--pnd26a55x.xn--73g3065g"); }
test { try parseIDNAFail("xn--osd925cvyn.xn--73g3065g"); }
test { try parseIDNAFail("xn--pnd26a55x.xn--f3g7465g"); }
test { try parseIDNAFail("\xe1\x82\xa9\xe7\x8c\x95\xf3\xb9\x9b\xab\xe2\x89\xae\xef\xbc\x8e\xef\xb8\x92"); }
test { try parseIDNAFail("\xe1\x82\xa9\xe7\x8c\x95\xf3\xb9\x9b\xab<\xcc\xb8\xef\xbc\x8e\xef\xb8\x92"); }
test { try parseIDNAFail("\xe1\x82\xa9\xe7\x8c\x95\xf3\xb9\x9b\xab\xe2\x89\xae.\xe3\x80\x82"); }
test { try parseIDNAFail("\xe1\x82\xa9\xe7\x8c\x95\xf3\xb9\x9b\xab<\xcc\xb8.\xe3\x80\x82"); }
test { try parseIDNAFail("\xe2\xb4\x89\xe7\x8c\x95\xf3\xb9\x9b\xab<\xcc\xb8.\xe3\x80\x82"); }
test { try parseIDNAFail("\xe2\xb4\x89\xe7\x8c\x95\xf3\xb9\x9b\xab\xe2\x89\xae.\xe3\x80\x82"); }
test { try parseIDNAFail("xn--gdh892bbz0d5438s.."); }
test { try parseIDNAFail("\xe2\xb4\x89\xe7\x8c\x95\xf3\xb9\x9b\xab<\xcc\xb8\xef\xbc\x8e\xef\xb8\x92"); }
test { try parseIDNAFail("\xe2\xb4\x89\xe7\x8c\x95\xf3\xb9\x9b\xab\xe2\x89\xae\xef\xbc\x8e\xef\xb8\x92"); }
test { try parseIDNAFail("xn--gdh892bbz0d5438s.xn--y86c"); }
test { try parseIDNAFail("xn--hnd212gz32d54x5r.."); }
test { try parseIDNAFail("xn--hnd212gz32d54x5r.xn--y86c"); }
test { try parseIDNAFail("\xc3\x85\xeb\x91\x84-\xef\xbc\x8e\xe2\x80\x8c"); }
test { try parseIDNAFail("A\xcc\x8a\xe1\x84\x83\xe1\x85\xad\xe1\x86\xb7-\xef\xbc\x8e\xe2\x80\x8c"); }
test { try parseIDNAFail("\xc3\x85\xeb\x91\x84-.\xe2\x80\x8c"); }
test { try parseIDNAFail("A\xcc\x8a\xe1\x84\x83\xe1\x85\xad\xe1\x86\xb7-.\xe2\x80\x8c"); }
test { try parseIDNAFail("a\xcc\x8a\xe1\x84\x83\xe1\x85\xad\xe1\x86\xb7-.\xe2\x80\x8c"); }
test { try parseIDNAFail("\xc3\xa5\xeb\x91\x84-.\xe2\x80\x8c"); }
test { try parseIDNAFail("xn----1fa1788k.xn--0ug"); }
test { try parseIDNAFail("a\xcc\x8a\xe1\x84\x83\xe1\x85\xad\xe1\x86\xb7-\xef\xbc\x8e\xe2\x80\x8c"); }
test { try parseIDNAFail("\xc3\xa5\xeb\x91\x84-\xef\xbc\x8e\xe2\x80\x8c"); }
test { try parseIDNAFail("\xeb\xa3\xb1\xe2\x80\x8d\xf0\xb0\x8d\xa8\xe2\x80\x8c\xe3\x80\x82\xf0\x9d\xa8\x96\xef\xb8\x92"); }
test { try parseIDNAFail("\xe1\x84\x85\xe1\x85\xae\xe1\x86\xb0\xe2\x80\x8d\xf0\xb0\x8d\xa8\xe2\x80\x8c\xe3\x80\x82\xf0\x9d\xa8\x96\xef\xb8\x92"); }
test { try parseIDNAFail("\xeb\xa3\xb1\xe2\x80\x8d\xf0\xb0\x8d\xa8\xe2\x80\x8c\xe3\x80\x82\xf0\x9d\xa8\x96\xe3\x80\x82"); }
test { try parseIDNAFail("\xe1\x84\x85\xe1\x85\xae\xe1\x86\xb0\xe2\x80\x8d\xf0\xb0\x8d\xa8\xe2\x80\x8c\xe3\x80\x82\xf0\x9d\xa8\x96\xe3\x80\x82"); }
test { try parseIDNAFail("xn--ct2b0738h.xn--772h."); }
test { try parseIDNAFail("xn--0ugb3358ili2v.xn--772h."); }
test { try parseIDNAFail("xn--ct2b0738h.xn--y86cl899a"); }
test { try parseIDNAFail("xn--0ugb3358ili2v.xn--y86cl899a"); }
test { try parseIDNAFail("\xf0\x9f\x84\x84\xef\xbc\x8e\xe1\xb3\x9c\xe2\x92\x88\xc3\x9f"); }
test { try parseIDNAFail("3,.\xe1\xb3\x9c1.\xc3\x9f"); }
test { try parseIDNAFail("3,.\xe1\xb3\x9c1.SS"); }
test { try parseIDNAFail("3,.\xe1\xb3\x9c1.ss"); }
test { try parseIDNAFail("3,.\xe1\xb3\x9c1.Ss"); }
test { try parseIDNAFail("3,.xn--1-43l.ss"); }
test { try parseIDNAFail("3,.xn--1-43l.xn--zca"); }
test { try parseIDNAFail("\xf0\x9f\x84\x84\xef\xbc\x8e\xe1\xb3\x9c\xe2\x92\x88SS"); }
test { try parseIDNAFail("\xf0\x9f\x84\x84\xef\xbc\x8e\xe1\xb3\x9c\xe2\x92\x88ss"); }
test { try parseIDNAFail("\xf0\x9f\x84\x84\xef\xbc\x8e\xe1\xb3\x9c\xe2\x92\x88Ss"); }
test { try parseIDNAFail("3,.xn--ss-k1r094b"); }
test { try parseIDNAFail("3,.xn--zca344lmif"); }
test { try parseIDNAFail("xn--x07h.xn--ss-k1r094b"); }
test { try parseIDNAFail("xn--x07h.xn--zca344lmif"); }
test { try parseIDNAFail("\xe1\xb7\xbd\xe1\x80\xba\xe0\xa5\x8d\xef\xbc\x8e\xe2\x89\xa0\xe2\x80\x8d\xe3\x87\x9b"); }
test { try parseIDNAFail("\xe1\x80\xba\xe0\xa5\x8d\xe1\xb7\xbd\xef\xbc\x8e\xe2\x89\xa0\xe2\x80\x8d\xe3\x87\x9b"); }
test { try parseIDNAFail("\xe1\x80\xba\xe0\xa5\x8d\xe1\xb7\xbd\xef\xbc\x8e=\xcc\xb8\xe2\x80\x8d\xe3\x87\x9b"); }
test { try parseIDNAFail("\xe1\x80\xba\xe0\xa5\x8d\xe1\xb7\xbd.\xe2\x89\xa0\xe2\x80\x8d\xe3\x87\x9b"); }
test { try parseIDNAFail("\xe1\x80\xba\xe0\xa5\x8d\xe1\xb7\xbd.=\xcc\xb8\xe2\x80\x8d\xe3\x87\x9b"); }
test { try parseIDNAFail("xn--n3b956a9zm.xn--1ch912d"); }
test { try parseIDNAFail("xn--n3b956a9zm.xn--1ug63gz5w"); }
test { try parseIDNAFail("\xe1\xaf\xb3.-\xe9\x80\x8b\xf1\xb3\xa6\xad\xf3\x99\x99\xae"); }
test { try parseIDNAFail("xn--1zf.xn----483d46987byr50b"); }
test { try parseIDNAFail("xn--9ob.xn--4xa380e"); }
test { try parseIDNAFail("xn--9ob.xn--4xa380ebol"); }
test { try parseIDNAFail("xn--9ob.xn--3xa580ebol"); }
test { try parseIDNAFail("xn--9ob.xn--4xa574u"); }
test { try parseIDNAFail("xn--9ob.xn--4xa795lq2l"); }
test { try parseIDNAFail("xn--9ob.xn--3xa995lq2l"); }
test { try parseIDNAFail("\xe1\xa1\x86\xe1\x82\xa3\xef\xbd\xa1\xf3\x9e\xa2\xa7\xcc\x95\xe2\x80\x8d\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe1\xa1\x86\xe1\x82\xa3\xe3\x80\x82\xf3\x9e\xa2\xa7\xcc\x95\xe2\x80\x8d\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe1\xa1\x86\xe2\xb4\x83\xe3\x80\x82\xf3\x9e\xa2\xa7\xcc\x95\xe2\x80\x8d\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--57e237h.xn--5sa98523p"); }
test { try parseIDNAFail("xn--57e237h.xn--5sa649la993427a"); }
test { try parseIDNAFail("\xe1\xa1\x86\xe2\xb4\x83\xef\xbd\xa1\xf3\x9e\xa2\xa7\xcc\x95\xe2\x80\x8d\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--bnd320b.xn--5sa98523p"); }
test { try parseIDNAFail("xn--bnd320b.xn--5sa649la993427a"); }
test { try parseIDNAFail("\xf0\x9e\x80\xa8\xef\xbd\xa1\xe1\xad\x84\xf2\xa1\x9b\xa8\xf0\x9e\x8e\x87"); }
test { try parseIDNAFail("\xf0\x9e\x80\xa8\xe3\x80\x82\xe1\xad\x84\xf2\xa1\x9b\xa8\xf0\x9e\x8e\x87"); }
test { try parseIDNAFail("xn--mi4h.xn--1uf6843smg20c"); }
test { try parseIDNAFail("\xe1\xa2\x9b\xf3\xa8\x85\x9f\xc3\x9f.\xe1\x8c\xa7"); }
test { try parseIDNAFail("\xe1\xa2\x9b\xf3\xa8\x85\x9fSS.\xe1\x8c\xa7"); }
test { try parseIDNAFail("\xe1\xa2\x9b\xf3\xa8\x85\x9fss.\xe1\x8c\xa7"); }
test { try parseIDNAFail("\xe1\xa2\x9b\xf3\xa8\x85\x9fSs.\xe1\x8c\xa7"); }
test { try parseIDNAFail("xn--ss-7dp66033t.xn--p5d"); }
test { try parseIDNAFail("xn--zca562jc642x.xn--p5d"); }
test { try parseIDNAFail("\xe2\xae\x92\xe2\x80\x8c.\xf1\x92\x9a\x97\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--b9i.xn--5p9y"); }
test { try parseIDNAFail("xn--0ugx66b.xn--0ugz2871c"); }
test { try parseIDNAFail("\xe2\x89\xaf\xf0\x91\x9c\xab\xf3\xa0\xad\x87.\xe1\x9c\xb4\xf1\x92\x9e\xa4\xf0\x91\x8d\xac\xe1\xa2\xa7"); }
test { try parseIDNAFail(">\xcc\xb8\xf0\x91\x9c\xab\xf3\xa0\xad\x87.\xe1\x9c\xb4\xf1\x92\x9e\xa4\xf0\x91\x8d\xac\xe1\xa2\xa7"); }
test { try parseIDNAFail("xn--hdhx157g68o0g.xn--c0e65eu616c34o7a"); }
test { try parseIDNAFail("ss.xn--lgd10cu829c"); }
test { try parseIDNAFail("xn--zca.xn--lgd10cu829c"); }
test { try parseIDNAFail("\xe1\xa9\x9a\xf0\x9b\xa6\x9d\xe0\xb1\x8d\xe3\x80\x82\xf0\x9a\x9d\xac\xf0\x9d\x9f\xb5"); }
test { try parseIDNAFail("\xe1\xa9\x9a\xf0\x9b\xa6\x9d\xe0\xb1\x8d\xe3\x80\x82\xf0\x9a\x9d\xac9"); }
test { try parseIDNAFail("xn--lqc703ebm93a.xn--9-000p"); }
test { try parseIDNAFail("\xe1\xa1\x96\xef\xbd\xa1\xcc\x9f\xf1\x97\x9b\xa8\xe0\xae\x82-"); }
test { try parseIDNAFail("\xe1\xa1\x96\xe3\x80\x82\xcc\x9f\xf1\x97\x9b\xa8\xe0\xae\x82-"); }
test { try parseIDNAFail("xn--m8e.xn----mdb555dkk71m"); }
test { try parseIDNAFail("\xd6\x96\xe1\x82\xab\xef\xbc\x8e\xf0\x9d\x9f\xb3\xe2\x89\xaf\xef\xb8\x92\xef\xb8\x8a"); }
test { try parseIDNAFail("\xd6\x96\xe1\x82\xab\xef\xbc\x8e\xf0\x9d\x9f\xb3>\xcc\xb8\xef\xb8\x92\xef\xb8\x8a"); }
test { try parseIDNAFail("\xd6\x96\xe1\x82\xab.7\xe2\x89\xaf\xe3\x80\x82\xef\xb8\x8a"); }
test { try parseIDNAFail("\xd6\x96\xe1\x82\xab.7>\xcc\xb8\xe3\x80\x82\xef\xb8\x8a"); }
test { try parseIDNAFail("\xd6\x96\xe2\xb4\x8b.7>\xcc\xb8\xe3\x80\x82\xef\xb8\x8a"); }
test { try parseIDNAFail("\xd6\x96\xe2\xb4\x8b.7\xe2\x89\xaf\xe3\x80\x82\xef\xb8\x8a"); }
test { try parseIDNAFail("xn--hcb613r.xn--7-pgo."); }
test { try parseIDNAFail("\xd6\x96\xe2\xb4\x8b\xef\xbc\x8e\xf0\x9d\x9f\xb3>\xcc\xb8\xef\xb8\x92\xef\xb8\x8a"); }
test { try parseIDNAFail("\xd6\x96\xe2\xb4\x8b\xef\xbc\x8e\xf0\x9d\x9f\xb3\xe2\x89\xaf\xef\xb8\x92\xef\xb8\x8a"); }
test { try parseIDNAFail("xn--hcb613r.xn--7-pgoy530h"); }
test { try parseIDNAFail("xn--hcb887c.xn--7-pgo."); }
test { try parseIDNAFail("xn--hcb887c.xn--7-pgoy530h"); }
test { try parseIDNAFail("\xf0\x9f\x84\x87\xe4\xbc\x90\xef\xb8\x92.\xf0\x9c\x99\x9a\xea\xa3\x84"); }
test { try parseIDNAFail("6,\xe4\xbc\x90\xe3\x80\x82.\xf0\x9c\x99\x9a\xea\xa3\x84"); }
test { try parseIDNAFail("xn--6,-7i3c..xn--0f9ao925c"); }
test { try parseIDNAFail("xn--6,-7i3cj157d.xn--0f9ao925c"); }
test { try parseIDNAFail("xn--woqs083bel0g.xn--0f9ao925c"); }
test { try parseIDNAFail("\xf3\xa0\x86\xa0\xef\xbc\x8e\xf1\xb7\x90\xb4\xf3\x8c\x9f\x88"); }
test { try parseIDNAFail("\xf3\xa0\x86\xa0.\xf1\xb7\x90\xb4\xf3\x8c\x9f\x88"); }
test { try parseIDNAFail(".xn--rx21bhv12i"); }
test { try parseIDNAFail("-.\xe1\xa2\x86\xf3\xa1\xb2\xa3-"); }
test { try parseIDNAFail("-.xn----pbkx6497q"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0\xef\xbc\x8e-\xf0\x9d\x9f\xbb\xc3\x9f"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0.-5\xc3\x9f"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0.-5SS"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0.-5ss"); }
test { try parseIDNAFail("xn--t960e.-5ss"); }
test { try parseIDNAFail("xn--t960e.xn---5-hia"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0\xef\xbc\x8e-\xf0\x9d\x9f\xbbSS"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0\xef\xbc\x8e-\xf0\x9d\x9f\xbbss"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0\xef\xbc\x8e-\xf0\x9d\x9f\xbbSs"); }
test { try parseIDNAFail("\xf3\x8f\x92\xb0.-5Ss"); }
test { try parseIDNAFail("\xe2\x80\x8d\xf0\x90\xa8\xbf.\xf0\x9f\xa4\x92\xe1\x83\x85\xf2\x91\xae\xb6"); }
test { try parseIDNAFail("\xe2\x80\x8d\xf0\x90\xa8\xbf.\xf0\x9f\xa4\x92\xe2\xb4\xa5\xf2\x91\xae\xb6"); }
test { try parseIDNAFail("xn--0s9c.xn--tljz038l0gz4b"); }
test { try parseIDNAFail("xn--1ug9533g.xn--tljz038l0gz4b"); }
test { try parseIDNAFail("xn--0s9c.xn--9nd3211w0gz4b"); }
test { try parseIDNAFail("xn--1ug9533g.xn--9nd3211w0gz4b"); }
test { try parseIDNAFail("\xf0\xb5\x8b\x85\xe3\x80\x82\xc3\x9f\xf0\xac\xb5\xa9\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xb5\x8b\x85\xe3\x80\x82SS\xf0\xac\xb5\xa9\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xb5\x8b\x85\xe3\x80\x82ss\xf0\xac\xb5\xa9\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xb5\x8b\x85\xe3\x80\x82Ss\xf0\xac\xb5\xa9\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--ey1p.xn--ss-eq36b"); }
test { try parseIDNAFail("xn--ey1p.xn--ss-n1tx0508a"); }
test { try parseIDNAFail("xn--ey1p.xn--zca870nz438b"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xef\xbd\xa1\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x82\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xef\xbd\xa1\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x82=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xe3\x80\x82\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x82\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xe3\x80\x82\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x82=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xe3\x80\x82\xf0\x91\x96\xbf\xe1\xaa\xbb\xce\xa3=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xe3\x80\x82\xf0\x91\x96\xbf\xe1\xaa\xbb\xce\xa3\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xe3\x80\x82\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x83\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xe3\x80\x82\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x83=\xcc\xb8"); }
test { try parseIDNAFail("xn--zb9h5968x.xn--4xa378i1mfjw7y"); }
test { try parseIDNAFail("xn--0ug3766p5nm1b.xn--4xa378i1mfjw7y"); }
test { try parseIDNAFail("xn--0ug3766p5nm1b.xn--3xa578i1mfjw7y"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xef\xbd\xa1\xf0\x91\x96\xbf\xe1\xaa\xbb\xce\xa3=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xef\xbd\xa1\xf0\x91\x96\xbf\xe1\xaa\xbb\xce\xa3\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xef\xbd\xa1\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x83\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x85\xaf\xf2\x87\xbd\xad\xe2\x80\x8c\xf0\x9f\x9c\xad\xef\xbd\xa1\xf0\x91\x96\xbf\xe1\xaa\xbb\xcf\x83=\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x92\x8b\xef\xbd\xa1\xe2\x92\x88\xe2\x80\x8d\xf2\xb3\xb4\xa2"); }
test { try parseIDNAFail("4.\xe3\x80\x821.\xe2\x80\x8d\xf2\xb3\xb4\xa2"); }
test { try parseIDNAFail("4..1.xn--sf51d"); }
test { try parseIDNAFail("4..1.xn--1ug64613i"); }
test { try parseIDNAFail("xn--wsh.xn--tsh07994h"); }
test { try parseIDNAFail("xn--wsh.xn--1ug58o74922a"); }
test { try parseIDNAFail("\xe1\x82\xb3\xf0\x91\x9c\xab\xe2\x80\x8d\xf2\x97\xad\x93\xef\xbc\x8e\xda\xa7\xf0\x91\xb0\xb6"); }
test { try parseIDNAFail("\xe1\x82\xb3\xf0\x91\x9c\xab\xe2\x80\x8d\xf2\x97\xad\x93.\xda\xa7\xf0\x91\xb0\xb6"); }
test { try parseIDNAFail("\xe2\xb4\x93\xf0\x91\x9c\xab\xe2\x80\x8d\xf2\x97\xad\x93.\xda\xa7\xf0\x91\xb0\xb6"); }
test { try parseIDNAFail("xn--blj6306ey091d.xn--9jb4223l"); }
test { try parseIDNAFail("xn--1ugy52cym7p7xu5e.xn--9jb4223l"); }
test { try parseIDNAFail("\xe2\xb4\x93\xf0\x91\x9c\xab\xe2\x80\x8d\xf2\x97\xad\x93\xef\xbc\x8e\xda\xa7\xf0\x91\xb0\xb6"); }
test { try parseIDNAFail("xn--rnd8945ky009c.xn--9jb4223l"); }
test { try parseIDNAFail("xn--rnd479ep20q7x12e.xn--9jb4223l"); }
test { try parseIDNAFail("\xf0\x90\xa8\xbf.\xf0\x9f\x84\x86\xe2\x80\x94"); }
test { try parseIDNAFail("\xf0\x90\xa8\xbf.5,\xe2\x80\x94"); }
test { try parseIDNAFail("xn--0s9c.xn--5,-81t"); }
test { try parseIDNAFail("xn--0s9c.xn--8ug8324p"); }
test { try parseIDNAFail("\xf2\x94\x8a\xb1\xf1\x81\xa6\xae\xdb\xb8\xe3\x80\x82\xf3\xa0\xbe\xad-"); }
test { try parseIDNAFail("xn--lmb18944c0g2z.xn----2k81m"); }
test { try parseIDNAFail("\xf0\x9f\x9e\x85\xf3\xa0\xb3\xa1\xf3\x9c\x8d\x99.\xf1\xb2\x96\xb7"); }
test { try parseIDNAFail("xn--ie9hi1349bqdlb.xn--oj69a"); }
test { try parseIDNAFail("\xe2\x83\xa7\xf1\xaf\xa1\x8e-\xf2\xab\xa3\x9d.4\xe1\x82\xa4\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\x83\xa7\xf1\xaf\xa1\x8e-\xf2\xab\xa3\x9d.4\xe2\xb4\x84\xe2\x80\x8c"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-ivs"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-sgn589c"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-f0g"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-f0g649i"); }
test { try parseIDNAFail("\xf0\x91\x91\x84\xe2\x89\xaf\xef\xbd\xa1\xf0\x91\x9c\xa4"); }
test { try parseIDNAFail("\xf0\x91\x91\x84>\xcc\xb8\xef\xbd\xa1\xf0\x91\x9c\xa4"); }
test { try parseIDNAFail("\xf0\x91\x91\x84\xe2\x89\xaf\xe3\x80\x82\xf0\x91\x9c\xa4"); }
test { try parseIDNAFail("\xf0\x91\x91\x84>\xcc\xb8\xe3\x80\x82\xf0\x91\x9c\xa4"); }
test { try parseIDNAFail("xn--hdh5636g.xn--ci2d"); }
test { try parseIDNAFail("\xe1\x82\xab\xe2\x89\xae\xf0\xb1\xb2\x86\xe3\x80\x82\xe2\x80\x8d\xde\xa7\xf0\x90\x8b\xa3"); }
test { try parseIDNAFail("\xe1\x82\xab<\xcc\xb8\xf0\xb1\xb2\x86\xe3\x80\x82\xe2\x80\x8d\xde\xa7\xf0\x90\x8b\xa3"); }
test { try parseIDNAFail("\xe2\xb4\x8b<\xcc\xb8\xf0\xb1\xb2\x86\xe3\x80\x82\xe2\x80\x8d\xde\xa7\xf0\x90\x8b\xa3"); }
test { try parseIDNAFail("\xe2\xb4\x8b\xe2\x89\xae\xf0\xb1\xb2\x86\xe3\x80\x82\xe2\x80\x8d\xde\xa7\xf0\x90\x8b\xa3"); }
test { try parseIDNAFail("xn--gdhz03bxt42d.xn--lrb6479j"); }
test { try parseIDNAFail("xn--gdhz03bxt42d.xn--lrb506jqr4n"); }
test { try parseIDNAFail("xn--jnd802gsm17c.xn--lrb6479j"); }
test { try parseIDNAFail("xn--jnd802gsm17c.xn--lrb506jqr4n"); }
test { try parseIDNAFail("\xe1\x9f\x92.\xf2\x86\xbd\x92\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe1\x9f\x92.\xf2\x86\xbd\x92>\xcc\xb8"); }
test { try parseIDNAFail("xn--u4e.xn--hdhx0084f"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4\xef\xbc\x8e\xf0\x90\xa8\xba\xc3\x89\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4\xef\xbc\x8e\xf0\x90\xa8\xbaE\xcc\x81\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4.\xf0\x90\xa8\xba\xc3\x89\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4.\xf0\x90\xa8\xbaE\xcc\x81\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4.\xf0\x90\xa8\xbae\xcc\x81\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4.\xf0\x90\xa8\xba\xc3\xa9\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("xn--c0e34564d.xn--9ca207st53lg3f"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4\xef\xbc\x8e\xf0\x90\xa8\xbae\xcc\x81\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("\xf1\x8f\x81\x87\xe1\x9c\xb4\xef\xbc\x8e\xf0\x90\xa8\xba\xc3\xa9\xe2\xac\x93\xf0\x91\x84\xb4"); }
test { try parseIDNAFail("\xe1\x83\x83\xef\xbc\x8e\xd9\x93\xe1\xa2\xa4"); }
test { try parseIDNAFail("\xe1\x83\x83.\xd9\x93\xe1\xa2\xa4"); }
test { try parseIDNAFail("\xe2\xb4\xa3.\xd9\x93\xe1\xa2\xa4"); }
test { try parseIDNAFail("xn--rlj.xn--vhb294g"); }
test { try parseIDNAFail("\xe2\xb4\xa3\xef\xbc\x8e\xd9\x93\xe1\xa2\xa4"); }
test { try parseIDNAFail("xn--7nd.xn--vhb294g"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93\xef\xbc\x8e\xec\x8b\x89\xf2\x84\x86\xbb\xe1\x83\x84\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93\xef\xbc\x8e\xe1\x84\x89\xe1\x85\xb4\xe1\x86\xb0\xf2\x84\x86\xbb\xe1\x83\x84\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93.\xec\x8b\x89\xf2\x84\x86\xbb\xe1\x83\x84\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93.\xe1\x84\x89\xe1\x85\xb4\xe1\x86\xb0\xf2\x84\x86\xbb\xe1\x83\x84\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93.\xe1\x84\x89\xe1\x85\xb4\xe1\x86\xb0\xf2\x84\x86\xbb\xe2\xb4\xa4\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93.\xec\x8b\x89\xf2\x84\x86\xbb\xe2\xb4\xa4\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("xn--oub.xn--sljz109bpe25dviva"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93\xef\xbc\x8e\xe1\x84\x89\xe1\x85\xb4\xe1\x86\xb0\xf2\x84\x86\xbb\xe2\xb4\xa4\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("\xf3\xa0\x84\x88\xe0\xa0\x93\xef\xbc\x8e\xec\x8b\x89\xf2\x84\x86\xbb\xe2\xb4\xa4\xf2\x82\xa1\x90"); }
test { try parseIDNAFail("xn--oub.xn--8nd9522gpe69cviva"); }
test { try parseIDNAFail("\xea\xa8\xac\xf0\x91\xb2\xab\xe2\x89\xae\xef\xbc\x8e\xe2\xa4\x82"); }
test { try parseIDNAFail("\xea\xa8\xac\xf0\x91\xb2\xab<\xcc\xb8\xef\xbc\x8e\xe2\xa4\x82"); }
test { try parseIDNAFail("\xea\xa8\xac\xf0\x91\xb2\xab\xe2\x89\xae.\xe2\xa4\x82"); }
test { try parseIDNAFail("\xea\xa8\xac\xf0\x91\xb2\xab<\xcc\xb8.\xe2\xa4\x82"); }
test { try parseIDNAFail("xn--gdh1854cn19c.xn--kqi"); }
test { try parseIDNAFail("\xf0\x91\x81\x85\xe3\x80\x82-"); }
test { try parseIDNAFail("xn--210d.-"); }
test { try parseIDNAFail("\xea\xa1\xa6\xe1\xa1\x91\xe2\x80\x8d\xe2\x92\x88\xe3\x80\x82\xf0\x90\x8b\xa3-"); }
test { try parseIDNAFail("\xea\xa1\xa6\xe1\xa1\x91\xe2\x80\x8d1.\xe3\x80\x82\xf0\x90\x8b\xa3-"); }
test { try parseIDNAFail("xn--1-o7j663bdl7m..xn----381i"); }
test { try parseIDNAFail("xn--h8e863drj7h.xn----381i"); }
test { try parseIDNAFail("xn--h8e470bl0d838o.xn----381i"); }
test { try parseIDNAFail("\xe2\x92\x88\xe4\xb0\xb9\xe2\x80\x8d-\xe3\x80\x82\xec\x9b\x88"); }
test { try parseIDNAFail("\xe2\x92\x88\xe4\xb0\xb9\xe2\x80\x8d-\xe3\x80\x82\xe1\x84\x8b\xe1\x85\xae\xe1\x86\xbf"); }
test { try parseIDNAFail("1.\xe4\xb0\xb9\xe2\x80\x8d-\xe3\x80\x82\xec\x9b\x88"); }
test { try parseIDNAFail("1.\xe4\xb0\xb9\xe2\x80\x8d-\xe3\x80\x82\xe1\x84\x8b\xe1\x85\xae\xe1\x86\xbf"); }
test { try parseIDNAFail("1.xn----tgnz80r.xn--kp5b"); }
test { try parseIDNAFail("xn----dcp160o.xn--kp5b"); }
test { try parseIDNAFail("xn----tgnx5rjr6c.xn--kp5b"); }
test { try parseIDNAFail("\xe3\x81\xa6\xe3\x80\x82\xe2\x80\x8c\xf3\xa0\xb3\xbd\xdf\xb3"); }
test { try parseIDNAFail("xn--m9j.xn--rtb10784p"); }
test { try parseIDNAFail("xn--m9j.xn--rtb154j9l73w"); }
test { try parseIDNAFail("\xcf\x82\xef\xbd\xa1\xea\xa7\x80\xdb\xa7"); }
test { try parseIDNAFail("\xcf\x82\xe3\x80\x82\xea\xa7\x80\xdb\xa7"); }
test { try parseIDNAFail("\xce\xa3\xe3\x80\x82\xea\xa7\x80\xdb\xa7"); }
test { try parseIDNAFail("\xcf\x83\xe3\x80\x82\xea\xa7\x80\xdb\xa7"); }
test { try parseIDNAFail("xn--4xa.xn--3lb1944f"); }
test { try parseIDNAFail("xn--3xa.xn--3lb1944f"); }
test { try parseIDNAFail("\xce\xa3\xef\xbd\xa1\xea\xa7\x80\xdb\xa7"); }
test { try parseIDNAFail("\xcf\x83\xef\xbd\xa1\xea\xa7\x80\xdb\xa7"); }
test { try parseIDNAFail("\xe0\xaf\x8d\xf3\xa5\xab\x85\xf2\x8c\x89\x91.\xe1\x82\xa2\xe1\x82\xb5"); }
test { try parseIDNAFail("\xe0\xaf\x8d\xf3\xa5\xab\x85\xf2\x8c\x89\x91.\xe2\xb4\x82\xe2\xb4\x95"); }
test { try parseIDNAFail("\xe0\xaf\x8d\xf3\xa5\xab\x85\xf2\x8c\x89\x91.\xe1\x82\xa2\xe2\xb4\x95"); }
test { try parseIDNAFail("xn--xmc83135idcxza.xn--tkjwb"); }
test { try parseIDNAFail("xn--xmc83135idcxza.xn--9md086l"); }
test { try parseIDNAFail("xn--xmc83135idcxza.xn--9md2b"); }
test { try parseIDNAFail("\xe1\xb0\xb2\xf0\x9f\x84\x88\xe2\xbe\x9b\xd6\xa6\xef\xbc\x8e\xe2\x80\x8d\xf2\xaf\xa5\xa4\xdf\xbd"); }
test { try parseIDNAFail("\xe1\xb0\xb27,\xe8\xb5\xb0\xd6\xa6.\xe2\x80\x8d\xf2\xaf\xa5\xa4\xdf\xbd"); }
test { try parseIDNAFail("xn--7,-bid991urn3k.xn--1tb13454l"); }
test { try parseIDNAFail("xn--7,-bid991urn3k.xn--1tb334j1197q"); }
test { try parseIDNAFail("xn--xcb756i493fwi5o.xn--1tb13454l"); }
test { try parseIDNAFail("xn--xcb756i493fwi5o.xn--1tb334j1197q"); }
test { try parseIDNAFail("\xe1\xa2\x97\xef\xbd\xa1\xd3\x80\xf1\x9d\x84\xbb"); }
test { try parseIDNAFail("\xe1\xa2\x97\xe3\x80\x82\xd3\x80\xf1\x9d\x84\xbb"); }
test { try parseIDNAFail("\xe1\xa2\x97\xe3\x80\x82\xd3\x8f\xf1\x9d\x84\xbb"); }
test { try parseIDNAFail("xn--hbf.xn--s5a83117e"); }
test { try parseIDNAFail("\xe1\xa2\x97\xef\xbd\xa1\xd3\x8f\xf1\x9d\x84\xbb"); }
test { try parseIDNAFail("xn--hbf.xn--d5a86117e"); }
test { try parseIDNAFail("\xf0\x91\xb2\x98\xf3\xa0\x84\x92\xf0\x93\x91\xa1\xef\xbd\xa1\xf0\x9d\x9f\xaa\xe1\x82\xbc"); }
test { try parseIDNAFail("\xf0\x91\xb2\x98\xf3\xa0\x84\x92\xf0\x93\x91\xa1\xe3\x80\x828\xe1\x82\xbc"); }
test { try parseIDNAFail("\xf0\x91\xb2\x98\xf3\xa0\x84\x92\xf0\x93\x91\xa1\xe3\x80\x828\xe2\xb4\x9c"); }
test { try parseIDNAFail("xn--7m3d291b.xn--8-vws"); }
test { try parseIDNAFail("\xf0\x91\xb2\x98\xf3\xa0\x84\x92\xf0\x93\x91\xa1\xef\xbd\xa1\xf0\x9d\x9f\xaa\xe2\xb4\x9c"); }
test { try parseIDNAFail("xn--7m3d291b.xn--8-s1g"); }
test { try parseIDNAFail("\xe1\xae\xab\xef\xbd\xa1\xf0\x9f\x82\x89\xf3\xa0\x81\xb0"); }
test { try parseIDNAFail("\xe1\xae\xab\xe3\x80\x82\xf0\x9f\x82\x89\xf3\xa0\x81\xb0"); }
test { try parseIDNAFail("xn--zxf.xn--fx7ho0250c"); }
test { try parseIDNAFail("\xf3\xac\x9a\xb6\xf3\xb8\x8b\x96\xf2\x96\xa9\xb0-\xe3\x80\x82\xe2\x80\x8c"); }
test { try parseIDNAFail("xn----7i12hu122k9ire."); }
test { try parseIDNAFail("xn----7i12hu122k9ire.xn--0ug"); }
test { try parseIDNAFail("\xef\xb8\x92\xef\xbc\x8e\xef\xb8\xaf\xf0\x91\x91\x82"); }
test { try parseIDNAFail("\xef\xb8\x92\xef\xbc\x8e\xf0\x91\x91\x82\xef\xb8\xaf"); }
test { try parseIDNAFail("\xe3\x80\x82.\xf0\x91\x91\x82\xef\xb8\xaf"); }
test { try parseIDNAFail("..xn--s96cu30b"); }
test { try parseIDNAFail("xn--y86c.xn--s96cu30b"); }
test { try parseIDNAFail("\xea\xa4\xac\xe3\x80\x82\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--zi9a."); }
test { try parseIDNAFail("xn--zi9a.xn--1ug"); }
test { try parseIDNAFail("\xf3\xa6\x88\x84\xe3\x80\x82-"); }
test { try parseIDNAFail("xn--xm38e.-"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98\xc3\x9f\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98\xc3\x9f>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98\xc3\x9f\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98\xc3\x9f>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98SS>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98SS\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98ss\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98ss>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98Ss>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae.\xf2\xb6\x88\xae\xe0\xbc\x98Ss\xe2\x89\xaf"); }
test { try parseIDNAFail("xn--pgh4639f.xn--ss-ifj426nle504a"); }
test { try parseIDNAFail("xn--pgh4639f.xn--zca593eo6oc013y"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98SS>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98SS\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98ss\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98ss>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x89\xbc\xcc\xb8\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98Ss>\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x8b\xa0\xf0\x90\x8b\xae\xef\xbc\x8e\xf2\xb6\x88\xae\xe0\xbc\x98Ss\xe2\x89\xaf"); }
test { try parseIDNAFail("\xcc\xb0\xef\xbc\x8e\xf3\xb0\x9c\xb1\xe8\x9a\x80"); }
test { try parseIDNAFail("\xcc\xb0.\xf3\xb0\x9c\xb1\xe8\x9a\x80"); }
test { try parseIDNAFail("xn--xta.xn--e91aw9417e"); }
test { try parseIDNAFail("\xf0\x9f\xa2\x9f\xf0\x9f\x84\x88\xe2\x80\x8d\xea\xa1\x8e\xef\xbd\xa1\xe0\xbe\x84"); }
test { try parseIDNAFail("\xf0\x9f\xa2\x9f7,\xe2\x80\x8d\xea\xa1\x8e\xe3\x80\x82\xe0\xbe\x84"); }
test { try parseIDNAFail("xn--7,-gh9hg322i.xn--3ed"); }
test { try parseIDNAFail("xn--7,-n1t0654eqo3o.xn--3ed"); }
test { try parseIDNAFail("xn--nc9aq743ds0e.xn--3ed"); }
test { try parseIDNAFail("xn--1ug4874cfd0kbmg.xn--3ed"); }
test { try parseIDNAFail("\xea\xa1\x94\xe3\x80\x82\xe1\x80\xb9\xe1\xa2\x87"); }
test { try parseIDNAFail("xn--tc9a.xn--9jd663b"); }
test { try parseIDNAFail("\xe2\x83\xab\xe2\x89\xae.\xf0\x9d\xa8\x96"); }
test { try parseIDNAFail("\xe2\x83\xab<\xcc\xb8.\xf0\x9d\xa8\x96"); }
test { try parseIDNAFail("xn--e1g71d.xn--772h"); }
test { try parseIDNAFail("\xe2\x80\x8c.\xe2\x89\xaf"); }
test { try parseIDNAFail("\xe2\x80\x8c.>\xcc\xb8"); }
test { try parseIDNAFail("xn--0ug.xn--hdh"); }
test { try parseIDNAFail("\xf0\xb0\x85\xa7\xf1\xa3\xa9\xa0-\xef\xbc\x8e\xea\xaf\xad-\xe6\x82\x9c"); }
test { try parseIDNAFail("\xf0\xb0\x85\xa7\xf1\xa3\xa9\xa0-.\xea\xaf\xad-\xe6\x82\x9c"); }
test { try parseIDNAFail("xn----7m53aj640l.xn----8f4br83t"); }
test { try parseIDNAFail("\xe1\xa1\x89\xf0\xb6\x93\xa7\xe2\xac\x9e\xe1\xa2\x9c.-\xe2\x80\x8d\xf0\x9e\xa3\x91\xe2\x80\xae"); }
test { try parseIDNAFail("xn--87e0ol04cdl39e.xn----qinu247r"); }
test { try parseIDNAFail("xn--87e0ol04cdl39e.xn----ugn5e3763s"); }
test { try parseIDNAFail("xn--ynd2415j.xn--5-dug9054m"); }
test { try parseIDNAFail("\xe2\x80\x8d-\xe1\xa0\xb9\xef\xb9\xaa.\xe1\xb7\xa1\xe1\xa4\xa2"); }
test { try parseIDNAFail("\xe2\x80\x8d-\xe1\xa0\xb9%.\xe1\xb7\xa1\xe1\xa4\xa2"); }
test { try parseIDNAFail("xn---%-u4o.xn--gff52t"); }
test { try parseIDNAFail("xn---%-u4oy48b.xn--gff52t"); }
test { try parseIDNAFail("xn----c6jx047j.xn--gff52t"); }
test { try parseIDNAFail("xn----c6j614b1z4v.xn--gff52t"); }
test { try parseIDNAFail("\xf0\xa3\xa9\xab\xef\xbc\x8e\xf2\x8c\x91\xb2"); }
test { try parseIDNAFail("\xf0\xa3\xa9\xab.\xf2\x8c\x91\xb2"); }
test { try parseIDNAFail("xn--td3j.xn--4628b"); }
test { try parseIDNAFail("\xe0\xb1\x8d\xf0\x9d\xa8\xbe\xd6\xa9\xf0\x9d\x9f\xad\xe3\x80\x82-\xf0\x91\x9c\xa8"); }
test { try parseIDNAFail("\xe0\xb1\x8d\xf0\x9d\xa8\xbe\xd6\xa91\xe3\x80\x82-\xf0\x91\x9c\xa8"); }
test { try parseIDNAFail("xn--1-rfc312cdp45c.xn----nq0j"); }
test { try parseIDNAFail("\xf2\xa3\xbf\x88\xe3\x80\x82\xeb\x99\x8f"); }
test { try parseIDNAFail("\xf2\xa3\xbf\x88\xe3\x80\x82\xe1\x84\x84\xe1\x85\xab\xe1\x86\xae"); }
test { try parseIDNAFail("xn--ph26c.xn--281b"); }
test { try parseIDNAFail("\xf1\x95\xa8\x9a\xf3\xa0\x84\x8c\xf3\x91\xbd\x80\xe1\xa1\x80.\xe0\xa2\xb6"); }
test { try parseIDNAFail("xn--z7e98100evc01b.xn--czb"); }
test { try parseIDNAFail("\xe2\x80\x8d\xef\xbd\xa1\xf1\x85\x81\x9b"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\x80\x82\xf1\x85\x81\x9b"); }
test { try parseIDNAFail(".xn--6x4u"); }
test { try parseIDNAFail("xn--1ug.xn--6x4u"); }
test { try parseIDNAFail("\xef\xbf\xb9\xe2\x80\x8c\xef\xbd\xa1\xe6\x9b\xb3\xe2\xbe\x91\xf0\x90\x8b\xb0\xe2\x89\xaf"); }
test { try parseIDNAFail("\xef\xbf\xb9\xe2\x80\x8c\xef\xbd\xa1\xe6\x9b\xb3\xe2\xbe\x91\xf0\x90\x8b\xb0>\xcc\xb8"); }
test { try parseIDNAFail("\xef\xbf\xb9\xe2\x80\x8c\xe3\x80\x82\xe6\x9b\xb3\xe8\xa5\xbe\xf0\x90\x8b\xb0\xe2\x89\xaf"); }
test { try parseIDNAFail("\xef\xbf\xb9\xe2\x80\x8c\xe3\x80\x82\xe6\x9b\xb3\xe8\xa5\xbe\xf0\x90\x8b\xb0>\xcc\xb8"); }
test { try parseIDNAFail("xn--vn7c.xn--hdh501y8wvfs5h"); }
test { try parseIDNAFail("xn--0ug2139f.xn--hdh501y8wvfs5h"); }
test { try parseIDNAFail("\xe2\x89\xaf\xe2\x92\x88\xe3\x80\x82\xc3\x9f"); }
test { try parseIDNAFail(">\xcc\xb8\xe2\x92\x88\xe3\x80\x82\xc3\x9f"); }
test { try parseIDNAFail(">\xcc\xb8\xe2\x92\x88\xe3\x80\x82SS"); }
test { try parseIDNAFail("\xe2\x89\xaf\xe2\x92\x88\xe3\x80\x82SS"); }
test { try parseIDNAFail("\xe2\x89\xaf\xe2\x92\x88\xe3\x80\x82ss"); }
test { try parseIDNAFail(">\xcc\xb8\xe2\x92\x88\xe3\x80\x82ss"); }
test { try parseIDNAFail(">\xcc\xb8\xe2\x92\x88\xe3\x80\x82Ss"); }
test { try parseIDNAFail("\xe2\x89\xaf\xe2\x92\x88\xe3\x80\x82Ss"); }
test { try parseIDNAFail("xn--hdh84f.ss"); }
test { try parseIDNAFail("xn--hdh84f.xn--zca"); }
test { try parseIDNAFail("\xe2\x80\x8c\xef\xbd\xa1\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe2\x80\x8c\xef\xbd\xa1=\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe3\x80\x82\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe3\x80\x82=\xcc\xb8"); }
test { try parseIDNAFail("xn--0ug.xn--1ch"); }
test { try parseIDNAFail("\xf0\x91\x96\xbf\xf0\x9d\xa8\x94.\xe1\xa1\x9f\xf0\x91\x96\xbf\xe1\xad\x82\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--461dw464a.xn--v8e29loy65a"); }
test { try parseIDNAFail("xn--461dw464a.xn--v8e29ldzfo952a"); }
test { try parseIDNAFail("\xf2\x94\xa3\xb3\xe2\x80\x8d\xf2\x91\x9d\xb1.\xf0\x96\xac\xb4\xe2\x86\x83\xe2\x89\xa0-"); }
test { try parseIDNAFail("\xf2\x94\xa3\xb3\xe2\x80\x8d\xf2\x91\x9d\xb1.\xf0\x96\xac\xb4\xe2\x86\x83=\xcc\xb8-"); }
test { try parseIDNAFail("\xf2\x94\xa3\xb3\xe2\x80\x8d\xf2\x91\x9d\xb1.\xf0\x96\xac\xb4\xe2\x86\x84=\xcc\xb8-"); }
test { try parseIDNAFail("\xf2\x94\xa3\xb3\xe2\x80\x8d\xf2\x91\x9d\xb1.\xf0\x96\xac\xb4\xe2\x86\x84\xe2\x89\xa0-"); }
test { try parseIDNAFail("xn--6j00chy9a.xn----81n51bt713h"); }
test { try parseIDNAFail("xn--1ug15151gkb5a.xn----81n51bt713h"); }
test { try parseIDNAFail("xn--6j00chy9a.xn----61n81bt713h"); }
test { try parseIDNAFail("xn--1ug15151gkb5a.xn----61n81bt713h"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x94\xae\xf3\xa0\x87\x90\xef\xbc\x8e\xe0\xb0\x80\xe0\xb1\x8d\xe1\x9c\xb4\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x94\xae\xf3\xa0\x87\x90.\xe0\xb0\x80\xe0\xb1\x8d\xe1\x9c\xb4\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--kxh.xn--eoc8m432a"); }
test { try parseIDNAFail("xn--1ug04r.xn--eoc8m432a40i"); }
test { try parseIDNAFail("\xf2\xb9\x9a\xaa\xef\xbd\xa1\xf0\x9f\x84\x82"); }
test { try parseIDNAFail("\xf2\xb9\x9a\xaa\xe3\x80\x821,"); }
test { try parseIDNAFail("xn--n433d.1,"); }
test { try parseIDNAFail("xn--n433d.xn--v07h"); }
test { try parseIDNAFail("\xf0\x91\x8d\xa8\xe5\x88\x8d.\xf0\x9f\x9b\xa6"); }
test { try parseIDNAFail("xn--rbry728b.xn--y88h"); }
test { try parseIDNAFail("\xf3\xa0\x8c\x8f3\xef\xbd\xa1\xe1\xaf\xb1\xf0\x9d\x9f\x92"); }
test { try parseIDNAFail("\xf3\xa0\x8c\x8f3\xe3\x80\x82\xe1\xaf\xb14"); }
test { try parseIDNAFail("xn--3-ib31m.xn--4-pql"); }
test { try parseIDNAFail("\xea\xa1\xbd\xe2\x89\xaf\xef\xbc\x8e\xf2\xbb\xb2\x80\xf2\x92\xb3\x84"); }
test { try parseIDNAFail("\xea\xa1\xbd>\xcc\xb8\xef\xbc\x8e\xf2\xbb\xb2\x80\xf2\x92\xb3\x84"); }
test { try parseIDNAFail("\xea\xa1\xbd\xe2\x89\xaf.\xf2\xbb\xb2\x80\xf2\x92\xb3\x84"); }
test { try parseIDNAFail("\xea\xa1\xbd>\xcc\xb8.\xf2\xbb\xb2\x80\xf2\x92\xb3\x84"); }
test { try parseIDNAFail("xn--hdh8193c.xn--5z40cp629b"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b\xef\xbc\x8e\xe2\x80\x8d\xe4\xa4\xab\xe2\x89\xa0\xe1\x82\xbe"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b\xef\xbc\x8e\xe2\x80\x8d\xe4\xa4\xab=\xcc\xb8\xe1\x82\xbe"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b.\xe2\x80\x8d\xe4\xa4\xab\xe2\x89\xa0\xe1\x82\xbe"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b.\xe2\x80\x8d\xe4\xa4\xab=\xcc\xb8\xe1\x82\xbe"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b.\xe2\x80\x8d\xe4\xa4\xab=\xcc\xb8\xe2\xb4\x9e"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b.\xe2\x80\x8d\xe4\xa4\xab\xe2\x89\xa0\xe2\xb4\x9e"); }
test { try parseIDNAFail("xn--1t56e.xn--1ch153bqvw"); }
test { try parseIDNAFail("xn--1t56e.xn--1ug73gzzpwi3a"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b\xef\xbc\x8e\xe2\x80\x8d\xe4\xa4\xab=\xcc\xb8\xe2\xb4\x9e"); }
test { try parseIDNAFail("\xf3\xa0\xb3\x9b\xef\xbc\x8e\xe2\x80\x8d\xe4\xa4\xab\xe2\x89\xa0\xe2\xb4\x9e"); }
test { try parseIDNAFail("xn--1t56e.xn--2nd141ghl2a"); }
test { try parseIDNAFail("xn--1t56e.xn--2nd159e9vb743e"); }
test { try parseIDNAFail("3.1.xn--110d.j"); }
test { try parseIDNAFail("xn--tshd3512p.j"); }
test { try parseIDNAFail("\xcd\x8a\xef\xbc\x8e\xf0\x90\xa8\x8e"); }
test { try parseIDNAFail("\xcd\x8a.\xf0\x90\xa8\x8e"); }
test { try parseIDNAFail("xn--oua.xn--mr9c"); }
test { try parseIDNAFail("\xed\x9b\x89\xe2\x89\xae\xef\xbd\xa1\xe0\xb8\xb4"); }
test { try parseIDNAFail("\xe1\x84\x92\xe1\x85\xae\xe1\x86\xac<\xcc\xb8\xef\xbd\xa1\xe0\xb8\xb4"); }
test { try parseIDNAFail("\xed\x9b\x89\xe2\x89\xae\xe3\x80\x82\xe0\xb8\xb4"); }
test { try parseIDNAFail("\xe1\x84\x92\xe1\x85\xae\xe1\x86\xac<\xcc\xb8\xe3\x80\x82\xe0\xb8\xb4"); }
test { try parseIDNAFail("xn--gdh2512e.xn--i4c"); }
test { try parseIDNAFail("xn--fc9a.xn----qmg787k869k"); }
test { try parseIDNAFail("\xe2\x89\xae\xf0\x9d\x85\xb6\xef\xbc\x8e\xf1\xb1\xb2\x81\xea\xab\xac\xe2\xb9\x88\xf3\xb0\xa5\xad"); }
test { try parseIDNAFail("<\xcc\xb8\xf0\x9d\x85\xb6\xef\xbc\x8e\xf1\xb1\xb2\x81\xea\xab\xac\xe2\xb9\x88\xf3\xb0\xa5\xad"); }
test { try parseIDNAFail("\xe2\x89\xae\xf0\x9d\x85\xb6.\xf1\xb1\xb2\x81\xea\xab\xac\xe2\xb9\x88\xf3\xb0\xa5\xad"); }
test { try parseIDNAFail("<\xcc\xb8\xf0\x9d\x85\xb6.\xf1\xb1\xb2\x81\xea\xab\xac\xe2\xb9\x88\xf3\xb0\xa5\xad"); }
test { try parseIDNAFail("xn--gdh.xn--4tjx101bsg00ds9pyc"); }
test { try parseIDNAFail("xn--gdh0880o.xn--4tjx101bsg00ds9pyc"); }
test { try parseIDNAFail("\xf0\x91\x91\x82\xef\xbd\xa1\xe2\x80\x8d\xf3\xa5\x9e\x80\xf0\x9f\x9e\x95\xf2\xa5\x81\x94"); }
test { try parseIDNAFail("\xf0\x91\x91\x82\xe3\x80\x82\xe2\x80\x8d\xf3\xa5\x9e\x80\xf0\x9f\x9e\x95\xf2\xa5\x81\x94"); }
test { try parseIDNAFail("xn--8v1d.xn--ye9h41035a2qqs"); }
test { try parseIDNAFail("xn--8v1d.xn--1ug1386plvx1cd8vya"); }
test { try parseIDNAFail("-\xe2\x80\x8c\xe2\x92\x99\xf0\x90\xab\xa5\xef\xbd\xa1\xf0\x9d\xa8\xb5"); }
test { try parseIDNAFail("-\xe2\x80\x8c18.\xf0\x90\xab\xa5\xe3\x80\x82\xf0\x9d\xa8\xb5"); }
test { try parseIDNAFail("-18.xn--rx9c.xn--382h"); }
test { try parseIDNAFail("xn---18-9m0a.xn--rx9c.xn--382h"); }
test { try parseIDNAFail("xn----ddps939g.xn--382h"); }
test { try parseIDNAFail("xn----sgn18r3191a.xn--382h"); }
test { try parseIDNAFail("\xef\xb8\x85\xef\xb8\x92\xe3\x80\x82\xf0\xa6\x80\xbe\xe1\xb3\xa0"); }
test { try parseIDNAFail("xn--y86c.xn--t6f5138v"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-\xc3\x9f\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-\xc3\x9f\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-\xc3\x9f\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-\xc3\x9f\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-SS\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-SS\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-ss\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-ss\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-Ss\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f.-Ss\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("xn--u836e.xn---ss-gl2a"); }
test { try parseIDNAFail("xn--u836e.xn---ss-cn0at5l"); }
test { try parseIDNAFail("xn--u836e.xn----qfa750ve7b"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-SS\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-SS\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-ss\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-ss\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-Ss\xe2\x80\x8c=\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x95\x8f\xef\xbc\x8e-Ss\xe2\x80\x8c\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe1\xa1\x99\xe2\x80\x8c\xef\xbd\xa1\xe2\x89\xaf\xf0\x90\x8b\xb2\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe1\xa1\x99\xe2\x80\x8c\xef\xbd\xa1>\xcc\xb8\xf0\x90\x8b\xb2=\xcc\xb8"); }
test { try parseIDNAFail("\xe1\xa1\x99\xe2\x80\x8c\xe3\x80\x82\xe2\x89\xaf\xf0\x90\x8b\xb2\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe1\xa1\x99\xe2\x80\x8c\xe3\x80\x82>\xcc\xb8\xf0\x90\x8b\xb2=\xcc\xb8"); }
test { try parseIDNAFail("xn--p8e650b.xn--1ch3a7084l"); }
test { try parseIDNAFail("\xf2\xae\xb5\x9b\xd8\x93.\xe1\x82\xb5"); }
test { try parseIDNAFail("\xf2\xae\xb5\x9b\xd8\x93.\xe2\xb4\x95"); }
test { try parseIDNAFail("xn--1fb94204l.xn--dlj"); }
test { try parseIDNAFail("xn--1fb94204l.xn--tnd"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf3\xa0\x84\xb7\xef\xbd\xa1\xf2\x92\x91\x81"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf3\xa0\x84\xb7\xe3\x80\x82\xf2\x92\x91\x81"); }
test { try parseIDNAFail(".xn--w720c"); }
test { try parseIDNAFail("xn--0ug.xn--w720c"); }
test { try parseIDNAFail("\xe2\x92\x88\xe0\xb7\x96\xe7\x84\x85.\xf3\x97\xa1\x99\xe2\x80\x8d\xea\xa1\x9f"); }
test { try parseIDNAFail("1.\xe0\xb7\x96\xe7\x84\x85.\xf3\x97\xa1\x99\xe2\x80\x8d\xea\xa1\x9f"); }
test { try parseIDNAFail("1.xn--t1c6981c.xn--4c9a21133d"); }
test { try parseIDNAFail("1.xn--t1c6981c.xn--1ugz184c9lw7i"); }
test { try parseIDNAFail("xn--t1c337io97c.xn--4c9a21133d"); }
test { try parseIDNAFail("xn--t1c337io97c.xn--1ugz184c9lw7i"); }
test { try parseIDNAFail("\xf0\x91\x87\x80\xe2\x96\x8d.\xe2\x81\x9e\xe1\xa0\xb0"); }
test { try parseIDNAFail("xn--9zh3057f.xn--j7e103b"); }
test { try parseIDNAFail("-3.\xe2\x80\x8d\xe3\x83\x8c\xe1\xa2\x95"); }
test { try parseIDNAFail("-3.xn--fbf739aq5o"); }
test { try parseIDNAFail("\xe2\x84\xb2\xe1\x9f\x92\xe2\x80\x8d\xef\xbd\xa1\xe2\x89\xa0\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\x84\xb2\xe1\x9f\x92\xe2\x80\x8d\xef\xbd\xa1=\xcc\xb8\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\x84\xb2\xe1\x9f\x92\xe2\x80\x8d\xe3\x80\x82\xe2\x89\xa0\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\x84\xb2\xe1\x9f\x92\xe2\x80\x8d\xe3\x80\x82=\xcc\xb8\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\x85\x8e\xe1\x9f\x92\xe2\x80\x8d\xe3\x80\x82=\xcc\xb8\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\x85\x8e\xe1\x9f\x92\xe2\x80\x8d\xe3\x80\x82\xe2\x89\xa0\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--u4e823bq1a.xn--0ugb89o"); }
test { try parseIDNAFail("\xe2\x85\x8e\xe1\x9f\x92\xe2\x80\x8d\xef\xbd\xa1=\xcc\xb8\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\x85\x8e\xe1\x9f\x92\xe2\x80\x8d\xef\xbd\xa1\xe2\x89\xa0\xe2\x80\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--u4e319b.xn--1ch"); }
test { try parseIDNAFail("xn--u4e823bcza.xn--0ugb89o"); }
test { try parseIDNAFail("\xf1\xba\x94\xaf\xe0\xbe\xa8\xef\xbc\x8e\xe2\x89\xaf"); }
test { try parseIDNAFail("\xf1\xba\x94\xaf\xe0\xbe\xa8\xef\xbc\x8e>\xcc\xb8"); }
test { try parseIDNAFail("\xf1\xba\x94\xaf\xe0\xbe\xa8.\xe2\x89\xaf"); }
test { try parseIDNAFail("\xf1\xba\x94\xaf\xe0\xbe\xa8.>\xcc\xb8"); }
test { try parseIDNAFail("xn--4fd57150h.xn--hdh"); }
test { try parseIDNAFail("\xf0\x90\xa8\xbf\xf3\xa0\x86\x8c\xe9\xb8\xae\xf0\x91\x9a\xb6.\xcf\x82"); }
test { try parseIDNAFail("\xf0\x90\xa8\xbf\xf3\xa0\x86\x8c\xe9\xb8\xae\xf0\x91\x9a\xb6.\xce\xa3"); }
test { try parseIDNAFail("\xf0\x90\xa8\xbf\xf3\xa0\x86\x8c\xe9\xb8\xae\xf0\x91\x9a\xb6.\xcf\x83"); }
test { try parseIDNAFail("xn--l76a726rt2h.xn--4xa"); }
test { try parseIDNAFail("xn--l76a726rt2h.xn--3xa"); }
test { try parseIDNAFail("\xcf\x82-\xe3\x80\x82\xe2\x80\x8c\xf0\x9d\x9f\xad-"); }
test { try parseIDNAFail("\xcf\x82-\xe3\x80\x82\xe2\x80\x8c1-"); }
test { try parseIDNAFail("\xce\xa3-\xe3\x80\x82\xe2\x80\x8c1-"); }
test { try parseIDNAFail("\xcf\x83-\xe3\x80\x82\xe2\x80\x8c1-"); }
test { try parseIDNAFail("xn----zmb.xn--1--i1t"); }
test { try parseIDNAFail("xn----xmb.xn--1--i1t"); }
test { try parseIDNAFail("\xce\xa3-\xe3\x80\x82\xe2\x80\x8c\xf0\x9d\x9f\xad-"); }
test { try parseIDNAFail("\xcf\x83-\xe3\x80\x82\xe2\x80\x8c\xf0\x9d\x9f\xad-"); }
test { try parseIDNAFail("\xe1\x9c\xb4-\xe0\xb3\xa2\xef\xbc\x8e\xf3\xa0\x84\xa9\xe1\x82\xa4"); }
test { try parseIDNAFail("\xe1\x9c\xb4-\xe0\xb3\xa2.\xf3\xa0\x84\xa9\xe1\x82\xa4"); }
test { try parseIDNAFail("\xe1\x9c\xb4-\xe0\xb3\xa2.\xf3\xa0\x84\xa9\xe2\xb4\x84"); }
test { try parseIDNAFail("xn----ggf830f.xn--vkj"); }
test { try parseIDNAFail("\xe1\x9c\xb4-\xe0\xb3\xa2\xef\xbc\x8e\xf3\xa0\x84\xa9\xe2\xb4\x84"); }
test { try parseIDNAFail("xn----ggf830f.xn--cnd"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\x80\x82\xf0\x9e\x80\x98\xe2\x92\x88\xea\xa1\x8d\xe6\x93\x89"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\x80\x82\xf0\x9e\x80\x981.\xea\xa1\x8d\xe6\x93\x89"); }
test { try parseIDNAFail(".xn--1-1p4r.xn--s7uv61m"); }
test { try parseIDNAFail("xn--1ug.xn--1-1p4r.xn--s7uv61m"); }
test { try parseIDNAFail(".xn--tsh026uql4bew9p"); }
test { try parseIDNAFail("xn--1ug.xn--tsh026uql4bew9p"); }
test { try parseIDNAFail("\xe2\xab\x90\xef\xbd\xa1\xe1\x83\x80-\xf3\x83\x90\xa2"); }
test { try parseIDNAFail("\xe2\xab\x90\xe3\x80\x82\xe1\x83\x80-\xf3\x83\x90\xa2"); }
test { try parseIDNAFail("\xe2\xab\x90\xe3\x80\x82\xe2\xb4\xa0-\xf3\x83\x90\xa2"); }
test { try parseIDNAFail("xn--r3i.xn----2wst7439i"); }
test { try parseIDNAFail("\xe2\xab\x90\xef\xbd\xa1\xe2\xb4\xa0-\xf3\x83\x90\xa2"); }
test { try parseIDNAFail("xn--r3i.xn----z1g58579u"); }
test { try parseIDNAFail("\xf0\x91\x91\x82\xe2\x97\x8a\xef\xbc\x8e\xe2\xa6\x9f\xe2\x88\xa0"); }
test { try parseIDNAFail("\xf0\x91\x91\x82\xe2\x97\x8a.\xe2\xa6\x9f\xe2\x88\xa0"); }
test { try parseIDNAFail("xn--01h3338f.xn--79g270a"); }
test { try parseIDNAFail("\xed\x97\x81\xf3\x98\x96\x99\xe0\xb8\xba\xf3\x9a\x8d\x9a\xe3\x80\x82\xda\xba\xf0\x9d\x9f\x9c"); }
test { try parseIDNAFail("\xe1\x84\x92\xe1\x85\xa4\xe1\x86\xbc\xf3\x98\x96\x99\xe0\xb8\xba\xf3\x9a\x8d\x9a\xe3\x80\x82\xda\xba\xf0\x9d\x9f\x9c"); }
test { try parseIDNAFail("\xed\x97\x81\xf3\x98\x96\x99\xe0\xb8\xba\xf3\x9a\x8d\x9a\xe3\x80\x82\xda\xba4"); }
test { try parseIDNAFail("\xe1\x84\x92\xe1\x85\xa4\xe1\x86\xbc\xf3\x98\x96\x99\xe0\xb8\xba\xf3\x9a\x8d\x9a\xe3\x80\x82\xda\xba4"); }
test { try parseIDNAFail("xn--o4c1723h8g85gt4ya.xn--4-dvc"); }
test { try parseIDNAFail("\xea\xa5\x93.\xcc\xbd\xf0\x91\x82\xbd\xe9\xa6\x8b"); }
test { try parseIDNAFail("xn--3j9a.xn--bua0708eqzrd"); }
test { try parseIDNAFail("\xf3\x88\xab\x9d\xf2\xaa\x9b\xb8\xe2\x80\x8d\xef\xbd\xa1\xe4\x9c\x96"); }
test { try parseIDNAFail("\xf3\x88\xab\x9d\xf2\xaa\x9b\xb8\xe2\x80\x8d\xe3\x80\x82\xe4\x9c\x96"); }
test { try parseIDNAFail("xn--g138cxw05a.xn--k0o"); }
test { try parseIDNAFail("xn--1ug30527h9mxi.xn--k0o"); }
test { try parseIDNAFail("\xe1\xa1\xaf\xe2\x9a\x89\xe5\xa7\xb6\xf0\x9f\x84\x89\xef\xbc\x8e\xdb\xb7\xe2\x80\x8d\xf0\x9f\x8e\xaa\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe1\xa1\xaf\xe2\x9a\x89\xe5\xa7\xb68,.\xdb\xb7\xe2\x80\x8d\xf0\x9f\x8e\xaa\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--8,-g9oy26fzu4d.xn--kmb859ja94998b"); }
test { try parseIDNAFail("xn--c9e433epi4b3j20a.xn--kmb6733w"); }
test { try parseIDNAFail("xn--c9e433epi4b3j20a.xn--kmb859ja94998b"); }
test { try parseIDNAFail("\xe1\x8d\x9f\xe1\xa1\x88\xe2\x80\x8c\xef\xbc\x8e\xef\xb8\x92-\xf0\x96\xbe\x90-"); }
test { try parseIDNAFail("\xe1\x8d\x9f\xe1\xa1\x88\xe2\x80\x8c.\xe3\x80\x82-\xf0\x96\xbe\x90-"); }
test { try parseIDNAFail("xn--b7d82w..xn-----pe4u"); }
test { try parseIDNAFail("xn--b7d82wo4h..xn-----pe4u"); }
test { try parseIDNAFail("xn--b7d82w.xn-----c82nz547a"); }
test { try parseIDNAFail("xn--b7d82wo4h.xn-----c82nz547a"); }
test { try parseIDNAFail("\xf0\x9d\xa9\x9c\xe3\x80\x82-\xe0\xad\x8d\xe1\x82\xab"); }
test { try parseIDNAFail("\xf0\x9d\xa9\x9c\xe3\x80\x82-\xe0\xad\x8d\xe2\xb4\x8b"); }
test { try parseIDNAFail("xn--792h.xn----bse820x"); }
test { try parseIDNAFail("xn--792h.xn----bse632b"); }
test { try parseIDNAFail("\xf0\x9d\x9f\xb5\xe9\x9a\x81\xe2\xaf\xae\xef\xbc\x8e\xe1\xa0\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("9\xe9\x9a\x81\xe2\xaf\xae.\xe1\xa0\x8d\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--9-mfs8024b.xn--0ug"); }
test { try parseIDNAFail("\xe1\xae\xac\xe1\x82\xac\xe2\x80\x8c\xcc\xa5\xe3\x80\x82\xf0\x9d\x9f\xb8"); }
test { try parseIDNAFail("xn--mta176jjjm.c"); }
test { try parseIDNAFail("xn--mta176j97cl2q.c"); }
test { try parseIDNAFail("\xe1\xae\xac\xe2\xb4\x8c\xe2\x80\x8c\xcc\xa5\xe3\x80\x82\xf0\x9d\x9f\xb8"); }
test { try parseIDNAFail("xn--mta930emri.c"); }
test { try parseIDNAFail("xn--mta930emribme.c"); }
test { try parseIDNAFail("\xf3\xa0\x84\x81\xcd\x9f\xe2\xbe\xb6\xef\xbd\xa1\xe2\x82\x87\xef\xb8\x92\xeb\x88\x87\xe2\x89\xae"); }
test { try parseIDNAFail("\xf3\xa0\x84\x81\xcd\x9f\xe2\xbe\xb6\xef\xbd\xa1\xe2\x82\x87\xef\xb8\x92\xe1\x84\x82\xe1\x85\xae\xe1\x86\xaa<\xcc\xb8"); }
test { try parseIDNAFail("\xf3\xa0\x84\x81\xcd\x9f\xe9\xa3\x9b\xe3\x80\x827\xe3\x80\x82\xeb\x88\x87\xe2\x89\xae"); }
test { try parseIDNAFail("\xf3\xa0\x84\x81\xcd\x9f\xe9\xa3\x9b\xe3\x80\x827\xe3\x80\x82\xe1\x84\x82\xe1\x85\xae\xe1\x86\xaa<\xcc\xb8"); }
test { try parseIDNAFail("xn--9ua0567e.7.xn--gdh6767c"); }
test { try parseIDNAFail("xn--9ua0567e.xn--7-ngou006d1ttc"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe3\x80\x82\xef\xbe\xa0\xe0\xbe\x84\xe0\xbe\x96"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe3\x80\x82\xe1\x85\xa0\xe0\xbe\x84\xe0\xbe\x96"); }
test { try parseIDNAFail(".xn--3ed0b"); }
test { try parseIDNAFail("xn--0ug.xn--3ed0b"); }
test { try parseIDNAFail(".xn--3ed0b20h"); }
test { try parseIDNAFail("xn--0ug.xn--3ed0b20h"); }
test { try parseIDNAFail(".xn--3ed0by082k"); }
test { try parseIDNAFail("xn--0ug.xn--3ed0by082k"); }
test { try parseIDNAFail("\xe2\x89\xaf\xf2\x8d\x98\x85\xef\xbc\x8e\xe2\x80\x8d\xf0\x90\x85\xbc\xf2\xb2\x87\x9b"); }
test { try parseIDNAFail(">\xcc\xb8\xf2\x8d\x98\x85\xef\xbc\x8e\xe2\x80\x8d\xf0\x90\x85\xbc\xf2\xb2\x87\x9b"); }
test { try parseIDNAFail("\xe2\x89\xaf\xf2\x8d\x98\x85.\xe2\x80\x8d\xf0\x90\x85\xbc\xf2\xb2\x87\x9b"); }
test { try parseIDNAFail(">\xcc\xb8\xf2\x8d\x98\x85.\xe2\x80\x8d\xf0\x90\x85\xbc\xf2\xb2\x87\x9b"); }
test { try parseIDNAFail("xn--hdh84488f.xn--xy7cw2886b"); }
test { try parseIDNAFail("xn--hdh84488f.xn--1ug8099fbjp4e"); }
test { try parseIDNAFail("xn--d5a07sn4u297k.xn--2e1b"); }
test { try parseIDNAFail("\xea\xa3\xaa\xef\xbd\xa1\xf0\x96\x84\xbf\xf0\x91\x86\xbe\xf3\xa0\x87\x97"); }
test { try parseIDNAFail("\xea\xa3\xaa\xe3\x80\x82\xf0\x96\x84\xbf\xf0\x91\x86\xbe\xf3\xa0\x87\x97"); }
test { try parseIDNAFail("xn--3g9a.xn--ud1dz07k"); }
test { try parseIDNAFail("\xf3\x87\x93\x93\xf0\x91\x9a\xb3\xe3\x80\x82\xf1\x90\xb7\xbf\xe2\x89\xaf\xe2\xbe\x87"); }
test { try parseIDNAFail("\xf3\x87\x93\x93\xf0\x91\x9a\xb3\xe3\x80\x82\xf1\x90\xb7\xbf>\xcc\xb8\xe2\xbe\x87"); }
test { try parseIDNAFail("\xf3\x87\x93\x93\xf0\x91\x9a\xb3\xe3\x80\x82\xf1\x90\xb7\xbf\xe2\x89\xaf\xe8\x88\x9b"); }
test { try parseIDNAFail("\xf3\x87\x93\x93\xf0\x91\x9a\xb3\xe3\x80\x82\xf1\x90\xb7\xbf>\xcc\xb8\xe8\x88\x9b"); }
test { try parseIDNAFail("xn--3e2d79770c.xn--hdh0088abyy1c"); }
test { try parseIDNAFail("\xf1\xa1\x85\x88\xe7\xa0\xaa\xe2\x89\xaf\xe1\xa2\x91\xef\xbd\xa1\xe2\x89\xaf\xf0\x9d\xa9\x9a\xf2\x93\xb4\x94\xe2\x80\x8c"); }
test { try parseIDNAFail("\xf1\xa1\x85\x88\xe7\xa0\xaa>\xcc\xb8\xe1\xa2\x91\xef\xbd\xa1>\xcc\xb8\xf0\x9d\xa9\x9a\xf2\x93\xb4\x94\xe2\x80\x8c"); }
test { try parseIDNAFail("\xf1\xa1\x85\x88\xe7\xa0\xaa\xe2\x89\xaf\xe1\xa2\x91\xe3\x80\x82\xe2\x89\xaf\xf0\x9d\xa9\x9a\xf2\x93\xb4\x94\xe2\x80\x8c"); }
test { try parseIDNAFail("\xf1\xa1\x85\x88\xe7\xa0\xaa>\xcc\xb8\xe1\xa2\x91\xe3\x80\x82>\xcc\xb8\xf0\x9d\xa9\x9a\xf2\x93\xb4\x94\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--bbf561cf95e57y3e.xn--hdh0834o7mj6b"); }
test { try parseIDNAFail("xn--bbf561cf95e57y3e.xn--0ugz6gc910ejro8c"); }
test { try parseIDNAFail("\xe1\x83\x85.\xf0\x91\x84\xb3\xe3\x8a\xb8"); }
test { try parseIDNAFail("\xe1\x83\x85.\xf0\x91\x84\xb343"); }
test { try parseIDNAFail("\xe2\xb4\xa5.\xf0\x91\x84\xb343"); }
test { try parseIDNAFail("xn--tlj.xn--43-274o"); }
test { try parseIDNAFail("\xe2\xb4\xa5.\xf0\x91\x84\xb3\xe3\x8a\xb8"); }
test { try parseIDNAFail("xn--9nd.xn--43-274o"); }
test { try parseIDNAFail("\xf1\x97\xaa\xa8\xf3\xa0\x84\x89\xef\xbe\xa0\xe0\xbe\xb7.\xf1\xb8\x9e\xb0\xea\xa5\x93"); }
test { try parseIDNAFail("\xf1\x97\xaa\xa8\xf3\xa0\x84\x89\xe1\x85\xa0\xe0\xbe\xb7.\xf1\xb8\x9e\xb0\xea\xa5\x93"); }
test { try parseIDNAFail("xn--kgd72212e.xn--3j9au7544a"); }
test { try parseIDNAFail("xn--kgd36f9z57y.xn--3j9au7544a"); }
test { try parseIDNAFail("xn--kgd7493jee34a.xn--3j9au7544a"); }
test { try parseIDNAFail("\xd8\x98.\xdb\xb3\xe2\x80\x8c\xea\xa5\x93"); }
test { try parseIDNAFail("xn--6fb.xn--gmb0524f"); }
test { try parseIDNAFail("xn--6fb.xn--gmb469jjf1h"); }
test { try parseIDNAFail("\xe1\xa1\x8c\xef\xbc\x8e\xef\xb8\x92\xe1\xa2\x91"); }
test { try parseIDNAFail("xn--c8e.xn--bbf9168i"); }
test { try parseIDNAFail("\xf0\x9e\xb7\x8f\xe3\x80\x82\xe1\xa0\xa2\xf2\x93\x98\x86"); }
test { try parseIDNAFail("xn--hd7h.xn--46e66060j"); }
test { try parseIDNAFail("\xf2\x8c\x8b\x94\xf3\xa0\x86\x8e\xf3\xa0\x86\x97\xf0\x91\xb2\x95\xe3\x80\x82\xe2\x89\xae"); }
test { try parseIDNAFail("\xf2\x8c\x8b\x94\xf3\xa0\x86\x8e\xf3\xa0\x86\x97\xf0\x91\xb2\x95\xe3\x80\x82<\xcc\xb8"); }
test { try parseIDNAFail("xn--4m3dv4354a.xn--gdh"); }
test { try parseIDNAFail("\xf3\xa0\x86\xa6.\xe0\xa3\xa3\xe6\x9a\x80\xe2\x89\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x86\xa6.\xe0\xa3\xa3\xe6\x9a\x80=\xcc\xb8"); }
test { try parseIDNAFail(".xn--m0b461k3g2c"); }
test { try parseIDNAFail("\xe4\x82\xb9\xf3\xbe\x96\x85\xf0\x90\x8b\xa6\xef\xbc\x8e\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe4\x82\xb9\xf3\xbe\x96\x85\xf0\x90\x8b\xa6.\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--0on3543c5981i."); }
test { try parseIDNAFail("xn--0on3543c5981i.xn--1ug"); }
test { try parseIDNAFail("\xef\xb8\x92\xef\xbd\xa1\xe1\x82\xa3\xe2\x89\xaf"); }
test { try parseIDNAFail("\xef\xb8\x92\xef\xbd\xa1\xe1\x82\xa3>\xcc\xb8"); }
test { try parseIDNAFail("\xef\xb8\x92\xef\xbd\xa1\xe2\xb4\x83>\xcc\xb8"); }
test { try parseIDNAFail("\xef\xb8\x92\xef\xbd\xa1\xe2\xb4\x83\xe2\x89\xaf"); }
test { try parseIDNAFail("xn--y86c.xn--hdh782b"); }
test { try parseIDNAFail("..xn--bnd622g"); }
test { try parseIDNAFail("xn--y86c.xn--bnd622g"); }
test { try parseIDNAFail("\xe7\xae\x83\xe1\x83\x81-\xf3\xa0\x81\x9d\xef\xbd\xa1\xe2\x89\xa0-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("\xe7\xae\x83\xe1\x83\x81-\xf3\xa0\x81\x9d\xef\xbd\xa1=\xcc\xb8-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("\xe7\xae\x83\xe1\x83\x81-\xf3\xa0\x81\x9d\xe3\x80\x82\xe2\x89\xa0-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("\xe7\xae\x83\xe1\x83\x81-\xf3\xa0\x81\x9d\xe3\x80\x82=\xcc\xb8-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("\xe7\xae\x83\xe2\xb4\xa1-\xf3\xa0\x81\x9d\xe3\x80\x82=\xcc\xb8-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("\xe7\xae\x83\xe2\xb4\xa1-\xf3\xa0\x81\x9d\xe3\x80\x82\xe2\x89\xa0-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("xn----4wsr321ay823p.xn----tfot873s"); }
test { try parseIDNAFail("\xe7\xae\x83\xe2\xb4\xa1-\xf3\xa0\x81\x9d\xef\xbd\xa1=\xcc\xb8-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("\xe7\xae\x83\xe2\xb4\xa1-\xf3\xa0\x81\x9d\xef\xbd\xa1\xe2\x89\xa0-\xf0\x9f\xa4\x96"); }
test { try parseIDNAFail("xn----11g3013fy8x5m.xn----tfot873s"); }
test { try parseIDNAFail("\xe1\x80\xba\xe2\x80\x8d\xe2\x80\x8c\xe3\x80\x82-\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--bkd.-"); }
test { try parseIDNAFail("xn--bkd412fca.xn----sgn"); }
test { try parseIDNAFail("\xef\xb8\x92\xef\xbd\xa1\xe1\xad\x84\xe1\xa1\x89"); }
test { try parseIDNAFail("\xe3\x80\x82\xe3\x80\x82\xe1\xad\x84\xe1\xa1\x89"); }
test { try parseIDNAFail("..xn--87e93m"); }
test { try parseIDNAFail("xn--y86c.xn--87e93m"); }
test { try parseIDNAFail("-\xe1\xae\xab\xef\xb8\x92\xe2\x80\x8d.\xf1\x92\xb6\x88\xf1\xa5\xb9\x93"); }
test { try parseIDNAFail("-\xe1\xae\xab\xe3\x80\x82\xe2\x80\x8d.\xf1\x92\xb6\x88\xf1\xa5\xb9\x93"); }
test { try parseIDNAFail("xn----qml..xn--x50zy803a"); }
test { try parseIDNAFail("xn----qml.xn--1ug.xn--x50zy803a"); }
test { try parseIDNAFail("xn----qml1407i.xn--x50zy803a"); }
test { try parseIDNAFail("xn----qmlv7tw180a.xn--x50zy803a"); }
test { try parseIDNAFail("\xf3\xa0\xa6\xae.\xe2\x89\xaf\xf0\x9e\x80\x86"); }
test { try parseIDNAFail("\xf3\xa0\xa6\xae.>\xcc\xb8\xf0\x9e\x80\x86"); }
test { try parseIDNAFail("xn--t546e.xn--hdh5166o"); }
test { try parseIDNAFail("xn--skb.xn--osd737a"); }
test { try parseIDNAFail("\xe3\xa8\x9b\xf0\x98\xb1\x8e.\xef\xb8\x92\xf0\x9d\x9f\x95\xe0\xb4\x81"); }
test { try parseIDNAFail("xn--mbm8237g.xn--7-7hf1526p"); }
test { try parseIDNAFail("\xc3\x9f\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5\xef\xbc\x8e\xe2\x8a\xb6\xe1\x83\x81\xe1\x82\xb6"); }
test { try parseIDNAFail("\xc3\x9f\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe1\x83\x81\xe1\x82\xb6"); }
test { try parseIDNAFail("\xc3\x9f\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe2\xb4\xa1\xe2\xb4\x96"); }
test { try parseIDNAFail("SS\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe1\x83\x81\xe1\x82\xb6"); }
test { try parseIDNAFail("ss\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe2\xb4\xa1\xe2\xb4\x96"); }
test { try parseIDNAFail("Ss\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe1\x83\x81\xe2\xb4\x96"); }
test { try parseIDNAFail("xn--ss-4ep585bkm5p.xn--ifh802b6a"); }
test { try parseIDNAFail("xn--zca682johfi89m.xn--ifh802b6a"); }
test { try parseIDNAFail("\xc3\x9f\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5\xef\xbc\x8e\xe2\x8a\xb6\xe2\xb4\xa1\xe2\xb4\x96"); }
test { try parseIDNAFail("SS\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5\xef\xbc\x8e\xe2\x8a\xb6\xe1\x83\x81\xe1\x82\xb6"); }
test { try parseIDNAFail("ss\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5\xef\xbc\x8e\xe2\x8a\xb6\xe2\xb4\xa1\xe2\xb4\x96"); }
test { try parseIDNAFail("Ss\xe2\x80\x8c\xea\xab\xb6\xe1\xa2\xa5\xef\xbc\x8e\xe2\x8a\xb6\xe1\x83\x81\xe2\xb4\x96"); }
test { try parseIDNAFail("xn--ss-4epx629f.xn--5nd703gyrh"); }
test { try parseIDNAFail("xn--ss-4ep585bkm5p.xn--5nd703gyrh"); }
test { try parseIDNAFail("xn--ss-4epx629f.xn--undv409k"); }
test { try parseIDNAFail("xn--ss-4ep585bkm5p.xn--undv409k"); }
test { try parseIDNAFail("xn--zca682johfi89m.xn--undv409k"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\x80\x82\xcf\x82\xf3\xa0\x81\x89"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\x80\x82\xce\xa3\xf3\xa0\x81\x89"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\x80\x82\xcf\x83\xf3\xa0\x81\x89"); }
test { try parseIDNAFail(".xn--4xa24344p"); }
test { try parseIDNAFail("xn--1ug.xn--4xa24344p"); }
test { try parseIDNAFail("xn--1ug.xn--3xa44344p"); }
test { try parseIDNAFail("\xe2\x92\x92\xf2\xa8\x98\x99\xf2\xb3\xb3\xa0\xf0\x91\x93\x80.-\xf3\x9e\xa1\x8a"); }
test { try parseIDNAFail("11.\xf2\xa8\x98\x99\xf2\xb3\xb3\xa0\xf0\x91\x93\x80.-\xf3\x9e\xa1\x8a"); }
test { try parseIDNAFail("11.xn--uz1d59632bxujd.xn----x310m"); }
test { try parseIDNAFail("xn--3shy698frsu9dt1me.xn----x310m"); }
test { try parseIDNAFail("-\xef\xbd\xa1\xe2\x80\x8d"); }
test { try parseIDNAFail("-\xe3\x80\x82\xe2\x80\x8d"); }
test { try parseIDNAFail("-.xn--1ug"); }
test { try parseIDNAFail("\xe1\x89\xac\xf2\x94\xa0\xbc\xf1\x81\x97\xb6\xef\xbd\xa1\xf0\x90\xa8\xac\xf0\x9d\x9f\xa0"); }
test { try parseIDNAFail("\xe1\x89\xac\xf2\x94\xa0\xbc\xf1\x81\x97\xb6\xe3\x80\x82\xf0\x90\xa8\xac8"); }
test { try parseIDNAFail("xn--d0d41273c887z.xn--8-ob5i"); }
test { try parseIDNAFail("\xcf\x82\xe2\x80\x8d-.\xe1\x83\x83\xf0\xa6\x9f\x99"); }
test { try parseIDNAFail("\xcf\x82\xe2\x80\x8d-.\xe2\xb4\xa3\xf0\xa6\x9f\x99"); }
test { try parseIDNAFail("\xce\xa3\xe2\x80\x8d-.\xe1\x83\x83\xf0\xa6\x9f\x99"); }
test { try parseIDNAFail("\xcf\x83\xe2\x80\x8d-.\xe2\xb4\xa3\xf0\xa6\x9f\x99"); }
test { try parseIDNAFail("xn----zmb048s.xn--rlj2573p"); }
test { try parseIDNAFail("xn----xmb348s.xn--rlj2573p"); }
test { try parseIDNAFail("xn----zmb.xn--7nd64871a"); }
test { try parseIDNAFail("xn----zmb048s.xn--7nd64871a"); }
test { try parseIDNAFail("xn----xmb348s.xn--7nd64871a"); }
test { try parseIDNAFail("\xf3\x85\xac\xbd.\xe8\xa0\x94"); }
test { try parseIDNAFail("xn--g747d.xn--xl2a"); }
test { try parseIDNAFail("\xe0\xa3\xa6\xe2\x80\x8d\xef\xbc\x8e\xeb\xbc\xbd"); }
test { try parseIDNAFail("\xe0\xa3\xa6\xe2\x80\x8d\xef\xbc\x8e\xe1\x84\x88\xe1\x85\xa8\xe1\x87\x80"); }
test { try parseIDNAFail("\xe0\xa3\xa6\xe2\x80\x8d.\xeb\xbc\xbd"); }
test { try parseIDNAFail("\xe0\xa3\xa6\xe2\x80\x8d.\xe1\x84\x88\xe1\x85\xa8\xe1\x87\x80"); }
test { try parseIDNAFail("xn--p0b.xn--e43b"); }
test { try parseIDNAFail("xn--p0b869i.xn--e43b"); }
test { try parseIDNAFail("\xf1\x8d\xa8\xbd\xef\xbc\x8e\xf1\x8b\xb8\x95"); }
test { try parseIDNAFail("\xf1\x8d\xa8\xbd.\xf1\x8b\xb8\x95"); }
test { try parseIDNAFail("xn--pr3x.xn--rv7w"); }
test { try parseIDNAFail("\xf0\x90\xaf\x80\xf0\x90\xb8\x89\xf0\x9e\xa7\x8f\xe3\x80\x82\xf1\xa2\x9a\xa7\xe2\x82\x84\xe1\x82\xab\xf1\x82\xb9\xab"); }
test { try parseIDNAFail("\xf0\x90\xaf\x80\xf0\x90\xb8\x89\xf0\x9e\xa7\x8f\xe3\x80\x82\xf1\xa2\x9a\xa74\xe1\x82\xab\xf1\x82\xb9\xab"); }
test { try parseIDNAFail("\xf0\x90\xaf\x80\xf0\x90\xb8\x89\xf0\x9e\xa7\x8f\xe3\x80\x82\xf1\xa2\x9a\xa74\xe2\xb4\x8b\xf1\x82\xb9\xab"); }
test { try parseIDNAFail("xn--039c42bq865a.xn--4-wvs27840bnrzm"); }
test { try parseIDNAFail("\xf0\x90\xaf\x80\xf0\x90\xb8\x89\xf0\x9e\xa7\x8f\xe3\x80\x82\xf1\xa2\x9a\xa7\xe2\x82\x84\xe2\xb4\x8b\xf1\x82\xb9\xab"); }
test { try parseIDNAFail("xn--039c42bq865a.xn--4-t0g49302fnrzm"); }
test { try parseIDNAFail("\xf0\x9d\x9f\x93\xe3\x80\x82\xdb\x97"); }
test { try parseIDNAFail("5\xe3\x80\x82\xdb\x97"); }
test { try parseIDNAFail("5.xn--nlb"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf2\xba\xb8\xa9.\xe2\xbe\x95"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf2\xba\xb8\xa9.\xe8\xb0\xb7"); }
test { try parseIDNAFail("xn--i183d.xn--6g3a"); }
test { try parseIDNAFail("xn--0ug26167i.xn--6g3a"); }
test { try parseIDNAFail("\xef\xb8\x92\xf3\x8e\xb0\x87\xe2\x80\x8d.-\xdc\xbc\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe3\x80\x82\xf3\x8e\xb0\x87\xe2\x80\x8d.-\xdc\xbc\xe2\x80\x8c"); }
test { try parseIDNAFail(".xn--hh50e.xn----t2c"); }
test { try parseIDNAFail(".xn--1ug05310k.xn----t2c071q"); }
test { try parseIDNAFail("xn--y86c71305c.xn----t2c"); }
test { try parseIDNAFail("xn--1ug1658ftw26f.xn----t2c071q"); }
test { try parseIDNAFail("\xe2\x80\x8d\xef\xbc\x8e\xf0\x9d\x9f\x97"); }
test { try parseIDNAFail("\xe2\x80\x8d.j"); }
test { try parseIDNAFail("\xe2\x80\x8d.J"); }
test { try parseIDNAFail("xn--1ug.j"); }
test { try parseIDNAFail("\xe1\x82\xad\xf0\xbf\xa3\x8d\xea\xa1\xa8\xd6\xae\xe3\x80\x82\xe1\x82\xbe\xe2\x80\x8c\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\xb4\x8d\xf0\xbf\xa3\x8d\xea\xa1\xa8\xd6\xae\xe3\x80\x82\xe2\xb4\x9e\xe2\x80\x8c\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--5cb172r175fug38a.xn--mlj"); }
test { try parseIDNAFail("xn--5cb172r175fug38a.xn--0uga051h"); }
test { try parseIDNAFail("xn--5cb347co96jug15a.xn--2nd"); }
test { try parseIDNAFail("xn--5cb347co96jug15a.xn--2nd059ea"); }
test { try parseIDNAFail("\xf0\x90\x8b\xb0\xe3\x80\x82\xf3\x91\x93\xb1"); }
test { try parseIDNAFail("xn--k97c.xn--q031e"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe1\x82\xab\xf0\xb6\xbf\xb8\xea\xb7\xa4\xef\xbc\x8e\xf2\xa0\x85\xbc\xf0\x9d\x9f\xa2\xed\x9c\xaa\xe0\xab\xa3"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe1\x82\xab\xf0\xb6\xbf\xb8\xe1\x84\x80\xe1\x85\xb2\xe1\x86\xaf\xef\xbc\x8e\xf2\xa0\x85\xbc\xf0\x9d\x9f\xa2\xe1\x84\x92\xe1\x85\xb1\xe1\x86\xb9\xe0\xab\xa3"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe1\x82\xab\xf0\xb6\xbf\xb8\xea\xb7\xa4.\xf2\xa0\x85\xbc0\xed\x9c\xaa\xe0\xab\xa3"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe1\x82\xab\xf0\xb6\xbf\xb8\xe1\x84\x80\xe1\x85\xb2\xe1\x86\xaf.\xf2\xa0\x85\xbc0\xe1\x84\x92\xe1\x85\xb1\xe1\x86\xb9\xe0\xab\xa3"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe2\xb4\x8b\xf0\xb6\xbf\xb8\xe1\x84\x80\xe1\x85\xb2\xe1\x86\xaf.\xf2\xa0\x85\xbc0\xe1\x84\x92\xe1\x85\xb1\xe1\x86\xb9\xe0\xab\xa3"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe2\xb4\x8b\xf0\xb6\xbf\xb8\xea\xb7\xa4.\xf2\xa0\x85\xbc0\xed\x9c\xaa\xe0\xab\xa3"); }
test { try parseIDNAFail("xn--i0b436pkl2g2h42a.xn--0-8le8997mulr5f"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe2\xb4\x8b\xf0\xb6\xbf\xb8\xe1\x84\x80\xe1\x85\xb2\xe1\x86\xaf\xef\xbc\x8e\xf2\xa0\x85\xbc\xf0\x9d\x9f\xa2\xe1\x84\x92\xe1\x85\xb1\xe1\x86\xb9\xe0\xab\xa3"); }
test { try parseIDNAFail("\xe0\xa3\x9f\xe2\xb4\x8b\xf0\xb6\xbf\xb8\xea\xb7\xa4\xef\xbc\x8e\xf2\xa0\x85\xbc\xf0\x9d\x9f\xa2\xed\x9c\xaa\xe0\xab\xa3"); }
test { try parseIDNAFail("xn--i0b601b6r7l2hs0a.xn--0-8le8997mulr5f"); }
test { try parseIDNAFail("\xde\x84\xef\xbc\x8e\xf0\x9e\xa1\x9d\xd8\x81"); }
test { try parseIDNAFail("\xde\x84.\xf0\x9e\xa1\x9d\xd8\x81"); }
test { try parseIDNAFail("xn--lqb.xn--jfb1808v"); }
test { try parseIDNAFail("\xe0\xab\x8d\xe2\x82\x83.8\xea\xa3\x84\xe2\x80\x8d\xf0\x9f\x83\xa4"); }
test { try parseIDNAFail("\xe0\xab\x8d3.8\xea\xa3\x84\xe2\x80\x8d\xf0\x9f\x83\xa4"); }
test { try parseIDNAFail("xn--3-yke.xn--8-sl4et308f"); }
test { try parseIDNAFail("xn--3-yke.xn--8-ugnv982dbkwm"); }
test { try parseIDNAFail("\xea\xa1\x95\xe2\x89\xa0\xe1\x81\x9e\xf3\xae\xbf\xb1\xef\xbd\xa1\xf0\x90\xb5\xa7\xf3\xa0\x84\xab\xef\xbe\xa0"); }
test { try parseIDNAFail("\xea\xa1\x95=\xcc\xb8\xe1\x81\x9e\xf3\xae\xbf\xb1\xef\xbd\xa1\xf0\x90\xb5\xa7\xf3\xa0\x84\xab\xef\xbe\xa0"); }
test { try parseIDNAFail("\xea\xa1\x95\xe2\x89\xa0\xe1\x81\x9e\xf3\xae\xbf\xb1\xe3\x80\x82\xf0\x90\xb5\xa7\xf3\xa0\x84\xab\xe1\x85\xa0"); }
test { try parseIDNAFail("\xea\xa1\x95=\xcc\xb8\xe1\x81\x9e\xf3\xae\xbf\xb1\xe3\x80\x82\xf0\x90\xb5\xa7\xf3\xa0\x84\xab\xe1\x85\xa0"); }
test { try parseIDNAFail("xn--cld333gn31h0158l.xn--3g0d"); }
test { try parseIDNAFail("\xe9\xb1\x8a\xe3\x80\x82\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--rt6a.xn--0ug"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf1\x92\x83\xa0\xef\xbc\x8e\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf1\x92\x83\xa0.\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--dj8y."); }
test { try parseIDNAFail("xn--0ugz7551c.xn--1ug"); }
test { try parseIDNAFail("\xf0\x91\x87\x80.\xf3\xa0\xa8\xb1"); }
test { try parseIDNAFail("xn--wd1d.xn--k946e"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xba\xef\xbd\xa1\xcf\x82"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xba\xe3\x80\x82\xcf\x82"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x9a\xe3\x80\x82\xcf\x82"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xba\xe3\x80\x82\xce\xa3"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x9a\xe3\x80\x82\xcf\x83"); }
test { try parseIDNAFail("xn--0ug262c.xn--4xa"); }
test { try parseIDNAFail("xn--0ug262c.xn--3xa"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x9a\xef\xbd\xa1\xcf\x82"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xba\xef\xbd\xa1\xce\xa3"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x9a\xef\xbd\xa1\xcf\x83"); }
test { try parseIDNAFail("xn--ynd.xn--4xa"); }
test { try parseIDNAFail("xn--ynd.xn--3xa"); }
test { try parseIDNAFail("xn--ynd759e.xn--4xa"); }
test { try parseIDNAFail("xn--ynd759e.xn--3xa"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\xbe\x95\xe3\x80\x82\xe2\x80\x8c\xcc\x90\xea\xa5\x93\xea\xa1\x8e"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\xbe\x95\xe3\x80\x82\xe2\x80\x8c\xea\xa5\x93\xcc\x90\xea\xa1\x8e"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe8\xb0\xb7\xe3\x80\x82\xe2\x80\x8c\xea\xa5\x93\xcc\x90\xea\xa1\x8e"); }
test { try parseIDNAFail("xn--6g3a.xn--0sa8175flwa"); }
test { try parseIDNAFail("xn--1ug0273b.xn--0sa359l6n7g13a"); }
test { try parseIDNAFail("\xf2\xac\xa8\xa9\xe1\x82\xb3\xe2\x9d\x93\xef\xbd\xa1\xf0\x91\x84\xa8"); }
test { try parseIDNAFail("\xf2\xac\xa8\xa9\xe1\x82\xb3\xe2\x9d\x93\xe3\x80\x82\xf0\x91\x84\xa8"); }
test { try parseIDNAFail("\xf2\xac\xa8\xa9\xe2\xb4\x93\xe2\x9d\x93\xe3\x80\x82\xf0\x91\x84\xa8"); }
test { try parseIDNAFail("xn--8di78qvw32y.xn--k80d"); }
test { try parseIDNAFail("\xf2\xac\xa8\xa9\xe2\xb4\x93\xe2\x9d\x93\xef\xbd\xa1\xf0\x91\x84\xa8"); }
test { try parseIDNAFail("xn--rnd896i0j14q.xn--k80d"); }
test { try parseIDNAFail("\xe1\x9f\xbf\xef\xbd\xa1\xf0\x9e\xac\xb3"); }
test { try parseIDNAFail("\xe1\x9f\xbf\xe3\x80\x82\xf0\x9e\xac\xb3"); }
test { try parseIDNAFail("xn--45e.xn--et6h"); }
test { try parseIDNAFail("\xd9\x92\xe2\x80\x8d\xef\xbd\xa1\xe0\xb3\x8d\xf0\x91\x9a\xb3"); }
test { try parseIDNAFail("\xd9\x92\xe2\x80\x8d\xe3\x80\x82\xe0\xb3\x8d\xf0\x91\x9a\xb3"); }
test { try parseIDNAFail("xn--uhb.xn--8tc4527k"); }
test { try parseIDNAFail("xn--uhb882k.xn--8tc4527k"); }
test { try parseIDNAFail("\xc3\x9f\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xef\xbd\xa1\xf0\x9d\xa9\xa8\xf0\x9f\x95\xae\xc3\x9f"); }
test { try parseIDNAFail("\xc3\x9f\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xe3\x80\x82\xf0\x9d\xa9\xa8\xf0\x9f\x95\xae\xc3\x9f"); }
test { try parseIDNAFail("SS\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xe3\x80\x82\xf0\x9d\xa9\xa8\xf0\x9f\x95\xaeSS"); }
test { try parseIDNAFail("ss\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xe3\x80\x82\xf0\x9d\xa9\xa8\xf0\x9f\x95\xaess"); }
test { try parseIDNAFail("Ss\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xe3\x80\x82\xf0\x9d\xa9\xa8\xf0\x9f\x95\xaeSs"); }
test { try parseIDNAFail("xn--ss-jl59biy67d.xn--ss-4d11aw87d"); }
test { try parseIDNAFail("xn--zca20040bgrkh.xn--zca3653v86qa"); }
test { try parseIDNAFail("SS\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xef\xbd\xa1\xf0\x9d\xa9\xa8\xf0\x9f\x95\xaeSS"); }
test { try parseIDNAFail("ss\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xef\xbd\xa1\xf0\x9d\xa9\xa8\xf0\x9f\x95\xaess"); }
test { try parseIDNAFail("Ss\xf0\xb0\x80\xbb\xf1\x86\xac\x97\xef\xbd\xa1\xf0\x9d\xa9\xa8\xf0\x9f\x95\xaeSs"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\x80\x82\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--1ug.xn--0ug"); }
test { try parseIDNAFail("\xf3\xa0\x91\x98\xef\xbc\x8e\xf3\xa0\x84\xae"); }
test { try parseIDNAFail("\xf3\xa0\x91\x98.\xf3\xa0\x84\xae"); }
test { try parseIDNAFail("xn--s136e."); }
test { try parseIDNAFail("\xea\xa6\xb7\xf3\x9d\xb5\x99\xeb\xa9\xb9\xe3\x80\x82\xe2\x92\x9b\xf3\xa0\xa8\x87"); }
test { try parseIDNAFail("\xea\xa6\xb7\xf3\x9d\xb5\x99\xe1\x84\x86\xe1\x85\xa7\xe1\x86\xb0\xe3\x80\x82\xe2\x92\x9b\xf3\xa0\xa8\x87"); }
test { try parseIDNAFail("\xea\xa6\xb7\xf3\x9d\xb5\x99\xeb\xa9\xb9\xe3\x80\x8220.\xf3\xa0\xa8\x87"); }
test { try parseIDNAFail("\xea\xa6\xb7\xf3\x9d\xb5\x99\xe1\x84\x86\xe1\x85\xa7\xe1\x86\xb0\xe3\x80\x8220.\xf3\xa0\xa8\x87"); }
test { try parseIDNAFail("xn--ym9av13acp85w.20.xn--d846e"); }
test { try parseIDNAFail("xn--ym9av13acp85w.xn--dth22121k"); }
test { try parseIDNAFail("\xe2\x80\x8c\xef\xbd\xa1\xef\xb8\x92"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe3\x80\x82\xe3\x80\x82"); }
test { try parseIDNAFail("xn--0ug.."); }
test { try parseIDNAFail(".xn--y86c"); }
test { try parseIDNAFail("xn--0ug.xn--y86c"); }
test { try parseIDNAFail("\xe1\xa1\xb2-\xf0\x9d\x9f\xb9.\xc3\x9f-\xe2\x80\x8c-"); }
test { try parseIDNAFail("\xe1\xa1\xb2-3.\xc3\x9f-\xe2\x80\x8c-"); }
test { try parseIDNAFail("\xe1\xa1\xb2-3.SS-\xe2\x80\x8c-"); }
test { try parseIDNAFail("\xe1\xa1\xb2-3.ss-\xe2\x80\x8c-"); }
test { try parseIDNAFail("\xe1\xa1\xb2-3.Ss-\xe2\x80\x8c-"); }
test { try parseIDNAFail("xn---3-p9o.xn--ss---276a"); }
test { try parseIDNAFail("xn---3-p9o.xn-----fia9303a"); }
test { try parseIDNAFail("\xe1\xa1\xb2-\xf0\x9d\x9f\xb9.SS-\xe2\x80\x8c-"); }
test { try parseIDNAFail("\xe1\xa1\xb2-\xf0\x9d\x9f\xb9.ss-\xe2\x80\x8c-"); }
test { try parseIDNAFail("\xe1\xa1\xb2-\xf0\x9d\x9f\xb9.Ss-\xe2\x80\x8c-"); }
test { try parseIDNAFail("\xf3\x99\xb6\x9c\xe1\xa2\x98\xe3\x80\x82\xe1\xa9\xbf\xe2\xba\xa2"); }
test { try parseIDNAFail("xn--ibf35138o.xn--fpfz94g"); }
test { try parseIDNAFail("\xf2\x97\x86\xa7\xf0\x9d\x9f\xaf\xe3\x80\x82\xe2\x92\x88\xe1\xa9\xb6\xf0\x9d\x9f\x9a\xf2\xa0\x98\x8c"); }
test { try parseIDNAFail("\xf2\x97\x86\xa73\xe3\x80\x821.\xe1\xa9\xb62\xf2\xa0\x98\x8c"); }
test { try parseIDNAFail("xn--3-rj42h.1.xn--2-13k96240l"); }
test { try parseIDNAFail("xn--3-rj42h.xn--2-13k746cq465x"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x82\x85\xe2\x92\x88\xe3\x80\x82\xe2\x89\xaf\xf0\x9d\x9f\xb4\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x82\x85\xe2\x92\x88\xe3\x80\x82>\xcc\xb8\xf0\x9d\x9f\xb4\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d51.\xe3\x80\x82\xe2\x89\xaf8\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d51.\xe3\x80\x82>\xcc\xb88\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--51-l1t..xn--8-ugn00i"); }
test { try parseIDNAFail("xn--5-ecp.xn--8-ogo"); }
test { try parseIDNAFail("xn--5-tgnz5r.xn--8-ugn00i"); }
test { try parseIDNAFail("\xf0\xbe\xb7\x82\xe0\xa9\x82\xe1\x82\xaa\xf1\x82\x82\x9f.\xe2\x89\xae"); }
test { try parseIDNAFail("\xf0\xbe\xb7\x82\xe0\xa9\x82\xe1\x82\xaa\xf1\x82\x82\x9f.<\xcc\xb8"); }
test { try parseIDNAFail("\xf0\xbe\xb7\x82\xe0\xa9\x82\xe2\xb4\x8a\xf1\x82\x82\x9f.<\xcc\xb8"); }
test { try parseIDNAFail("\xf0\xbe\xb7\x82\xe0\xa9\x82\xe2\xb4\x8a\xf1\x82\x82\x9f.\xe2\x89\xae"); }
test { try parseIDNAFail("xn--nbc229o4y27dgskb.xn--gdh"); }
test { try parseIDNAFail("xn--nbc493aro75ggskb.xn--gdh"); }
test { try parseIDNAFail("\xea\x99\xbd\xe2\x80\x8c\xf0\xaf\xa7\xb5\xf0\x9f\x84\x86\xef\xbd\xa1\xe2\x80\x8c\xf0\x91\x81\x82\xe1\xac\x81"); }
test { try parseIDNAFail("\xea\x99\xbd\xe2\x80\x8c\xe9\x9c\xa3\xf0\x9f\x84\x86\xef\xbd\xa1\xe2\x80\x8c\xf0\x91\x81\x82\xe1\xac\x81"); }
test { try parseIDNAFail("\xea\x99\xbd\xe2\x80\x8c\xe9\x9c\xa35,\xe3\x80\x82\xe2\x80\x8c\xf0\x91\x81\x82\xe1\xac\x81"); }
test { try parseIDNAFail("xn--5,-op8g373c.xn--4sf0725i"); }
test { try parseIDNAFail("xn--5,-i1tz135dnbqa.xn--4sf36u6u4w"); }
test { try parseIDNAFail("xn--2q5a751a653w.xn--4sf0725i"); }
test { try parseIDNAFail("xn--0ug4208b2vjuk63a.xn--4sf36u6u4w"); }
test { try parseIDNAFail("\xe5\x85\x8e\xef\xbd\xa1\xe1\xa0\xbc\xf3\xa0\xb4\x9c\xf0\x91\x9a\xb6\xf0\x91\xb0\xbf"); }
test { try parseIDNAFail("\xe5\x85\x8e\xe3\x80\x82\xe1\xa0\xbc\xf3\xa0\xb4\x9c\xf0\x91\x9a\xb6\xf0\x91\xb0\xbf"); }
test { try parseIDNAFail("xn--b5q.xn--v7e6041kqqd4m251b"); }
test { try parseIDNAFail("\xf0\x9d\x9f\x99\xef\xbd\xa1\xe2\x80\x8d\xf0\x9d\x9f\xb8\xe2\x80\x8d\xe2\x81\xb7"); }
test { try parseIDNAFail("1\xe3\x80\x82\xe2\x80\x8d2\xe2\x80\x8d7"); }
test { try parseIDNAFail("1.xn--27-l1tb"); }
test { try parseIDNAFail("\xe1\xa1\xa8-\xef\xbd\xa1\xf3\xa0\xbb\x8b\xf0\x9d\x9f\xb7"); }
test { try parseIDNAFail("\xe1\xa1\xa8-\xe3\x80\x82\xf3\xa0\xbb\x8b1"); }
test { try parseIDNAFail("xn----z8j.xn--1-5671m"); }
test { try parseIDNAFail("\xe1\x82\xbc\xf2\x88\xb7\xad\xe0\xbe\x80\xe2\xbe\x87\xe3\x80\x82\xe1\x82\xaf\xe2\x99\x80\xe2\x80\x8c\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe1\x82\xbc\xf2\x88\xb7\xad\xe0\xbe\x80\xe8\x88\x9b\xe3\x80\x82\xe1\x82\xaf\xe2\x99\x80\xe2\x80\x8c\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\xb4\x9c\xf2\x88\xb7\xad\xe0\xbe\x80\xe8\x88\x9b\xe3\x80\x82\xe2\xb4\x8f\xe2\x99\x80\xe2\x80\x8c\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--zed372mdj2do3v4h.xn--e5h11w"); }
test { try parseIDNAFail("xn--zed372mdj2do3v4h.xn--0uga678bgyh"); }
test { try parseIDNAFail("\xe2\xb4\x9c\xf2\x88\xb7\xad\xe0\xbe\x80\xe2\xbe\x87\xe3\x80\x82\xe2\xb4\x8f\xe2\x99\x80\xe2\x80\x8c\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--zed54dz10wo343g.xn--nnd651i"); }
test { try parseIDNAFail("xn--zed54dz10wo343g.xn--nnd089ea464d"); }
test { try parseIDNAFail("\xf0\x91\x81\x86\xf0\x9d\x9f\xb0.\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\x91\x81\x864.\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--4-xu7i."); }
test { try parseIDNAFail("xn--4-xu7i.xn--1ug"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe1\x82\xbe\xe7\x99\x80\xef\xbd\xa1\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xeb\xb6\xbc"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe1\x82\xbe\xe7\x99\x80\xef\xbd\xa1\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xe1\x84\x87\xe1\x85\xb0\xe1\x86\xab"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe1\x82\xbe\xe7\x99\x80\xe3\x80\x82\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xeb\xb6\xbc"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe1\x82\xbe\xe7\x99\x80\xe3\x80\x82\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xe1\x84\x87\xe1\x85\xb0\xe1\x86\xab"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe2\xb4\x9e\xe7\x99\x80\xe3\x80\x82\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xe1\x84\x87\xe1\x85\xb0\xe1\x86\xab"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe2\xb4\x9e\xe7\x99\x80\xe3\x80\x82\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xeb\xb6\xbc"); }
test { try parseIDNAFail("xn--mlju35u7qx2f.xn--et3bn23n"); }
test { try parseIDNAFail("xn--mlju35u7qx2f.xn--0ugb6122js83c"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe2\xb4\x9e\xe7\x99\x80\xef\xbd\xa1\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xe1\x84\x87\xe1\x85\xb0\xe1\x86\xab"); }
test { try parseIDNAFail("\xf1\xae\xb4\x98\xe2\xb4\x9e\xe7\x99\x80\xef\xbd\xa1\xf0\x91\x98\xbf\xe2\x80\x8d\xe2\x80\x8c\xeb\xb6\xbc"); }
test { try parseIDNAFail("xn--2nd6803c7q37d.xn--et3bn23n"); }
test { try parseIDNAFail("xn--2nd6803c7q37d.xn--0ugb6122js83c"); }
test { try parseIDNAFail("\xe1\xa1\x83\xf0\x9d\x9f\xa7\xe2\x89\xaf\xe1\xa0\xa3\xef\xbc\x8e\xe6\xb0\x81\xf1\xa8\x8f\xb1\xea\x81\xab"); }
test { try parseIDNAFail("\xe1\xa1\x83\xf0\x9d\x9f\xa7>\xcc\xb8\xe1\xa0\xa3\xef\xbc\x8e\xe6\xb0\x81\xf1\xa8\x8f\xb1\xea\x81\xab"); }
test { try parseIDNAFail("\xe1\xa1\x835\xe2\x89\xaf\xe1\xa0\xa3.\xe6\xb0\x81\xf1\xa8\x8f\xb1\xea\x81\xab"); }
test { try parseIDNAFail("\xe1\xa1\x835>\xcc\xb8\xe1\xa0\xa3.\xe6\xb0\x81\xf1\xa8\x8f\xb1\xea\x81\xab"); }
test { try parseIDNAFail("xn--5-24jyf768b.xn--lqw213ime95g"); }
test { try parseIDNAFail("-\xf0\x91\x88\xb6\xe2\x92\x8f\xef\xbc\x8e\xe2\x92\x8e\xf0\xb0\x9b\xa2\xf3\xa0\x8e\xad"); }
test { try parseIDNAFail("-\xf0\x91\x88\xb68..7.\xf0\xb0\x9b\xa2\xf3\xa0\x8e\xad"); }
test { try parseIDNAFail("xn---8-bv5o..7.xn--c35nf1622b"); }
test { try parseIDNAFail("xn----scp6252h.xn--zshy411yzpx2d"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xa1\xe7\x95\x9d\xe2\x80\x8d\xef\xbc\x8e\xe2\x89\xae"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xa1\xe7\x95\x9d\xe2\x80\x8d\xef\xbc\x8e<\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xa1\xe7\x95\x9d\xe2\x80\x8d.\xe2\x89\xae"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe1\x82\xa1\xe7\x95\x9d\xe2\x80\x8d.<\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x81\xe7\x95\x9d\xe2\x80\x8d.<\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x81\xe7\x95\x9d\xe2\x80\x8d.\xe2\x89\xae"); }
test { try parseIDNAFail("xn--0ugc160hb36e.xn--gdh"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x81\xe7\x95\x9d\xe2\x80\x8d\xef\xbc\x8e<\xcc\xb8"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\xb4\x81\xe7\x95\x9d\xe2\x80\x8d\xef\xbc\x8e\xe2\x89\xae"); }
test { try parseIDNAFail("xn--8md0962c.xn--gdh"); }
test { try parseIDNAFail("xn--8md700fea3748f.xn--gdh"); }
test { try parseIDNAFail("\xe0\xbb\x8b\xe2\x80\x8d\xef\xbc\x8e\xe9\x8e\x81\xf3\xa0\xb0\x91"); }
test { try parseIDNAFail("\xe0\xbb\x8b\xe2\x80\x8d.\xe9\x8e\x81\xf3\xa0\xb0\x91"); }
test { try parseIDNAFail("xn--t8c.xn--iz4a43209d"); }
test { try parseIDNAFail("xn--t8c059f.xn--iz4a43209d"); }
test { try parseIDNAFail("\xf2\x89\x9b\xb4.-\xe1\xa1\xa2\xd6\x92\xf0\x9d\xa8\xa0"); }
test { try parseIDNAFail("xn--ep37b.xn----hec165lho83b"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab\xef\xbc\x8e\xe1\xae\xaa\xcf\x82\xe1\x82\xa6\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab.\xe1\xae\xaa\xcf\x82\xe1\x82\xa6\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab.\xe1\xae\xaa\xcf\x82\xe2\xb4\x86\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab.\xe1\xae\xaa\xce\xa3\xe1\x82\xa6\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab.\xe1\xae\xaa\xcf\x83\xe2\xb4\x86\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab.\xe1\xae\xaa\xce\xa3\xe2\xb4\x86\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa153j7im"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa153jk8cs1q"); }
test { try parseIDNAFail("xn--nu4s.xn--3xa353jk8cs1q"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab\xef\xbc\x8e\xe1\xae\xaa\xcf\x82\xe2\xb4\x86\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab\xef\xbc\x8e\xe1\xae\xaa\xce\xa3\xe1\x82\xa6\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab\xef\xbc\x8e\xe1\xae\xaa\xcf\x83\xe2\xb4\x86\xe2\x80\x8d"); }
test { try parseIDNAFail("\xf0\xbf\x80\xab\xef\xbc\x8e\xe1\xae\xaa\xce\xa3\xe2\xb4\x86\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa217dxri"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa217dxriome"); }
test { try parseIDNAFail("xn--nu4s.xn--3xa417dxriome"); }
test { try parseIDNAFail("\xe2\x92\x88\xe2\x80\x8c\xea\xab\xac\xef\xb8\x92\xef\xbc\x8e\xe0\xab\x8d"); }
test { try parseIDNAFail("1.\xe2\x80\x8c\xea\xab\xac\xe3\x80\x82.\xe0\xab\x8d"); }
test { try parseIDNAFail("1.xn--sv9a..xn--mfc"); }
test { try parseIDNAFail("1.xn--0ug7185c..xn--mfc"); }
test { try parseIDNAFail("xn--tsh0720cse8b.xn--mfc"); }
test { try parseIDNAFail("xn--0ug78o720myr1c.xn--mfc"); }
test { try parseIDNAFail("\xc3\x9f\xe2\x80\x8d.\xe1\xaf\xb2\xf1\x84\xbe\xbc"); }
test { try parseIDNAFail("SS\xe2\x80\x8d.\xe1\xaf\xb2\xf1\x84\xbe\xbc"); }
test { try parseIDNAFail("ss\xe2\x80\x8d.\xe1\xaf\xb2\xf1\x84\xbe\xbc"); }
test { try parseIDNAFail("Ss\xe2\x80\x8d.\xe1\xaf\xb2\xf1\x84\xbe\xbc"); }
test { try parseIDNAFail("ss.xn--0zf22107b"); }
test { try parseIDNAFail("xn--ss-n1t.xn--0zf22107b"); }
test { try parseIDNAFail("xn--zca870n.xn--0zf22107b"); }
test { try parseIDNAFail("\xf0\x91\x93\x82\xe2\x80\x8c\xe2\x89\xae.\xe2\x89\xae"); }
test { try parseIDNAFail("\xf0\x91\x93\x82\xe2\x80\x8c<\xcc\xb8.<\xcc\xb8"); }
test { try parseIDNAFail("xn--gdhz656g.xn--gdh"); }
test { try parseIDNAFail("xn--0ugy6glz29a.xn--gdh"); }
test { try parseIDNAFail("xn--my8h.xn--psd"); }
test { try parseIDNAFail("xn--my8h.xn--cl7c"); }
test { try parseIDNAFail("\xe7\x88\x95\xf2\xb3\x99\x91\xef\xbc\x8e\xf0\x9d\x9f\xb0\xe6\xb0\x97"); }
test { try parseIDNAFail("\xe7\x88\x95\xf2\xb3\x99\x91.4\xe6\xb0\x97"); }
test { try parseIDNAFail("xn--1zxq3199c.xn--4-678b"); }
test { try parseIDNAFail("\xf3\x9e\x9d\x83\xe3\x80\x82\xf2\x91\x86\x83\xf1\x89\xa2\x97--"); }
test { try parseIDNAFail("xn--2y75e.xn-----1l15eer88n"); }
test { try parseIDNAFail("\xe8\x94\xb0\xe3\x80\x82\xf3\xa0\x81\xb9\xe0\xa3\x9d-\xf0\x91\x88\xb5"); }
test { try parseIDNAFail("xn--sz1a.xn----mrd9984r3dl0i"); }
test { try parseIDNAFail("xn--4xa477d.xn--epb"); }
test { try parseIDNAFail("xn--3xa677d.xn--epb"); }
test { try parseIDNAFail("xn--pt9c.xn--hnd666l"); }
test { try parseIDNAFail("xn--pt9c.xn--hndy"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\x80\x8c\xe3\x84\xa4\xef\xbc\x8e\xcc\xae\xf3\x95\xa8\x91\xe0\xa7\x82"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\x80\x8c\xe3\x84\xa4.\xcc\xae\xf3\x95\xa8\x91\xe0\xa7\x82"); }
test { try parseIDNAFail("xn--1fk.xn--vta284a9o563a"); }
test { try parseIDNAFail("xn--0uga242k.xn--vta284a9o563a"); }
test { try parseIDNAFail("\xe1\x82\xb4\xf0\x9d\xa8\xa8\xe2\x82\x83\xf3\xa0\x81\xa6\xef\xbc\x8e\xf0\x9d\x9f\xb3\xf0\x91\x82\xb9\xe0\xae\x82"); }
test { try parseIDNAFail("\xe1\x82\xb4\xf0\x9d\xa8\xa83\xf3\xa0\x81\xa6.7\xf0\x91\x82\xb9\xe0\xae\x82"); }
test { try parseIDNAFail("\xe2\xb4\x94\xf0\x9d\xa8\xa83\xf3\xa0\x81\xa6.7\xf0\x91\x82\xb9\xe0\xae\x82"); }
test { try parseIDNAFail("xn--3-ews6985n35s3g.xn--7-cve6271r"); }
test { try parseIDNAFail("\xe2\xb4\x94\xf0\x9d\xa8\xa8\xe2\x82\x83\xf3\xa0\x81\xa6\xef\xbc\x8e\xf0\x9d\x9f\xb3\xf0\x91\x82\xb9\xe0\xae\x82"); }
test { try parseIDNAFail("xn--3-b1g83426a35t0g.xn--7-cve6271r"); }
test { try parseIDNAFail("\xe4\x8f\x88\xe2\x80\x8c\xe3\x80\x82\xe2\x80\x8c\xe2\x92\x88\xf1\xb1\xa2\x95"); }
test { try parseIDNAFail("\xe4\x8f\x88\xe2\x80\x8c\xe3\x80\x82\xe2\x80\x8c1.\xf1\xb1\xa2\x95"); }
test { try parseIDNAFail("xn--eco.1.xn--ms39a"); }
test { try parseIDNAFail("xn--0ug491l.xn--1-rgn.xn--ms39a"); }
test { try parseIDNAFail("xn--eco.xn--tsh21126d"); }
test { try parseIDNAFail("xn--0ug491l.xn--0ug88oot66q"); }
test { try parseIDNAFail("\xef\xbc\x91\xea\xab\xb6\xc3\x9f\xf0\x91\xb2\xa5\xef\xbd\xa1\xe1\xb7\x98"); }
test { try parseIDNAFail("1\xea\xab\xb6\xc3\x9f\xf0\x91\xb2\xa5\xe3\x80\x82\xe1\xb7\x98"); }
test { try parseIDNAFail("1\xea\xab\xb6SS\xf0\x91\xb2\xa5\xe3\x80\x82\xe1\xb7\x98"); }
test { try parseIDNAFail("1\xea\xab\xb6ss\xf0\x91\xb2\xa5\xe3\x80\x82\xe1\xb7\x98"); }
test { try parseIDNAFail("xn--1ss-ir6ln166b.xn--weg"); }
test { try parseIDNAFail("xn--1-qfa2471kdb0d.xn--weg"); }
test { try parseIDNAFail("\xef\xbc\x91\xea\xab\xb6SS\xf0\x91\xb2\xa5\xef\xbd\xa1\xe1\xb7\x98"); }
test { try parseIDNAFail("\xef\xbc\x91\xea\xab\xb6ss\xf0\x91\xb2\xa5\xef\xbd\xa1\xe1\xb7\x98"); }
test { try parseIDNAFail("1\xea\xab\xb6Ss\xf0\x91\xb2\xa5\xe3\x80\x82\xe1\xb7\x98"); }
test { try parseIDNAFail("\xef\xbc\x91\xea\xab\xb6Ss\xf0\x91\xb2\xa5\xef\xbd\xa1\xe1\xb7\x98"); }
test { try parseIDNAFail("xn--3j78f.xn--mkb20b"); }
test { try parseIDNAFail("\xf0\xb2\xa4\xb1\xe2\x92\x9b\xe2\xbe\xb3\xef\xbc\x8e\xea\xa1\xa6\xe2\x92\x88"); }
test { try parseIDNAFail("xn--dth6033bzbvx.xn--tsh9439b"); }
test { try parseIDNAFail("xn--tnd.xn--ss-jbe65aw27i"); }
test { try parseIDNAFail("xn--tnd.xn--zca912alh227g"); }
test { try parseIDNAFail("\xe2\x84\xb2\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82\xe2\x89\xaf\xe2\xbe\x91"); }
test { try parseIDNAFail("\xe2\x84\xb2\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82>\xcc\xb8\xe2\xbe\x91"); }
test { try parseIDNAFail("\xe2\x84\xb2\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82\xe2\x89\xaf\xe8\xa5\xbe"); }
test { try parseIDNAFail("\xe2\x84\xb2\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82>\xcc\xb8\xe8\xa5\xbe"); }
test { try parseIDNAFail("\xe2\x85\x8e\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82>\xcc\xb8\xe8\xa5\xbe"); }
test { try parseIDNAFail("\xe2\x85\x8e\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82\xe2\x89\xaf\xe8\xa5\xbe"); }
test { try parseIDNAFail("xn--73g39298c.xn--hdhz171b"); }
test { try parseIDNAFail("\xe2\x85\x8e\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82>\xcc\xb8\xe2\xbe\x91"); }
test { try parseIDNAFail("\xe2\x85\x8e\xf3\xa0\x85\xba\xf1\x9d\xb5\x92\xe3\x80\x82\xe2\x89\xaf\xe2\xbe\x91"); }
test { try parseIDNAFail("xn--f3g73398c.xn--hdhz171b"); }
test { try parseIDNAFail("\xe2\x80\x8c.\xc3\x9f\xe1\x82\xa9-"); }
test { try parseIDNAFail("\xe2\x80\x8c.\xc3\x9f\xe2\xb4\x89-"); }
test { try parseIDNAFail("\xe2\x80\x8c.SS\xe1\x82\xa9-"); }
test { try parseIDNAFail("\xe2\x80\x8c.ss\xe2\xb4\x89-"); }
test { try parseIDNAFail("\xe2\x80\x8c.Ss\xe2\xb4\x89-"); }
test { try parseIDNAFail("xn--0ug.xn--ss--bi1b"); }
test { try parseIDNAFail("xn--0ug.xn----pfa2305a"); }
test { try parseIDNAFail(".xn--ss--4rn"); }
test { try parseIDNAFail("xn--0ug.xn--ss--4rn"); }
test { try parseIDNAFail("xn--0ug.xn----pfa042j"); }
test { try parseIDNAFail("\xf3\xa0\xaa\xa2-\xe3\x80\x82\xf2\x9b\x82\x8f\xe2\x89\xae\xf0\x91\x9c\xab"); }
test { try parseIDNAFail("\xf3\xa0\xaa\xa2-\xe3\x80\x82\xf2\x9b\x82\x8f<\xcc\xb8\xf0\x91\x9c\xab"); }
test { try parseIDNAFail("xn----bh61m.xn--gdhz157g0em1d"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf3\xa0\x89\xb9\xe2\x80\x8d\xe3\x80\x82\xf2\x8c\xbf\xa7\xe2\x89\xae\xe1\x82\xa9"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf3\xa0\x89\xb9\xe2\x80\x8d\xe3\x80\x82\xf2\x8c\xbf\xa7<\xcc\xb8\xe1\x82\xa9"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf3\xa0\x89\xb9\xe2\x80\x8d\xe3\x80\x82\xf2\x8c\xbf\xa7<\xcc\xb8\xe2\xb4\x89"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf3\xa0\x89\xb9\xe2\x80\x8d\xe3\x80\x82\xf2\x8c\xbf\xa7\xe2\x89\xae\xe2\xb4\x89"); }
test { try parseIDNAFail("xn--3n36e.xn--gdh992byu01p"); }
test { try parseIDNAFail("xn--0ugc90904y.xn--gdh992byu01p"); }
test { try parseIDNAFail("xn--3n36e.xn--hnd112gpz83n"); }
test { try parseIDNAFail("xn--0ugc90904y.xn--hnd112gpz83n"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe1\x82\xb0\xef\xbd\xa1\xec\xaa\xa1"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe1\x82\xb0\xef\xbd\xa1\xe1\x84\x8d\xe1\x85\xa8\xe1\x86\xa8"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe1\x82\xb0\xe3\x80\x82\xec\xaa\xa1"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe1\x82\xb0\xe3\x80\x82\xe1\x84\x8d\xe1\x85\xa8\xe1\x86\xa8"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe2\xb4\x90\xe3\x80\x82\xe1\x84\x8d\xe1\x85\xa8\xe1\x86\xa8"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe2\xb4\x90\xe3\x80\x82\xec\xaa\xa1"); }
test { try parseIDNAFail("xn--7kj1858k.xn--pi6b"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe2\xb4\x90\xef\xbd\xa1\xe1\x84\x8d\xe1\x85\xa8\xe1\x86\xa8"); }
test { try parseIDNAFail("\xf0\x9d\xaa\x9e\xe2\xb4\x90\xef\xbd\xa1\xec\xaa\xa1"); }
test { try parseIDNAFail("xn--ond3755u.xn--pi6b"); }
test { try parseIDNAFail("\xe1\xa1\x85\xef\xbc\x90\xe2\x80\x8c\xef\xbd\xa1\xe2\x8e\xa2\xf3\xa4\xa8\x84"); }
test { try parseIDNAFail("\xe1\xa1\x850\xe2\x80\x8c\xe3\x80\x82\xe2\x8e\xa2\xf3\xa4\xa8\x84"); }
test { try parseIDNAFail("xn--0-z6j.xn--8lh28773l"); }
test { try parseIDNAFail("xn--0-z6jy93b.xn--8lh28773l"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a\xef\xbc\x99\xea\x8d\xa9\xe1\x9f\x93\xef\xbc\x8e\xe2\x80\x8d\xc3\x9f"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a9\xea\x8d\xa9\xe1\x9f\x93.\xe2\x80\x8d\xc3\x9f"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a9\xea\x8d\xa9\xe1\x9f\x93.\xe2\x80\x8dSS"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a9\xea\x8d\xa9\xe1\x9f\x93.\xe2\x80\x8dss"); }
test { try parseIDNAFail("xn--9-i0j5967eg3qz.xn--ss-l1t"); }
test { try parseIDNAFail("xn--9-i0j5967eg3qz.xn--zca770n"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a\xef\xbc\x99\xea\x8d\xa9\xe1\x9f\x93\xef\xbc\x8e\xe2\x80\x8dSS"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a\xef\xbc\x99\xea\x8d\xa9\xe1\x9f\x93\xef\xbc\x8e\xe2\x80\x8dss"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a9\xea\x8d\xa9\xe1\x9f\x93.\xe2\x80\x8dSs"); }
test { try parseIDNAFail("\xf0\xb2\xae\x9a\xef\xbc\x99\xea\x8d\xa9\xe1\x9f\x93\xef\xbc\x8e\xe2\x80\x8dSs"); }
test { try parseIDNAFail("\xe2\x92\x90\xe2\x89\xaf-\xe3\x80\x82\xef\xb8\x92\xf2\xa9\x91\xa3-\xf1\x9e\x9b\xa0"); }
test { try parseIDNAFail("\xe2\x92\x90>\xcc\xb8-\xe3\x80\x82\xef\xb8\x92\xf2\xa9\x91\xa3-\xf1\x9e\x9b\xa0"); }
test { try parseIDNAFail("9.\xe2\x89\xaf-\xe3\x80\x82\xe3\x80\x82\xf2\xa9\x91\xa3-\xf1\x9e\x9b\xa0"); }
test { try parseIDNAFail("9.>\xcc\xb8-\xe3\x80\x82\xe3\x80\x82\xf2\xa9\x91\xa3-\xf1\x9e\x9b\xa0"); }
test { try parseIDNAFail("9.xn----ogo..xn----xj54d1s69k"); }
test { try parseIDNAFail("xn----ogot9g.xn----n89hl0522az9u2a"); }
test { try parseIDNAFail("\xe1\x82\xaf\xf3\xa0\x85\x8b-\xef\xbc\x8e\xe2\x80\x8d\xe1\x82\xa9"); }
test { try parseIDNAFail("\xe1\x82\xaf\xf3\xa0\x85\x8b-.\xe2\x80\x8d\xe1\x82\xa9"); }
test { try parseIDNAFail("\xe2\xb4\x8f\xf3\xa0\x85\x8b-.\xe2\x80\x8d\xe2\xb4\x89"); }
test { try parseIDNAFail("xn----3vs.xn--1ug532c"); }
test { try parseIDNAFail("\xe2\xb4\x8f\xf3\xa0\x85\x8b-\xef\xbc\x8e\xe2\x80\x8d\xe2\xb4\x89"); }
test { try parseIDNAFail("xn----00g.xn--hnd"); }
test { try parseIDNAFail("xn----00g.xn--hnd399e"); }
test { try parseIDNAFail("\xe1\x9c\x94\xe3\x80\x82\xf3\xa0\x86\xa3-\xf0\x91\x8b\xaa"); }
test { try parseIDNAFail("xn--fze.xn----ly8i"); }
test { try parseIDNAFail("\xea\xaf\xa8-\xef\xbc\x8e\xf2\xa8\x8f\x9c\xd6\xbd\xc3\x9f"); }
test { try parseIDNAFail("\xea\xaf\xa8-.\xf2\xa8\x8f\x9c\xd6\xbd\xc3\x9f"); }
test { try parseIDNAFail("\xea\xaf\xa8-.\xf2\xa8\x8f\x9c\xd6\xbdSS"); }
test { try parseIDNAFail("\xea\xaf\xa8-.\xf2\xa8\x8f\x9c\xd6\xbdss"); }
test { try parseIDNAFail("\xea\xaf\xa8-.\xf2\xa8\x8f\x9c\xd6\xbdSs"); }
test { try parseIDNAFail("xn----pw5e.xn--ss-7jd10716y"); }
test { try parseIDNAFail("xn----pw5e.xn--zca50wfv060a"); }
test { try parseIDNAFail("\xea\xaf\xa8-\xef\xbc\x8e\xf2\xa8\x8f\x9c\xd6\xbdSS"); }
test { try parseIDNAFail("\xea\xaf\xa8-\xef\xbc\x8e\xf2\xa8\x8f\x9c\xd6\xbdss"); }
test { try parseIDNAFail("\xea\xaf\xa8-\xef\xbc\x8e\xf2\xa8\x8f\x9c\xd6\xbdSs"); }
test { try parseIDNAFail("\xf0\x9d\x9f\xa5\xe2\x99\xae\xf0\x91\x9c\xab\xe0\xa3\xad\xef\xbc\x8e\xe1\x9f\x92\xf0\x91\x9c\xab8\xf3\xa0\x86\x8f"); }
test { try parseIDNAFail("3\xe2\x99\xae\xf0\x91\x9c\xab\xe0\xa3\xad.\xe1\x9f\x92\xf0\x91\x9c\xab8\xf3\xa0\x86\x8f"); }
test { try parseIDNAFail("xn--3-ksd277tlo7s.xn--8-f0jx021l"); }
test { try parseIDNAFail("-\xef\xbd\xa1\xf2\x95\x8c\x80\xe2\x80\x8d\xe2\x9d\xa1"); }
test { try parseIDNAFail("-\xe3\x80\x82\xf2\x95\x8c\x80\xe2\x80\x8d\xe2\x9d\xa1"); }
test { try parseIDNAFail("-.xn--nei54421f"); }
test { try parseIDNAFail("-.xn--1ug800aq795s"); }
test { try parseIDNAFail("\xf0\x9d\x9f\x93\xe2\x98\xb1\xf0\x9d\x9f\x90\xf2\xa5\xb0\xb5\xef\xbd\xa1\xf0\x9d\xaa\xae\xf1\x90\xa1\xb3"); }
test { try parseIDNAFail("5\xe2\x98\xb12\xf2\xa5\xb0\xb5\xe3\x80\x82\xf0\x9d\xaa\xae\xf1\x90\xa1\xb3"); }
test { try parseIDNAFail("xn--52-dwx47758j.xn--kd3hk431k"); }
test { try parseIDNAFail("-.-\xe2\x94\x9c\xf2\x96\xa6\xa3"); }
test { try parseIDNAFail("-.xn----ukp70432h"); }
test { try parseIDNAFail("\xcf\x82\xef\xbc\x8e\xef\xb7\x81\xf0\x9f\x9e\x9b\xe2\x92\x88"); }
test { try parseIDNAFail("\xce\xa3\xef\xbc\x8e\xef\xb7\x81\xf0\x9f\x9e\x9b\xe2\x92\x88"); }
test { try parseIDNAFail("\xcf\x83\xef\xbc\x8e\xef\xb7\x81\xf0\x9f\x9e\x9b\xe2\x92\x88"); }
test { try parseIDNAFail("xn--4xa.xn--dhbip2802atb20c"); }
test { try parseIDNAFail("xn--3xa.xn--dhbip2802atb20c"); }
test { try parseIDNAFail("9\xf3\xa0\x87\xa5\xef\xbc\x8e\xf3\xaa\xb4\xb4\xe1\xa2\x93"); }
test { try parseIDNAFail("9\xf3\xa0\x87\xa5.\xf3\xaa\xb4\xb4\xe1\xa2\x93"); }
test { try parseIDNAFail("9.xn--dbf91222q"); }
test { try parseIDNAFail("\xef\xb8\x92\xe1\x82\xb6\xcd\xa6\xef\xbc\x8e\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe3\x80\x82\xe1\x82\xb6\xcd\xa6.\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe3\x80\x82\xe2\xb4\x96\xcd\xa6.\xe2\x80\x8c"); }
test { try parseIDNAFail(".xn--hva754s.xn--0ug"); }
test { try parseIDNAFail("\xef\xb8\x92\xe2\xb4\x96\xcd\xa6\xef\xbc\x8e\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--hva754sy94k."); }
test { try parseIDNAFail("xn--hva754sy94k.xn--0ug"); }
test { try parseIDNAFail(".xn--hva929d."); }
test { try parseIDNAFail(".xn--hva929d.xn--0ug"); }
test { try parseIDNAFail("xn--hva929dl29p."); }
test { try parseIDNAFail("xn--hva929dl29p.xn--0ug"); }
test { try parseIDNAFail("xn--hva929d."); }
test { try parseIDNAFail("xn--hzb.xn--bnd2938u"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xe3\x80\x82\xef\xbc\x92\xe4\xab\xb7\xf3\xa0\xa7\xb7"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xe3\x80\x822\xe4\xab\xb7\xf3\xa0\xa7\xb7"); }
test { try parseIDNAFail(".xn--2-me5ay1273i"); }
test { try parseIDNAFail("xn--0ugb.xn--2-me5ay1273i"); }
test { try parseIDNAFail("-\xf0\x9e\x80\xa4\xf3\x9c\xa0\x90\xe3\x80\x82\xf2\x88\xac\x96"); }
test { try parseIDNAFail("xn----rq4re4997d.xn--l707b"); }
test { try parseIDNAFail("\xf3\xb3\x9b\x82\xef\xb8\x92\xe2\x80\x8c\xe3\x9f\x80\xef\xbc\x8e\xd8\xa4\xe2\x92\x88"); }
test { try parseIDNAFail("\xf3\xb3\x9b\x82\xef\xb8\x92\xe2\x80\x8c\xe3\x9f\x80\xef\xbc\x8e\xd9\x88\xd9\x94\xe2\x92\x88"); }
test { try parseIDNAFail("xn--z272f.xn--etl.xn--1-smc."); }
test { try parseIDNAFail("xn--etlt457ccrq7h.xn--jgb476m"); }
test { try parseIDNAFail("xn--0ug754gxl4ldlt0k.xn--jgb476m"); }
test { try parseIDNAFail("\xdf\xbc\xf0\x90\xb8\x86.\xf0\x93\x96\x8f\xef\xb8\x92\xf1\x8a\xa8\xa9\xe1\x82\xb0"); }
test { try parseIDNAFail("\xdf\xbc\xf0\x90\xb8\x86.\xf0\x93\x96\x8f\xe3\x80\x82\xf1\x8a\xa8\xa9\xe1\x82\xb0"); }
test { try parseIDNAFail("\xdf\xbc\xf0\x90\xb8\x86.\xf0\x93\x96\x8f\xe3\x80\x82\xf1\x8a\xa8\xa9\xe2\xb4\x90"); }
test { try parseIDNAFail("xn--0tb8725k.xn--tu8d.xn--7kj73887a"); }
test { try parseIDNAFail("\xdf\xbc\xf0\x90\xb8\x86.\xf0\x93\x96\x8f\xef\xb8\x92\xf1\x8a\xa8\xa9\xe2\xb4\x90"); }
test { try parseIDNAFail("xn--0tb8725k.xn--7kj9008dt18a7py9c"); }
test { try parseIDNAFail("xn--0tb8725k.xn--tu8d.xn--ond97931d"); }
test { try parseIDNAFail("xn--0tb8725k.xn--ond3562jt18a7py9c"); }
test { try parseIDNAFail("\xe1\x83\x85\xe2\x9a\xad\xf3\xa0\x96\xab\xe2\x8b\x83\xef\xbd\xa1\xf0\x91\x8c\xbc"); }
test { try parseIDNAFail("\xe1\x83\x85\xe2\x9a\xad\xf3\xa0\x96\xab\xe2\x8b\x83\xe3\x80\x82\xf0\x91\x8c\xbc"); }
test { try parseIDNAFail("\xe2\xb4\xa5\xe2\x9a\xad\xf3\xa0\x96\xab\xe2\x8b\x83\xe3\x80\x82\xf0\x91\x8c\xbc"); }
test { try parseIDNAFail("xn--vfh16m67gx1162b.xn--ro1d"); }
test { try parseIDNAFail("\xe2\xb4\xa5\xe2\x9a\xad\xf3\xa0\x96\xab\xe2\x8b\x83\xef\xbd\xa1\xf0\x91\x8c\xbc"); }
test { try parseIDNAFail("xn--9nd623g4zc5z060c.xn--ro1d"); }
test { try parseIDNAFail("\xf1\x82\x88\xa6\xe5\xb8\xb7\xef\xbd\xa1\xe2\x89\xaf\xe8\x90\xba\xe1\xb7\x88-"); }
test { try parseIDNAFail("\xf1\x82\x88\xa6\xe5\xb8\xb7\xef\xbd\xa1>\xcc\xb8\xe8\x90\xba\xe1\xb7\x88-"); }
test { try parseIDNAFail("\xf1\x82\x88\xa6\xe5\xb8\xb7\xe3\x80\x82\xe2\x89\xaf\xe8\x90\xba\xe1\xb7\x88-"); }
test { try parseIDNAFail("\xf1\x82\x88\xa6\xe5\xb8\xb7\xe3\x80\x82>\xcc\xb8\xe8\x90\xba\xe1\xb7\x88-"); }
test { try parseIDNAFail("xn--qutw175s.xn----mimu6tf67j"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe6\x94\x8c\xea\xaf\xad\xe3\x80\x82\xe1\xa2\x96-\xe1\x82\xb8"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe6\x94\x8c\xea\xaf\xad\xe3\x80\x82\xe1\xa2\x96-\xe2\xb4\x98"); }
test { try parseIDNAFail("xn--1ug592ykp6b.xn----mck373i"); }
test { try parseIDNAFail("xn--p9ut19m.xn----k1g451d"); }
test { try parseIDNAFail("xn--1ug592ykp6b.xn----k1g451d"); }
test { try parseIDNAFail("\xe2\x80\x8c\xea\x96\xa8\xef\xbc\x8e\xe2\x92\x97\xef\xbc\x93\xed\x88\x92\xdb\xb3"); }
test { try parseIDNAFail("\xe2\x80\x8c\xea\x96\xa8\xef\xbc\x8e\xe2\x92\x97\xef\xbc\x93\xe1\x84\x90\xe1\x85\xad\xe1\x86\xa9\xdb\xb3"); }
test { try parseIDNAFail("\xe2\x80\x8c\xea\x96\xa8.16.3\xed\x88\x92\xdb\xb3"); }
test { try parseIDNAFail("\xe2\x80\x8c\xea\x96\xa8.16.3\xe1\x84\x90\xe1\x85\xad\xe1\x86\xa9\xdb\xb3"); }
test { try parseIDNAFail("xn--0ug2473c.16.xn--3-nyc0117m"); }
test { try parseIDNAFail("xn--9r8a.xn--3-nyc678tu07m"); }
test { try parseIDNAFail("xn--0ug2473c.xn--3-nyc678tu07m"); }
test { try parseIDNAFail("\xf0\x9d\x9f\x8f\xf0\x9d\xa8\x99\xe2\xb8\x96.\xe2\x80\x8d"); }
test { try parseIDNAFail("1\xf0\x9d\xa8\x99\xe2\xb8\x96.\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--1-5bt6845n.xn--1ug"); }
test { try parseIDNAFail("F\xf3\xa0\x85\x9f\xef\xbd\xa1\xf2\x8f\x97\x85\xe2\x99\x9a"); }
test { try parseIDNAFail("F\xf3\xa0\x85\x9f\xe3\x80\x82\xf2\x8f\x97\x85\xe2\x99\x9a"); }
test { try parseIDNAFail("f\xf3\xa0\x85\x9f\xe3\x80\x82\xf2\x8f\x97\x85\xe2\x99\x9a"); }
test { try parseIDNAFail("f.xn--45hz6953f"); }
test { try parseIDNAFail("f\xf3\xa0\x85\x9f\xef\xbd\xa1\xf2\x8f\x97\x85\xe2\x99\x9a"); }
test { try parseIDNAFail("\xe0\xad\x8d\xf0\x91\x84\xb4\xe1\xb7\xa9\xe3\x80\x82\xf0\x9d\x9f\xae\xe1\x82\xb8\xf0\x9e\x80\xa8\xf1\x83\xa5\x87"); }
test { try parseIDNAFail("\xe0\xad\x8d\xf0\x91\x84\xb4\xe1\xb7\xa9\xe3\x80\x822\xe1\x82\xb8\xf0\x9e\x80\xa8\xf1\x83\xa5\x87"); }
test { try parseIDNAFail("\xe0\xad\x8d\xf0\x91\x84\xb4\xe1\xb7\xa9\xe3\x80\x822\xe2\xb4\x98\xf0\x9e\x80\xa8\xf1\x83\xa5\x87"); }
test { try parseIDNAFail("xn--9ic246gs21p.xn--2-nws2918ndrjr"); }
test { try parseIDNAFail("\xe0\xad\x8d\xf0\x91\x84\xb4\xe1\xb7\xa9\xe3\x80\x82\xf0\x9d\x9f\xae\xe2\xb4\x98\xf0\x9e\x80\xa8\xf1\x83\xa5\x87"); }
test { try parseIDNAFail("xn--9ic246gs21p.xn--2-k1g43076adrwq"); }
test { try parseIDNAFail("\xf2\x93\xa0\xad\xe2\x80\x8c\xe2\x80\x8c\xe2\x92\x88\xe3\x80\x82\xe5\x8b\x89\xf0\x91\x81\x85"); }
test { try parseIDNAFail("\xf2\x93\xa0\xad\xe2\x80\x8c\xe2\x80\x8c1.\xe3\x80\x82\xe5\x8b\x89\xf0\x91\x81\x85"); }
test { try parseIDNAFail("xn--1-yi00h..xn--4grs325b"); }
test { try parseIDNAFail("xn--1-rgna61159u..xn--4grs325b"); }
test { try parseIDNAFail("xn--tsh11906f.xn--4grs325b"); }
test { try parseIDNAFail("xn--0uga855aez302a.xn--4grs325b"); }
test { try parseIDNAFail("\xe1\xa1\x83.\xe7\x8e\xbf\xf1\xab\x88\x9c\xf3\x95\x9e\x90"); }
test { try parseIDNAFail("xn--27e.xn--7cy81125a0yq4a"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\x80\x8c\xef\xbd\xa1\xe2\x92\x88\xe2\x89\xaf\xf0\x9d\x9f\xb5"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\x80\x8c\xef\xbd\xa1\xe2\x92\x88>\xcc\xb8\xf0\x9d\x9f\xb5"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\x80\x8c\xe3\x80\x821.\xe2\x89\xaf9"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\x80\x8c\xe3\x80\x821.>\xcc\xb89"); }
test { try parseIDNAFail("xn--0uga.1.xn--9-ogo"); }
test { try parseIDNAFail(".xn--9-ogo37g"); }
test { try parseIDNAFail("xn--0uga.xn--9-ogo37g"); }
test { try parseIDNAFail("\xe2\x83\x9a\xef\xbc\x8e\xf0\x91\x98\xbf-"); }
test { try parseIDNAFail("\xe2\x83\x9a.\xf0\x91\x98\xbf-"); }
test { try parseIDNAFail("xn--w0g.xn----bd0j"); }
test { try parseIDNAFail("\xe1\x82\x82-\xe2\x80\x8d\xea\xa3\xaa\xef\xbc\x8e\xea\xa1\x8a\xe2\x80\x8d\xf1\xbc\xb8\xb3"); }
test { try parseIDNAFail("\xe1\x82\x82-\xe2\x80\x8d\xea\xa3\xaa.\xea\xa1\x8a\xe2\x80\x8d\xf1\xbc\xb8\xb3"); }
test { try parseIDNAFail("xn----gyg3618i.xn--jc9ao4185a"); }
test { try parseIDNAFail("xn----gyg250jio7k.xn--1ug8774cri56d"); }
test { try parseIDNAFail("\xf0\x91\x88\xb5\xe5\xbb\x8a.\xf0\x90\xa0\x8d"); }
test { try parseIDNAFail("xn--xytw701b.xn--yc9c"); }
test { try parseIDNAFail("\xe1\x82\xbe\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb\xef\xbc\x8e\xe1\xa2\x97\xeb\xa6\xab"); }
test { try parseIDNAFail("\xe1\x82\xbe\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb\xef\xbc\x8e\xe1\xa2\x97\xe1\x84\x85\xe1\x85\xb4\xe1\x87\x82"); }
test { try parseIDNAFail("\xe1\x82\xbe\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb.\xe1\xa2\x97\xeb\xa6\xab"); }
test { try parseIDNAFail("\xe1\x82\xbe\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb.\xe1\xa2\x97\xe1\x84\x85\xe1\x85\xb4\xe1\x87\x82"); }
test { try parseIDNAFail("\xe2\xb4\x9e\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb.\xe1\xa2\x97\xe1\x84\x85\xe1\x85\xb4\xe1\x87\x82"); }
test { try parseIDNAFail("\xe2\xb4\x9e\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb.\xe1\xa2\x97\xeb\xa6\xab"); }
test { try parseIDNAFail("xn--mlj0486jgl2j.xn--hbf6853f"); }
test { try parseIDNAFail("\xe2\xb4\x9e\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb\xef\xbc\x8e\xe1\xa2\x97\xe1\x84\x85\xe1\x85\xb4\xe1\x87\x82"); }
test { try parseIDNAFail("\xe2\xb4\x9e\xf0\xb6\x9b\x80\xf0\x9b\x97\xbb\xef\xbc\x8e\xe1\xa2\x97\xeb\xa6\xab"); }
test { try parseIDNAFail("xn--2nd8876sgl2j.xn--hbf6853f"); }
test { try parseIDNAFail("\xc3\x9f\xe2\x80\x8d\xe1\x80\xba\xef\xbd\xa1\xe2\x92\x88"); }
test { try parseIDNAFail("xn--ss-f4j585j.b."); }
test { try parseIDNAFail("xn--zca679eh2l.b."); }
test { try parseIDNAFail("SS\xe2\x80\x8d\xe1\x80\xba\xef\xbd\xa1\xe2\x92\x88"); }
test { try parseIDNAFail("ss\xe2\x80\x8d\xe1\x80\xba\xef\xbd\xa1\xe2\x92\x88"); }
test { try parseIDNAFail("Ss\xe2\x80\x8d\xe1\x80\xba\xef\xbd\xa1\xe2\x92\x88"); }
test { try parseIDNAFail("xn--ss-f4j.xn--tsh"); }
test { try parseIDNAFail("xn--ss-f4j585j.xn--tsh"); }
test { try parseIDNAFail("xn--zca679eh2l.xn--tsh"); }
test { try parseIDNAFail("\xf0\x9d\x9f\xa0\xe2\x89\xae\xe2\x80\x8c\xef\xbd\xa1\xf3\xa0\x85\xb1\xe1\x9e\xb4"); }
test { try parseIDNAFail("\xf0\x9d\x9f\xa0<\xcc\xb8\xe2\x80\x8c\xef\xbd\xa1\xf3\xa0\x85\xb1\xe1\x9e\xb4"); }
test { try parseIDNAFail("8\xe2\x89\xae\xe2\x80\x8c\xe3\x80\x82\xf3\xa0\x85\xb1\xe1\x9e\xb4"); }
test { try parseIDNAFail("8<\xcc\xb8\xe2\x80\x8c\xe3\x80\x82\xf3\xa0\x85\xb1\xe1\x9e\xb4"); }
test { try parseIDNAFail("xn--8-sgn10i."); }
test { try parseIDNAFail("xn--8-ngo.xn--z3e"); }
test { try parseIDNAFail("xn--8-sgn10i.xn--z3e"); }
test { try parseIDNAFail("\xe1\xa2\x95\xe2\x89\xaf\xef\xb8\x92\xf1\x84\x82\xaf\xef\xbc\x8e\xe1\x82\xa0"); }
test { try parseIDNAFail("\xe1\xa2\x95>\xcc\xb8\xef\xb8\x92\xf1\x84\x82\xaf\xef\xbc\x8e\xe1\x82\xa0"); }
test { try parseIDNAFail("\xe1\xa2\x95\xe2\x89\xaf\xe3\x80\x82\xf1\x84\x82\xaf.\xe1\x82\xa0"); }
test { try parseIDNAFail("\xe1\xa2\x95>\xcc\xb8\xe3\x80\x82\xf1\x84\x82\xaf.\xe1\x82\xa0"); }
test { try parseIDNAFail("\xe1\xa2\x95>\xcc\xb8\xe3\x80\x82\xf1\x84\x82\xaf.\xe2\xb4\x80"); }
test { try parseIDNAFail("\xe1\xa2\x95\xe2\x89\xaf\xe3\x80\x82\xf1\x84\x82\xaf.\xe2\xb4\x80"); }
test { try parseIDNAFail("xn--fbf851c.xn--ko1u.xn--rkj"); }
test { try parseIDNAFail("\xe1\xa2\x95>\xcc\xb8\xef\xb8\x92\xf1\x84\x82\xaf\xef\xbc\x8e\xe2\xb4\x80"); }
test { try parseIDNAFail("\xe1\xa2\x95\xe2\x89\xaf\xef\xb8\x92\xf1\x84\x82\xaf\xef\xbc\x8e\xe2\xb4\x80"); }
test { try parseIDNAFail("xn--fbf851cq98poxw1a.xn--rkj"); }
test { try parseIDNAFail("xn--fbf851c.xn--ko1u.xn--7md"); }
test { try parseIDNAFail("xn--fbf851cq98poxw1a.xn--7md"); }
test { try parseIDNAFail("\xe0\xbe\x9f\xef\xbc\x8e-\xe0\xa0\xaa"); }
test { try parseIDNAFail("\xe0\xbe\x9f.-\xe0\xa0\xaa"); }
test { try parseIDNAFail("xn--vfd.xn----fhd"); }
test { try parseIDNAFail("\xe1\xb5\xac\xf3\xa0\x86\xa0\xef\xbc\x8e\xed\x95\x92\xe2\x92\x92\xe2\x92\x88\xf4\x88\x84\xa6"); }
test { try parseIDNAFail("\xe1\xb5\xac\xf3\xa0\x86\xa0\xef\xbc\x8e\xe1\x84\x91\xe1\x85\xb5\xe1\x86\xbd\xe2\x92\x92\xe2\x92\x88\xf4\x88\x84\xa6"); }
test { try parseIDNAFail("\xe1\xb5\xac\xf3\xa0\x86\xa0.\xed\x95\x9211.1.\xf4\x88\x84\xa6"); }
test { try parseIDNAFail("\xe1\xb5\xac\xf3\xa0\x86\xa0.\xe1\x84\x91\xe1\x85\xb5\xe1\x86\xbd11.1.\xf4\x88\x84\xa6"); }
test { try parseIDNAFail("xn--tbg.xn--11-5o7k.1.xn--k469f"); }
test { try parseIDNAFail("xn--tbg.xn--tsht7586kyts9l"); }
test { try parseIDNAFail("\xe2\x92\x88\xe2\x9c\x8c\xf2\x9f\xac\x9f\xef\xbc\x8e\xf0\x9d\x9f\xa1\xf1\xa0\xb1\xa3"); }
test { try parseIDNAFail("1.\xe2\x9c\x8c\xf2\x9f\xac\x9f.9\xf1\xa0\xb1\xa3"); }
test { try parseIDNAFail("1.xn--7bi44996f.xn--9-o706d"); }
test { try parseIDNAFail("xn--tsh24g49550b.xn--9-o706d"); }
test { try parseIDNAFail("\xcf\x82\xef\xbc\x8e\xea\xa7\x80\xea\xa3\x84"); }
test { try parseIDNAFail("\xcf\x82.\xea\xa7\x80\xea\xa3\x84"); }
test { try parseIDNAFail("\xce\xa3.\xea\xa7\x80\xea\xa3\x84"); }
test { try parseIDNAFail("\xcf\x83.\xea\xa7\x80\xea\xa3\x84"); }
test { try parseIDNAFail("xn--4xa.xn--0f9ars"); }
test { try parseIDNAFail("xn--3xa.xn--0f9ars"); }
test { try parseIDNAFail("\xce\xa3\xef\xbc\x8e\xea\xa7\x80\xea\xa3\x84"); }
test { try parseIDNAFail("\xcf\x83\xef\xbc\x8e\xea\xa7\x80\xea\xa3\x84"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95\xe1\xbb\x97\xe2\x92\x88\xef\xbc\x8e\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b\xf0\x9d\x9f\xab"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95o\xcc\x82\xcc\x83\xe2\x92\x88\xef\xbc\x8e\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b\xf0\x9d\x9f\xab"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95\xe1\xbb\x971..\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b9"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95o\xcc\x82\xcc\x831..\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b9"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95O\xcc\x82\xcc\x831..\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b9"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95\xe1\xbb\x961..\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b9"); }
test { try parseIDNAFail("xn--1-3xm292b6044r..xn--9-6jd87310jtcqs"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95O\xcc\x82\xcc\x83\xe2\x92\x88\xef\xbc\x8e\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b\xf0\x9d\x9f\xab"); }
test { try parseIDNAFail("\xe2\x9e\x86\xf1\xb7\xa7\x95\xe1\xbb\x96\xe2\x92\x88\xef\xbc\x8e\xf2\x91\xac\x92\xf1\xa1\x98\xae\xe0\xa1\x9b\xf0\x9d\x9f\xab"); }
test { try parseIDNAFail("xn--6lg26tvvc6v99z.xn--9-6jd87310jtcqs"); }
test { try parseIDNAFail("\xdc\xbc\xe2\x80\x8c-\xe3\x80\x82\xf0\x93\x90\xbe\xc3\x9f"); }
test { try parseIDNAFail("\xdc\xbc\xe2\x80\x8c-\xe3\x80\x82\xf0\x93\x90\xbeSS"); }
test { try parseIDNAFail("\xdc\xbc\xe2\x80\x8c-\xe3\x80\x82\xf0\x93\x90\xbess"); }
test { try parseIDNAFail("\xdc\xbc\xe2\x80\x8c-\xe3\x80\x82\xf0\x93\x90\xbeSs"); }
test { try parseIDNAFail("xn----s2c.xn--ss-066q"); }
test { try parseIDNAFail("xn----s2c071q.xn--ss-066q"); }
test { try parseIDNAFail("xn----s2c071q.xn--zca7848m"); }
test { try parseIDNAFail("-\xf2\xb7\x9d\xac\xe1\x8d\x9e\xf0\x91\x9c\xa7.\xe1\xb7\xab-\xef\xb8\x92"); }
test { try parseIDNAFail("-\xf2\xb7\x9d\xac\xe1\x8d\x9e\xf0\x91\x9c\xa7.\xe1\xb7\xab-\xe3\x80\x82"); }
test { try parseIDNAFail("xn----b5h1837n2ok9f.xn----mkm."); }
test { try parseIDNAFail("xn----b5h1837n2ok9f.xn----mkmw278h"); }
test { try parseIDNAFail("\xef\xb8\x92.\xf2\x9a\xa0\xa1\xe1\xa9\x99"); }
test { try parseIDNAFail("\xe3\x80\x82.\xf2\x9a\xa0\xa1\xe1\xa9\x99"); }
test { try parseIDNAFail("..xn--cof61594i"); }
test { try parseIDNAFail("xn--y86c.xn--cof61594i"); }
test { try parseIDNAFail("\xf0\x91\xb0\xba.-\xf2\x91\x9f\x8f"); }
test { try parseIDNAFail("xn--jk3d.xn----iz68g"); }
test { try parseIDNAFail("\xf3\xa0\xbb\xa9\xef\xbc\x8e\xe8\xb5\x8f"); }
test { try parseIDNAFail("\xf3\xa0\xbb\xa9.\xe8\xb5\x8f"); }
test { try parseIDNAFail("xn--2856e.xn--6o3a"); }
test { try parseIDNAFail("\xe1\x82\xad\xef\xbc\x8e\xf1\x8d\x87\xa6\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe1\x82\xad.\xf1\x8d\x87\xa6\xe2\x80\x8c"); }
test { try parseIDNAFail("\xe2\xb4\x8d.\xf1\x8d\x87\xa6\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--4kj.xn--p01x"); }
test { try parseIDNAFail("xn--4kj.xn--0ug56448b"); }
test { try parseIDNAFail("\xe2\xb4\x8d\xef\xbc\x8e\xf1\x8d\x87\xa6\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--lnd.xn--p01x"); }
test { try parseIDNAFail("xn--lnd.xn--0ug56448b"); }
test { try parseIDNAFail("-\xe2\x80\x8d.\xe1\x82\xbe\xf0\x90\x8b\xb7"); }
test { try parseIDNAFail("-\xe2\x80\x8d.\xe2\xb4\x9e\xf0\x90\x8b\xb7"); }
test { try parseIDNAFail("xn----ugn.xn--mlj8559d"); }
test { try parseIDNAFail("-.xn--2nd2315j"); }
test { try parseIDNAFail("xn----ugn.xn--2nd2315j"); }
test { try parseIDNAFail("\xe2\x80\x8d\xcf\x82\xc3\x9f\xdc\xb1\xef\xbc\x8e\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xcf\x82\xc3\x9f\xdc\xb1.\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xce\xa3SS\xdc\xb1.\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xcf\x83ss\xdc\xb1.\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xce\xa3ss\xdc\xb1.\xe0\xaf\x8d"); }
test { try parseIDNAFail("xn--ss-ubc826a.xn--xmc"); }
test { try parseIDNAFail("xn--ss-ubc826ab34b.xn--xmc"); }
test { try parseIDNAFail("\xe2\x80\x8d\xce\xa3\xc3\x9f\xdc\xb1.\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xcf\x83\xc3\x9f\xdc\xb1.\xe0\xaf\x8d"); }
test { try parseIDNAFail("xn--zca39lk1di19a.xn--xmc"); }
test { try parseIDNAFail("xn--zca19ln1di19a.xn--xmc"); }
test { try parseIDNAFail("\xe2\x80\x8d\xce\xa3SS\xdc\xb1\xef\xbc\x8e\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xcf\x83ss\xdc\xb1\xef\xbc\x8e\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xce\xa3ss\xdc\xb1\xef\xbc\x8e\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xce\xa3\xc3\x9f\xdc\xb1\xef\xbc\x8e\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x80\x8d\xcf\x83\xc3\x9f\xdc\xb1\xef\xbc\x8e\xe0\xaf\x8d"); }
test { try parseIDNAFail("\xe2\x89\xa0\xef\xbc\x8e\xe2\x80\x8d"); }
test { try parseIDNAFail("=\xcc\xb8\xef\xbc\x8e\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\x89\xa0.\xe2\x80\x8d"); }
test { try parseIDNAFail("=\xcc\xb8.\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--1ch.xn--1ug"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xcf\x82\xef\xbc\x8e\xcf\x82\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xcf\x82.\xcf\x82\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xce\xa3.\xce\xa3\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xcf\x83.\xcf\x82\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xcf\x83.\xcf\x83\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xce\xa3.\xcf\x83\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("xn--4xa502av8297a.xn--4xa6055k"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xce\xa3.\xcf\x82\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("xn--4xa502av8297a.xn--3xa8055k"); }
test { try parseIDNAFail("xn--3xa702av8297a.xn--3xa8055k"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xce\xa3\xef\xbc\x8e\xce\xa3\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xcf\x83\xef\xbc\x8e\xcf\x82\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xcf\x83\xef\xbc\x8e\xcf\x83\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xce\xa3\xef\xbc\x8e\xcf\x83\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf3\xa7\x8b\xb5\xe0\xa7\x8d\xce\xa3\xef\xbc\x8e\xcf\x82\xf0\x90\xa8\xbf"); }
test { try parseIDNAFail("\xf1\xa3\xa4\x92\xef\xbd\xa1\xeb\xa5\xa7"); }
test { try parseIDNAFail("\xf1\xa3\xa4\x92\xef\xbd\xa1\xe1\x84\x85\xe1\x85\xb2\xe1\x86\xb6"); }
test { try parseIDNAFail("\xf1\xa3\xa4\x92\xe3\x80\x82\xeb\xa5\xa7"); }
test { try parseIDNAFail("\xf1\xa3\xa4\x92\xe3\x80\x82\xe1\x84\x85\xe1\x85\xb2\xe1\x86\xb6"); }
test { try parseIDNAFail("xn--s264a.xn--pw2b"); }
test { try parseIDNAFail("\xe1\xa1\x86\xf0\x91\x93\x9d\xef\xbc\x8e\xf0\x9e\xb5\x86"); }
test { try parseIDNAFail("\xe1\xa1\x86\xf0\x91\x93\x9d.\xf0\x9e\xb5\x86"); }
test { try parseIDNAFail("xn--57e0440k.xn--k86h"); }
test { try parseIDNAFail("\xf4\x8b\xbf\xa6\xef\xbd\xa1\xe1\xa0\xbd"); }
test { try parseIDNAFail("\xf4\x8b\xbf\xa6\xe3\x80\x82\xe1\xa0\xbd"); }
test { try parseIDNAFail("xn--j890g.xn--w7e"); }
test { try parseIDNAFail("\xe5\xac\x83\xf0\x9d\x8d\x8c\xef\xbc\x8e\xe2\x80\x8d\xe0\xad\x84"); }
test { try parseIDNAFail("\xe5\xac\x83\xf0\x9d\x8d\x8c.\xe2\x80\x8d\xe0\xad\x84"); }
test { try parseIDNAFail("xn--b6s0078f.xn--0ic"); }
test { try parseIDNAFail("xn--b6s0078f.xn--0ic557h"); }
test { try parseIDNAFail("\xe2\x80\x8c.\xf1\x9f\x9b\xa4"); }
test { try parseIDNAFail(".xn--q823a"); }
test { try parseIDNAFail("xn--0ug.xn--q823a"); }
test { try parseIDNAFail("\xf2\xba\x9b\x95\xe1\x82\xa3\xe4\xa0\x85\xef\xbc\x8e\xf0\x90\xb8\x91"); }
test { try parseIDNAFail("\xf2\xba\x9b\x95\xe1\x82\xa3\xe4\xa0\x85.\xf0\x90\xb8\x91"); }
test { try parseIDNAFail("\xf2\xba\x9b\x95\xe2\xb4\x83\xe4\xa0\x85.\xf0\x90\xb8\x91"); }
test { try parseIDNAFail("xn--ukju77frl47r.xn--yl0d"); }
test { try parseIDNAFail("\xf2\xba\x9b\x95\xe2\xb4\x83\xe4\xa0\x85\xef\xbc\x8e\xf0\x90\xb8\x91"); }
test { try parseIDNAFail("xn--bnd074zr557n.xn--yl0d"); }
test { try parseIDNAFail("-\xef\xbd\xa1\xef\xb8\x92"); }
test { try parseIDNAFail("-.xn--y86c"); }
test { try parseIDNAFail("\xe2\x80\x8d.F"); }
test { try parseIDNAFail("\xe2\x80\x8d.f"); }
test { try parseIDNAFail("xn--1ug.f"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xef\xbd\xa1\xc3\x9f"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xe3\x80\x82\xc3\x9f"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xe3\x80\x82SS"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xe3\x80\x82ss"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xe3\x80\x82Ss"); }
test { try parseIDNAFail("xn--1ug914h.ss"); }
test { try parseIDNAFail("xn--1ug914h.xn--zca"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xef\xbd\xa1SS"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xef\xbd\xa1ss"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe3\xa8\xb2\xef\xbd\xa1Ss"); }
test { try parseIDNAFail("\xe2\x80\x8d\xef\xbc\x8e\xf4\x80\xb8\xa8"); }
test { try parseIDNAFail("\xe2\x80\x8d.\xf4\x80\xb8\xa8"); }
test { try parseIDNAFail(".xn--h327f"); }
test { try parseIDNAFail("xn--1ug.xn--h327f"); }
test { try parseIDNAFail("\xf1\xa3\xad\xbb\xf1\x8c\xa5\x81\xef\xbd\xa1\xe2\x89\xa0\xf0\x9d\x9f\xb2"); }
test { try parseIDNAFail("\xf1\xa3\xad\xbb\xf1\x8c\xa5\x81\xef\xbd\xa1=\xcc\xb8\xf0\x9d\x9f\xb2"); }
test { try parseIDNAFail("\xf1\xa3\xad\xbb\xf1\x8c\xa5\x81\xe3\x80\x82\xe2\x89\xa06"); }
test { try parseIDNAFail("\xf1\xa3\xad\xbb\xf1\x8c\xa5\x81\xe3\x80\x82=\xcc\xb86"); }
test { try parseIDNAFail("xn--h79w4z99a.xn--6-tfo"); }
test { try parseIDNAFail("xn--98e.xn--om9c"); }
test { try parseIDNAFail("\xea\xab\xb6\xe1\xa2\x8f\xe0\xb8\xba\xef\xbc\x92.\xf0\x90\x8b\xa2\xdd\x85\xe0\xbe\x9f\xef\xb8\x92"); }
test { try parseIDNAFail("\xea\xab\xb6\xe1\xa2\x8f\xe0\xb8\xba2.\xf0\x90\x8b\xa2\xdd\x85\xe0\xbe\x9f\xe3\x80\x82"); }
test { try parseIDNAFail("xn--2-2zf840fk16m.xn--sob093b2m7s."); }
test { try parseIDNAFail("xn--2-2zf840fk16m.xn--sob093bj62sz9d"); }
test { try parseIDNAFail("\xf3\x85\xb4\xa7\xef\xbd\xa1\xe2\x89\xa0-\xf3\xa0\x99\x84\xe2\xbe\x9b"); }
test { try parseIDNAFail("\xf3\x85\xb4\xa7\xef\xbd\xa1=\xcc\xb8-\xf3\xa0\x99\x84\xe2\xbe\x9b"); }
test { try parseIDNAFail("\xf3\x85\xb4\xa7\xe3\x80\x82\xe2\x89\xa0-\xf3\xa0\x99\x84\xe8\xb5\xb0"); }
test { try parseIDNAFail("\xf3\x85\xb4\xa7\xe3\x80\x82=\xcc\xb8-\xf3\xa0\x99\x84\xe8\xb5\xb0"); }
test { try parseIDNAFail("xn--gm57d.xn----tfo4949b3664m"); }
test { try parseIDNAFail("-\xe2\xbe\x86\xef\xbc\x8e\xea\xab\xb6"); }
test { try parseIDNAFail("-\xe8\x88\x8c.\xea\xab\xb6"); }
test { try parseIDNAFail("xn----ef8c.xn--2v9a"); }
test { try parseIDNAFail("xn--jnd1986v.xn--gdh"); }
test { try parseIDNAFail("\xe7\x92\xbc\xf0\x9d\xa8\xad\xef\xbd\xa1\xe2\x80\x8c\xf3\xa0\x87\x9f"); }
test { try parseIDNAFail("\xe7\x92\xbc\xf0\x9d\xa8\xad\xe3\x80\x82\xe2\x80\x8c\xf3\xa0\x87\x9f"); }
test { try parseIDNAFail("xn--gky8837e.xn--0ug"); }
test { try parseIDNAFail("\xe2\x80\x8c.\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--0ug.xn--0ug"); }
test { try parseIDNAFail("\xe1\x82\xb7\xef\xbc\x8e\xd7\x82\xf0\x91\x84\xb4\xea\xa6\xb7\xf1\x98\x83\xa8"); }
test { try parseIDNAFail("\xe1\x82\xb7\xef\xbc\x8e\xf0\x91\x84\xb4\xd7\x82\xea\xa6\xb7\xf1\x98\x83\xa8"); }
test { try parseIDNAFail("\xe1\x82\xb7.\xf0\x91\x84\xb4\xd7\x82\xea\xa6\xb7\xf1\x98\x83\xa8"); }
test { try parseIDNAFail("\xe2\xb4\x97.\xf0\x91\x84\xb4\xd7\x82\xea\xa6\xb7\xf1\x98\x83\xa8"); }
test { try parseIDNAFail("xn--flj.xn--qdb0605f14ycrms3c"); }
test { try parseIDNAFail("\xe2\xb4\x97\xef\xbc\x8e\xf0\x91\x84\xb4\xd7\x82\xea\xa6\xb7\xf1\x98\x83\xa8"); }
test { try parseIDNAFail("\xe2\xb4\x97\xef\xbc\x8e\xd7\x82\xf0\x91\x84\xb4\xea\xa6\xb7\xf1\x98\x83\xa8"); }
test { try parseIDNAFail("xn--vnd.xn--qdb0605f14ycrms3c"); }
test { try parseIDNAFail("\xe2\x92\x88\xe9\x85\xab\xef\xb8\x92\xe3\x80\x82\xe0\xa3\x96"); }
test { try parseIDNAFail("1.\xe9\x85\xab\xe3\x80\x82\xe3\x80\x82\xe0\xa3\x96"); }
test { try parseIDNAFail("1.xn--8j4a..xn--8zb"); }
test { try parseIDNAFail("xn--tsh4490bfe8c.xn--8zb"); }
test { try parseIDNAFail("\xe2\xb7\xa3\xe2\x80\x8c\xe2\x89\xae\xe1\xa9\xab.\xe2\x80\x8c\xe0\xb8\xba"); }
test { try parseIDNAFail("\xe2\xb7\xa3\xe2\x80\x8c<\xcc\xb8\xe1\xa9\xab.\xe2\x80\x8c\xe0\xb8\xba"); }
test { try parseIDNAFail("xn--uof548an0j.xn--o4c"); }
test { try parseIDNAFail("xn--uof63xk4bf3s.xn--o4c732g"); }
test { try parseIDNAFail("xn--co6h.xn--1-kwssa"); }
test { try parseIDNAFail("xn--co6h.xn--1-h1g429s"); }
test { try parseIDNAFail("xn--co6h.xn--1-h1gs"); }
test { try parseIDNAFail("\xea\xa0\x86\xe3\x80\x82\xf0\xbb\x9a\x8f\xe0\xbe\xb0\xe2\x92\x95"); }
test { try parseIDNAFail("\xea\xa0\x86\xe3\x80\x82\xf0\xbb\x9a\x8f\xe0\xbe\xb014."); }
test { try parseIDNAFail("xn--l98a.xn--14-jsj57880f."); }
test { try parseIDNAFail("xn--l98a.xn--dgd218hhp28d"); }
test { try parseIDNAFail("\xf0\x9d\x9f\xa04\xf3\xa0\x87\x97\xf0\x9d\x88\xbb\xef\xbc\x8e\xe2\x80\x8d\xf0\x90\x8b\xb5\xe2\x9b\xa7\xe2\x80\x8d"); }
test { try parseIDNAFail("84\xf3\xa0\x87\x97\xf0\x9d\x88\xbb.\xe2\x80\x8d\xf0\x90\x8b\xb5\xe2\x9b\xa7\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--84-s850a.xn--1uga573cfq1w"); }
test { try parseIDNAFail("\xf1\xad\x9c\x8e\xe2\x92\x88\xef\xbd\xa1\xe2\x80\x8c\xf0\x9d\x9f\xa4"); }
test { try parseIDNAFail("\xf1\xad\x9c\x8e1.\xe3\x80\x82\xe2\x80\x8c2"); }
test { try parseIDNAFail("xn--1-ex54e..c"); }
test { try parseIDNAFail("xn--1-ex54e..xn--2-rgn"); }
test { try parseIDNAFail("xn--tsh94183d.c"); }
test { try parseIDNAFail("xn--tsh94183d.xn--2-rgn"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xef\xbd\xa1\xc3\x9f\xf0\x91\x93\x83"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xe3\x80\x82\xc3\x9f\xf0\x91\x93\x83"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xe3\x80\x82SS\xf0\x91\x93\x83"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xe3\x80\x82ss\xf0\x91\x93\x83"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xe3\x80\x82Ss\xf0\x91\x93\x83"); }
test { try parseIDNAFail("xn--0ugb.xn--ss-bh7o"); }
test { try parseIDNAFail("xn--0ugb.xn--zca0732l"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xef\xbd\xa1SS\xf0\x91\x93\x83"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xef\xbd\xa1ss\xf0\x91\x93\x83"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8c\xf3\xa0\x86\xaa\xef\xbd\xa1Ss\xf0\x91\x93\x83"); }
test { try parseIDNAFail("\xef\xb8\x92\xe2\x80\x8c\xe3\x83\xb6\xe4\x92\xa9.\xea\xa1\xaa"); }
test { try parseIDNAFail("\xe3\x80\x82\xe2\x80\x8c\xe3\x83\xb6\xe4\x92\xa9.\xea\xa1\xaa"); }
test { try parseIDNAFail(".xn--0ug287dj0o.xn--gd9a"); }
test { try parseIDNAFail("xn--qekw60dns9k.xn--gd9a"); }
test { try parseIDNAFail("xn--0ug287dj0or48o.xn--gd9a"); }
test { try parseIDNAFail("\xe2\x80\x8c\xe2\x92\x88\xf0\xa4\xae\x8d.\xf3\xa2\x93\x8b\xe1\xa9\xa0"); }
test { try parseIDNAFail("\xe2\x80\x8c1.\xf0\xa4\xae\x8d.\xf3\xa2\x93\x8b\xe1\xa9\xa0"); }
test { try parseIDNAFail("1.xn--4x6j.xn--jof45148n"); }
test { try parseIDNAFail("xn--1-rgn.xn--4x6j.xn--jof45148n"); }
test { try parseIDNAFail("xn--tshw462r.xn--jof45148n"); }
test { try parseIDNAFail("xn--0ug88o7471d.xn--jof45148n"); }
test { try parseIDNAFail("\xf0\x9d\x85\xb5\xef\xbd\xa1\xf0\x9d\x9f\xab\xf0\x9e\x80\x88\xe4\xac\xba\xe2\x92\x88"); }
test { try parseIDNAFail(".xn--9-ecp936non25a"); }
test { try parseIDNAFail("xn--3f1h.xn--91-030c1650n."); }
test { try parseIDNAFail("xn--3f1h.xn--9-ecp936non25a"); }
test { try parseIDNAFail("-\xf3\xa0\x85\xb10\xef\xbd\xa1\xe1\x9f\x8f\xe1\xb7\xbd\xed\x86\x87\xec\x8b\xad"); }
test { try parseIDNAFail("-\xf3\xa0\x85\xb10\xef\xbd\xa1\xe1\x9f\x8f\xe1\xb7\xbd\xe1\x84\x90\xe1\x85\xa8\xe1\x86\xaa\xe1\x84\x89\xe1\x85\xb5\xe1\x86\xb8"); }
test { try parseIDNAFail("-\xf3\xa0\x85\xb10\xe3\x80\x82\xe1\x9f\x8f\xe1\xb7\xbd\xed\x86\x87\xec\x8b\xad"); }
test { try parseIDNAFail("-\xf3\xa0\x85\xb10\xe3\x80\x82\xe1\x9f\x8f\xe1\xb7\xbd\xe1\x84\x90\xe1\x85\xa8\xe1\x86\xaa\xe1\x84\x89\xe1\x85\xb5\xe1\x86\xb8"); }
test { try parseIDNAFail("-0.xn--r4e872ah77nghm"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe1\x82\xbf\xe1\x82\xb5\xe1\x83\xa0\xef\xbd\xa1\xe0\xad\x8d"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe1\x82\xbf\xe1\x82\xb5\xe1\x83\xa0\xe3\x80\x82\xe0\xad\x8d"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe2\xb4\x9f\xe2\xb4\x95\xe1\x83\xa0\xe3\x80\x82\xe0\xad\x8d"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe1\x82\xbf\xe1\x82\xb5\xe1\xb2\xa0\xe3\x80\x82\xe0\xad\x8d"); }
test { try parseIDNAFail("xn--1od555l3a.xn--9ic"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe2\xb4\x9f\xe2\xb4\x95\xe1\x83\xa0\xef\xbd\xa1\xe0\xad\x8d"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe1\x82\xbf\xe1\x82\xb5\xe1\xb2\xa0\xef\xbd\xa1\xe0\xad\x8d"); }
test { try parseIDNAFail("xn--tndt4hvw.xn--9ic"); }
test { try parseIDNAFail("xn--1od7wz74eeb.xn--9ic"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe1\x82\xbf\xe2\xb4\x95\xe1\x83\xa0\xe3\x80\x82\xe0\xad\x8d"); }
test { try parseIDNAFail("xn--3nd0etsm92g.xn--9ic"); }
test { try parseIDNAFail("\xe1\x85\x9f\xe1\x82\xbf\xe2\xb4\x95\xe1\x83\xa0\xef\xbd\xa1\xe0\xad\x8d"); }
test { try parseIDNAFail("xn--l96h.xn--o8e4044k"); }
test { try parseIDNAFail("xn--l96h.xn--03e93aq365d"); }
test { try parseIDNAFail("\xf0\x9d\x9f\x9b\xf0\x9d\x86\xaa\xea\xa3\x84\xef\xbd\xa1\xea\xa3\xaa-"); }
test { try parseIDNAFail("\xf0\x9d\x9f\x9b\xea\xa3\x84\xf0\x9d\x86\xaa\xef\xbd\xa1\xea\xa3\xaa-"); }
test { try parseIDNAFail("3\xea\xa3\x84\xf0\x9d\x86\xaa\xe3\x80\x82\xea\xa3\xaa-"); }
test { try parseIDNAFail("xn--3-sl4eu679e.xn----xn4e"); }
test { try parseIDNAFail("\xe1\x84\xb9\xef\xbd\xa1\xe0\xbb\x8a\xf2\xa0\xaf\xa4\xf3\xa0\x84\x9e"); }
test { try parseIDNAFail("\xe1\x84\xb9\xe3\x80\x82\xe0\xbb\x8a\xf2\xa0\xaf\xa4\xf3\xa0\x84\x9e"); }
test { try parseIDNAFail("xn--lrd.xn--s8c05302k"); }
test { try parseIDNAFail("\xe1\x82\xa6\xf2\xbb\xa2\xa9\xef\xbc\x8e\xf3\xa0\x86\xa1\xef\xb8\x89\xf0\x9e\xa4\x8d"); }
test { try parseIDNAFail("\xe1\x82\xa6\xf2\xbb\xa2\xa9.\xf3\xa0\x86\xa1\xef\xb8\x89\xf0\x9e\xa4\x8d"); }
test { try parseIDNAFail("\xe2\xb4\x86\xf2\xbb\xa2\xa9.\xf3\xa0\x86\xa1\xef\xb8\x89\xf0\x9e\xa4\xaf"); }
test { try parseIDNAFail("xn--xkjw3965g.xn--ne6h"); }
test { try parseIDNAFail("\xe2\xb4\x86\xf2\xbb\xa2\xa9\xef\xbc\x8e\xf3\xa0\x86\xa1\xef\xb8\x89\xf0\x9e\xa4\xaf"); }
test { try parseIDNAFail("xn--end82983m.xn--ne6h"); }
test { try parseIDNAFail("\xe2\xb4\x86\xf2\xbb\xa2\xa9.\xf3\xa0\x86\xa1\xef\xb8\x89\xf0\x9e\xa4\x8d"); }
test { try parseIDNAFail("\xe2\xb4\x86\xf2\xbb\xa2\xa9\xef\xbc\x8e\xf3\xa0\x86\xa1\xef\xb8\x89\xf0\x9e\xa4\x8d"); }
test { try parseIDNAFail("\xf1\x97\x9b\xa8.\xf2\x85\x9f\xa2\xf0\x9d\x9f\xa8\xea\xa3\x84"); }
test { try parseIDNAFail("\xf1\x97\x9b\xa8.\xf2\x85\x9f\xa26\xea\xa3\x84"); }
test { try parseIDNAFail("xn--mi60a.xn--6-sl4es8023c"); }
test { try parseIDNAFail("\xf0\x90\x8b\xb8\xf3\xae\x98\x8b\xe1\x83\x82.\xe1\x82\xa1"); }
test { try parseIDNAFail("\xf0\x90\x8b\xb8\xf3\xae\x98\x8b\xe2\xb4\xa2.\xe2\xb4\x81"); }
test { try parseIDNAFail("\xf0\x90\x8b\xb8\xf3\xae\x98\x8b\xe1\x83\x82.\xe2\xb4\x81"); }
test { try parseIDNAFail("xn--qlj1559dr224h.xn--skj"); }
test { try parseIDNAFail("xn--6nd5215jr2u0h.xn--skj"); }
test { try parseIDNAFail("xn--6nd5215jr2u0h.xn--8md"); }
test { try parseIDNAFail("\xf1\x97\x91\xbf\xea\xa0\x86\xe2\x82\x84\xf2\xa9\x9e\x86\xef\xbd\xa1\xf0\xb2\xa9\xa7\xf3\xa0\x92\xb9\xcf\x82"); }
test { try parseIDNAFail("\xf1\x97\x91\xbf\xea\xa0\x864\xf2\xa9\x9e\x86\xe3\x80\x82\xf0\xb2\xa9\xa7\xf3\xa0\x92\xb9\xcf\x82"); }
test { try parseIDNAFail("\xf1\x97\x91\xbf\xea\xa0\x864\xf2\xa9\x9e\x86\xe3\x80\x82\xf0\xb2\xa9\xa7\xf3\xa0\x92\xb9\xce\xa3"); }
test { try parseIDNAFail("\xf1\x97\x91\xbf\xea\xa0\x864\xf2\xa9\x9e\x86\xe3\x80\x82\xf0\xb2\xa9\xa7\xf3\xa0\x92\xb9\xcf\x83"); }
test { try parseIDNAFail("xn--4-w93ej7463a9io5a.xn--4xa31142bk3f0d"); }
test { try parseIDNAFail("xn--4-w93ej7463a9io5a.xn--3xa51142bk3f0d"); }
test { try parseIDNAFail("\xf1\x97\x91\xbf\xea\xa0\x86\xe2\x82\x84\xf2\xa9\x9e\x86\xef\xbd\xa1\xf0\xb2\xa9\xa7\xf3\xa0\x92\xb9\xce\xa3"); }
test { try parseIDNAFail("\xf1\x97\x91\xbf\xea\xa0\x86\xe2\x82\x84\xf2\xa9\x9e\x86\xef\xbd\xa1\xf0\xb2\xa9\xa7\xf3\xa0\x92\xb9\xcf\x83"); }
test { try parseIDNAFail("\xf0\xbe\xa2\xac\xe3\x80\x82\xdc\xa9\xe3\x80\x82\xec\xaf\x995"); }
test { try parseIDNAFail("\xf0\xbe\xa2\xac\xe3\x80\x82\xdc\xa9\xe3\x80\x82\xe1\x84\x8d\xe1\x85\xb3\xe1\x86\xac5"); }
test { try parseIDNAFail("xn--t92s.xn--znb.xn--5-y88f"); }
test { try parseIDNAFail("\xe1\x9f\x8a.\xe2\x80\x8d\xf0\x9d\x9f\xae\xf0\x91\x80\xbf"); }
test { try parseIDNAFail("\xe1\x9f\x8a.\xe2\x80\x8d2\xf0\x91\x80\xbf"); }
test { try parseIDNAFail("xn--m4e.xn--2-ku7i"); }
test { try parseIDNAFail("xn--m4e.xn--2-tgnv469h"); }
test { try parseIDNAFail("\xea\xab\xb6\xe3\x80\x82\xe5\xac\xb6\xc3\x9f\xe8\x91\xbd"); }
test { try parseIDNAFail("\xea\xab\xb6\xe3\x80\x82\xe5\xac\xb6SS\xe8\x91\xbd"); }
test { try parseIDNAFail("\xea\xab\xb6\xe3\x80\x82\xe5\xac\xb6ss\xe8\x91\xbd"); }
test { try parseIDNAFail("\xea\xab\xb6\xe3\x80\x82\xe5\xac\xb6Ss\xe8\x91\xbd"); }
test { try parseIDNAFail("xn--2v9a.xn--ss-q40dp97m"); }
test { try parseIDNAFail("xn--2v9a.xn--zca7637b14za"); }
test { try parseIDNAFail("\xcf\x82\xf0\x91\x90\xbd\xf0\xb5\xa2\x88\xf0\x91\x9c\xab\xef\xbd\xa1\xf0\x9e\xac\xa9\xe2\x80\x8c\xf0\x90\xab\x84"); }
test { try parseIDNAFail("\xcf\x82\xf0\x91\x90\xbd\xf0\xb5\xa2\x88\xf0\x91\x9c\xab\xe3\x80\x82\xf0\x9e\xac\xa9\xe2\x80\x8c\xf0\x90\xab\x84"); }
test { try parseIDNAFail("\xce\xa3\xf0\x91\x90\xbd\xf0\xb5\xa2\x88\xf0\x91\x9c\xab\xe3\x80\x82\xf0\x9e\xac\xa9\xe2\x80\x8c\xf0\x90\xab\x84"); }
test { try parseIDNAFail("\xcf\x83\xf0\x91\x90\xbd\xf0\xb5\xa2\x88\xf0\x91\x9c\xab\xe3\x80\x82\xf0\x9e\xac\xa9\xe2\x80\x8c\xf0\x90\xab\x84"); }
test { try parseIDNAFail("xn--4xa2260lk3b8z15g.xn--tw9ct349a"); }
test { try parseIDNAFail("xn--4xa2260lk3b8z15g.xn--0ug4653g2xzf"); }
test { try parseIDNAFail("xn--3xa4260lk3b8z15g.xn--0ug4653g2xzf"); }
test { try parseIDNAFail("\xce\xa3\xf0\x91\x90\xbd\xf0\xb5\xa2\x88\xf0\x91\x9c\xab\xef\xbd\xa1\xf0\x9e\xac\xa9\xe2\x80\x8c\xf0\x90\xab\x84"); }
test { try parseIDNAFail("\xcf\x83\xf0\x91\x90\xbd\xf0\xb5\xa2\x88\xf0\x91\x9c\xab\xef\xbd\xa1\xf0\x9e\xac\xa9\xe2\x80\x8c\xf0\x90\xab\x84"); }
test { try parseIDNAFail("\xe2\xba\xa2\xf2\x87\xba\x85\xf0\x9d\x9f\xa4\xef\xbd\xa1\xe2\x80\x8d\xf0\x9f\x9a\xb7"); }
test { try parseIDNAFail("\xe2\xba\xa2\xf2\x87\xba\x852\xe3\x80\x82\xe2\x80\x8d\xf0\x9f\x9a\xb7"); }
test { try parseIDNAFail("xn--2-4jtr4282f.xn--m78h"); }
test { try parseIDNAFail("xn--2-4jtr4282f.xn--1ugz946p"); }
test { try parseIDNAFail("\xf0\x9d\xa8\xa5\xe3\x80\x82\xe2\xab\x9f\xf0\x91\x88\xbe"); }
test { try parseIDNAFail("xn--n82h.xn--63iw010f"); }
test { try parseIDNAFail("-\xe1\xa2\x97\xe2\x80\x8c\xf0\x9f\x84\x84.\xf0\x91\x9c\xa2"); }
test { try parseIDNAFail("-\xe1\xa2\x97\xe2\x80\x8c3,.\xf0\x91\x9c\xa2"); }
test { try parseIDNAFail("xn---3,-3eu.xn--9h2d"); }
test { try parseIDNAFail("xn---3,-3eu051c.xn--9h2d"); }
test { try parseIDNAFail("xn----pck1820x.xn--9h2d"); }
test { try parseIDNAFail("xn----pck312bx563c.xn--9h2d"); }
test { try parseIDNAFail("xn--z3e.xn----938f"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf0\x91\x93\x82\xe3\x80\x82\xe2\x92\x88-\xf4\x80\xaa\x9b"); }
test { try parseIDNAFail("\xe2\x80\x8c\xf0\x91\x93\x82\xe3\x80\x821.-\xf4\x80\xaa\x9b"); }
test { try parseIDNAFail("xn--wz1d.1.xn----rg03o"); }
test { try parseIDNAFail("xn--0ugy057g.1.xn----rg03o"); }
test { try parseIDNAFail("xn--wz1d.xn----dcp29674o"); }
test { try parseIDNAFail("xn--0ugy057g.xn----dcp29674o"); }
test { try parseIDNAFail("\xe0\xbe\x94\xea\xa1\x8b-\xef\xbc\x8e-\xf0\x96\xac\xb4"); }
test { try parseIDNAFail("\xe0\xbe\x94\xea\xa1\x8b-.-\xf0\x96\xac\xb4"); }
test { try parseIDNAFail("xn----ukg9938i.xn----4u5m"); }
test { try parseIDNAFail("\xf1\xbf\x92\xb3-\xe2\x8b\xa2\xe2\x80\x8c\xef\xbc\x8e\xe6\xa0\x87-"); }
test { try parseIDNAFail("\xf1\xbf\x92\xb3-\xe2\x8a\x91\xcc\xb8\xe2\x80\x8c\xef\xbc\x8e\xe6\xa0\x87-"); }
test { try parseIDNAFail("\xf1\xbf\x92\xb3-\xe2\x8b\xa2\xe2\x80\x8c.\xe6\xa0\x87-"); }
test { try parseIDNAFail("\xf1\xbf\x92\xb3-\xe2\x8a\x91\xcc\xb8\xe2\x80\x8c.\xe6\xa0\x87-"); }
test { try parseIDNAFail("xn----9mo67451g.xn----qj7b"); }
test { try parseIDNAFail("xn----sgn90kn5663a.xn----qj7b"); }
test { try parseIDNAFail("-\xf1\x95\x89\xb4.\xdb\xa0\xe1\xa2\x9a-"); }
test { try parseIDNAFail("xn----qi38c.xn----jxc827k"); }
test { try parseIDNAFail("\xe3\x80\x82\xd8\xb5\xd9\x89\xe0\xb8\xb7\xd9\x84\xd8\xa7\xe3\x80\x82\xe5\xb2\x93\xe1\xaf\xb2\xf3\xa0\xbe\x83\xe1\xa1\x82"); }
test { try parseIDNAFail(".xn--mgb1a7bt462h.xn--17e10qe61f9r71s"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2\xef\xbc\x8e\xc3\x9f"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2.\xc3\x9f"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2.SS"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2.ss"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2.Ss"); }
test { try parseIDNAFail("xn----9tg11172akr8b.ss"); }
test { try parseIDNAFail("xn----9tg11172akr8b.xn--zca"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2\xef\xbc\x8eSS"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2\xef\xbc\x8ess"); }
test { try parseIDNAFail("\xe1\x80\xb9-\xf0\x9a\xae\xad\xf0\x9f\x9e\xa2\xef\xbc\x8eSs"); }
test { try parseIDNAFail("\xe0\xb5\x8d-\xe2\x80\x8d\xe2\x80\x8c\xef\xbd\xa1\xf1\xa5\x9e\xa7\xe2\x82\x85\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe0\xb5\x8d-\xe2\x80\x8d\xe2\x80\x8c\xef\xbd\xa1\xf1\xa5\x9e\xa7\xe2\x82\x85=\xcc\xb8"); }
test { try parseIDNAFail("\xe0\xb5\x8d-\xe2\x80\x8d\xe2\x80\x8c\xe3\x80\x82\xf1\xa5\x9e\xa75\xe2\x89\xa0"); }
test { try parseIDNAFail("\xe0\xb5\x8d-\xe2\x80\x8d\xe2\x80\x8c\xe3\x80\x82\xf1\xa5\x9e\xa75=\xcc\xb8"); }
test { try parseIDNAFail("xn----jmf.xn--5-ufo50192e"); }
test { try parseIDNAFail("xn----jmf215lda.xn--5-ufo50192e"); }
test { try parseIDNAFail("\xe9\x94\xa3\xe3\x80\x82\xe0\xa9\x8d\xf3\xa0\x98\xbb\xf3\xa0\x9a\x86"); }
test { try parseIDNAFail("xn--gc5a.xn--ybc83044ppga"); }
test { try parseIDNAFail("xn--6-8cb306hms1a.xn--ss-2vq"); }
test { try parseIDNAFail("xn--6-8cb555h2b.xn--ss-2vq"); }
test { try parseIDNAFail("xn--6-8cb555h2b.xn--zca894k"); }
test { try parseIDNAFail("\xf2\x8b\xa1\x90\xef\xbd\xa1\xe2\x89\xaf\xf0\x91\x8b\xaa"); }
test { try parseIDNAFail("\xf2\x8b\xa1\x90\xef\xbd\xa1>\xcc\xb8\xf0\x91\x8b\xaa"); }
test { try parseIDNAFail("\xf2\x8b\xa1\x90\xe3\x80\x82\xe2\x89\xaf\xf0\x91\x8b\xaa"); }
test { try parseIDNAFail("\xf2\x8b\xa1\x90\xe3\x80\x82>\xcc\xb8\xf0\x91\x8b\xaa"); }
test { try parseIDNAFail("xn--eo08b.xn--hdh3385g"); }
test { try parseIDNAFail("\xf3\xa0\x84\x8f\xf0\x96\xac\xb4\xf3\xa0\xb2\xbd\xef\xbd\xa1\xef\xbe\xa0"); }
test { try parseIDNAFail("\xf3\xa0\x84\x8f\xf0\x96\xac\xb4\xf3\xa0\xb2\xbd\xe3\x80\x82\xe1\x85\xa0"); }
test { try parseIDNAFail("xn--619ep9154c."); }
test { try parseIDNAFail("xn--619ep9154c.xn--psd"); }
test { try parseIDNAFail("xn--619ep9154c.xn--cl7c"); }
test { try parseIDNAFail("\xf3\xa0\xad\x94.\xf0\x90\x8b\xb1\xe2\x82\x82"); }
test { try parseIDNAFail("\xf3\xa0\xad\x94.\xf0\x90\x8b\xb12"); }
test { try parseIDNAFail("xn--vi56e.xn--2-w91i"); }
test { try parseIDNAFail("\xe2\xb6\xbf.\xc3\x9f\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\xb6\xbf.SS\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\xb6\xbf.ss\xe2\x80\x8d"); }
test { try parseIDNAFail("\xe2\xb6\xbf.Ss\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--7pj.ss"); }
test { try parseIDNAFail("xn--7pj.xn--ss-n1t"); }
test { try parseIDNAFail("xn--7pj.xn--zca870n"); }
test { try parseIDNAFail("\xe6\xa2\x89\xe3\x80\x82\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--7zv.xn--0ug"); }
test { try parseIDNAFail("\xe4\x83\x9a\xe8\x9f\xa5-\xe3\x80\x82-\xf1\xbd\x92\x98\xe2\x92\x88"); }
test { try parseIDNAFail("\xe4\x83\x9a\xe8\x9f\xa5-\xe3\x80\x82-\xf1\xbd\x92\x981."); }
test { try parseIDNAFail("xn----n50a258u.xn---1-up07j."); }
test { try parseIDNAFail("xn----n50a258u.xn----ecp33805f"); }
test { try parseIDNAFail("\xe1\xa2\x94\xe2\x89\xa0\xf4\x8b\x89\x82.\xe2\x80\x8d\xf0\x90\x8b\xa2"); }
test { try parseIDNAFail("\xe1\xa2\x94=\xcc\xb8\xf4\x8b\x89\x82.\xe2\x80\x8d\xf0\x90\x8b\xa2"); }
test { try parseIDNAFail("xn--ebf031cf7196a.xn--587c"); }
test { try parseIDNAFail("xn--ebf031cf7196a.xn--1ug9540g"); }
test { try parseIDNAFail("\xf3\xa0\xb0\xa9\xf0\x91\xb2\xac\xef\xbc\x8e\xd9\x9c"); }
test { try parseIDNAFail("\xf3\xa0\xb0\xa9\xf0\x91\xb2\xac.\xd9\x9c"); }
test { try parseIDNAFail("xn--sn3d59267c.xn--4hb"); }
test { try parseIDNAFail("\xf0\x90\x8d\xba.\xf1\x9a\x87\x83\xe2\x80\x8c"); }
test { try parseIDNAFail("xn--ie8c.xn--2g51a"); }
test { try parseIDNAFail("xn--ie8c.xn--0ug03366c"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x89\xae\xef\xbc\x8e\xf3\xa0\x9f\xaa\xf0\xb9\xab\x8f-"); }
test { try parseIDNAFail("\xe2\x80\x8d<\xcc\xb8\xef\xbc\x8e\xf3\xa0\x9f\xaa\xf0\xb9\xab\x8f-"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x89\xae.\xf3\xa0\x9f\xaa\xf0\xb9\xab\x8f-"); }
test { try parseIDNAFail("\xe2\x80\x8d<\xcc\xb8.\xf3\xa0\x9f\xaa\xf0\xb9\xab\x8f-"); }
test { try parseIDNAFail("xn--gdh.xn----cr99a1w710b"); }
test { try parseIDNAFail("xn--1ug95g.xn----cr99a1w710b"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8d\xe8\xa5\x94\xe3\x80\x82\xe1\x82\xbc5\xea\xa1\xae\xf1\xb5\x9d\x8f"); }
test { try parseIDNAFail("\xe2\x80\x8d\xe2\x80\x8d\xe8\xa5\x94\xe3\x80\x82\xe2\xb4\x9c5\xea\xa1\xae\xf1\xb5\x9d\x8f"); }
test { try parseIDNAFail("xn--2u2a.xn--5-uws5848bpf44e"); }
test { try parseIDNAFail("xn--1uga7691f.xn--5-uws5848bpf44e"); }
test { try parseIDNAFail("xn--2u2a.xn--5-r1g7167ipfw8d"); }
test { try parseIDNAFail("xn--1uga7691f.xn--5-r1g7167ipfw8d"); }
test { try parseIDNAFail("\xea\xa6\xb9\xe2\x80\x8d\xed\x81\xb7\xf0\xbb\xb6\xa1\xef\xbd\xa1\xe2\x82\x82"); }
test { try parseIDNAFail("\xea\xa6\xb9\xe2\x80\x8d\xe1\x84\x8f\xe1\x85\xb3\xe1\x86\xb2\xf0\xbb\xb6\xa1\xef\xbd\xa1\xe2\x82\x82"); }
test { try parseIDNAFail("xn--0m9as84e2e21c.c"); }
test { try parseIDNAFail("xn--1ug1435cfkyaoi04d.c"); }
test { try parseIDNAFail("\xe2\x89\xa0\xe8\x86\xa3\xe3\x80\x82\xe0\xbe\x83"); }
test { try parseIDNAFail("=\xcc\xb8\xe8\x86\xa3\xe3\x80\x82\xe0\xbe\x83"); }
test { try parseIDNAFail("xn--1chy468a.xn--2ed"); }
test { try parseIDNAFail("\xf0\x90\x8b\xb7\xe3\x80\x82\xe2\x80\x8d"); }
test { try parseIDNAFail("xn--r97c.xn--1ug"); }
test { try parseIDNAFail("\xf0\x91\xb0\xb3\xf0\x91\x88\xaf\xe3\x80\x82\xe2\xa5\xaa"); }
test { try parseIDNAFail("xn--2g1d14o.xn--jti"); }
test { try parseIDNAFail("\xf0\x91\x86\x80\xe4\x81\xb4\xf1\xa4\xa7\xa3\xef\xbc\x8e\xe1\x82\xb5\xf0\x9d\x9f\x9c\xe2\x80\x8c\xcd\x88"); }
test { try parseIDNAFail("\xf0\x91\x86\x80\xe4\x81\xb4\xf1\xa4\xa7\xa3.\xe1\x82\xb54\xe2\x80\x8c\xcd\x88"); }
test { try parseIDNAFail("\xf0\x91\x86\x80\xe4\x81\xb4\xf1\xa4\xa7\xa3.\xe2\xb4\x954\xe2\x80\x8c\xcd\x88"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb5123a"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb502tlsl"); }
test { try parseIDNAFail("\xf0\x91\x86\x80\xe4\x81\xb4\xf1\xa4\xa7\xa3\xef\xbc\x8e\xe2\xb4\x95\xf0\x9d\x9f\x9c\xe2\x80\x8c\xcd\x88"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb324h"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb324h32o"); }

test { try parseIDNAPass("fass.de", "fass.de"); }
test { try parseIDNAPass("fa\xc3\x9f.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("Fa\xc3\x9f.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("xn--fa-hia.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("\xc3\xa0.\xd7\x90\xcc\x88", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("a\xcc\x80.\xd7\x90\xcc\x88", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("A\xcc\x80.\xd7\x90\xcc\x88", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("\xc3\x80.\xd7\x90\xcc\x88", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("xn--0ca.xn--ssa73l", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("\xc3\xa0\xcc\x88.\xd7\x90", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("a\xcc\x80\xcc\x88.\xd7\x90", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("A\xcc\x80\xcc\x88.\xd7\x90", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("\xc3\x80\xcc\x88.\xd7\x90", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("xn--0ca81i.xn--4db", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("ab", "ab"); }
test { try parseIDNAPass("a\xe0\xa5\x8d\xe2\x80\x8cb", "xn--ab-fsf604u"); }
test { try parseIDNAPass("A\xe0\xa5\x8d\xe2\x80\x8cB", "xn--ab-fsf604u"); }
test { try parseIDNAPass("A\xe0\xa5\x8d\xe2\x80\x8cb", "xn--ab-fsf604u"); }
test { try parseIDNAPass("xn--ab-fsf", "xn--ab-fsf"); }
test { try parseIDNAPass("a\xe0\xa5\x8db", "xn--ab-fsf"); }
test { try parseIDNAPass("A\xe0\xa5\x8dB", "xn--ab-fsf"); }
test { try parseIDNAPass("A\xe0\xa5\x8db", "xn--ab-fsf"); }
test { try parseIDNAPass("xn--ab-fsf604u", "xn--ab-fsf604u"); }
test { try parseIDNAPass("a\xe0\xa5\x8d\xe2\x80\x8db", "xn--ab-fsf014u"); }
test { try parseIDNAPass("A\xe0\xa5\x8d\xe2\x80\x8dB", "xn--ab-fsf014u"); }
test { try parseIDNAPass("A\xe0\xa5\x8d\xe2\x80\x8db", "xn--ab-fsf014u"); }
test { try parseIDNAPass("xn--ab-fsf014u", "xn--ab-fsf014u"); }
test { try parseIDNAPass("\xc2\xa1", "xn--7a"); }
test { try parseIDNAPass("xn--7a", "xn--7a"); }
test { try parseIDNAPass("\xe1\xa7\x9a", "xn--pkf"); }
test { try parseIDNAPass("xn--pkf", "xn--pkf"); }
test { try parseIDNAPass("", ""); }
test { try parseIDNAPass("\xe3\x80\x82", "."); }
test { try parseIDNAPass(".", "."); }
test { try parseIDNAPass("\xea\xad\xa0", "xn--3y9a"); }
test { try parseIDNAPass("xn--3y9a", "xn--3y9a"); }
test { try parseIDNAPass("1234567890\xc3\xa41234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("1234567890a\xcc\x881234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("1234567890A\xcc\x881234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("1234567890\xc3\x841234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("xn--12345678901234567890123456789012345678901234567890123456-fxe", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("www.eXample.cOm", "www.example.com"); }
test { try parseIDNAPass("B\xc3\xbccher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("Bu\xcc\x88cher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("bu\xcc\x88cher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("b\xc3\xbccher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("B\xc3\x9cCHER.DE", "xn--bcher-kva.de"); }
test { try parseIDNAPass("BU\xcc\x88CHER.DE", "xn--bcher-kva.de"); }
test { try parseIDNAPass("xn--bcher-kva.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("\xc3\x96BB", "xn--bb-eka"); }
test { try parseIDNAPass("O\xcc\x88BB", "xn--bb-eka"); }
test { try parseIDNAPass("o\xcc\x88bb", "xn--bb-eka"); }
test { try parseIDNAPass("\xc3\xb6bb", "xn--bb-eka"); }
test { try parseIDNAPass("\xc3\x96bb", "xn--bb-eka"); }
test { try parseIDNAPass("O\xcc\x88bb", "xn--bb-eka"); }
test { try parseIDNAPass("xn--bb-eka", "xn--bb-eka"); }
test { try parseIDNAPass("FA\xe1\xba\x9e.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("FA\xe1\xba\x9e.DE", "xn--fa-hia.de"); }
test { try parseIDNAPass("\xce\xb2\xcf\x8c\xce\xbb\xce\xbf\xcf\x82.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("\xce\xb2\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x82.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("\xce\x92\xce\x9f\xcc\x81\xce\x9b\xce\x9f\xce\xa3.COM", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\xce\x92\xce\x8c\xce\x9b\xce\x9f\xce\xa3.COM", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\xce\xb2\xcf\x8c\xce\xbb\xce\xbf\xcf\x83.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\xce\xb2\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x83.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\xce\x92\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x83.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\xce\x92\xcf\x8c\xce\xbb\xce\xbf\xcf\x83.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("xn--nxasmq6b.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\xce\x92\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x82.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("\xce\x92\xcf\x8c\xce\xbb\xce\xbf\xcf\x82.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("xn--nxasmm1c.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("xn--nxasmm1c", "xn--nxasmm1c"); }
test { try parseIDNAPass("\xce\xb2\xcf\x8c\xce\xbb\xce\xbf\xcf\x82", "xn--nxasmm1c"); }
test { try parseIDNAPass("\xce\xb2\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x82", "xn--nxasmm1c"); }
test { try parseIDNAPass("\xce\x92\xce\x9f\xcc\x81\xce\x9b\xce\x9f\xce\xa3", "xn--nxasmq6b"); }
test { try parseIDNAPass("\xce\x92\xce\x8c\xce\x9b\xce\x9f\xce\xa3", "xn--nxasmq6b"); }
test { try parseIDNAPass("\xce\xb2\xcf\x8c\xce\xbb\xce\xbf\xcf\x83", "xn--nxasmq6b"); }
test { try parseIDNAPass("\xce\xb2\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x83", "xn--nxasmq6b"); }
test { try parseIDNAPass("\xce\x92\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x83", "xn--nxasmq6b"); }
test { try parseIDNAPass("\xce\x92\xcf\x8c\xce\xbb\xce\xbf\xcf\x83", "xn--nxasmq6b"); }
test { try parseIDNAPass("xn--nxasmq6b", "xn--nxasmq6b"); }
test { try parseIDNAPass("\xce\x92\xcf\x8c\xce\xbb\xce\xbf\xcf\x82", "xn--nxasmm1c"); }
test { try parseIDNAPass("\xce\x92\xce\xbf\xcc\x81\xce\xbb\xce\xbf\xcf\x82", "xn--nxasmm1c"); }
test { try parseIDNAPass("www.\xe0\xb7\x81\xe0\xb7\x8a\xe2\x80\x8d\xe0\xb6\xbb\xe0\xb7\x93.com", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("WWW.\xe0\xb7\x81\xe0\xb7\x8a\xe2\x80\x8d\xe0\xb6\xbb\xe0\xb7\x93.COM", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("Www.\xe0\xb7\x81\xe0\xb7\x8a\xe2\x80\x8d\xe0\xb6\xbb\xe0\xb7\x93.com", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("www.xn--10cl1a0b.com", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("www.\xe0\xb7\x81\xe0\xb7\x8a\xe0\xb6\xbb\xe0\xb7\x93.com", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("WWW.\xe0\xb7\x81\xe0\xb7\x8a\xe0\xb6\xbb\xe0\xb7\x93.COM", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("Www.\xe0\xb7\x81\xe0\xb7\x8a\xe0\xb6\xbb\xe0\xb7\x93.com", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("www.xn--10cl1a0b660p.com", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("\xd9\x86\xd8\xa7\xd9\x85\xd9\x87\xe2\x80\x8c\xd8\xa7\xdb\x8c", "xn--mgba3gch31f060k"); }
test { try parseIDNAPass("xn--mgba3gch31f", "xn--mgba3gch31f"); }
test { try parseIDNAPass("\xd9\x86\xd8\xa7\xd9\x85\xd9\x87\xd8\xa7\xdb\x8c", "xn--mgba3gch31f"); }
test { try parseIDNAPass("xn--mgba3gch31f060k", "xn--mgba3gch31f060k"); }
test { try parseIDNAPass("xn--mgba3gch31f060k.com", "xn--mgba3gch31f060k.com"); }
test { try parseIDNAPass("\xd9\x86\xd8\xa7\xd9\x85\xd9\x87\xe2\x80\x8c\xd8\xa7\xdb\x8c.com", "xn--mgba3gch31f060k.com"); }
test { try parseIDNAPass("\xd9\x86\xd8\xa7\xd9\x85\xd9\x87\xe2\x80\x8c\xd8\xa7\xdb\x8c.COM", "xn--mgba3gch31f060k.com"); }
test { try parseIDNAPass("xn--mgba3gch31f.com", "xn--mgba3gch31f.com"); }
test { try parseIDNAPass("\xd9\x86\xd8\xa7\xd9\x85\xd9\x87\xd8\xa7\xdb\x8c.com", "xn--mgba3gch31f.com"); }
test { try parseIDNAPass("\xd9\x86\xd8\xa7\xd9\x85\xd9\x87\xd8\xa7\xdb\x8c.COM", "xn--mgba3gch31f.com"); }
test { try parseIDNAPass("a.b\xef\xbc\x8ec\xe3\x80\x82d\xef\xbd\xa1", "a.b.c.d."); }
test { try parseIDNAPass("a.b.c\xe3\x80\x82d\xe3\x80\x82", "a.b.c.d."); }
test { try parseIDNAPass("A.B.C\xe3\x80\x82D\xe3\x80\x82", "a.b.c.d."); }
test { try parseIDNAPass("A.b.c\xe3\x80\x82D\xe3\x80\x82", "a.b.c.d."); }
test { try parseIDNAPass("a.b.c.d.", "a.b.c.d."); }
test { try parseIDNAPass("A.B\xef\xbc\x8eC\xe3\x80\x82D\xef\xbd\xa1", "a.b.c.d."); }
test { try parseIDNAPass("A.b\xef\xbc\x8ec\xe3\x80\x82D\xef\xbd\xa1", "a.b.c.d."); }
test { try parseIDNAPass("U\xcc\x88.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xc3\x9c.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xc3\xbc.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("u\xcc\x88.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\xcc\x88.XN--TDA", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xc3\x9c.XN--TDA", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xc3\x9c.xn--Tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\xcc\x88.xn--Tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("xn--tda.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xc3\xbc.\xc3\xbc", "xn--tda.xn--tda"); }
test { try parseIDNAPass("u\xcc\x88.u\xcc\x88", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\xcc\x88.U\xcc\x88", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xc3\x9c.\xc3\x9c", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xc3\x9c.\xc3\xbc", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\xcc\x88.u\xcc\x88", "xn--tda.xn--tda"); }
test { try parseIDNAPass("a1.com", "a1.com"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e\xe3\x80\x82\xef\xbc\xaa\xef\xbc\xb0", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e\xe3\x80\x82JP", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e\xe3\x80\x82jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e\xe3\x80\x82Jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("xn--wgv71a119e.jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e.jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e.JP", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e.Jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e\xe3\x80\x82\xef\xbd\x8a\xef\xbd\x90", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe6\x97\xa5\xe6\x9c\xac\xe8\xaa\x9e\xe3\x80\x82\xef\xbc\xaa\xef\xbd\x90", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\xe2\x98\x95", "xn--53h"); }
test { try parseIDNAPass("xn--53h", "xn--53h"); }
test { try parseIDNAPass("1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.assbcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\xc5\x9dssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.assbcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\xcc\x82ssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.ASSBCSSSSSSSSD\xce\xa3\xce\xa3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSSS\xcc\x82SSZ", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.ASSBCSSSSSSSSD\xce\xa3\xce\xa3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSS\xc5\x9cSSZ", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.Assbcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\xc5\x9dssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.Assbcssssssssd\xcf\x83\xcf\x83ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\xcc\x82ssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("xn--bss", "xn--bss"); }
test { try parseIDNAPass("\xe5\xa4\x99", "xn--bss"); }
test { try parseIDNAPass("\xcb\xa3\xcd\x8f\xe2\x84\x95\xe2\x80\x8b\xef\xb9\xa3\xc2\xad\xef\xbc\x8d\xe1\xa0\x8c\xe2\x84\xac\xef\xb8\x80\xc5\xbf\xe2\x81\xa4\xf0\x9d\x94\xb0\xf3\xa0\x87\xaf\xef\xac\x84", "xn--bssffl"); }
test { try parseIDNAPass("x\xcd\x8fN\xe2\x80\x8b-\xc2\xad-\xe1\xa0\x8cB\xef\xb8\x80s\xe2\x81\xa4s\xf3\xa0\x87\xafffl", "xn--bssffl"); }
test { try parseIDNAPass("x\xcd\x8fn\xe2\x80\x8b-\xc2\xad-\xe1\xa0\x8cb\xef\xb8\x80s\xe2\x81\xa4s\xf3\xa0\x87\xafffl", "xn--bssffl"); }
test { try parseIDNAPass("X\xcd\x8fN\xe2\x80\x8b-\xc2\xad-\xe1\xa0\x8cB\xef\xb8\x80S\xe2\x81\xa4S\xf3\xa0\x87\xafFFL", "xn--bssffl"); }
test { try parseIDNAPass("X\xcd\x8fn\xe2\x80\x8b-\xc2\xad-\xe1\xa0\x8cB\xef\xb8\x80s\xe2\x81\xa4s\xf3\xa0\x87\xafffl", "xn--bssffl"); }
test { try parseIDNAPass("xn--bssffl", "xn--bssffl"); }
test { try parseIDNAPass("\xe5\xa4\xa1\xe5\xa4\x9e\xe5\xa4\x9c\xe5\xa4\x99", "xn--bssffl"); }
test { try parseIDNAPass("\xcb\xa3\xcd\x8f\xe2\x84\x95\xe2\x80\x8b\xef\xb9\xa3\xc2\xad\xef\xbc\x8d\xe1\xa0\x8c\xe2\x84\xac\xef\xb8\x80S\xe2\x81\xa4\xf0\x9d\x94\xb0\xf3\xa0\x87\xafFFL", "xn--bssffl"); }
test { try parseIDNAPass("x\xcd\x8fN\xe2\x80\x8b-\xc2\xad-\xe1\xa0\x8cB\xef\xb8\x80S\xe2\x81\xa4s\xf3\xa0\x87\xafFFL", "xn--bssffl"); }
test { try parseIDNAPass("\xcb\xa3\xcd\x8f\xe2\x84\x95\xe2\x80\x8b\xef\xb9\xa3\xc2\xad\xef\xbc\x8d\xe1\xa0\x8c\xe2\x84\xac\xef\xb8\x80s\xe2\x81\xa4\xf0\x9d\x94\xb0\xf3\xa0\x87\xafffl", "xn--bssffl"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("\xc3\xa41234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("a\xcc\x881234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("A\xcc\x881234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("\xc3\x841234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("xn--1234567890123456789012345678901234567890123456789012345-9te", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\xa4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x84123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\xa4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x84123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\xa4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901C", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x84123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901C", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\xa41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x841234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\xa41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x841234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\xa41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x841234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("a.b..-q--a-.e", "a.b..-q--a-.e"); }
test { try parseIDNAPass("a.b..-q--\xc3\xa4-.e", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("a.b..-q--a\xcc\x88-.e", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.B..-Q--A\xcc\x88-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.B..-Q--\xc3\x84-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.b..-Q--\xc3\x84-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.b..-Q--A\xcc\x88-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("a.b..xn---q----jra.e", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("a..c", "a..c"); }
test { try parseIDNAPass("a.-b.", "a.-b."); }
test { try parseIDNAPass("a.b-.c", "a.b-.c"); }
test { try parseIDNAPass("a.-.c", "a.-.c"); }
test { try parseIDNAPass("a.bc--de.f", "a.bc--de.f"); }
test { try parseIDNAPass("\xc3\xa4.\xc2\xad.c", "xn--4ca..c"); }
test { try parseIDNAPass("a\xcc\x88.\xc2\xad.c", "xn--4ca..c"); }
test { try parseIDNAPass("A\xcc\x88.\xc2\xad.C", "xn--4ca..c"); }
test { try parseIDNAPass("\xc3\x84.\xc2\xad.C", "xn--4ca..c"); }
test { try parseIDNAPass("xn--4ca..c", "xn--4ca..c"); }
test { try parseIDNAPass("\xc3\xa4.-b.", "xn--4ca.-b."); }
test { try parseIDNAPass("a\xcc\x88.-b.", "xn--4ca.-b."); }
test { try parseIDNAPass("A\xcc\x88.-B.", "xn--4ca.-b."); }
test { try parseIDNAPass("\xc3\x84.-B.", "xn--4ca.-b."); }
test { try parseIDNAPass("xn--4ca.-b.", "xn--4ca.-b."); }
test { try parseIDNAPass("\xc3\xa4.b-.c", "xn--4ca.b-.c"); }
test { try parseIDNAPass("a\xcc\x88.b-.c", "xn--4ca.b-.c"); }
test { try parseIDNAPass("A\xcc\x88.B-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("\xc3\x84.B-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("\xc3\x84.b-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("A\xcc\x88.b-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("xn--4ca.b-.c", "xn--4ca.b-.c"); }
test { try parseIDNAPass("\xc3\xa4.-.c", "xn--4ca.-.c"); }
test { try parseIDNAPass("a\xcc\x88.-.c", "xn--4ca.-.c"); }
test { try parseIDNAPass("A\xcc\x88.-.C", "xn--4ca.-.c"); }
test { try parseIDNAPass("\xc3\x84.-.C", "xn--4ca.-.c"); }
test { try parseIDNAPass("xn--4ca.-.c", "xn--4ca.-.c"); }
test { try parseIDNAPass("\xc3\xa4.bc--de.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("a\xcc\x88.bc--de.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("A\xcc\x88.BC--DE.F", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("\xc3\x84.BC--DE.F", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("\xc3\x84.bc--De.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("A\xcc\x88.bc--De.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("xn--4ca.bc--de.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("A0", "a0"); }
test { try parseIDNAPass("0A", "0a"); }
test { try parseIDNAPass("\xd7\x90\xd7\x87", "xn--vdbr"); }
test { try parseIDNAPass("xn--vdbr", "xn--vdbr"); }
test { try parseIDNAPass("\xd7\x909\xd7\x87", "xn--9-ihcz"); }
test { try parseIDNAPass("xn--9-ihcz", "xn--9-ihcz"); }
test { try parseIDNAPass("\xd7\x90\xd7\xaa", "xn--4db6c"); }
test { try parseIDNAPass("xn--4db6c", "xn--4db6c"); }
test { try parseIDNAPass("\xd7\x90\xd7\xb3\xd7\xaa", "xn--4db6c0a"); }
test { try parseIDNAPass("xn--4db6c0a", "xn--4db6c0a"); }
test { try parseIDNAPass("\xd7\x907\xd7\xaa", "xn--7-zhc3f"); }
test { try parseIDNAPass("xn--7-zhc3f", "xn--7-zhc3f"); }
test { try parseIDNAPass("\xd7\x90\xd9\xa7\xd7\xaa", "xn--4db6c6t"); }
test { try parseIDNAPass("xn--4db6c6t", "xn--4db6c6t"); }
test { try parseIDNAPass("\xe0\xae\xb9\xe0\xaf\x8d\xe2\x80\x8d", "xn--dmc4b194h"); }
test { try parseIDNAPass("xn--dmc4b", "xn--dmc4b"); }
test { try parseIDNAPass("\xe0\xae\xb9\xe0\xaf\x8d", "xn--dmc4b"); }
test { try parseIDNAPass("xn--dmc4b194h", "xn--dmc4b194h"); }
test { try parseIDNAPass("xn--dmc", "xn--dmc"); }
test { try parseIDNAPass("\xe0\xae\xb9", "xn--dmc"); }
test { try parseIDNAPass("\xe0\xae\xb9\xe0\xaf\x8d\xe2\x80\x8c", "xn--dmc4by94h"); }
test { try parseIDNAPass("xn--dmc4by94h", "xn--dmc4by94h"); }
test { try parseIDNAPass("\xd9\x84\xd9\xb0\xe2\x80\x8c\xdb\xad\xdb\xaf", "xn--ghb2gxqia7523a"); }
test { try parseIDNAPass("xn--ghb2gxqia", "xn--ghb2gxqia"); }
test { try parseIDNAPass("\xd9\x84\xd9\xb0\xdb\xad\xdb\xaf", "xn--ghb2gxqia"); }
test { try parseIDNAPass("xn--ghb2gxqia7523a", "xn--ghb2gxqia7523a"); }
test { try parseIDNAPass("\xd9\x84\xd9\xb0\xe2\x80\x8c\xdb\xaf", "xn--ghb2g3qq34f"); }
test { try parseIDNAPass("xn--ghb2g3q", "xn--ghb2g3q"); }
test { try parseIDNAPass("\xd9\x84\xd9\xb0\xdb\xaf", "xn--ghb2g3q"); }
test { try parseIDNAPass("xn--ghb2g3qq34f", "xn--ghb2g3qq34f"); }
test { try parseIDNAPass("\xd9\x84\xe2\x80\x8c\xdb\xad\xdb\xaf", "xn--ghb25aga828w"); }
test { try parseIDNAPass("xn--ghb25aga", "xn--ghb25aga"); }
test { try parseIDNAPass("\xd9\x84\xdb\xad\xdb\xaf", "xn--ghb25aga"); }
test { try parseIDNAPass("xn--ghb25aga828w", "xn--ghb25aga828w"); }
test { try parseIDNAPass("\xd9\x84\xe2\x80\x8c\xdb\xaf", "xn--ghb65a953d"); }
test { try parseIDNAPass("xn--ghb65a", "xn--ghb65a"); }
test { try parseIDNAPass("\xd9\x84\xdb\xaf", "xn--ghb65a"); }
test { try parseIDNAPass("xn--ghb65a953d", "xn--ghb65a953d"); }
test { try parseIDNAPass("xn--ghb2gxq", "xn--ghb2gxq"); }
test { try parseIDNAPass("\xd9\x84\xd9\xb0\xdb\xad", "xn--ghb2gxq"); }
test { try parseIDNAPass("xn--cmba", "xn--cmba"); }
test { try parseIDNAPass("\xdb\xaf\xdb\xaf", "xn--cmba"); }
test { try parseIDNAPass("xn--ghb", "xn--ghb"); }
test { try parseIDNAPass("\xd9\x84", "xn--ghb"); }
test { try parseIDNAPass("a\xe3\x80\x82\xe3\x80\x82b", "a..b"); }
test { try parseIDNAPass("A\xe3\x80\x82\xe3\x80\x82B", "a..b"); }
test { try parseIDNAPass("a..b", "a..b"); }
test { try parseIDNAPass("..xn--skb", "..xn--skb"); }
test { try parseIDNAPass("$", "$"); }
test { try parseIDNAPass("\xe2\x91\xb7.four", "(4).four"); }
test { try parseIDNAPass("(4).four", "(4).four"); }
test { try parseIDNAPass("\xe2\x91\xb7.FOUR", "(4).four"); }
test { try parseIDNAPass("\xe2\x91\xb7.Four", "(4).four"); }
test { try parseIDNAPass("ascii", "ascii"); }
test { try parseIDNAPass("unicode.org", "unicode.org"); }
test { try parseIDNAPass("\xef\xa5\x91\xf0\xaf\xa1\xa8\xf0\xaf\xa1\xb4\xf0\xaf\xa4\x9f\xf0\xaf\xa5\x9f\xf0\xaf\xa6\xbf", "xn--snl253bgitxhzwu2arn60c"); }
test { try parseIDNAPass("\xe9\x99\x8b\xe3\x9b\xbc\xe5\xbd\x93\xf0\xa4\x8e\xab\xe7\xab\xae\xe4\x97\x97", "xn--snl253bgitxhzwu2arn60c"); }
test { try parseIDNAPass("xn--snl253bgitxhzwu2arn60c", "xn--snl253bgitxhzwu2arn60c"); }
test { try parseIDNAPass("\xe9\x9b\xbb\xf0\xa1\x8d\xaa\xe5\xbc\xb3\xe4\x8e\xab\xe7\xaa\xae\xe4\xb5\x97", "xn--kbo60w31ob3z6t3av9z5b"); }
test { try parseIDNAPass("xn--kbo60w31ob3z6t3av9z5b", "xn--kbo60w31ob3z6t3av9z5b"); }
test { try parseIDNAPass("xn--A-1ga", "xn--a-1ga"); }
test { try parseIDNAPass("a\xc3\xb6", "xn--a-1ga"); }
test { try parseIDNAPass("ao\xcc\x88", "xn--a-1ga"); }
test { try parseIDNAPass("AO\xcc\x88", "xn--a-1ga"); }
test { try parseIDNAPass("A\xc3\x96", "xn--a-1ga"); }
test { try parseIDNAPass("A\xc3\xb6", "xn--a-1ga"); }
test { try parseIDNAPass("Ao\xcc\x88", "xn--a-1ga"); }
test { try parseIDNAPass("\xef\xbc\x9d\xcc\xb8", "xn--1ch"); }
test { try parseIDNAPass("\xe2\x89\xa0", "xn--1ch"); }
test { try parseIDNAPass("=\xcc\xb8", "xn--1ch"); }
test { try parseIDNAPass("xn--1ch", "xn--1ch"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x84123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x84123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x88123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x84123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x841234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x841234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\xcc\x881234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc3\x841234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("\xea\xa1\xa3.\xdf\x8f", "xn--8c9a.xn--qsb"); }
test { try parseIDNAPass("xn--8c9a.xn--qsb", "xn--8c9a.xn--qsb"); }
test { try parseIDNAPass("xn--jbf911clb.xn----p9j493ivi4l", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("\xe2\x89\xa0\xe1\xa2\x99\xe2\x89\xaf.\xec\x86\xa3-\xe1\xa1\xb4\xe2\xb4\x80", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("=\xcc\xb8\xe1\xa2\x99>\xcc\xb8.\xe1\x84\x89\xe1\x85\xa9\xe1\x86\xbe-\xe1\xa1\xb4\xe2\xb4\x80", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("=\xcc\xb8\xe1\xa2\x99>\xcc\xb8.\xe1\x84\x89\xe1\x85\xa9\xe1\x86\xbe-\xe1\xa1\xb4\xe1\x82\xa0", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("\xe2\x89\xa0\xe1\xa2\x99\xe2\x89\xaf.\xec\x86\xa3-\xe1\xa1\xb4\xe1\x82\xa0", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("xn--gl0as212a.i.", "xn--gl0as212a.i."); }
test { try parseIDNAPass("\xe7\xb9\xb1\xf0\x91\x96\xbf.i.", "xn--gl0as212a.i."); }
test { try parseIDNAPass("\xe7\xb9\xb1\xf0\x91\x96\xbf.I.", "xn--gl0as212a.i."); }
test { try parseIDNAPass("xn--1ug6928ac48e.i.", "xn--1ug6928ac48e.i."); }
test { try parseIDNAPass("\xe7\xb9\xb1\xf0\x91\x96\xbf\xe2\x80\x8d.i.", "xn--1ug6928ac48e.i."); }
test { try parseIDNAPass("\xe7\xb9\xb1\xf0\x91\x96\xbf\xe2\x80\x8d.I.", "xn--1ug6928ac48e.i."); }
test { try parseIDNAPass("xn--ss-59d.", "xn--ss-59d."); }
test { try parseIDNAPass("ss\xdb\xab.", "xn--ss-59d."); }
test { try parseIDNAPass("SS\xdb\xab.", "xn--ss-59d."); }
test { try parseIDNAPass("Ss\xdb\xab.", "xn--ss-59d."); }
test { try parseIDNAPass("\xf0\x9e\xa4\xb7.\xf0\x90\xae\x90\xf0\x9e\xa2\x81\xf0\x90\xb9\xa0\xd8\xa4", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xb7.\xf0\x90\xae\x90\xf0\x9e\xa2\x81\xf0\x90\xb9\xa0\xd9\x88\xd9\x94", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x95.\xf0\x90\xae\x90\xf0\x9e\xa2\x81\xf0\x90\xb9\xa0\xd9\x88\xd9\x94", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x95.\xf0\x90\xae\x90\xf0\x9e\xa2\x81\xf0\x90\xb9\xa0\xd8\xa4", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("xn--ve6h.xn--jgb1694kz0b2176a", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xa5\xf3\xa0\x85\xae\xef\xbc\x8e\xe1\xa1\x84\xe1\x82\xae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xa5\xf3\xa0\x85\xae.\xe1\xa1\x84\xe1\x82\xae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xa5\xf3\xa0\x85\xae.\xe1\xa1\x84\xe2\xb4\x8e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x83\xf3\xa0\x85\xae.\xe1\xa1\x84\xe1\x82\xae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x83\xf3\xa0\x85\xae.\xe1\xa1\x84\xe2\xb4\x8e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("xn--de6h.xn--37e857h", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xa5.\xe1\xa1\x84\xe2\xb4\x8e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x83.\xe1\xa1\x84\xe1\x82\xae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x83.\xe1\xa1\x84\xe2\xb4\x8e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xa5\xf3\xa0\x85\xae\xef\xbc\x8e\xe1\xa1\x84\xe2\xb4\x8e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x83\xf3\xa0\x85\xae\xef\xbc\x8e\xe1\xa1\x84\xe1\x82\xae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x83\xf3\xa0\x85\xae\xef\xbc\x8e\xe1\xa1\x84\xe2\xb4\x8e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xa5.\xe1\xa1\x84\xe1\x82\xae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("xn--ej0b.xn----d87b", "xn--ej0b.xn----d87b"); }
test { try parseIDNAPass("xn----1fa1788k.", "xn----1fa1788k."); }
test { try parseIDNAPass("xn--9ob.xn--4xa", "xn--9ob.xn--4xa"); }
test { try parseIDNAPass("\xdd\x96.\xcf\x83", "xn--9ob.xn--4xa"); }
test { try parseIDNAPass("\xdd\x96.\xce\xa3", "xn--9ob.xn--4xa"); }
test { try parseIDNAPass("\xc3\x9f\xef\xbd\xa1\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xc3\x9f\xe3\x80\x82\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xc3\x9f\xe3\x80\x82\xf0\x90\x8b\xb3\xe2\xb4\x8c\xe0\xbe\xb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("SS\xe3\x80\x82\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss\xe3\x80\x82\xf0\x90\x8b\xb3\xe2\xb4\x8c\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("Ss\xe3\x80\x82\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss.xn--lgd921mvv0m", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss.\xf0\x90\x8b\xb3\xe2\xb4\x8c\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("SS.\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("Ss.\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("xn--zca.xn--lgd921mvv0m", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xc3\x9f.\xf0\x90\x8b\xb3\xe2\xb4\x8c\xe0\xbe\xb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xc3\x9f\xef\xbd\xa1\xf0\x90\x8b\xb3\xe2\xb4\x8c\xe0\xbe\xb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("SS\xef\xbd\xa1\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss\xef\xbd\xa1\xf0\x90\x8b\xb3\xe2\xb4\x8c\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("Ss\xef\xbd\xa1\xf0\x90\x8b\xb3\xe1\x82\xac\xe0\xbe\xb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xe1\x9a\xad\xef\xbd\xa1\xf0\x9d\x8c\xa0\xc3\x9f\xf0\x96\xab\xb1", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\xe1\x9a\xad\xe3\x80\x82\xf0\x9d\x8c\xa0\xc3\x9f\xf0\x96\xab\xb1", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\xe1\x9a\xad\xe3\x80\x82\xf0\x9d\x8c\xa0SS\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\xe1\x9a\xad\xe3\x80\x82\xf0\x9d\x8c\xa0ss\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\xe1\x9a\xad\xe3\x80\x82\xf0\x9d\x8c\xa0Ss\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("xn--hwe.xn--ss-ci1ub261a", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\xe1\x9a\xad.\xf0\x9d\x8c\xa0ss\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\xe1\x9a\xad.\xf0\x9d\x8c\xa0SS\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\xe1\x9a\xad.\xf0\x9d\x8c\xa0Ss\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("xn--hwe.xn--zca4946pblnc", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\xe1\x9a\xad.\xf0\x9d\x8c\xa0\xc3\x9f\xf0\x96\xab\xb1", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\xe1\x9a\xad\xef\xbd\xa1\xf0\x9d\x8c\xa0SS\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\xe1\x9a\xad\xef\xbd\xa1\xf0\x9d\x8c\xa0ss\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\xe1\x9a\xad\xef\xbd\xa1\xf0\x9d\x8c\xa0Ss\xf0\x96\xab\xb1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("xn--09e4694e..xn--ye6h", "xn--09e4694e..xn--ye6h"); }
test { try parseIDNAPass("xn--1-o7j0610f..xn----381i", "xn--1-o7j0610f..xn----381i"); }
test { try parseIDNAPass("1.xn----zw5a.xn--kp5b", "1.xn----zw5a.xn--kp5b"); }
test { try parseIDNAPass("-\xf0\x90\x8b\xb7\xf0\x96\xbe\x91\xe3\x80\x82\xf3\xa0\x86\xac", "xn----991iq40y."); }
test { try parseIDNAPass("xn----991iq40y.", "xn----991iq40y."); }
test { try parseIDNAPass(".xn--hdh", ".xn--hdh"); }
test { try parseIDNAPass("\xf0\x9e\xa5\x93\xef\xbc\x8e\xdc\x98", "xn--of6h.xn--inb"); }
test { try parseIDNAPass("\xf0\x9e\xa5\x93.\xdc\x98", "xn--of6h.xn--inb"); }
test { try parseIDNAPass("xn--of6h.xn--inb", "xn--of6h.xn--inb"); }
test { try parseIDNAPass("\xf3\xa0\x84\xbd-\xef\xbc\x8e-\xe0\xb7\x8a", "-.xn----ptf"); }
test { try parseIDNAPass("\xf3\xa0\x84\xbd-.-\xe0\xb7\x8a", "-.xn----ptf"); }
test { try parseIDNAPass("-.xn----ptf", "-.xn----ptf"); }
test { try parseIDNAPass("\xe1\x82\xba\xf0\x90\x8b\xb8\xf3\xa0\x84\x84\xe3\x80\x82\xf0\x9d\x9f\x9d\xed\x9f\xb6\xe1\x80\xba", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\xe1\x82\xba\xf0\x90\x8b\xb8\xf3\xa0\x84\x84\xe3\x80\x825\xed\x9f\xb6\xe1\x80\xba", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\xe2\xb4\x9a\xf0\x90\x8b\xb8\xf3\xa0\x84\x84\xe3\x80\x825\xed\x9f\xb6\xe1\x80\xba", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("xn--ilj2659d.xn--5-dug9054m", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\xe2\xb4\x9a\xf0\x90\x8b\xb8.5\xed\x9f\xb6\xe1\x80\xba", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\xe1\x82\xba\xf0\x90\x8b\xb8.5\xed\x9f\xb6\xe1\x80\xba", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\xe2\xb4\x9a\xf0\x90\x8b\xb8\xf3\xa0\x84\x84\xe3\x80\x82\xf0\x9d\x9f\x9d\xed\x9f\xb6\xe1\x80\xba", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\xe2\x89\xa0.\xe1\xa0\xbf", "xn--1ch.xn--y7e"); }
test { try parseIDNAPass("=\xcc\xb8.\xe1\xa0\xbf", "xn--1ch.xn--y7e"); }
test { try parseIDNAPass("xn--1ch.xn--y7e", "xn--1ch.xn--y7e"); }
test { try parseIDNAPass("\xdc\xa3\xd6\xa3\xef\xbd\xa1\xe3\x8c\xaa", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("\xdc\xa3\xd6\xa3\xe3\x80\x82\xe3\x83\x8f\xe3\x82\xa4\xe3\x83\x84", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("xn--ucb18e.xn--eck4c5a", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("\xdc\xa3\xd6\xa3.\xe3\x83\x8f\xe3\x82\xa4\xe3\x83\x84", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("xn--skb", "xn--skb"); }
test { try parseIDNAPass("\xda\xb9", "xn--skb"); }
test { try parseIDNAPass("\xe2\x89\xaf1.\xe3\x80\x82\xc3\x9f", "xn--1-ogo..xn--zca"); }
test { try parseIDNAPass(">\xcc\xb81.\xe3\x80\x82\xc3\x9f", "xn--1-ogo..xn--zca"); }
test { try parseIDNAPass(">\xcc\xb81.\xe3\x80\x82SS", "xn--1-ogo..ss"); }
test { try parseIDNAPass("\xe2\x89\xaf1.\xe3\x80\x82SS", "xn--1-ogo..ss"); }
test { try parseIDNAPass("\xe2\x89\xaf1.\xe3\x80\x82ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass(">\xcc\xb81.\xe3\x80\x82ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass(">\xcc\xb81.\xe3\x80\x82Ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass("\xe2\x89\xaf1.\xe3\x80\x82Ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass("xn--1-ogo..ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass("xn--1-ogo..xn--zca", "xn--1-ogo..xn--zca"); }
test { try parseIDNAPass(".xn--1ch", ".xn--1ch"); }
test { try parseIDNAPass("\xea\xa1\x86\xe3\x80\x82\xe2\x86\x83\xe0\xbe\xb5\xeb\x86\xae-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xea\xa1\x86\xe3\x80\x82\xe2\x86\x83\xe0\xbe\xb5\xe1\x84\x82\xe1\x85\xaa\xe1\x87\x81-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xea\xa1\x86\xe3\x80\x82\xe2\x86\x84\xe0\xbe\xb5\xe1\x84\x82\xe1\x85\xaa\xe1\x87\x81-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xea\xa1\x86\xe3\x80\x82\xe2\x86\x84\xe0\xbe\xb5\xeb\x86\xae-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("xn--fc9a.xn----qmg097k469k", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xc3\x9f\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa08\xe2\x82\x85", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("\xc3\x9f\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa085", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("SS\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("ss\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("Ss\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("xn--ss-e2f077r.xn--85-psd", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("ss\xe0\xa7\x81\xe1\xb7\xad.\xd8\xa085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("SS\xe0\xa7\x81\xe1\xb7\xad.\xd8\xa085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("Ss\xe0\xa7\x81\xe1\xb7\xad.\xd8\xa085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("xn--zca266bwrr.xn--85-psd", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("\xc3\x9f\xe0\xa7\x81\xe1\xb7\xad.\xd8\xa085", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("SS\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa08\xe2\x82\x85", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("ss\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa08\xe2\x82\x85", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("Ss\xe0\xa7\x81\xe1\xb7\xad\xe3\x80\x82\xd8\xa08\xe2\x82\x85", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("\xef\xb8\x8d\xe0\xaa\x9b\xe3\x80\x82\xe5\xb5\xa8", "xn--6dc.xn--tot"); }
test { try parseIDNAPass("xn--6dc.xn--tot", "xn--6dc.xn--tot"); }
test { try parseIDNAPass("\xe0\xaa\x9b.\xe5\xb5\xa8", "xn--6dc.xn--tot"); }
test { try parseIDNAPass("\xef\xb8\x85\xe3\x80\x82\xe3\x80\x82\xf0\xa6\x80\xbe\xe1\xb3\xa0", "..xn--t6f5138v"); }
test { try parseIDNAPass("..xn--t6f5138v", "..xn--t6f5138v"); }
test { try parseIDNAPass("xn--t6f5138v", "xn--t6f5138v"); }
test { try parseIDNAPass("\xf0\xa6\x80\xbe\xe1\xb3\xa0", "xn--t6f5138v"); }
test { try parseIDNAPass("xn--p8e.xn--1ch3a7084l", "xn--p8e.xn--1ch3a7084l"); }
test { try parseIDNAPass("\xe1\xa1\x99.\xe2\x89\xaf\xf0\x90\x8b\xb2\xe2\x89\xa0", "xn--p8e.xn--1ch3a7084l"); }
test { try parseIDNAPass("\xe1\xa1\x99.>\xcc\xb8\xf0\x90\x8b\xb2=\xcc\xb8", "xn--p8e.xn--1ch3a7084l"); }
test { try parseIDNAPass("-3.xn--fbf115j", "-3.xn--fbf115j"); }
test { try parseIDNAPass("xn--u4e969b.xn--1ch", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\xe2\x85\x8e\xe1\x9f\x92.\xe2\x89\xa0", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\xe2\x85\x8e\xe1\x9f\x92.=\xcc\xb8", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\xe2\x84\xb2\xe1\x9f\x92.=\xcc\xb8", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\xe2\x84\xb2\xe1\x9f\x92.\xe2\x89\xa0", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("xn----zmb.1-", "xn----zmb.1-"); }
test { try parseIDNAPass("xn--8,-g9oy26fzu4d.xn--kmb6733w", "xn--8,-g9oy26fzu4d.xn--kmb6733w"); }
test { try parseIDNAPass("xn--9-mfs8024b.", "xn--9-mfs8024b."); }
test { try parseIDNAPass("9\xe9\x9a\x81\xe2\xaf\xae.", "xn--9-mfs8024b."); }
test { try parseIDNAPass("xn--2ib43l.xn--te6h", "xn--2ib43l.xn--te6h"); }
test { try parseIDNAPass("\xd9\xbd\xe0\xa5\x83.\xf0\x9e\xa4\xb5", "xn--2ib43l.xn--te6h"); }
test { try parseIDNAPass("\xd9\xbd\xe0\xa5\x83.\xf0\x9e\xa4\x93", "xn--2ib43l.xn--te6h"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x80\xe1\xae\xaa\xe0\xa3\xb6\xef\xbc\x8e\xeb\x88\xb5", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x80\xe1\xae\xaa\xe0\xa3\xb6\xef\xbc\x8e\xe1\x84\x82\xe1\x85\xaf\xe1\x86\xbc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x80\xe1\xae\xaa\xe0\xa3\xb6.\xeb\x88\xb5", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x80\xe1\xae\xaa\xe0\xa3\xb6.\xe1\x84\x82\xe1\x85\xaf\xe1\x86\xbc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x8f\xe1\xae\xaa\xe0\xa3\xb6.\xe1\x84\x82\xe1\x85\xaf\xe1\x86\xbc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x8f\xe1\xae\xaa\xe0\xa3\xb6.\xeb\x88\xb5", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("xn--s5a04sn4u297k.xn--2e1b", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x8f\xe1\xae\xaa\xe0\xa3\xb6\xef\xbc\x8e\xe1\x84\x82\xe1\x85\xaf\xe1\x86\xbc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xea\xa7\x90\xd3\x8f\xe1\xae\xaa\xe0\xa3\xb6\xef\xbc\x8e\xeb\x88\xb5", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("xn--9hb7344k.", "xn--9hb7344k."); }
test { try parseIDNAPass("\xf0\x90\xab\x87\xd9\xa1.", "xn--9hb7344k."); }
test { try parseIDNAPass("\xe1\xa1\x8c.\xe3\x80\x82\xe1\xa2\x91", "xn--c8e..xn--bbf"); }
test { try parseIDNAPass("xn--c8e..xn--bbf", "xn--c8e..xn--bbf"); }
test { try parseIDNAPass("\xe3\x80\x82\xe3\x80\x82\xe1\x82\xa3\xe2\x89\xaf", "..xn--hdh782b"); }
test { try parseIDNAPass("\xe3\x80\x82\xe3\x80\x82\xe1\x82\xa3>\xcc\xb8", "..xn--hdh782b"); }
test { try parseIDNAPass("\xe3\x80\x82\xe3\x80\x82\xe2\xb4\x83>\xcc\xb8", "..xn--hdh782b"); }
test { try parseIDNAPass("\xe3\x80\x82\xe3\x80\x82\xe2\xb4\x83\xe2\x89\xaf", "..xn--hdh782b"); }
test { try parseIDNAPass("..xn--hdh782b", "..xn--hdh782b"); }
test { try parseIDNAPass("\xdf\xa5.\xda\xb5", "xn--dtb.xn--okb"); }
test { try parseIDNAPass("xn--dtb.xn--okb", "xn--dtb.xn--okb"); }
test { try parseIDNAPass(".xn--3e6h", ".xn--3e6h"); }
test { try parseIDNAPass("xn--3e6h", "xn--3e6h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xbf", "xn--3e6h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x9d", "xn--3e6h"); }
test { try parseIDNAPass("\xda\xb9\xef\xbc\x8e\xe1\xa1\xb3\xe1\x85\x9f", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("\xda\xb9.\xe1\xa1\xb3\xe1\x85\x9f", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("xn--skb.xn--g9e", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("\xda\xb9.\xe1\xa1\xb3", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("\xe3\xa8\x9b\xf0\x98\xb1\x8e.\xe3\x80\x827\xe0\xb4\x81", "xn--mbm8237g..xn--7-7hf"); }
test { try parseIDNAPass("xn--mbm8237g..xn--7-7hf", "xn--mbm8237g..xn--7-7hf"); }
test { try parseIDNAPass("xn--ss-4epx629f.xn--ifh802b6a", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("ss\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe2\xb4\xa1\xe2\xb4\x96", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("SS\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe1\x83\x81\xe1\x82\xb6", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("Ss\xea\xab\xb6\xe1\xa2\xa5.\xe2\x8a\xb6\xe1\x83\x81\xe2\xb4\x96", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("-.", "-."); }
test { try parseIDNAPass("xn----zmb.xn--rlj2573p", "xn----zmb.xn--rlj2573p"); }
test { try parseIDNAPass("\xe2\x89\xa0\xe3\x80\x82\xf0\x9f\x9e\xb3\xf0\x9d\x9f\xb2", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("=\xcc\xb8\xe3\x80\x82\xf0\x9f\x9e\xb3\xf0\x9d\x9f\xb2", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("\xe2\x89\xa0\xe3\x80\x82\xf0\x9f\x9e\xb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("=\xcc\xb8\xe3\x80\x82\xf0\x9f\x9e\xb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("xn--1ch.xn--6-dl4s", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("\xe2\x89\xa0.\xf0\x9f\x9e\xb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("=\xcc\xb8.\xf0\x9f\x9e\xb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass(".j", ".j"); }
test { try parseIDNAPass("j", "j"); }
test { try parseIDNAPass("xn--rt6a.", "xn--rt6a."); }
test { try parseIDNAPass("\xe9\xb1\x8a.", "xn--rt6a."); }
test { try parseIDNAPass("xn--4-0bd15808a.", "xn--4-0bd15808a."); }
test { try parseIDNAPass("\xf0\x9e\xa4\xba\xdf\x8c4.", "xn--4-0bd15808a."); }
test { try parseIDNAPass("\xf0\x9e\xa4\x98\xdf\x8c4.", "xn--4-0bd15808a."); }
test { try parseIDNAPass("-\xef\xbd\xa1\xe4\x8f\x9b", "-.xn--xco"); }
test { try parseIDNAPass("-\xe3\x80\x82\xe4\x8f\x9b", "-.xn--xco"); }
test { try parseIDNAPass("-.xn--xco", "-.xn--xco"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95\xe2\x89\xaf\xc3\x9f", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95>\xcc\xb8\xc3\x9f", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885\xe2\x89\xaf\xc3\x9f", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885>\xcc\xb8\xc3\x9f", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885>\xcc\xb8SS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885\xe2\x89\xafSS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885\xe2\x89\xafss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885>\xcc\xb8ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885>\xcc\xb8Ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe8\x88\x8c.\xea\xa1\x885\xe2\x89\xafSs", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("xn--tc1a.xn--5ss-3m2a5009e", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("xn--tc1a.xn--5-qfa988w745i", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95>\xcc\xb8SS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95\xe2\x89\xafSS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95\xe2\x89\xafss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95>\xcc\xb8ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95>\xcc\xb8Ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xe2\xbe\x86\xef\xbc\x8e\xea\xa1\x88\xef\xbc\x95\xe2\x89\xafSs", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xaa.\xcf\x82", "xn--ie6h.xn--3xa"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x88.\xce\xa3", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xaa.\xcf\x83", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x88.\xcf\x83", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("xn--ie6h.xn--4xa", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x88.\xcf\x82", "xn--ie6h.xn--3xa"); }
test { try parseIDNAPass("xn--ie6h.xn--3xa", "xn--ie6h.xn--3xa"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xaa.\xce\xa3", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("xn--ilj.xn--4xa", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\xe2\xb4\x9a.\xcf\x83", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\xe1\x82\xba.\xce\xa3", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\xe2\xb4\x9a.\xcf\x82", "xn--ilj.xn--3xa"); }
test { try parseIDNAPass("\xe1\x82\xba.\xcf\x82", "xn--ilj.xn--3xa"); }
test { try parseIDNAPass("xn--ilj.xn--3xa", "xn--ilj.xn--3xa"); }
test { try parseIDNAPass("\xe1\x82\xba.\xcf\x83", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\xe6\xb7\xbd\xe3\x80\x82\xe1\xa0\xbe", "xn--34w.xn--x7e"); }
test { try parseIDNAPass("xn--34w.xn--x7e", "xn--34w.xn--x7e"); }
test { try parseIDNAPass("\xe6\xb7\xbd.\xe1\xa0\xbe", "xn--34w.xn--x7e"); }
test { try parseIDNAPass("..", ".."); }
test { try parseIDNAPass("xn---3-p9o.ss--", "xn---3-p9o.ss--"); }
test { try parseIDNAPass("51..xn--8-ogo", "51..xn--8-ogo"); }
test { try parseIDNAPass("\xea\xa1\xa0\xef\xbc\x8e\xdb\xb2", "xn--5c9a.xn--fmb"); }
test { try parseIDNAPass("\xea\xa1\xa0.\xdb\xb2", "xn--5c9a.xn--fmb"); }
test { try parseIDNAPass("xn--5c9a.xn--fmb", "xn--5c9a.xn--fmb"); }
test { try parseIDNAPass("1.2h", "1.2h"); }
test { try parseIDNAPass("xn--skjy82u.xn--gdh", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\xe2\xb4\x81\xe7\x95\x9d.\xe2\x89\xae", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\xe2\xb4\x81\xe7\x95\x9d.<\xcc\xb8", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\xe1\x82\xa1\xe7\x95\x9d.<\xcc\xb8", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\xe1\x82\xa1\xe7\x95\x9d.\xe2\x89\xae", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\xf0\x9f\x95\xbc\xef\xbc\x8e\xef\xbe\xa0", "xn--my8h."); }
test { try parseIDNAPass("\xf0\x9f\x95\xbc.\xe1\x85\xa0", "xn--my8h."); }
test { try parseIDNAPass("xn--my8h.", "xn--my8h."); }
test { try parseIDNAPass("\xf0\x9f\x95\xbc.", "xn--my8h."); }
test { try parseIDNAPass("\xcf\x82\xe1\x83\x85\xe3\x80\x82\xdd\x9a", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("\xcf\x82\xe2\xb4\xa5\xe3\x80\x82\xdd\x9a", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("\xce\xa3\xe1\x83\x85\xe3\x80\x82\xdd\x9a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\xcf\x83\xe2\xb4\xa5\xe3\x80\x82\xdd\x9a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\xce\xa3\xe2\xb4\xa5\xe3\x80\x82\xdd\x9a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("xn--4xa203s.xn--epb", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\xcf\x83\xe2\xb4\xa5.\xdd\x9a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\xce\xa3\xe1\x83\x85.\xdd\x9a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\xce\xa3\xe2\xb4\xa5.\xdd\x9a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("xn--3xa403s.xn--epb", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("\xcf\x82\xe2\xb4\xa5.\xdd\x9a", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("xn--vkb.xn--08e172a", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\xda\xbc.\xe1\xba\x8f\xe1\xa1\xa4", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\xda\xbc.y\xcc\x87\xe1\xa1\xa4", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\xda\xbc.Y\xcc\x87\xe1\xa1\xa4", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\xda\xbc.\xe1\xba\x8e\xe1\xa1\xa4", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("xn--pt9c.xn--0kjya", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xf0\x90\xa9\x97.\xe2\xb4\x89\xe2\xb4\x95", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xf0\x90\xa9\x97.\xe1\x82\xa9\xe1\x82\xb5", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xf0\x90\xa9\x97.\xe1\x82\xa9\xe2\xb4\x95", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xf0\xb2\xa4\xb120.\xe9\x9f\xb3.\xea\xa1\xa61.", "xn--20-9802c.xn--0w5a.xn--1-eg4e."); }
test { try parseIDNAPass("xn--20-9802c.xn--0w5a.xn--1-eg4e.", "xn--20-9802c.xn--0w5a.xn--1-eg4e."); }
test { try parseIDNAPass("\xe1\x82\xb5\xe3\x80\x82\xdb\xb0\xe2\x89\xae\xc3\x9f\xdd\x85", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\xe1\x82\xb5\xe3\x80\x82\xdb\xb0<\xcc\xb8\xc3\x9f\xdd\x85", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\xe2\xb4\x95\xe3\x80\x82\xdb\xb0<\xcc\xb8\xc3\x9f\xdd\x85", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\xe2\xb4\x95\xe3\x80\x82\xdb\xb0\xe2\x89\xae\xc3\x9f\xdd\x85", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\xe1\x82\xb5\xe3\x80\x82\xdb\xb0\xe2\x89\xaeSS\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe1\x82\xb5\xe3\x80\x82\xdb\xb0<\xcc\xb8SS\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe2\xb4\x95\xe3\x80\x82\xdb\xb0<\xcc\xb8ss\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe2\xb4\x95\xe3\x80\x82\xdb\xb0\xe2\x89\xaess\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe1\x82\xb5\xe3\x80\x82\xdb\xb0\xe2\x89\xaeSs\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe1\x82\xb5\xe3\x80\x82\xdb\xb0<\xcc\xb8Ss\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("xn--dlj.xn--ss-jbe65aw27i", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe2\xb4\x95.\xdb\xb0\xe2\x89\xaess\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe2\xb4\x95.\xdb\xb0<\xcc\xb8ss\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe1\x82\xb5.\xdb\xb0<\xcc\xb8SS\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe1\x82\xb5.\xdb\xb0\xe2\x89\xaeSS\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe1\x82\xb5.\xdb\xb0\xe2\x89\xaeSs\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\xe1\x82\xb5.\xdb\xb0<\xcc\xb8Ss\xdd\x85", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("xn--dlj.xn--zca912alh227g", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\xe2\xb4\x95.\xdb\xb0\xe2\x89\xae\xc3\x9f\xdd\x85", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\xe2\xb4\x95.\xdb\xb0<\xcc\xb8\xc3\x9f\xdd\x85", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("xn--ge6h.xn--oc9a", "xn--ge6h.xn--oc9a"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xa8.\xea\xa1\x8f", "xn--ge6h.xn--oc9a"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x86.\xea\xa1\x8f", "xn--ge6h.xn--oc9a"); }
test { try parseIDNAPass(".xn--ss--bi1b", ".xn--ss--bi1b"); }
test { try parseIDNAPass("\xe9\xbd\x99--\xf0\x9d\x9f\xb0.\xc3\x9f", "xn----4-p16k.xn--zca"); }
test { try parseIDNAPass("\xe9\xbd\x99--4.\xc3\x9f", "xn----4-p16k.xn--zca"); }
test { try parseIDNAPass("\xe9\xbd\x99--4.SS", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\xe9\xbd\x99--4.ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\xe9\xbd\x99--4.Ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("xn----4-p16k.ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("xn----4-p16k.xn--zca", "xn----4-p16k.xn--zca"); }
test { try parseIDNAPass("\xe9\xbd\x99--\xf0\x9d\x9f\xb0.SS", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\xe9\xbd\x99--\xf0\x9d\x9f\xb0.ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\xe9\xbd\x99--\xf0\x9d\x9f\xb0.Ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("xn--9-i0j5967eg3qz.ss", "xn--9-i0j5967eg3qz.ss"); }
test { try parseIDNAPass("\xf0\xb2\xae\x9a9\xea\x8d\xa9\xe1\x9f\x93.ss", "xn--9-i0j5967eg3qz.ss"); }
test { try parseIDNAPass("\xf0\xb2\xae\x9a9\xea\x8d\xa9\xe1\x9f\x93.SS", "xn--9-i0j5967eg3qz.ss"); }
test { try parseIDNAPass("\xea\x97\xb7\xf0\x91\x86\x80.\xdd\x9d\xf0\x90\xa9\x92", "xn--ju8a625r.xn--hpb0073k"); }
test { try parseIDNAPass("xn--ju8a625r.xn--hpb0073k", "xn--ju8a625r.xn--hpb0073k"); }
test { try parseIDNAPass("xn----3vs.xn--0kj", "xn----3vs.xn--0kj"); }
test { try parseIDNAPass("\xcf\x82.\xd9\x81\xd9\x85\xd9\x8a\xf0\x9f\x9e\x9b1.", "xn--3xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("\xce\xa3.\xd9\x81\xd9\x85\xd9\x8a\xf0\x9f\x9e\x9b1.", "xn--4xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("\xcf\x83.\xd9\x81\xd9\x85\xd9\x8a\xf0\x9f\x9e\x9b1.", "xn--4xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("xn--4xa.xn--1-gocmu97674d.", "xn--4xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("xn--3xa.xn--1-gocmu97674d.", "xn--3xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass(".xn--hva754s.", ".xn--hva754s."); }
test { try parseIDNAPass("xn--hva754s.", "xn--hva754s."); }
test { try parseIDNAPass("\xe2\xb4\x96\xcd\xa6.", "xn--hva754s."); }
test { try parseIDNAPass("\xe1\x82\xb6\xcd\xa6.", "xn--hva754s."); }
test { try parseIDNAPass("xn--hzb.xn--ukj4430l", "xn--hzb.xn--ukj4430l"); }
test { try parseIDNAPass("\xe0\xa2\xbb.\xe2\xb4\x83\xf0\x9e\x80\x92", "xn--hzb.xn--ukj4430l"); }
test { try parseIDNAPass("\xe0\xa2\xbb.\xe1\x82\xa3\xf0\x9e\x80\x92", "xn--hzb.xn--ukj4430l"); }
test { try parseIDNAPass("\xf3\xa0\x86\x93\xe2\x9b\x8f-\xe3\x80\x82\xea\xa1\x92", "xn----o9p.xn--rc9a"); }
test { try parseIDNAPass("xn----o9p.xn--rc9a", "xn----o9p.xn--rc9a"); }
test { try parseIDNAPass("xn--p9ut19m.xn----mck373i", "xn--p9ut19m.xn----mck373i"); }
test { try parseIDNAPass("\xe6\x94\x8c\xea\xaf\xad.\xe1\xa2\x96-\xe2\xb4\x98", "xn--p9ut19m.xn----mck373i"); }
test { try parseIDNAPass("\xe6\x94\x8c\xea\xaf\xad.\xe1\xa2\x96-\xe1\x82\xb8", "xn--p9ut19m.xn----mck373i"); }
test { try parseIDNAPass("xn--9r8a.16.xn--3-nyc0117m", "xn--9r8a.16.xn--3-nyc0117m"); }
test { try parseIDNAPass("\xea\x96\xa8.16.3\xed\x88\x92\xdb\xb3", "xn--9r8a.16.xn--3-nyc0117m"); }
test { try parseIDNAPass("\xea\x96\xa8.16.3\xe1\x84\x90\xe1\x85\xad\xe1\x86\xa9\xdb\xb3", "xn--9r8a.16.xn--3-nyc0117m"); }
test { try parseIDNAPass("xn--1-5bt6845n.", "xn--1-5bt6845n."); }
test { try parseIDNAPass("1\xf0\x9d\xa8\x99\xe2\xb8\x96.", "xn--1-5bt6845n."); }
test { try parseIDNAPass(".1.xn--9-ogo", ".1.xn--9-ogo"); }
test { try parseIDNAPass("xn--ss-f4j.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("ss\xe1\x80\xba.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("SS\xe1\x80\xba.B.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("Ss\xe1\x80\xba.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("SS\xe1\x80\xba.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf\xef\xbc\x8e\xc3\x9f\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--zca216edt0r"); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf.\xc3\x9f\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--zca216edt0r"); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf.SS\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf.ss\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("xn--clb2593k.xn--ss-toj6092t", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("xn--clb2593k.xn--zca216edt0r", "xn--clb2593k.xn--zca216edt0r"); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf\xef\xbc\x8eSS\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf\xef\xbc\x8ess\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf.Ss\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\xdb\x8c\xf0\x90\xa8\xbf\xef\xbc\x8eSs\xe0\xbe\x84\xf0\x91\x8d\xac", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("xn--8-ngo.", "xn--8-ngo."); }
test { try parseIDNAPass("8\xe2\x89\xae.", "xn--8-ngo."); }
test { try parseIDNAPass("8<\xcc\xb8.", "xn--8-ngo."); }
test { try parseIDNAPass("\xe7\xbe\x9a\xef\xbd\xa1\xe2\x89\xaf", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\xe7\xbe\x9a\xef\xbd\xa1>\xcc\xb8", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\xe7\xbe\x9a\xe3\x80\x82\xe2\x89\xaf", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\xe7\xbe\x9a\xe3\x80\x82>\xcc\xb8", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("xn--xt0a.xn--hdh", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\xe7\xbe\x9a.\xe2\x89\xaf", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\xe7\xbe\x9a.>\xcc\xb8", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass(".xn--ye6h", ".xn--ye6h"); }
test { try parseIDNAPass("xn--ye6h", "xn--ye6h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\xba", "xn--ye6h"); }
test { try parseIDNAPass("\xf0\x9e\xa4\x98", "xn--ye6h"); }
test { try parseIDNAPass("\xf0\x9d\x9f\x9b\xef\xbc\x8e\xef\xa7\xb8", "3.xn--6vz"); }
test { try parseIDNAPass("\xf0\x9d\x9f\x9b\xef\xbc\x8e\xe7\xac\xa0", "3.xn--6vz"); }
test { try parseIDNAPass("3.\xe7\xac\xa0", "3.xn--6vz"); }
test { try parseIDNAPass("3.xn--6vz", "3.xn--6vz"); }
test { try parseIDNAPass("-.xn--mlj8559d", "-.xn--mlj8559d"); }
test { try parseIDNAPass("xn--1ch.", "xn--1ch."); }
test { try parseIDNAPass("\xe2\x89\xa0.", "xn--1ch."); }
test { try parseIDNAPass("=\xcc\xb8.", "xn--1ch."); }
test { try parseIDNAPass("-\xe3\x80\x82\xe3\x80\x82", "-.."); }
test { try parseIDNAPass("-..", "-.."); }
test { try parseIDNAPass(".f", ".f"); }
test { try parseIDNAPass("f", "f"); }
test { try parseIDNAPass("xn--9bm.ss", "xn--9bm.ss"); }
test { try parseIDNAPass("\xe3\xa8\xb2.ss", "xn--9bm.ss"); }
test { try parseIDNAPass("\xe3\xa8\xb2.SS", "xn--9bm.ss"); }
test { try parseIDNAPass("\xe3\xa8\xb2.Ss", "xn--9bm.ss"); }
test { try parseIDNAPass("\xf0\x9d\x9f\x8e\xe3\x80\x82\xe7\x94\xaf", "0.xn--qny"); }
test { try parseIDNAPass("0\xe3\x80\x82\xe7\x94\xaf", "0.xn--qny"); }
test { try parseIDNAPass("0.xn--qny", "0.xn--qny"); }
test { try parseIDNAPass("0.\xe7\x94\xaf", "0.xn--qny"); }
test { try parseIDNAPass("-\xef\xbd\xa1\xe1\xa2\x98", "-.xn--ibf"); }
test { try parseIDNAPass("-\xe3\x80\x82\xe1\xa2\x98", "-.xn--ibf"); }
test { try parseIDNAPass("-.xn--ibf", "-.xn--ibf"); }
test { try parseIDNAPass("\xf0\x9f\x82\xb4\xe1\x82\xab.\xe2\x89\xae", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("\xf0\x9f\x82\xb4\xe1\x82\xab.<\xcc\xb8", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("\xf0\x9f\x82\xb4\xe2\xb4\x8b.<\xcc\xb8", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("\xf0\x9f\x82\xb4\xe2\xb4\x8b.\xe2\x89\xae", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("xn--2kj7565l.xn--gdh", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("xn--gky8837e.", "xn--gky8837e."); }
test { try parseIDNAPass("\xe7\x92\xbc\xf0\x9d\xa8\xad.", "xn--gky8837e."); }
test { try parseIDNAPass("xn--157b.xn--gnb", "xn--157b.xn--gnb"); }
test { try parseIDNAPass("\xed\x8a\x9b.\xdc\x96", "xn--157b.xn--gnb"); }
test { try parseIDNAPass("\xe1\x84\x90\xe1\x85\xb1\xe1\x87\x82.\xdc\x96", "xn--157b.xn--gnb"); }
test { try parseIDNAPass("xn--84-s850a.xn--59h6326e", "xn--84-s850a.xn--59h6326e"); }
test { try parseIDNAPass("84\xf0\x9d\x88\xbb.\xf0\x90\x8b\xb5\xe2\x9b\xa7", "xn--84-s850a.xn--59h6326e"); }
test { try parseIDNAPass("\xe2\x89\xae\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96\xc3\x9f\xe2\x89\xaf", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\xcc\xb8\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96\xc3\x9f>\xcc\xb8", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("\xe2\x89\xae7.\xe8\xac\x96\xc3\x9f\xe2\x89\xaf", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\xcc\xb87.\xe8\xac\x96\xc3\x9f>\xcc\xb8", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\xcc\xb87.\xe8\xac\x96SS>\xcc\xb8", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\xe2\x89\xae7.\xe8\xac\x96SS\xe2\x89\xaf", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\xe2\x89\xae7.\xe8\xac\x96ss\xe2\x89\xaf", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\xcc\xb87.\xe8\xac\x96ss>\xcc\xb8", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\xcc\xb87.\xe8\xac\x96Ss>\xcc\xb8", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\xe2\x89\xae7.\xe8\xac\x96Ss\xe2\x89\xaf", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("xn--7-mgo.xn--ss-xjvv174c", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("xn--7-mgo.xn--zca892oly5e", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\xcc\xb8\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96SS>\xcc\xb8", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\xe2\x89\xae\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96SS\xe2\x89\xaf", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\xe2\x89\xae\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96ss\xe2\x89\xaf", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\xcc\xb8\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96ss>\xcc\xb8", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\xcc\xb8\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96Ss>\xcc\xb8", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\xe2\x89\xae\xf0\x9d\x9f\x95\xef\xbc\x8e\xe8\xac\x96Ss\xe2\x89\xaf", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass(".xn--ss-bh7o", ".xn--ss-bh7o"); }
test { try parseIDNAPass("xn--ss-bh7o", "xn--ss-bh7o"); }
test { try parseIDNAPass("ss\xf0\x91\x93\x83", "xn--ss-bh7o"); }
test { try parseIDNAPass("SS\xf0\x91\x93\x83", "xn--ss-bh7o"); }
test { try parseIDNAPass("Ss\xf0\x91\x93\x83", "xn--ss-bh7o"); }
test { try parseIDNAPass(".xn--qekw60d.xn--gd9a", ".xn--qekw60d.xn--gd9a"); }
test { try parseIDNAPass("xn--qekw60d.xn--gd9a", "xn--qekw60d.xn--gd9a"); }
test { try parseIDNAPass("\xe3\x83\xb6\xe4\x92\xa9.\xea\xa1\xaa", "xn--qekw60d.xn--gd9a"); }
test { try parseIDNAPass("\xf0\x9d\x85\xb5\xe3\x80\x829\xf0\x9e\x80\x88\xe4\xac\xba1.", ".xn--91-030c1650n."); }
test { try parseIDNAPass(".xn--91-030c1650n.", ".xn--91-030c1650n."); }
test { try parseIDNAPass("xn--8c1a.xn--2ib8jn539l", "xn--8c1a.xn--2ib8jn539l"); }
test { try parseIDNAPass("\xe8\x88\x9b.\xd9\xbd\xf0\x9e\xa4\xb4\xda\xbb", "xn--8c1a.xn--2ib8jn539l"); }
test { try parseIDNAPass("\xe8\x88\x9b.\xd9\xbd\xf0\x9e\xa4\x92\xda\xbb", "xn--8c1a.xn--2ib8jn539l"); }
test { try parseIDNAPass("\xe1\x9e\xb4.\xec\xae\x87-", ".xn----938f"); }
test { try parseIDNAPass("\xe1\x9e\xb4.\xe1\x84\x8d\xe1\x85\xb0\xe1\x86\xae-", ".xn----938f"); }
test { try parseIDNAPass(".xn----938f", ".xn----938f"); }
test { try parseIDNAPass(".xn--hcb32bni", ".xn--hcb32bni"); }
test { try parseIDNAPass("xn--hcb32bni", "xn--hcb32bni"); }
test { try parseIDNAPass("\xda\xbd\xd9\xa3\xd6\x96", "xn--hcb32bni"); }
test { try parseIDNAPass("\xe1\xa2\x8c\xef\xbc\x8e-\xe0\xa1\x9a", "xn--59e.xn----5jd"); }
test { try parseIDNAPass("\xe1\xa2\x8c.-\xe0\xa1\x9a", "xn--59e.xn----5jd"); }
test { try parseIDNAPass("xn--59e.xn----5jd", "xn--59e.xn----5jd"); }
test { try parseIDNAPass("xn--8gb2338k.xn--lhb0154f", "xn--8gb2338k.xn--lhb0154f"); }
test { try parseIDNAPass("\xd8\xbd\xf0\x91\x88\xbe.\xd9\x89\xea\xa4\xab", "xn--8gb2338k.xn--lhb0154f"); }
test { try parseIDNAPass("\xe1\x83\x81\xe1\x82\xb16\xcc\x98\xe3\x80\x82\xc3\x9f\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("\xe2\xb4\xa1\xe2\xb4\x916\xcc\x98\xe3\x80\x82\xc3\x9f\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("\xe1\x83\x81\xe1\x82\xb16\xcc\x98\xe3\x80\x82SS\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\xe2\xb4\xa1\xe2\xb4\x916\xcc\x98\xe3\x80\x82ss\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\xe1\x83\x81\xe2\xb4\x916\xcc\x98\xe3\x80\x82Ss\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("xn--6-8cb7433a2ba.xn--ss-2vq", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\xe2\xb4\xa1\xe2\xb4\x916\xcc\x98.ss\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\xe1\x83\x81\xe1\x82\xb16\xcc\x98.SS\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\xe1\x83\x81\xe2\xb4\x916\xcc\x98.Ss\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("xn--6-8cb7433a2ba.xn--zca894k", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("\xe2\xb4\xa1\xe2\xb4\x916\xcc\x98.\xc3\x9f\xe1\xac\x83", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("xn--7zv.", "xn--7zv."); }
test { try parseIDNAPass("\xe6\xa2\x89.", "xn--7zv."); }
test { try parseIDNAPass("xn--iwb.ss", "xn--iwb.ss"); }
test { try parseIDNAPass("\xe0\xa1\x93.ss", "xn--iwb.ss"); }
test { try parseIDNAPass("\xe0\xa1\x93.SS", "xn--iwb.ss"); }
test { try parseIDNAPass("-\xef\xbd\xa1\xe2\xba\x90", "-.xn--6vj"); }
test { try parseIDNAPass("-\xe3\x80\x82\xe2\xba\x90", "-.xn--6vj"); }
test { try parseIDNAPass("-.xn--6vj", "-.xn--6vj"); }
test { try parseIDNAPass("xn--ix9c26l.xn--q0s", "xn--ix9c26l.xn--q0s"); }
test { try parseIDNAPass("\xf0\x90\xab\x9c\xf0\x91\x8c\xbc.\xe5\xa9\x80", "xn--ix9c26l.xn--q0s"); }
test { try parseIDNAPass("\xf0\x90\xab\x80\xef\xbc\x8e\xda\x89\xf0\x91\x8c\x80", "xn--pw9c.xn--fjb8658k"); }
test { try parseIDNAPass("\xf0\x90\xab\x80.\xda\x89\xf0\x91\x8c\x80", "xn--pw9c.xn--fjb8658k"); }
test { try parseIDNAPass("xn--pw9c.xn--fjb8658k", "xn--pw9c.xn--fjb8658k"); }
test { try parseIDNAPass("xn--r97c.", "xn--r97c."); }
test { try parseIDNAPass("\xf0\x90\x8b\xb7.", "xn--r97c."); }
