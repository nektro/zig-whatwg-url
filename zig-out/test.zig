const std = @import("std");
const url = @import("url");
const expect = @import("expect").expect;

// zig fmt: off

pub fn parseFail(input: []const u8, base: ?[]const u8) !void {
    const allocator = std.testing.allocator;
    _ = url.URL.parse(allocator, input, base) catch |err| switch (err) {
        error.SkipZigTest => |e| return e,
        else => return,
    };
    return error.FailZigTest;
}

pub fn parsePass(input: []const u8, base: ?[]const u8, href: []const u8, origin: []const u8, protocol: []const u8, username: []const u8, password: []const u8, host: []const u8, hostname: []const u8, port: []const u8, pathname: []const u8, search: []const u8, hash: []const u8) !void {
    const allocator = std.testing.allocator;
    const u = try url.URL.parse(allocator, input, base);
    defer allocator.free(u.href);
    _ = href;
    _ = origin;
    _ = protocol;
    _ = username;
    _ = password;
    _ = host;
    _ = hostname;
    _ = port;
    _ = pathname;
    _ = search;
    _ = hash;
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
test { try parseFail("https://\xfffd", null); }
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
test { try parseFail("file://\xad/p", null); }
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
test { try parseFail("http://\xd83d\xdca9.123/", null); }
test { try parseFail("https://\x00y", null); }
test { try parseFail("https://\xffffy", null); }
test { try parseFail("", null); }
test { try parseFail("https://\xad/", null); }
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
test { try parsePass("http://example.com/foo%2\xc2\xa9zbar", null, "http://example.com/foo%2%C3%82%C2%A9zbar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%2%C3%82%C2%A9zbar", "", ""); }
test { try parsePass("http://example.com/foo%41%7a", null, "http://example.com/foo%41%7a", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%41%7a", "", ""); }
test { try parsePass("http://example.com/foo\t\x91%91", null, "http://example.com/foo%C2%91%91", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%C2%91%91", "", ""); }
test { try parsePass("http://example.com/foo%00%51", null, "http://example.com/foo%00%51", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foo%00%51", "", ""); }
test { try parsePass("http://example.com/(%28:%3A%29)", null, "http://example.com/(%28:%3A%29)", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/(%28:%3A%29)", "", ""); }
test { try parsePass("http://example.com/%3A%3a%3C%3c", null, "http://example.com/%3A%3a%3C%3c", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%3A%3a%3C%3c", "", ""); }
test { try parsePass("http://example.com/foo\tbar", null, "http://example.com/foobar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/foobar", "", ""); }
test { try parsePass("http://example.com\\\\foo\\\\bar", null, "http://example.com//foo//bar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "//foo//bar", "", ""); }
test { try parsePass("http://example.com/%7Ffp3%3Eju%3Dduvgw%3Dd", null, "http://example.com/%7Ffp3%3Eju%3Dduvgw%3Dd", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%7Ffp3%3Eju%3Dduvgw%3Dd", "", ""); }
test { try parsePass("http://example.com/@asdf%40", null, "http://example.com/@asdf%40", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/@asdf%40", "", ""); }
test { try parsePass("http://example.com/\x4f60\x597d\x4f60\x597d", null, "http://example.com/%E4%BD%A0%E5%A5%BD%E4%BD%A0%E5%A5%BD", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%E4%BD%A0%E5%A5%BD%E4%BD%A0%E5%A5%BD", "", ""); }
test { try parsePass("http://example.com/\x2025/foo", null, "http://example.com/%E2%80%A5/foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%E2%80%A5/foo", "", ""); }
test { try parsePass("http://example.com/\xfeff/foo", null, "http://example.com/%EF%BB%BF/foo", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%EF%BB%BF/foo", "", ""); }
test { try parsePass("http://example.com/\x202e/foo/\x202d/bar", null, "http://example.com/%E2%80%AE/foo/%E2%80%AD/bar", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/%E2%80%AE/foo/%E2%80%AD/bar", "", ""); }
test { try parsePass("http://www.google.com/foo?bar=baz#", null, "http://www.google.com/foo?bar=baz#", "http://www.google.com", "http:", "", "", "www.google.com", "www.google.com", "", "/foo", "?bar=baz", ""); }
test { try parsePass("http://www.google.com/foo?bar=baz# \xbb", null, "http://www.google.com/foo?bar=baz#%20%C2%BB", "http://www.google.com", "http:", "", "", "www.google.com", "www.google.com", "", "/foo", "?bar=baz", "#%20%C2%BB"); }
test { try parsePass("data:test# \xbb", null, "data:test#%20%C2%BB", "null", "data:", "", "", "", "", "", "test", "", "#%20%C2%BB"); }
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
test { try parsePass("https://x/\xfffd?\xfffd#\xfffd", null, "https://x/%EF%BF%BD?%EF%BF%BD#%EF%BF%BD", "https://x", "https:", "", "", "x", "x", "", "/%EF%BF%BD", "?%EF%BF%BD", "#%EF%BF%BD"); }
test { try parsePass("https://fa\xdf.ExAmPlE/", null, "https://xn--fa-hia.example/", "https://xn--fa-hia.example", "https:", "", "", "xn--fa-hia.example", "xn--fa-hia.example", "", "/", "", ""); }
test { try parsePass("sc://fa\xdf.ExAmPlE/", null, "sc://fa%C3%9F.ExAmPlE/", "null", "sc:", "", "", "fa%C3%9F.ExAmPlE", "fa%C3%9F.ExAmPlE", "", "/", "", ""); }
test { try parsePass("http://./", null, "http://./", "http://.", "http:", "", "", ".", ".", "", "/", "", ""); }
test { try parsePass("http://../", null, "http://../", "http://..", "http:", "", "", "..", "..", "", "/", "", ""); }
test { try parsePass("h://.", null, "h://.", "null", "h:", "", "", ".", ".", "", "", "", ""); }
test { try parsePass("http://host/?'", null, "http://host/?%27", "http://host", "http:", "", "", "host", "host", "", "/", "?%27", ""); }
test { try parsePass("notspecial://host/?'", null, "notspecial://host/?'", "null", "notspecial:", "", "", "host", "host", "", "/", "?'", ""); }
test { try parsePass("about:/../", null, "about:/", "null", "about:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("data:/../", null, "data:/", "null", "data:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("javascript:/../", null, "javascript:/", "null", "javascript:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("mailto:/../", null, "mailto:/", "null", "mailto:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("sc://\xf1.test/", null, "sc://%C3%B1.test/", "null", "sc:", "", "", "%C3%B1.test", "%C3%B1.test", "", "/", "", ""); }
test { try parsePass("sc://%/", null, "sc://%/", "", "sc:", "", "", "%", "%", "", "/", "", ""); }
test { try parsePass("sc:\\../", null, "sc:\\../", "null", "sc:", "", "", "", "", "", "\\../", "", ""); }
test { try parsePass("sc::a@example.net", null, "sc::a@example.net", "null", "sc:", "", "", "", "", "", ":a@example.net", "", ""); }
test { try parsePass("wow:%NBD", null, "wow:%NBD", "null", "wow:", "", "", "", "", "", "%NBD", "", ""); }
test { try parsePass("wow:%1G", null, "wow:%1G", "null", "wow:", "", "", "", "", "", "%1G", "", ""); }
test { try parsePass("wow:\xffff", null, "wow:%EF%BF%BF", "null", "wow:", "", "", "", "", "", "%EF%BF%BF", "", ""); }
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
test { try parsePass("sc://\xf1", null, "sc://%C3%B1", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "", ""); }
test { try parsePass("sc://\xf1?x", null, "sc://%C3%B1?x", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "?x", ""); }
test { try parsePass("sc://\xf1#x", null, "sc://%C3%B1#x", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "", "#x"); }
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
test { try parsePass("http://example.org/test?\x2323", null, "http://example.org/test?%E2%8C%A3", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%E2%8C%A3", ""); }
test { try parsePass("http://example.org/test?%23%23", null, "http://example.org/test?%23%23", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%23%23", ""); }
test { try parsePass("http://example.org/test?%GH", null, "http://example.org/test?%GH", "", "http:", "", "", "example.org", "example.org", "", "/test", "?%GH", ""); }
test { try parsePass("http://example.org/test?a#%EF", null, "http://example.org/test?a#%EF", "", "http:", "", "", "example.org", "example.org", "", "/test", "?a", "#%EF"); }
test { try parsePass("http://example.org/test?a#%GH", null, "http://example.org/test?a#%GH", "", "http:", "", "", "example.org", "example.org", "", "/test", "?a", "#%GH"); }
test { try parsePass("http://example.org/test?a#b\x00c", null, "http://example.org/test?a#b%00c", "", "http:", "", "", "example.org", "example.org", "", "/test", "?a", "#b%00c"); }
test { try parsePass("non-spec://example.org/test?a#b\x00c", null, "non-spec://example.org/test?a#b%00c", "", "non-spec:", "", "", "example.org", "example.org", "", "/test", "?a", "#b%00c"); }
test { try parsePass("non-spec:/test?a#b\x00c", null, "non-spec:/test?a#b%00c", "", "non-spec:", "", "", "", "", "", "/test", "?a", "#b%00c"); }
test { try parsePass("file://a\xadb/p", null, "file://ab/p", "", "file:", "", "", "ab", "ab", "", "/p", "", ""); }
test { try parsePass("file://a%C2%ADb/p", null, "file://ab/p", "", "file:", "", "", "ab", "ab", "", "/p", "", ""); }
test { try parsePass("file://loC\xd835\xdc00\xd835\xdc0b\xd835\xdc07\xd835\xdc28\xd835\xdc2c\xd835\xdc2d/usr/bin", null, "file:///usr/bin", "", "file:", "", "", "", "", "", "/usr/bin", "", ""); }
test { try parsePass("non-special:cannot-be-a-base-url-\x00\x01\x1f\x1e~\x7f\x80", null, "non-special:cannot-be-a-base-url-%00%01%1F%1E~%7F%C2%80", "null", "non-special:", "", "", "", "", "", "cannot-be-a-base-url-%00%01%1F%1E~%7F%C2%80", "", ""); }
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
test { try parsePass("https://x/\xffffy", null, "https://x/%EF%BF%BFy", "", "https:", "", "", "x", "x", "", "/%EF%BF%BFy", "", ""); }
test { try parsePass("https://x/?\xffffy", null, "https://x/?%EF%BF%BFy", "", "https:", "", "", "x", "x", "", "/", "?%EF%BF%BFy", ""); }
test { try parsePass("https://x/?#\xffffy", null, "https://x/?#%EF%BF%BFy", "", "https:", "", "", "x", "x", "", "/", "", "#%EF%BF%BFy"); }
test { try parsePass("non-special:\x00y", null, "non-special:%00y", "", "non-special:", "", "", "", "", "", "%00y", "", ""); }
test { try parsePass("non-special:x/\x00y", null, "non-special:x/%00y", "", "non-special:", "", "", "", "", "", "x/%00y", "", ""); }
test { try parsePass("non-special:x/?\x00y", null, "non-special:x/?%00y", "", "non-special:", "", "", "", "", "", "x/", "?%00y", ""); }
test { try parsePass("non-special:x/?#\x00y", null, "non-special:x/?#%00y", "", "non-special:", "", "", "", "", "", "x/", "", "#%00y"); }
test { try parsePass("non-special:\xffffy", null, "non-special:%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "%EF%BF%BFy", "", ""); }
test { try parsePass("non-special:x/\xffffy", null, "non-special:x/%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "x/%EF%BF%BFy", "", ""); }
test { try parsePass("non-special:x/?\xffffy", null, "non-special:x/?%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "x/", "?%EF%BF%BFy", ""); }
test { try parsePass("non-special:x/?#\xffffy", null, "non-special:x/?#%EF%BF%BFy", "", "non-special:", "", "", "", "", "", "x/", "", "#%EF%BF%BFy"); }
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



