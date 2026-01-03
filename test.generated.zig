const std = @import("std");
const url = @import("url");
const expect = @import("expect").expect;

// zig fmt: off

pub fn parseFail(input: []const u8, base: ?[]const u8) !void {
    const allocator = std.testing.allocator;
    _ = url.URL.parse(allocator, input, base) catch return;
    return error.SkipZigTest;
    // return error.FailZigTest;
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

test { try parseFail("http://f:b/c", "http://example.org/foo/bar"); }
test { try parseFail("http://f: /c", "http://example.org/foo/bar"); }
test { try parseFail("http://f:fifty-two/c", "http://example.org/foo/bar"); }
test { try parseFail("http://f:999999/c", "http://example.org/foo/bar"); }
test { try parseFail("non-special://f:999999/c", "http://example.org/foo/bar"); }
test { try parseFail("http://f: 21 / b ? d # e ", "http://example.org/foo/bar"); }
test { try parseFail("http://[1::2]:3:4", "http://example.org/foo/bar"); }
test { try parseFail("http://2001::1", "http://example.org/foo/bar"); }
test { try parseFail("http://2001::1]", "http://example.org/foo/bar"); }
test { try parseFail("http://2001::1]:80", "http://example.org/foo/bar"); }
test { try parseFail("http://[::127.0.0.1.]", "http://example.org/foo/bar"); }
test { try parseFail("http://example example.com", "http://other.com/"); }
test { try parseFail("http://Goo%20 goo%7C|.com", "http://other.com/"); }
test { try parseFail("http://[]", "http://other.com/"); }
test { try parseFail("http://[:]", "http://other.com/"); }
test { try parseFail("http://GOO\xa0\x3000goo.com", "http://other.com/"); }
test { try parseFail("http://\xfdd0zyx.com", "http://other.com/"); }
test { try parseFail("http://%ef%b7%90zyx.com", "http://other.com/"); }
test { try parseFail("http://\xff05\xff14\xff11.com", "http://other.com/"); }
test { try parseFail("http://%ef%bc%85%ef%bc%94%ef%bc%91.com", "http://other.com/"); }
test { try parseFail("http://\xff05\xff10\xff10.com", "http://other.com/"); }
test { try parseFail("http://%ef%bc%85%ef%bc%90%ef%bc%90.com", "http://other.com/"); }
test { try parseFail("http://%zz%66%a.com", "http://other.com/"); }
test { try parseFail("http://%25", "http://other.com/"); }
test { try parseFail("http://hello%00", "http://other.com/"); }
test { try parseFail("http://192.168.0.257", "http://other.com/"); }
test { try parseFail("http://%3g%78%63%30%2e%30%32%35%30%2E.01", "http://other.com/"); }
test { try parseFail("http://192.168.0.1 hello", "http://other.com/"); }
test { try parseFail("http://[google.com]", "http://other.com/"); }
test { try parseFail("http://[::1.2.3.4x]", "http://other.com/"); }
test { try parseFail("http://[::1.2.3.]", "http://other.com/"); }
test { try parseFail("http://[::1.2.]", "http://other.com/"); }
test { try parseFail("http://[::.1.2]", "http://other.com/"); }
test { try parseFail("http://[::1.]", "http://other.com/"); }
test { try parseFail("http://[::.1]", "http://other.com/"); }
test { try parseFail("http://[::%31]", "http://other.com/"); }
test { try parseFail("http://%5B::1]", "http://other.com/"); }
test { try parseFail("i", "sc:sd"); }
test { try parseFail("i", "sc:sd/sd"); }
test { try parseFail("../i", "sc:sd"); }
test { try parseFail("../i", "sc:sd/sd"); }
test { try parseFail("/i", "sc:sd"); }
test { try parseFail("/i", "sc:sd/sd"); }
test { try parseFail("?i", "sc:sd"); }
test { try parseFail("?i", "sc:sd/sd"); }
test { try parseFail("http:", "https://example.org/foo/bar"); }
test { try parseFail("http://10000000000", "http://other.com/"); }
test { try parseFail("http://4294967296", "http://other.com/"); }
test { try parseFail("http://0xffffffff1", "http://other.com/"); }
test { try parseFail("http://256.256.256.256", "http://other.com/"); }
test { try parseFail("http://[0:1:2:3:4:5:6:7:8]", "http://example.net/"); }
test { try parseFail("http://f:4294967377/c", "http://example.org/"); }
test { try parseFail("http://f:18446744073709551697/c", "http://example.org/"); }
test { try parseFail("http://f:340282366920938463463374607431768211537/c", "http://example.org/"); }
test { try parseFail("test-a-colon.html", "a:"); }
test { try parseFail("test-a-colon-b.html", "a:b"); }
test { try parseFail("http://1.2.3.4.5", "http://other.com/"); }
test { try parseFail("http://1.2.3.4.5.", "http://other.com/"); }
test { try parseFail("http://256.256.256.256.256", "http://other.com/"); }
test { try parseFail("http://256.256.256.256.256.", "http://other.com/"); }

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

test { try parsePass("http://example\t.\norg", "http://example.org/foo/bar", "http://example.org/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/", "", ""); }
test { try parsePass("http://user:pass@foo:21/bar;par?b#c", "http://example.org/foo/bar", "http://user:pass@foo:21/bar;par?b#c", "http://foo:21", "http:", "user", "pass", "foo:21", "foo", "21", "/bar;par", "?b", "#c"); }
test { try parsePass("http:foo.com", "http://example.org/foo/bar", "http://example.org/foo/foo.com", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/foo.com", "", ""); }
test { try parsePass("\t   :foo.com   \n", "http://example.org/foo/bar", "http://example.org/foo/:foo.com", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:foo.com", "", ""); }
test { try parsePass(" foo.com  ", "http://example.org/foo/bar", "http://example.org/foo/foo.com", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/foo.com", "", ""); }
test { try parsePass("a:\t foo.com", "http://example.org/foo/bar", "a: foo.com", "null", "a:", "", "", "", "", "", " foo.com", "", ""); }
test { try parsePass("http://f:21/ b ? d # e ", "http://example.org/foo/bar", "http://f:21/%20b%20?%20d%20#%20e", "http://f:21", "http:", "", "", "f:21", "f", "21", "/%20b%20", "?%20d%20", "#%20e"); }
test { try parsePass("http://f:/c", "http://example.org/foo/bar", "http://f/c", "http://f", "http:", "", "", "f", "f", "", "/c", "", ""); }
test { try parsePass("http://f:0/c", "http://example.org/foo/bar", "http://f:0/c", "http://f:0", "http:", "", "", "f:0", "f", "0", "/c", "", ""); }
test { try parsePass("http://f:00000000000000/c", "http://example.org/foo/bar", "http://f:0/c", "http://f:0", "http:", "", "", "f:0", "f", "0", "/c", "", ""); }
test { try parsePass("http://f:00000000000000000000080/c", "http://example.org/foo/bar", "http://f/c", "http://f", "http:", "", "", "f", "f", "", "/c", "", ""); }
test { try parsePass("http://f:\n/c", "http://example.org/foo/bar", "http://f/c", "http://f", "http:", "", "", "f", "f", "", "/c", "", ""); }
test { try parsePass("", "http://example.org/foo/bar", "http://example.org/foo/bar", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", ""); }
test { try parsePass("  \t", "http://example.org/foo/bar", "http://example.org/foo/bar", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", ""); }
test { try parsePass(":foo.com/", "http://example.org/foo/bar", "http://example.org/foo/:foo.com/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:foo.com/", "", ""); }
test { try parsePass(":foo.com\\", "http://example.org/foo/bar", "http://example.org/foo/:foo.com/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:foo.com/", "", ""); }
test { try parsePass(":", "http://example.org/foo/bar", "http://example.org/foo/:", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:", "", ""); }
test { try parsePass(":a", "http://example.org/foo/bar", "http://example.org/foo/:a", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:a", "", ""); }
test { try parsePass(":/", "http://example.org/foo/bar", "http://example.org/foo/:/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:/", "", ""); }
test { try parsePass(":\\", "http://example.org/foo/bar", "http://example.org/foo/:/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:/", "", ""); }
test { try parsePass(":#", "http://example.org/foo/bar", "http://example.org/foo/:#", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:", "", ""); }
test { try parsePass("#", "http://example.org/foo/bar", "http://example.org/foo/bar#", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", ""); }
test { try parsePass("#/", "http://example.org/foo/bar", "http://example.org/foo/bar#/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", "#/"); }
test { try parsePass("#\\", "http://example.org/foo/bar", "http://example.org/foo/bar#\\", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", "#\\"); }
test { try parsePass("#;?", "http://example.org/foo/bar", "http://example.org/foo/bar#;?", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", "#;?"); }
test { try parsePass("?", "http://example.org/foo/bar", "http://example.org/foo/bar?", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", ""); }
test { try parsePass("/", "http://example.org/foo/bar", "http://example.org/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/", "", ""); }
test { try parsePass(":23", "http://example.org/foo/bar", "http://example.org/foo/:23", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:23", "", ""); }
test { try parsePass("/:23", "http://example.org/foo/bar", "http://example.org/:23", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/:23", "", ""); }
test { try parsePass("\\x", "http://example.org/foo/bar", "http://example.org/x", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/x", "", ""); }
test { try parsePass("\\\\x\\hello", "http://example.org/foo/bar", "http://x/hello", "http://x", "http:", "", "", "x", "x", "", "/hello", "", ""); }
test { try parsePass("::", "http://example.org/foo/bar", "http://example.org/foo/::", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/::", "", ""); }
test { try parsePass("::23", "http://example.org/foo/bar", "http://example.org/foo/::23", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/::23", "", ""); }
test { try parsePass("foo://", "http://example.org/foo/bar", "foo://", "null", "foo:", "", "", "", "", "", "", "", ""); }
test { try parsePass("http://a:b@c:29/d", "http://example.org/foo/bar", "http://a:b@c:29/d", "http://c:29", "http:", "a", "b", "c:29", "c", "29", "/d", "", ""); }
test { try parsePass("http::@c:29", "http://example.org/foo/bar", "http://example.org/foo/:@c:29", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/:@c:29", "", ""); }
test { try parsePass("http://&a:foo(b]c@d:2/", "http://example.org/foo/bar", "http://&a:foo(b%5Dc@d:2/", "http://d:2", "http:", "&a", "foo(b%5Dc", "d:2", "d", "2", "/", "", ""); }
test { try parsePass("http://::@c@d:2", "http://example.org/foo/bar", "http://:%3A%40c@d:2/", "http://d:2", "http:", "", "%3A%40c", "d:2", "d", "2", "/", "", ""); }
test { try parsePass("http://foo.com:b@d/", "http://example.org/foo/bar", "http://foo.com:b@d/", "http://d", "http:", "foo.com", "b", "d", "d", "", "/", "", ""); }
test { try parsePass("http://foo.com/\\@", "http://example.org/foo/bar", "http://foo.com//@", "http://foo.com", "http:", "", "", "foo.com", "foo.com", "", "//@", "", ""); }
test { try parsePass("http:\\\\foo.com\\", "http://example.org/foo/bar", "http://foo.com/", "http://foo.com", "http:", "", "", "foo.com", "foo.com", "", "/", "", ""); }
test { try parsePass("http:\\\\a\\b:c\\d@foo.com\\", "http://example.org/foo/bar", "http://a/b:c/d@foo.com/", "http://a", "http:", "", "", "a", "a", "", "/b:c/d@foo.com/", "", ""); }
test { try parsePass("foo:/", "http://example.org/foo/bar", "foo:/", "null", "foo:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("foo:/bar.com/", "http://example.org/foo/bar", "foo:/bar.com/", "null", "foo:", "", "", "", "", "", "/bar.com/", "", ""); }
test { try parsePass("foo://///////", "http://example.org/foo/bar", "foo://///////", "null", "foo:", "", "", "", "", "", "///////", "", ""); }
test { try parsePass("foo://///////bar.com/", "http://example.org/foo/bar", "foo://///////bar.com/", "null", "foo:", "", "", "", "", "", "///////bar.com/", "", ""); }
test { try parsePass("foo:////://///", "http://example.org/foo/bar", "foo:////://///", "null", "foo:", "", "", "", "", "", "//://///", "", ""); }
test { try parsePass("c:/foo", "http://example.org/foo/bar", "c:/foo", "null", "c:", "", "", "", "", "", "/foo", "", ""); }
test { try parsePass("//foo/bar", "http://example.org/foo/bar", "http://foo/bar", "http://foo", "http:", "", "", "foo", "foo", "", "/bar", "", ""); }
test { try parsePass("http://foo/path;a??e#f#g", "http://example.org/foo/bar", "http://foo/path;a??e#f#g", "http://foo", "http:", "", "", "foo", "foo", "", "/path;a", "??e", "#f#g"); }
test { try parsePass("http://foo/abcd?efgh?ijkl", "http://example.org/foo/bar", "http://foo/abcd?efgh?ijkl", "http://foo", "http:", "", "", "foo", "foo", "", "/abcd", "?efgh?ijkl", ""); }
test { try parsePass("http://foo/abcd#foo?bar", "http://example.org/foo/bar", "http://foo/abcd#foo?bar", "http://foo", "http:", "", "", "foo", "foo", "", "/abcd", "", "#foo?bar"); }
test { try parsePass("[61:24:74]:98", "http://example.org/foo/bar", "http://example.org/foo/[61:24:74]:98", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/[61:24:74]:98", "", ""); }
test { try parsePass("http:[61:27]/:foo", "http://example.org/foo/bar", "http://example.org/foo/[61:27]/:foo", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/[61:27]/:foo", "", ""); }
test { try parsePass("http://[2001::1]", "http://example.org/foo/bar", "http://[2001::1]/", "http://[2001::1]", "http:", "", "", "[2001::1]", "[2001::1]", "", "/", "", ""); }
test { try parsePass("http://[::127.0.0.1]", "http://example.org/foo/bar", "http://[::7f00:1]/", "http://[::7f00:1]", "http:", "", "", "[::7f00:1]", "[::7f00:1]", "", "/", "", ""); }
test { try parsePass("http://[0:0:0:0:0:0:13.1.68.3]", "http://example.org/foo/bar", "http://[::d01:4403]/", "http://[::d01:4403]", "http:", "", "", "[::d01:4403]", "[::d01:4403]", "", "/", "", ""); }
test { try parsePass("http://[2001::1]:80", "http://example.org/foo/bar", "http://[2001::1]/", "http://[2001::1]", "http:", "", "", "[2001::1]", "[2001::1]", "", "/", "", ""); }
test { try parsePass("http:/example.com/", "http://example.org/foo/bar", "http://example.org/example.com/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/example.com/", "", ""); }
test { try parsePass("ftp:/example.com/", "http://example.org/foo/bar", "ftp://example.com/", "ftp://example.com", "ftp:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("https:/example.com/", "http://example.org/foo/bar", "https://example.com/", "https://example.com", "https:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("madeupscheme:/example.com/", "http://example.org/foo/bar", "madeupscheme:/example.com/", "null", "madeupscheme:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("file:/example.com/", "http://example.org/foo/bar", "file:///example.com/", "", "file:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("ftps:/example.com/", "http://example.org/foo/bar", "ftps:/example.com/", "null", "ftps:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("gopher:/example.com/", "http://example.org/foo/bar", "gopher:/example.com/", "null", "gopher:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("ws:/example.com/", "http://example.org/foo/bar", "ws://example.com/", "ws://example.com", "ws:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("wss:/example.com/", "http://example.org/foo/bar", "wss://example.com/", "wss://example.com", "wss:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("data:/example.com/", "http://example.org/foo/bar", "data:/example.com/", "null", "data:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("javascript:/example.com/", "http://example.org/foo/bar", "javascript:/example.com/", "null", "javascript:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("mailto:/example.com/", "http://example.org/foo/bar", "mailto:/example.com/", "null", "mailto:", "", "", "", "", "", "/example.com/", "", ""); }
test { try parsePass("http:example.com/", "http://example.org/foo/bar", "http://example.org/foo/example.com/", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/example.com/", "", ""); }
test { try parsePass("ftp:example.com/", "http://example.org/foo/bar", "ftp://example.com/", "ftp://example.com", "ftp:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("https:example.com/", "http://example.org/foo/bar", "https://example.com/", "https://example.com", "https:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("madeupscheme:example.com/", "http://example.org/foo/bar", "madeupscheme:example.com/", "null", "madeupscheme:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("ftps:example.com/", "http://example.org/foo/bar", "ftps:example.com/", "null", "ftps:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("gopher:example.com/", "http://example.org/foo/bar", "gopher:example.com/", "null", "gopher:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("ws:example.com/", "http://example.org/foo/bar", "ws://example.com/", "ws://example.com", "ws:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("wss:example.com/", "http://example.org/foo/bar", "wss://example.com/", "wss://example.com", "wss:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("data:example.com/", "http://example.org/foo/bar", "data:example.com/", "null", "data:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("javascript:example.com/", "http://example.org/foo/bar", "javascript:example.com/", "null", "javascript:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("mailto:example.com/", "http://example.org/foo/bar", "mailto:example.com/", "null", "mailto:", "", "", "", "", "", "example.com/", "", ""); }
test { try parsePass("/a/b/c", "http://example.org/foo/bar", "http://example.org/a/b/c", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/a/b/c", "", ""); }
test { try parsePass("/a/ /c", "http://example.org/foo/bar", "http://example.org/a/%20/c", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/a/%20/c", "", ""); }
test { try parsePass("/a%2fc", "http://example.org/foo/bar", "http://example.org/a%2fc", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/a%2fc", "", ""); }
test { try parsePass("/a/%2f/c", "http://example.org/foo/bar", "http://example.org/a/%2f/c", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/a/%2f/c", "", ""); }
test { try parsePass("#\x3b2", "http://example.org/foo/bar", "http://example.org/foo/bar#%CE%B2", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", "#%CE%B2"); }
test { try parsePass("data:text/html,test#test", "http://example.org/foo/bar", "data:text/html,test#test", "null", "data:", "", "", "", "", "", "text/html,test", "", "#test"); }
test { try parsePass("tel:1234567890", "http://example.org/foo/bar", "tel:1234567890", "null", "tel:", "", "", "", "", "", "1234567890", "", ""); }
test { try parsePass("ssh://example.com/foo/bar.git", "http://example.org/", "ssh://example.com/foo/bar.git", "null", "ssh:", "", "", "example.com", "example.com", "", "/foo/bar.git", "", ""); }
test { try parsePass("file:c:\\foo\\bar.html", "file:///tmp/mock/path", "file:///c:/foo/bar.html", "", "file:", "", "", "", "", "", "/c:/foo/bar.html", "", ""); }
test { try parsePass("  File:c|////foo\\bar.html", "file:///tmp/mock/path", "file:///c:////foo/bar.html", "", "file:", "", "", "", "", "", "/c:////foo/bar.html", "", ""); }
test { try parsePass("C|/foo/bar", "file:///tmp/mock/path", "file:///C:/foo/bar", "", "file:", "", "", "", "", "", "/C:/foo/bar", "", ""); }
test { try parsePass("/C|\\foo\\bar", "file:///tmp/mock/path", "file:///C:/foo/bar", "", "file:", "", "", "", "", "", "/C:/foo/bar", "", ""); }
test { try parsePass("//C|/foo/bar", "file:///tmp/mock/path", "file:///C:/foo/bar", "", "file:", "", "", "", "", "", "/C:/foo/bar", "", ""); }
test { try parsePass("//server/file", "file:///tmp/mock/path", "file://server/file", "", "file:", "", "", "server", "server", "", "/file", "", ""); }
test { try parsePass("\\\\server\\file", "file:///tmp/mock/path", "file://server/file", "", "file:", "", "", "server", "server", "", "/file", "", ""); }
test { try parsePass("/\\server/file", "file:///tmp/mock/path", "file://server/file", "", "file:", "", "", "server", "server", "", "/file", "", ""); }
test { try parsePass("file:///foo/bar.txt", "file:///tmp/mock/path", "file:///foo/bar.txt", "", "file:", "", "", "", "", "", "/foo/bar.txt", "", ""); }
test { try parsePass("file:///home/me", "file:///tmp/mock/path", "file:///home/me", "", "file:", "", "", "", "", "", "/home/me", "", ""); }
test { try parsePass("//", "file:///tmp/mock/path", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("///", "file:///tmp/mock/path", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("///test", "file:///tmp/mock/path", "file:///test", "", "file:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("file://test", "file:///tmp/mock/path", "file://test/", "", "file:", "", "", "test", "test", "", "/", "", ""); }
test { try parsePass("file://localhost", "file:///tmp/mock/path", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("file://localhost/", "file:///tmp/mock/path", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("file://localhost/test", "file:///tmp/mock/path", "file:///test", "", "file:", "", "", "", "", "", "/test", "", ""); }
test { try parsePass("test", "file:///tmp/mock/path", "file:///tmp/mock/test", "", "file:", "", "", "", "", "", "/tmp/mock/test", "", ""); }
test { try parsePass("file:test", "file:///tmp/mock/path", "file:///tmp/mock/test", "", "file:", "", "", "", "", "", "/tmp/mock/test", "", ""); }
test { try parsePass("/", "http://www.example.com/test", "http://www.example.com/", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("/test.txt", "http://www.example.com/test", "http://www.example.com/test.txt", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/test.txt", "", ""); }
test { try parsePass(".", "http://www.example.com/test", "http://www.example.com/", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("..", "http://www.example.com/test", "http://www.example.com/", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/", "", ""); }
test { try parsePass("test.txt", "http://www.example.com/test", "http://www.example.com/test.txt", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/test.txt", "", ""); }
test { try parsePass("./test.txt", "http://www.example.com/test", "http://www.example.com/test.txt", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/test.txt", "", ""); }
test { try parsePass("../test.txt", "http://www.example.com/test", "http://www.example.com/test.txt", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/test.txt", "", ""); }
test { try parsePass("../aaa/test.txt", "http://www.example.com/test", "http://www.example.com/aaa/test.txt", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/aaa/test.txt", "", ""); }
test { try parsePass("../../test.txt", "http://www.example.com/test", "http://www.example.com/test.txt", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/test.txt", "", ""); }
test { try parsePass("\x4e2d/test.txt", "http://www.example.com/test", "http://www.example.com/%E4%B8%AD/test.txt", "http://www.example.com", "http:", "", "", "www.example.com", "www.example.com", "", "/%E4%B8%AD/test.txt", "", ""); }
test { try parsePass("http://www.example2.com", "http://www.example.com/test", "http://www.example2.com/", "http://www.example2.com", "http:", "", "", "www.example2.com", "www.example2.com", "", "/", "", ""); }
test { try parsePass("//www.example2.com", "http://www.example.com/test", "http://www.example2.com/", "http://www.example2.com", "http:", "", "", "www.example2.com", "www.example2.com", "", "/", "", ""); }
test { try parsePass("file:...", "http://www.example.com/test", "file:///...", "", "file:", "", "", "", "", "", "/...", "", ""); }
test { try parsePass("file:..", "http://www.example.com/test", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("file:a", "http://www.example.com/test", "file:///a", "", "file:", "", "", "", "", "", "/a", "", ""); }
test { try parsePass("file:.", "http://www.example.com/test", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("http://ExAmPlE.CoM", "http://other.com/", "http://example.com/", "http://example.com", "http:", "", "", "example.com", "example.com", "", "/", "", ""); }
test { try parsePass("http://GOO\x200b\x2060\xfeffgoo.com", "http://other.com/", "http://googoo.com/", "http://googoo.com", "http:", "", "", "googoo.com", "googoo.com", "", "/", "", ""); }
test { try parsePass("http://www.foo\x3002bar.com", "http://other.com/", "http://www.foo.bar.com/", "http://www.foo.bar.com", "http:", "", "", "www.foo.bar.com", "www.foo.bar.com", "", "/", "", ""); }
test { try parsePass("http://\xff27\xff4f.com", "http://other.com/", "http://go.com/", "http://go.com", "http:", "", "", "go.com", "go.com", "", "/", "", ""); }
test { try parsePass("http://\x4f60\x597d\x4f60\x597d", "http://other.com/", "http://xn--6qqa088eba/", "http://xn--6qqa088eba", "http:", "", "", "xn--6qqa088eba", "xn--6qqa088eba", "", "/", "", ""); }
test { try parsePass("http://%30%78%63%30%2e%30%32%35%30.01", "http://other.com/", "http://192.168.0.1/", "http://192.168.0.1", "http:", "", "", "192.168.0.1", "192.168.0.1", "", "/", "", ""); }
test { try parsePass("http://%30%78%63%30%2e%30%32%35%30.01%2e", "http://other.com/", "http://192.168.0.1/", "http://192.168.0.1", "http:", "", "", "192.168.0.1", "192.168.0.1", "", "/", "", ""); }
test { try parsePass("http://\xff10\xff38\xff43\xff10\xff0e\xff10\xff12\xff15\xff10\xff0e\xff10\xff11", "http://other.com/", "http://192.168.0.1/", "http://192.168.0.1", "http:", "", "", "192.168.0.1", "192.168.0.1", "", "/", "", ""); }
test { try parsePass("http://foo:\xd83d\xdca9@example.com/bar", "http://other.com/", "http://foo:%F0%9F%92%A9@example.com/bar", "http://example.com", "http:", "foo", "%F0%9F%92%A9", "example.com", "example.com", "", "/bar", "", ""); }
test { try parsePass("#", "test:test", "test:test#", "null", "test:", "", "", "", "", "", "test", "", ""); }
test { try parsePass("#x", "mailto:x@x.com", "mailto:x@x.com#x", "null", "mailto:", "", "", "", "", "", "x@x.com", "", "#x"); }
test { try parsePass("#x", "data:,", "data:,#x", "null", "data:", "", "", "", "", "", ",", "", "#x"); }
test { try parsePass("#x", "about:blank", "about:blank#x", "null", "about:", "", "", "", "", "", "blank", "", "#x"); }
test { try parsePass("#x:y", "about:blank", "about:blank#x:y", "null", "about:", "", "", "", "", "", "blank", "", "#x:y"); }
test { try parsePass("#", "test:test?test", "test:test?test#", "null", "test:", "", "", "", "", "", "test", "?test", ""); }
test { try parsePass("https://@test@test@example:800/", "http://doesnotmatter/", "https://%40test%40test@example:800/", "https://example:800", "https:", "%40test%40test", "", "example:800", "example", "800", "/", "", ""); }
test { try parsePass("https://@@@example", "http://doesnotmatter/", "https://%40%40@example/", "https://example", "https:", "%40%40", "", "example", "example", "", "/", "", ""); }
test { try parsePass("http://`{}:`{}@h/`{}?`{}", "http://doesnotmatter/", "http://%60%7B%7D:%60%7B%7D@h/%60%7B%7D?`{}", "http://h", "http:", "%60%7B%7D", "%60%7B%7D", "h", "h", "", "/%60%7B%7D", "?`{}", ""); }
test { try parsePass("/some/path", "http://user@example.org/smth", "http://user@example.org/some/path", "http://example.org", "http:", "user", "", "example.org", "example.org", "", "/some/path", "", ""); }
test { try parsePass("", "http://user:pass@example.org:21/smth", "http://user:pass@example.org:21/smth", "http://example.org:21", "http:", "user", "pass", "example.org:21", "example.org", "21", "/smth", "", ""); }
test { try parsePass("/some/path", "http://user:pass@example.org:21/smth", "http://user:pass@example.org:21/some/path", "http://example.org:21", "http:", "user", "pass", "example.org:21", "example.org", "21", "/some/path", "", ""); }
test { try parsePass("i", "sc:/pa/pa", "sc:/pa/i", "null", "sc:", "", "", "", "", "", "/pa/i", "", ""); }
test { try parsePass("i", "sc://ho/pa", "sc://ho/i", "null", "sc:", "", "", "ho", "ho", "", "/i", "", ""); }
test { try parsePass("i", "sc:///pa/pa", "sc:///pa/i", "null", "sc:", "", "", "", "", "", "/pa/i", "", ""); }
test { try parsePass("../i", "sc:/pa/pa", "sc:/i", "null", "sc:", "", "", "", "", "", "/i", "", ""); }
test { try parsePass("../i", "sc://ho/pa", "sc://ho/i", "null", "sc:", "", "", "ho", "ho", "", "/i", "", ""); }
test { try parsePass("../i", "sc:///pa/pa", "sc:///i", "null", "sc:", "", "", "", "", "", "/i", "", ""); }
test { try parsePass("/i", "sc:/pa/pa", "sc:/i", "null", "sc:", "", "", "", "", "", "/i", "", ""); }
test { try parsePass("/i", "sc://ho/pa", "sc://ho/i", "null", "sc:", "", "", "ho", "ho", "", "/i", "", ""); }
test { try parsePass("/i", "sc:///pa/pa", "sc:///i", "null", "sc:", "", "", "", "", "", "/i", "", ""); }
test { try parsePass("?i", "sc:/pa/pa", "sc:/pa/pa?i", "null", "sc:", "", "", "", "", "", "/pa/pa", "?i", ""); }
test { try parsePass("?i", "sc://ho/pa", "sc://ho/pa?i", "null", "sc:", "", "", "ho", "ho", "", "/pa", "?i", ""); }
test { try parsePass("?i", "sc:///pa/pa", "sc:///pa/pa?i", "null", "sc:", "", "", "", "", "", "/pa/pa", "?i", ""); }
test { try parsePass("#i", "sc:sd", "sc:sd#i", "null", "sc:", "", "", "", "", "", "sd", "", "#i"); }
test { try parsePass("#i", "sc:sd/sd", "sc:sd/sd#i", "null", "sc:", "", "", "", "", "", "sd/sd", "", "#i"); }
test { try parsePass("#i", "sc:/pa/pa", "sc:/pa/pa#i", "null", "sc:", "", "", "", "", "", "/pa/pa", "", "#i"); }
test { try parsePass("#i", "sc://ho/pa", "sc://ho/pa#i", "null", "sc:", "", "", "ho", "ho", "", "/pa", "", "#i"); }
test { try parsePass("#i", "sc:///pa/pa", "sc:///pa/pa#i", "null", "sc:", "", "", "", "", "", "/pa/pa", "", "#i"); }
test { try parsePass("x", "sc://\xf1", "sc://%C3%B1/x", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "/x", "", ""); }
test { try parsePass("?a=b&c=d", "http://example.org/foo/bar", "http://example.org/foo/bar?a=b&c=d", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "?a=b&c=d", ""); }
test { try parsePass("??a=b&c=d", "http://example.org/foo/bar", "http://example.org/foo/bar??a=b&c=d", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "??a=b&c=d", ""); }
test { try parsePass("http:", "http://example.org/foo/bar", "http://example.org/foo/bar", "http://example.org", "http:", "", "", "example.org", "example.org", "", "/foo/bar", "", ""); }
test { try parsePass("sc:", "https://example.org/foo/bar", "sc:", "null", "sc:", "", "", "", "", "", "", "", ""); }
test { try parsePass("http://1.2.3.4/", "http://other.com/", "http://1.2.3.4/", "http://1.2.3.4", "http:", "", "", "1.2.3.4", "1.2.3.4", "", "/", "", ""); }
test { try parsePass("http://1.2.3.4./", "http://other.com/", "http://1.2.3.4/", "http://1.2.3.4", "http:", "", "", "1.2.3.4", "1.2.3.4", "", "/", "", ""); }
test { try parsePass("http://192.168.257", "http://other.com/", "http://192.168.1.1/", "http://192.168.1.1", "http:", "", "", "192.168.1.1", "192.168.1.1", "", "/", "", ""); }
test { try parsePass("http://192.168.257.", "http://other.com/", "http://192.168.1.1/", "http://192.168.1.1", "http:", "", "", "192.168.1.1", "192.168.1.1", "", "/", "", ""); }
test { try parsePass("http://192.168.257.com", "http://other.com/", "http://192.168.257.com/", "http://192.168.257.com", "http:", "", "", "192.168.257.com", "192.168.257.com", "", "/", "", ""); }
test { try parsePass("http://256", "http://other.com/", "http://0.0.1.0/", "http://0.0.1.0", "http:", "", "", "0.0.1.0", "0.0.1.0", "", "/", "", ""); }
test { try parsePass("http://256.com", "http://other.com/", "http://256.com/", "http://256.com", "http:", "", "", "256.com", "256.com", "", "/", "", ""); }
test { try parsePass("http://999999999", "http://other.com/", "http://59.154.201.255/", "http://59.154.201.255", "http:", "", "", "59.154.201.255", "59.154.201.255", "", "/", "", ""); }
test { try parsePass("http://999999999.", "http://other.com/", "http://59.154.201.255/", "http://59.154.201.255", "http:", "", "", "59.154.201.255", "59.154.201.255", "", "/", "", ""); }
test { try parsePass("http://999999999.com", "http://other.com/", "http://999999999.com/", "http://999999999.com", "http:", "", "", "999999999.com", "999999999.com", "", "/", "", ""); }
test { try parsePass("http://10000000000.com", "http://other.com/", "http://10000000000.com/", "http://10000000000.com", "http:", "", "", "10000000000.com", "10000000000.com", "", "/", "", ""); }
test { try parsePass("http://4294967295", "http://other.com/", "http://255.255.255.255/", "http://255.255.255.255", "http:", "", "", "255.255.255.255", "255.255.255.255", "", "/", "", ""); }
test { try parsePass("http://0xffffffff", "http://other.com/", "http://255.255.255.255/", "http://255.255.255.255", "http:", "", "", "255.255.255.255", "255.255.255.255", "", "/", "", ""); }
test { try parsePass("pix/submit.gif", "file:///C:/Users/Domenic/Dropbox/GitHub/tmpvar/jsdom/test/level2/html/files/anchor.html", "file:///C:/Users/Domenic/Dropbox/GitHub/tmpvar/jsdom/test/level2/html/files/pix/submit.gif", "", "file:", "", "", "", "", "", "/C:/Users/Domenic/Dropbox/GitHub/tmpvar/jsdom/test/level2/html/files/pix/submit.gif", "", ""); }
test { try parsePass("..", "file:///C:/", "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("..", "file:///", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("/", "file:///C:/a/b", "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("/", "file://h/C:/a/b", "file://h/C:/", "", "file:", "", "", "h", "h", "", "/C:/", "", ""); }
test { try parsePass("/", "file://h/a/b", "file://h/", "", "file:", "", "", "h", "h", "", "/", "", ""); }
test { try parsePass("//d:", "file:///C:/a/b", "file:///d:", "", "file:", "", "", "", "", "", "/d:", "", ""); }
test { try parsePass("//d:/..", "file:///C:/a/b", "file:///d:/", "", "file:", "", "", "", "", "", "/d:/", "", ""); }
test { try parsePass("..", "file:///ab:/", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("..", "file:///1:/", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("", "file:///test?test#test", "file:///test?test", "", "file:", "", "", "", "", "", "/test", "?test", ""); }
test { try parsePass("file:", "file:///test?test#test", "file:///test?test", "", "file:", "", "", "", "", "", "/test", "?test", ""); }
test { try parsePass("?x", "file:///test?test#test", "file:///test?x", "", "file:", "", "", "", "", "", "/test", "?x", ""); }
test { try parsePass("file:?x", "file:///test?test#test", "file:///test?x", "", "file:", "", "", "", "", "", "/test", "?x", ""); }
test { try parsePass("#x", "file:///test?test#test", "file:///test?test#x", "", "file:", "", "", "", "", "", "/test", "?test", "#x"); }
test { try parsePass("file:#x", "file:///test?test#test", "file:///test?test#x", "", "file:", "", "", "", "", "", "/test", "?test", "#x"); }
test { try parsePass("/////mouse", "file:///elephant", "file://///mouse", "", "file:", "", "", "", "", "", "///mouse", "", ""); }
test { try parsePass("\\//pig", "file://lion/", "file:///pig", "", "file:", "", "", "", "", "", "/pig", "", ""); }
test { try parsePass("\\/localhost//pig", "file://lion/", "file:////pig", "", "file:", "", "", "", "", "", "//pig", "", ""); }
test { try parsePass("//localhost//pig", "file://lion/", "file:////pig", "", "file:", "", "", "", "", "", "//pig", "", ""); }
test { try parsePass("/..//localhost//pig", "file://lion/", "file://lion//localhost//pig", "", "file:", "", "", "lion", "lion", "", "//localhost//pig", "", ""); }
test { try parsePass("file://", "file://ape/", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("/rooibos", "file://tea/", "file://tea/rooibos", "", "file:", "", "", "tea", "tea", "", "/rooibos", "", ""); }
test { try parsePass("/?chai", "file://tea/", "file://tea/?chai", "", "file:", "", "", "tea", "tea", "", "/", "?chai", ""); }
test { try parsePass("C|", "file://host/dir/file", "file://host/C:", "", "file:", "", "", "host", "host", "", "/C:", "", ""); }
test { try parsePass("C|", "file://host/D:/dir1/dir2/file", "file://host/C:", "", "file:", "", "", "host", "host", "", "/C:", "", ""); }
test { try parsePass("C|#", "file://host/dir/file", "file://host/C:#", "", "file:", "", "", "host", "host", "", "/C:", "", ""); }
test { try parsePass("C|?", "file://host/dir/file", "file://host/C:?", "", "file:", "", "", "host", "host", "", "/C:", "", ""); }
test { try parsePass("C|/", "file://host/dir/file", "file://host/C:/", "", "file:", "", "", "host", "host", "", "/C:/", "", ""); }
test { try parsePass("C|\n/", "file://host/dir/file", "file://host/C:/", "", "file:", "", "", "host", "host", "", "/C:/", "", ""); }
test { try parsePass("C|\\", "file://host/dir/file", "file://host/C:/", "", "file:", "", "", "host", "host", "", "/C:/", "", ""); }
test { try parsePass("C", "file://host/dir/file", "file://host/dir/C", "", "file:", "", "", "host", "host", "", "/dir/C", "", ""); }
test { try parsePass("C|a", "file://host/dir/file", "file://host/dir/C|a", "", "file:", "", "", "host", "host", "", "/dir/C|a", "", ""); }
test { try parsePass("/c:/foo/bar", "file:///c:/baz/qux", "file:///c:/foo/bar", "", "file:", "", "", "", "", "", "/c:/foo/bar", "", ""); }
test { try parsePass("/c|/foo/bar", "file:///c:/baz/qux", "file:///c:/foo/bar", "", "file:", "", "", "", "", "", "/c:/foo/bar", "", ""); }
test { try parsePass("file:\\c:\\foo\\bar", "file:///c:/baz/qux", "file:///c:/foo/bar", "", "file:", "", "", "", "", "", "/c:/foo/bar", "", ""); }
test { try parsePass("/c:/foo/bar", "file://host/path", "file://host/c:/foo/bar", "", "file:", "", "", "host", "host", "", "/c:/foo/bar", "", ""); }
test { try parsePass("C|/", "file://host/", "file://host/C:/", "", "file:", "", "", "host", "host", "", "/C:/", "", ""); }
test { try parsePass("/C:/", "file://host/", "file://host/C:/", "", "file:", "", "", "host", "host", "", "/C:/", "", ""); }
test { try parsePass("file:C:/", "file://host/", "file://host/C:/", "", "file:", "", "", "host", "host", "", "/C:/", "", ""); }
test { try parsePass("file:/C:/", "file://host/", "file://host/C:/", "", "file:", "", "", "host", "host", "", "/C:/", "", ""); }
test { try parsePass("//C:/", "file://host/", "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("file://C:/", "file://host/", "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("///C:/", "file://host/", "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("file:///C:/", "file://host/", "file:///C:/", "", "file:", "", "", "", "", "", "/C:/", "", ""); }
test { try parsePass("file:///one/two", "file:///", "file:///one/two", "", "file:", "", "", "", "", "", "/one/two", "", ""); }
test { try parsePass("file:////one/two", "file:///", "file:////one/two", "", "file:", "", "", "", "", "", "//one/two", "", ""); }
test { try parsePass("//one/two", "file:///", "file://one/two", "", "file:", "", "", "one", "one", "", "/two", "", ""); }
test { try parsePass("///one/two", "file:///", "file:///one/two", "", "file:", "", "", "", "", "", "/one/two", "", ""); }
test { try parsePass("////one/two", "file:///", "file:////one/two", "", "file:", "", "", "", "", "", "//one/two", "", ""); }
test { try parsePass("file:///.//", "file:////", "file:////", "", "file:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("http://[1:0::]", "http://example.net/", "http://[1::]/", "http://[1::]", "http:", "", "", "[1::]", "[1::]", "", "/", "", ""); }
test { try parsePass("#x", "sc://\xf1", "sc://%C3%B1#x", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "", "#x"); }
test { try parsePass("?x", "sc://\xf1", "sc://%C3%B1?x", "null", "sc:", "", "", "%C3%B1", "%C3%B1", "", "", "?x", ""); }
test { try parsePass("///", "sc://x/", "sc:///", "", "sc:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("////", "sc://x/", "sc:////", "", "sc:", "", "", "", "", "", "//", "", ""); }
test { try parsePass("////x/", "sc://x/", "sc:////x/", "", "sc:", "", "", "", "", "", "//x/", "", ""); }
test { try parsePass("/.//path", "non-spec:/p", "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("/..//path", "non-spec:/p", "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("..//path", "non-spec:/p", "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("a/..//path", "non-spec:/p", "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("", "non-spec:/..//p", "non-spec:/.//p", "", "non-spec:", "", "", "", "", "", "//p", "", ""); }
test { try parsePass("path", "non-spec:/..//p", "non-spec:/.//path", "", "non-spec:", "", "", "", "", "", "//path", "", ""); }
test { try parsePass("../path", "non-spec:/.//p", "non-spec:/path", "", "non-spec:", "", "", "", "", "", "/path", "", ""); }
test { try parsePass("test-a-colon-slash.html", "a:/", "a:/test-a-colon-slash.html", "", "a:", "", "", "", "", "", "/test-a-colon-slash.html", "", ""); }
test { try parsePass("test-a-colon-slash-slash.html", "a://", "a:///test-a-colon-slash-slash.html", "", "a:", "", "", "", "", "", "/test-a-colon-slash-slash.html", "", ""); }
test { try parsePass("test-a-colon-slash-b.html", "a:/b", "a:/test-a-colon-slash-b.html", "", "a:", "", "", "", "", "", "/test-a-colon-slash-b.html", "", ""); }
test { try parsePass("test-a-colon-slash-slash-b.html", "a://b", "a://b/test-a-colon-slash-slash-b.html", "", "a:", "", "", "b", "b", "", "/test-a-colon-slash-slash-b.html", "", ""); }
test { try parsePass("10.0.0.7:8080/foo.html", "file:///some/dir/bar.html", "file:///some/dir/10.0.0.7:8080/foo.html", "", "file:", "", "", "", "", "", "/some/dir/10.0.0.7:8080/foo.html", "", ""); }
test { try parsePass("a!@$*=/foo.html", "file:///some/dir/bar.html", "file:///some/dir/a!@$*=/foo.html", "", "file:", "", "", "", "", "", "/some/dir/a!@$*=/foo.html", "", ""); }
test { try parsePass("a1234567890-+.:foo/bar", "http://example.com/dir/file", "a1234567890-+.:foo/bar", "", "a1234567890-+.:", "", "", "", "", "", "foo/bar", "", ""); }
test { try parsePass("#link", "https://example.org/##link", "https://example.org/#link", "", "https:", "", "", "example.org", "example.org", "", "/", "", "#link"); }
test { try parsePass("https://user:pass[\x7f@foo/bar", "http://example.org", "https://user:pass%5B%7F@foo/bar", "https://foo", "https:", "user", "pass%5B%7F", "foo", "foo", "", "/bar", "", ""); }
test { try parsePass("abc:rootless", "abc://host/path", "abc:rootless", "", "abc:", "", "", "", "", "", "rootless", "", ""); }
test { try parsePass("abc:rootless", "abc:/path", "abc:rootless", "", "abc:", "", "", "", "", "", "rootless", "", ""); }
test { try parsePass("abc:rootless", "abc:path", "abc:rootless", "", "abc:", "", "", "", "", "", "rootless", "", ""); }
test { try parsePass("abc:/rooted", "abc://host/path", "abc:/rooted", "", "abc:", "", "", "", "", "", "/rooted", "", ""); }
test { try parsePass("///test", "http://example.org/", "http://test/", "", "http:", "", "", "test", "test", "", "/", "", ""); }
test { try parsePass("///\\//\\//test", "http://example.org/", "http://test/", "", "http:", "", "", "test", "test", "", "/", "", ""); }
test { try parsePass("///example.org/path", "http://example.org/", "http://example.org/path", "", "http:", "", "", "example.org", "example.org", "", "/path", "", ""); }
test { try parsePass("///example.org/../path", "http://example.org/", "http://example.org/path", "", "http:", "", "", "example.org", "example.org", "", "/path", "", ""); }
test { try parsePass("///example.org/../../", "http://example.org/", "http://example.org/", "", "http:", "", "", "example.org", "example.org", "", "/", "", ""); }
test { try parsePass("///example.org/../path/../../", "http://example.org/", "http://example.org/", "", "http:", "", "", "example.org", "example.org", "", "/", "", ""); }
test { try parsePass("///example.org/../path/../../path", "http://example.org/", "http://example.org/path", "", "http:", "", "", "example.org", "example.org", "", "/path", "", ""); }
test { try parsePass("/\\/\\//example.org/../path", "http://example.org/", "http://example.org/path", "", "http:", "", "", "example.org", "example.org", "", "/path", "", ""); }
test { try parsePass("///abcdef/../", "file:///", "file:///", "", "file:", "", "", "", "", "", "/", "", ""); }
test { try parsePass("/\\//\\/a/../", "file:///", "file://////", "", "file:", "", "", "", "", "", "////", "", ""); }
test { try parsePass("//a/../", "file:///", "file://a/", "", "file:", "", "", "a", "a", "", "/", "", ""); }

test { try parseIDNAFail("a\x200cb"); }
test { try parseIDNAFail("A\x200cB"); }
test { try parseIDNAFail("A\x200cb"); }
test { try parseIDNAFail("xn--ab-j1t"); }
test { try parseIDNAFail("a\x200db"); }
test { try parseIDNAFail("A\x200dB"); }
test { try parseIDNAFail("A\x200db"); }
test { try parseIDNAFail("xn--ab-m1t"); }
test { try parseIDNAFail(""); }
test { try parseIDNAFail("xn--u-ccb"); }
test { try parseIDNAFail("a\x2488com"); }
test { try parseIDNAFail("A\x2488COM"); }
test { try parseIDNAFail("A\x2488Com"); }
test { try parseIDNAFail("xn--acom-0w1b"); }
test { try parseIDNAFail("xn--a-ecp.ru"); }
test { try parseIDNAFail("xn--0.pt"); }
test { try parseIDNAFail("xn--a.pt"); }
test { try parseIDNAFail("xn--a-\xc4.pt"); }
test { try parseIDNAFail("xn--a-A\x308.pt"); }
test { try parseIDNAFail("xn--a-a\x308.pt"); }
test { try parseIDNAFail("xn--a-\xe4.pt"); }
test { try parseIDNAFail("XN--A-\xc4.PT"); }
test { try parseIDNAFail("XN--A-A\x308.PT"); }
test { try parseIDNAFail("Xn--A-A\x308.pt"); }
test { try parseIDNAFail("Xn--A-\xc4.pt"); }
test { try parseIDNAFail("xn--xn--a--gua.pt"); }
test { try parseIDNAFail("1.a\xdf\x200c\x200db\x200c\x200dc\xdf\xdf\xdf\xdfd\x3c2\x3c3\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdfe\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdfx\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdfy\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\x302\xdfz"); }
test { try parseIDNAFail("1.ASS\x200c\x200dB\x200c\x200dCSSSSSSSSD\x3a3\x3a3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSSS\x302SSZ"); }
test { try parseIDNAFail("1.ASS\x200c\x200dB\x200c\x200dCSSSSSSSSD\x3a3\x3a3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSS\x15cSSZ"); }
test { try parseIDNAFail("1.ass\x200c\x200db\x200c\x200dcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\x15dssz"); }
test { try parseIDNAFail("1.ass\x200c\x200db\x200c\x200dcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\x302ssz"); }
test { try parseIDNAFail("1.Ass\x200c\x200db\x200c\x200dcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\x302ssz"); }
test { try parseIDNAFail("1.Ass\x200c\x200db\x200c\x200dcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\x15dssz"); }
test { try parseIDNAFail("1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa69989dba9gc"); }
test { try parseIDNAFail("1.A\xdf\x200c\x200db\x200c\x200dc\xdf\xdf\xdf\xdfd\x3c2\x3c3\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdfe\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdfx\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdfy\xdf\xdf\xdf\xdf\xdf\xdf\xdf\xdf\x302\xdfz"); }
test { try parseIDNAFail("1.xn--abcdexyz-qyacaaabaaaaaaabaaaaaaaaabaaaaaaaaabaaaaaaaa010ze2isb1140zba8cc"); }
test { try parseIDNAFail("\x200cx\x200dn\x200c-\x200d-b\xdf"); }
test { try parseIDNAFail("\x200cX\x200dN\x200c-\x200d-BSS"); }
test { try parseIDNAFail("\x200cx\x200dn\x200c-\x200d-bss"); }
test { try parseIDNAFail("\x200cX\x200dn\x200c-\x200d-Bss"); }
test { try parseIDNAFail("xn--xn--bss-7z6ccid"); }
test { try parseIDNAFail("\x200cX\x200dn\x200c-\x200d-B\xdf"); }
test { try parseIDNAFail("xn--xn--b-pqa5796ccahd"); }
test { try parseIDNAFail("xn--xn---epa"); }
test { try parseIDNAFail("a.b.\x308c.d"); }
test { try parseIDNAFail("A.B.\x308C.D"); }
test { try parseIDNAFail("A.b.\x308c.d"); }
test { try parseIDNAFail("a.b.xn--c-bcb.d"); }
test { try parseIDNAFail("\xbb9\x200d"); }
test { try parseIDNAFail("xn--dmc225h"); }
test { try parseIDNAFail("\x200d"); }
test { try parseIDNAFail("xn--1ug"); }
test { try parseIDNAFail("\xbb9\x200c"); }
test { try parseIDNAFail("xn--dmc025h"); }
test { try parseIDNAFail("\x200c"); }
test { try parseIDNAFail("xn--0ug"); }
test { try parseIDNAFail("\x6ef\x200c\x6ef"); }
test { try parseIDNAFail("xn--cmba004q"); }
test { try parseIDNAFail("a\xd900z"); }
test { try parseIDNAFail("A\xd900Z"); }
test { try parseIDNAFail("xn--"); }
test { try parseIDNAFail("xn---"); }
test { try parseIDNAFail("xn--ASCII-"); }
test { try parseIDNAFail("xn--unicode-.org"); }
test { try parseIDNAFail("\x2495\x221d\x65f\xda0e\xdd26\xff0e-\xdb40\xdd2f"); }
test { try parseIDNAFail("14.\x221d\x65f\xda0e\xdd26.-\xdb40\xdd2f"); }
test { try parseIDNAFail("14.xn--7hb713l3v90n.-"); }
test { try parseIDNAFail("xn--7hb713lfwbi1311b.-"); }
test { try parseIDNAFail("\x200d\x2260\x1899\x226f.\xc1a3-\x1874\x10a0"); }
test { try parseIDNAFail("\x200d=\x338\x1899>\x338.\x1109\x1169\x11be-\x1874\x10a0"); }
test { try parseIDNAFail("\x200d=\x338\x1899>\x338.\x1109\x1169\x11be-\x1874\x2d00"); }
test { try parseIDNAFail("\x200d\x2260\x1899\x226f.\xc1a3-\x1874\x2d00"); }
test { try parseIDNAFail("xn--jbf929a90b0b.xn----p9j493ivi4l"); }
test { try parseIDNAFail("xn--jbf911clb.xn----6zg521d196p"); }
test { try parseIDNAFail("xn--jbf929a90b0b.xn----6zg521d196p"); }
test { try parseIDNAFail("\xd97d\xdf9c\xff0e\xd803\xdfc7\xfa2\x77d\x600"); }
test { try parseIDNAFail("\xd97d\xdf9c\xff0e\xd803\xdfc7\xfa1\xfb7\x77d\x600"); }
test { try parseIDNAFail("\xd97d\xdf9c.\xd803\xdfc7\xfa1\xfb7\x77d\x600"); }
test { try parseIDNAFail("xn--gw68a.xn--ifb57ev2psc6027m"); }
test { try parseIDNAFail("\xd84f\xdcd4\x303.\xd805\xdcc2"); }
test { try parseIDNAFail("xn--nsa95820a.xn--wz1d"); }
test { try parseIDNAFail("\x200c\xd9d4\xdfad.\x10b2\xd804\xddc0"); }
test { try parseIDNAFail("\x200c\xd9d4\xdfad.\x2d12\xd804\xddc0"); }
test { try parseIDNAFail("xn--bn95b.xn--9kj2034e"); }
test { try parseIDNAFail("xn--0ug15083f.xn--9kj2034e"); }
test { try parseIDNAFail("xn--bn95b.xn--qnd6272k"); }
test { try parseIDNAFail("xn--0ug15083f.xn--qnd6272k"); }
test { try parseIDNAFail("\x7e71\xd805\xddbf\x200d.\xff18\xfe12"); }
test { try parseIDNAFail("xn--gl0as212a.xn--8-o89h"); }
test { try parseIDNAFail("xn--1ug6928ac48e.xn--8-o89h"); }
test { try parseIDNAFail("\xdb40\xddbe\xff0e\xd838\xdc08"); }
test { try parseIDNAFail("\xdb40\xddbe.\xd838\xdc08"); }
test { try parseIDNAFail(".xn--ph4h"); }
test { try parseIDNAFail("\xdf\x6eb\x3002\x200d"); }
test { try parseIDNAFail("SS\x6eb\x3002\x200d"); }
test { try parseIDNAFail("ss\x6eb\x3002\x200d"); }
test { try parseIDNAFail("Ss\x6eb\x3002\x200d"); }
test { try parseIDNAFail("xn--ss-59d.xn--1ug"); }
test { try parseIDNAFail("xn--zca012a.xn--1ug"); }
test { try parseIDNAFail("\xdb41\xdc35\x200c\x2488\xff0e\xdb40\xdf87"); }
test { try parseIDNAFail("\xdb41\xdc35\x200c1..\xdb40\xdf87"); }
test { try parseIDNAFail("xn--1-bs31m..xn--tv36e"); }
test { try parseIDNAFail("xn--1-rgn37671n..xn--tv36e"); }
test { try parseIDNAFail("xn--tshz2001k.xn--tv36e"); }
test { try parseIDNAFail("xn--0ug88o47900b.xn--tv36e"); }
test { try parseIDNAFail("\xdb3c\xde23\x65f\xaab2\xdf\x3002\xdaf1\xdce7"); }
test { try parseIDNAFail("\xdb3c\xde23\x65f\xaab2SS\x3002\xdaf1\xdce7"); }
test { try parseIDNAFail("\xdb3c\xde23\x65f\xaab2ss\x3002\xdaf1\xdce7"); }
test { try parseIDNAFail("\xdb3c\xde23\x65f\xaab2Ss\x3002\xdaf1\xdce7"); }
test { try parseIDNAFail("xn--ss-3xd2839nncy1m.xn--bb79d"); }
test { try parseIDNAFail("xn--zca92z0t7n5w96j.xn--bb79d"); }
test { try parseIDNAFail("\x774\x200c\xd83a\xdd3f\x3002\xd8b5\xde10\x425c\x200d\xd9be\xdd3c"); }
test { try parseIDNAFail("\x774\x200c\xd83a\xdd1d\x3002\xd8b5\xde10\x425c\x200d\xd9be\xdd3c"); }
test { try parseIDNAFail("xn--4pb2977v.xn--z0nt555ukbnv"); }
test { try parseIDNAFail("xn--4pb607jjt73a.xn--1ug236ke314donv1a"); }
test { try parseIDNAFail("\x3164\x94d\x10a0\x17d0.\x180b"); }
test { try parseIDNAFail("\x1160\x94d\x10a0\x17d0.\x180b"); }
test { try parseIDNAFail("\x1160\x94d\x2d00\x17d0.\x180b"); }
test { try parseIDNAFail("xn--n3b445e53p."); }
test { try parseIDNAFail("\x3164\x94d\x2d00\x17d0.\x180b"); }
test { try parseIDNAFail("xn--n3b742bkqf4ty."); }
test { try parseIDNAFail("xn--n3b468aoqa89r."); }
test { try parseIDNAFail("xn--n3b445e53po6d."); }
test { try parseIDNAFail("xn--n3b468azngju2a."); }
test { try parseIDNAFail("\x2763\x200d\xff0e\x9cd\xd807\xdc3d\x612\xa929"); }
test { try parseIDNAFail("\x2763\x200d.\x9cd\xd807\xdc3d\x612\xa929"); }
test { try parseIDNAFail("xn--pei.xn--0fb32q3w7q2g4d"); }
test { try parseIDNAFail("xn--1ugy10a.xn--0fb32q3w7q2g4d"); }
test { try parseIDNAFail("\x349\x3002\xd85e\xdc6b"); }
test { try parseIDNAFail("xn--nua.xn--bc6k"); }
test { try parseIDNAFail("\xd807\xdc3f\xdb40\xdd66\xff0e\x1160"); }
test { try parseIDNAFail("\xd807\xdc3f\xdb40\xdd66.\x1160"); }
test { try parseIDNAFail("xn--ok3d."); }
test { try parseIDNAFail("xn--ok3d.xn--psd"); }
test { try parseIDNAFail("\x850f\xff61\xd807\xdc3a"); }
test { try parseIDNAFail("\x850f\x3002\xd807\xdc3a"); }
test { try parseIDNAFail("xn--uy1a.xn--jk3d"); }
test { try parseIDNAFail("xn--8g1d12120a.xn--5l6h"); }
test { try parseIDNAFail("\xd804\xdee7\xa9c02\xff61\x39c9\xda09\xdd84"); }
test { try parseIDNAFail("\xd804\xdee7\xa9c02\x3002\x39c9\xda09\xdd84"); }
test { try parseIDNAFail("xn--2-5z4eu89y.xn--97l02706d"); }
test { try parseIDNAFail("\x2938\x3c2\xd8ab\xdc40\xff61\xffa0"); }
test { try parseIDNAFail("\x2938\x3c2\xd8ab\xdc40\x3002\x1160"); }
test { try parseIDNAFail("\x2938\x3a3\xd8ab\xdc40\x3002\x1160"); }
test { try parseIDNAFail("\x2938\x3c3\xd8ab\xdc40\x3002\x1160"); }
test { try parseIDNAFail("xn--4xa192qmp03d."); }
test { try parseIDNAFail("xn--3xa392qmp03d."); }
test { try parseIDNAFail("\x2938\x3a3\xd8ab\xdc40\xff61\xffa0"); }
test { try parseIDNAFail("\x2938\x3c3\xd8ab\xdc40\xff61\xffa0"); }
test { try parseIDNAFail("xn--4xa192qmp03d.xn--psd"); }
test { try parseIDNAFail("xn--3xa392qmp03d.xn--psd"); }
test { try parseIDNAFail("xn--4xa192qmp03d.xn--cl7c"); }
test { try parseIDNAFail("xn--3xa392qmp03d.xn--cl7c"); }
test { try parseIDNAFail("\x200d\xdb7d\xdc56\xdb40\xdc50\xff0e\x5bd\xd826\xdfb0\xa85d\xd800\xdee1"); }
test { try parseIDNAFail("\x200d\xdb7d\xdc56\xdb40\xdc50.\x5bd\xd826\xdfb0\xa85d\xd800\xdee1"); }
test { try parseIDNAFail("xn--b726ey18m.xn--ldb8734fg0qcyzzg"); }
test { try parseIDNAFail("xn--1ug66101lt8me.xn--ldb8734fg0qcyzzg"); }
test { try parseIDNAFail("\x3002\xdbcc\xde35\x3c2\xd8c2\xdc07\x3002\xd802\xdf88"); }
test { try parseIDNAFail("\x3002\xdbcc\xde35\x3a3\xd8c2\xdc07\x3002\xd802\xdf88"); }
test { try parseIDNAFail("\x3002\xdbcc\xde35\x3c3\xd8c2\xdc07\x3002\xd802\xdf88"); }
test { try parseIDNAFail(".xn--4xa68573c7n64d.xn--f29c"); }
test { try parseIDNAFail(".xn--3xa88573c7n64d.xn--f29c"); }
test { try parseIDNAFail("\x2489\xdb40\xde93\x2260\xff61\x10bf\x2b23\x10a8"); }
test { try parseIDNAFail("\x2489\xdb40\xde93=\x338\xff61\x10bf\x2b23\x10a8"); }
test { try parseIDNAFail("2.\xdb40\xde93\x2260\x3002\x10bf\x2b23\x10a8"); }
test { try parseIDNAFail("2.\xdb40\xde93=\x338\x3002\x10bf\x2b23\x10a8"); }
test { try parseIDNAFail("2.\xdb40\xde93=\x338\x3002\x2d1f\x2b23\x2d08"); }
test { try parseIDNAFail("2.\xdb40\xde93\x2260\x3002\x2d1f\x2b23\x2d08"); }
test { try parseIDNAFail("2.xn--1chz4101l.xn--45iz7d6b"); }
test { try parseIDNAFail("\x2489\xdb40\xde93=\x338\xff61\x2d1f\x2b23\x2d08"); }
test { try parseIDNAFail("\x2489\xdb40\xde93\x2260\xff61\x2d1f\x2b23\x2d08"); }
test { try parseIDNAFail("xn--1ch07f91401d.xn--45iz7d6b"); }
test { try parseIDNAFail("2.xn--1chz4101l.xn--gnd9b297j"); }
test { try parseIDNAFail("xn--1ch07f91401d.xn--gnd9b297j"); }
test { try parseIDNAFail("-\xdb40\xde56\xa867\xff0e\xdb40\xde82\xd8dc\xdd83\xd83c\xdd09"); }
test { try parseIDNAFail("-\xdb40\xde56\xa867.\xdb40\xde82\xd8dc\xdd838,"); }
test { try parseIDNAFail("xn----hg4ei0361g.xn--8,-k362evu488a"); }
test { try parseIDNAFail("xn----hg4ei0361g.xn--207ht163h7m94c"); }
test { try parseIDNAFail("\x200c\xff61\x354"); }
test { try parseIDNAFail("\x200c\x3002\x354"); }
test { try parseIDNAFail(".xn--yua"); }
test { try parseIDNAFail("xn--0ug.xn--yua"); }
test { try parseIDNAFail("xn--de6h.xn--mnd799a"); }
test { try parseIDNAFail("\xfa4\xd986\xdd2f\xff0e\xd835\xdfed\x10bb"); }
test { try parseIDNAFail("\xfa4\xd986\xdd2f.1\x10bb"); }
test { try parseIDNAFail("\xfa4\xd986\xdd2f.1\x2d1b"); }
test { try parseIDNAFail("xn--0fd40533g.xn--1-tws"); }
test { try parseIDNAFail("\xfa4\xd986\xdd2f\xff0e\xd835\xdfed\x2d1b"); }
test { try parseIDNAFail("xn--0fd40533g.xn--1-q1g"); }
test { try parseIDNAFail("\x3c2\xd9d5\xdf0c\xff18.\xd83a\xdf64"); }
test { try parseIDNAFail("\x3c2\xd9d5\xdf0c8.\xd83a\xdf64"); }
test { try parseIDNAFail("\x3a3\xd9d5\xdf0c8.\xd83a\xdf64"); }
test { try parseIDNAFail("\x3c3\xd9d5\xdf0c8.\xd83a\xdf64"); }
test { try parseIDNAFail("xn--8-zmb14974n.xn--su6h"); }
test { try parseIDNAFail("xn--8-xmb44974n.xn--su6h"); }
test { try parseIDNAFail("\x3a3\xd9d5\xdf0c\xff18.\xd83a\xdf64"); }
test { try parseIDNAFail("\x3c3\xd9d5\xdf0c\xff18.\xd83a\xdf64"); }
test { try parseIDNAFail("\x200c\xae03.\x69b6-"); }
test { try parseIDNAFail("\x200c\x1100\x1173\x11b2.\x69b6-"); }
test { try parseIDNAFail("xn--0ug3307c.xn----d87b"); }
test { try parseIDNAFail("\xb253\x6cd3\xd833\xdd7d.\x9cd\x200d"); }
test { try parseIDNAFail("\x1102\x1170\x11be\x6cd3\xd833\xdd7d.\x9cd\x200d"); }
test { try parseIDNAFail("xn--lwwp69lqs7m.xn--b7b"); }
test { try parseIDNAFail("xn--lwwp69lqs7m.xn--b7b605i"); }
test { try parseIDNAFail("\x1b44\xff0e\x1baa-\x226e\x2260"); }
test { try parseIDNAFail("\x1b44\xff0e\x1baa-<\x338=\x338"); }
test { try parseIDNAFail("\x1b44.\x1baa-\x226e\x2260"); }
test { try parseIDNAFail("\x1b44.\x1baa-<\x338=\x338"); }
test { try parseIDNAFail("xn--1uf.xn----nmlz65aub"); }
test { try parseIDNAFail("\x1bf3\x10b1\x115f\xff0e\xd804\xdd34\x2132"); }
test { try parseIDNAFail("\x1bf3\x10b1\x115f.\xd804\xdd34\x2132"); }
test { try parseIDNAFail("\x1bf3\x2d11\x115f.\xd804\xdd34\x214e"); }
test { try parseIDNAFail("\x1bf3\x10b1\x115f.\xd804\xdd34\x214e"); }
test { try parseIDNAFail("xn--1zf224e.xn--73g3065g"); }
test { try parseIDNAFail("\x1bf3\x2d11\x115f\xff0e\xd804\xdd34\x214e"); }
test { try parseIDNAFail("\x1bf3\x10b1\x115f\xff0e\xd804\xdd34\x214e"); }
test { try parseIDNAFail("xn--pnd26a55x.xn--73g3065g"); }
test { try parseIDNAFail("xn--osd925cvyn.xn--73g3065g"); }
test { try parseIDNAFail("xn--pnd26a55x.xn--f3g7465g"); }
test { try parseIDNAFail("\x10a9\x7315\xdba5\xdeeb\x226e\xff0e\xfe12"); }
test { try parseIDNAFail("\x10a9\x7315\xdba5\xdeeb<\x338\xff0e\xfe12"); }
test { try parseIDNAFail("\x10a9\x7315\xdba5\xdeeb\x226e.\x3002"); }
test { try parseIDNAFail("\x10a9\x7315\xdba5\xdeeb<\x338.\x3002"); }
test { try parseIDNAFail("\x2d09\x7315\xdba5\xdeeb<\x338.\x3002"); }
test { try parseIDNAFail("\x2d09\x7315\xdba5\xdeeb\x226e.\x3002"); }
test { try parseIDNAFail("xn--gdh892bbz0d5438s.."); }
test { try parseIDNAFail("\x2d09\x7315\xdba5\xdeeb<\x338\xff0e\xfe12"); }
test { try parseIDNAFail("\x2d09\x7315\xdba5\xdeeb\x226e\xff0e\xfe12"); }
test { try parseIDNAFail("xn--gdh892bbz0d5438s.xn--y86c"); }
test { try parseIDNAFail("xn--hnd212gz32d54x5r.."); }
test { try parseIDNAFail("xn--hnd212gz32d54x5r.xn--y86c"); }
test { try parseIDNAFail("\xc5\xb444-\xff0e\x200c"); }
test { try parseIDNAFail("A\x30a\x1103\x116d\x11b7-\xff0e\x200c"); }
test { try parseIDNAFail("\xc5\xb444-.\x200c"); }
test { try parseIDNAFail("A\x30a\x1103\x116d\x11b7-.\x200c"); }
test { try parseIDNAFail("a\x30a\x1103\x116d\x11b7-.\x200c"); }
test { try parseIDNAFail("\xe5\xb444-.\x200c"); }
test { try parseIDNAFail("xn----1fa1788k.xn--0ug"); }
test { try parseIDNAFail("a\x30a\x1103\x116d\x11b7-\xff0e\x200c"); }
test { try parseIDNAFail("\xe5\xb444-\xff0e\x200c"); }
test { try parseIDNAFail("\xb8f1\x200d\xd880\xdf68\x200c\x3002\xd836\xde16\xfe12"); }
test { try parseIDNAFail("\x1105\x116e\x11b0\x200d\xd880\xdf68\x200c\x3002\xd836\xde16\xfe12"); }
test { try parseIDNAFail("\xb8f1\x200d\xd880\xdf68\x200c\x3002\xd836\xde16\x3002"); }
test { try parseIDNAFail("\x1105\x116e\x11b0\x200d\xd880\xdf68\x200c\x3002\xd836\xde16\x3002"); }
test { try parseIDNAFail("xn--ct2b0738h.xn--772h."); }
test { try parseIDNAFail("xn--0ugb3358ili2v.xn--772h."); }
test { try parseIDNAFail("xn--ct2b0738h.xn--y86cl899a"); }
test { try parseIDNAFail("xn--0ugb3358ili2v.xn--y86cl899a"); }
test { try parseIDNAFail("\xd83c\xdd04\xff0e\x1cdc\x2488\xdf"); }
test { try parseIDNAFail("3,.\x1cdc1.\xdf"); }
test { try parseIDNAFail("3,.\x1cdc1.SS"); }
test { try parseIDNAFail("3,.\x1cdc1.ss"); }
test { try parseIDNAFail("3,.\x1cdc1.Ss"); }
test { try parseIDNAFail("3,.xn--1-43l.ss"); }
test { try parseIDNAFail("3,.xn--1-43l.xn--zca"); }
test { try parseIDNAFail("\xd83c\xdd04\xff0e\x1cdc\x2488SS"); }
test { try parseIDNAFail("\xd83c\xdd04\xff0e\x1cdc\x2488ss"); }
test { try parseIDNAFail("\xd83c\xdd04\xff0e\x1cdc\x2488Ss"); }
test { try parseIDNAFail("3,.xn--ss-k1r094b"); }
test { try parseIDNAFail("3,.xn--zca344lmif"); }
test { try parseIDNAFail("xn--x07h.xn--ss-k1r094b"); }
test { try parseIDNAFail("xn--x07h.xn--zca344lmif"); }
test { try parseIDNAFail("\x1dfd\x103a\x94d\xff0e\x2260\x200d\x31db"); }
test { try parseIDNAFail("\x103a\x94d\x1dfd\xff0e\x2260\x200d\x31db"); }
test { try parseIDNAFail("\x103a\x94d\x1dfd\xff0e=\x338\x200d\x31db"); }
test { try parseIDNAFail("\x103a\x94d\x1dfd.\x2260\x200d\x31db"); }
test { try parseIDNAFail("\x103a\x94d\x1dfd.=\x338\x200d\x31db"); }
test { try parseIDNAFail("xn--n3b956a9zm.xn--1ch912d"); }
test { try parseIDNAFail("xn--n3b956a9zm.xn--1ug63gz5w"); }
test { try parseIDNAFail("\x1bf3.-\x900b\xd98e\xddad\xdb25\xde6e"); }
test { try parseIDNAFail("xn--1zf.xn----483d46987byr50b"); }
test { try parseIDNAFail("xn--9ob.xn--4xa380e"); }
test { try parseIDNAFail("xn--9ob.xn--4xa380ebol"); }
test { try parseIDNAFail("xn--9ob.xn--3xa580ebol"); }
test { try parseIDNAFail("xn--9ob.xn--4xa574u"); }
test { try parseIDNAFail("xn--9ob.xn--4xa795lq2l"); }
test { try parseIDNAFail("xn--9ob.xn--3xa995lq2l"); }
test { try parseIDNAFail("\x1846\x10a3\xff61\xdb3a\xdca7\x315\x200d\x200d"); }
test { try parseIDNAFail("\x1846\x10a3\x3002\xdb3a\xdca7\x315\x200d\x200d"); }
test { try parseIDNAFail("\x1846\x2d03\x3002\xdb3a\xdca7\x315\x200d\x200d"); }
test { try parseIDNAFail("xn--57e237h.xn--5sa98523p"); }
test { try parseIDNAFail("xn--57e237h.xn--5sa649la993427a"); }
test { try parseIDNAFail("\x1846\x2d03\xff61\xdb3a\xdca7\x315\x200d\x200d"); }
test { try parseIDNAFail("xn--bnd320b.xn--5sa98523p"); }
test { try parseIDNAFail("xn--bnd320b.xn--5sa649la993427a"); }
test { try parseIDNAFail("\xd838\xdc28\xff61\x1b44\xda45\xdee8\xd838\xdf87"); }
test { try parseIDNAFail("\xd838\xdc28\x3002\x1b44\xda45\xdee8\xd838\xdf87"); }
test { try parseIDNAFail("xn--mi4h.xn--1uf6843smg20c"); }
test { try parseIDNAFail("\x189b\xdb60\xdd5f\xdf.\x1327"); }
test { try parseIDNAFail("\x189b\xdb60\xdd5fSS.\x1327"); }
test { try parseIDNAFail("\x189b\xdb60\xdd5fss.\x1327"); }
test { try parseIDNAFail("\x189b\xdb60\xdd5fSs.\x1327"); }
test { try parseIDNAFail("xn--ss-7dp66033t.xn--p5d"); }
test { try parseIDNAFail("xn--zca562jc642x.xn--p5d"); }
test { try parseIDNAFail("\x2b92\x200c.\xd909\xde97\x200c"); }
test { try parseIDNAFail("xn--b9i.xn--5p9y"); }
test { try parseIDNAFail("xn--0ugx66b.xn--0ugz2871c"); }
test { try parseIDNAFail("\x226f\xd805\xdf2b\xdb42\xdf47.\x1734\xd909\xdfa4\xd804\xdf6c\x18a7"); }
test { try parseIDNAFail(">\x338\xd805\xdf2b\xdb42\xdf47.\x1734\xd909\xdfa4\xd804\xdf6c\x18a7"); }
test { try parseIDNAFail("xn--hdhx157g68o0g.xn--c0e65eu616c34o7a"); }
test { try parseIDNAFail("ss.xn--lgd10cu829c"); }
test { try parseIDNAFail("xn--zca.xn--lgd10cu829c"); }
test { try parseIDNAFail("\x1a5a\xd82e\xdd9d\xc4d\x3002\xd829\xdf6c\xd835\xdff5"); }
test { try parseIDNAFail("\x1a5a\xd82e\xdd9d\xc4d\x3002\xd829\xdf6c9"); }
test { try parseIDNAFail("xn--lqc703ebm93a.xn--9-000p"); }
test { try parseIDNAFail("\x1856\xff61\x31f\xd91d\xdee8\xb82-"); }
test { try parseIDNAFail("\x1856\x3002\x31f\xd91d\xdee8\xb82-"); }
test { try parseIDNAFail("xn--m8e.xn----mdb555dkk71m"); }
test { try parseIDNAFail("\x596\x10ab\xff0e\xd835\xdff3\x226f\xfe12\xfe0a"); }
test { try parseIDNAFail("\x596\x10ab\xff0e\xd835\xdff3>\x338\xfe12\xfe0a"); }
test { try parseIDNAFail("\x596\x10ab.7\x226f\x3002\xfe0a"); }
test { try parseIDNAFail("\x596\x10ab.7>\x338\x3002\xfe0a"); }
test { try parseIDNAFail("\x596\x2d0b.7>\x338\x3002\xfe0a"); }
test { try parseIDNAFail("\x596\x2d0b.7\x226f\x3002\xfe0a"); }
test { try parseIDNAFail("xn--hcb613r.xn--7-pgo."); }
test { try parseIDNAFail("\x596\x2d0b\xff0e\xd835\xdff3>\x338\xfe12\xfe0a"); }
test { try parseIDNAFail("\x596\x2d0b\xff0e\xd835\xdff3\x226f\xfe12\xfe0a"); }
test { try parseIDNAFail("xn--hcb613r.xn--7-pgoy530h"); }
test { try parseIDNAFail("xn--hcb887c.xn--7-pgo."); }
test { try parseIDNAFail("xn--hcb887c.xn--7-pgoy530h"); }
test { try parseIDNAFail("\xd83c\xdd07\x4f10\xfe12.\xd831\xde5a\xa8c4"); }
test { try parseIDNAFail("6,\x4f10\x3002.\xd831\xde5a\xa8c4"); }
test { try parseIDNAFail("xn--6,-7i3c..xn--0f9ao925c"); }
test { try parseIDNAFail("xn--6,-7i3cj157d.xn--0f9ao925c"); }
test { try parseIDNAFail("xn--woqs083bel0g.xn--0f9ao925c"); }
test { try parseIDNAFail("\xdb40\xdda0\xff0e\xd99d\xdc34\xdaf1\xdfc8"); }
test { try parseIDNAFail("\xdb40\xdda0.\xd99d\xdc34\xdaf1\xdfc8"); }
test { try parseIDNAFail(".xn--rx21bhv12i"); }
test { try parseIDNAFail("-.\x1886\xdb47\xdca3-"); }
test { try parseIDNAFail("-.xn----pbkx6497q"); }
test { try parseIDNAFail("\xdafd\xdcb0\xff0e-\xd835\xdffb\xdf"); }
test { try parseIDNAFail("\xdafd\xdcb0.-5\xdf"); }
test { try parseIDNAFail("\xdafd\xdcb0.-5SS"); }
test { try parseIDNAFail("\xdafd\xdcb0.-5ss"); }
test { try parseIDNAFail("xn--t960e.-5ss"); }
test { try parseIDNAFail("xn--t960e.xn---5-hia"); }
test { try parseIDNAFail("\xdafd\xdcb0\xff0e-\xd835\xdffbSS"); }
test { try parseIDNAFail("\xdafd\xdcb0\xff0e-\xd835\xdffbss"); }
test { try parseIDNAFail("\xdafd\xdcb0\xff0e-\xd835\xdffbSs"); }
test { try parseIDNAFail("\xdafd\xdcb0.-5Ss"); }
test { try parseIDNAFail("\x200d\xd802\xde3f.\xd83e\xdd12\x10c5\xda06\xdfb6"); }
test { try parseIDNAFail("\x200d\xd802\xde3f.\xd83e\xdd12\x2d25\xda06\xdfb6"); }
test { try parseIDNAFail("xn--0s9c.xn--tljz038l0gz4b"); }
test { try parseIDNAFail("xn--1ug9533g.xn--tljz038l0gz4b"); }
test { try parseIDNAFail("xn--0s9c.xn--9nd3211w0gz4b"); }
test { try parseIDNAFail("xn--1ug9533g.xn--9nd3211w0gz4b"); }
test { try parseIDNAFail("\xd894\xdec5\x3002\xdf\xd873\xdd69\x200d"); }
test { try parseIDNAFail("\xd894\xdec5\x3002SS\xd873\xdd69\x200d"); }
test { try parseIDNAFail("\xd894\xdec5\x3002ss\xd873\xdd69\x200d"); }
test { try parseIDNAFail("\xd894\xdec5\x3002Ss\xd873\xdd69\x200d"); }
test { try parseIDNAFail("xn--ey1p.xn--ss-eq36b"); }
test { try parseIDNAFail("xn--ey1p.xn--ss-n1tx0508a"); }
test { try parseIDNAFail("xn--ey1p.xn--zca870nz438b"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\xff61\xd805\xddbf\x1abb\x3c2\x2260"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\xff61\xd805\xddbf\x1abb\x3c2=\x338"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\x3002\xd805\xddbf\x1abb\x3c2\x2260"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\x3002\xd805\xddbf\x1abb\x3c2=\x338"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\x3002\xd805\xddbf\x1abb\x3a3=\x338"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\x3002\xd805\xddbf\x1abb\x3a3\x2260"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\x3002\xd805\xddbf\x1abb\x3c3\x2260"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\x3002\xd805\xddbf\x1abb\x3c3=\x338"); }
test { try parseIDNAFail("xn--zb9h5968x.xn--4xa378i1mfjw7y"); }
test { try parseIDNAFail("xn--0ug3766p5nm1b.xn--4xa378i1mfjw7y"); }
test { try parseIDNAFail("xn--0ug3766p5nm1b.xn--3xa578i1mfjw7y"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\xff61\xd805\xddbf\x1abb\x3a3=\x338"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\xff61\xd805\xddbf\x1abb\x3a3\x2260"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\xff61\xd805\xddbf\x1abb\x3c3\x2260"); }
test { try parseIDNAFail("\xdb40\xdd6f\xd9df\xdf6d\x200c\xd83d\xdf2d\xff61\xd805\xddbf\x1abb\x3c3=\x338"); }
test { try parseIDNAFail("\x248b\xff61\x2488\x200d\xda8f\xdd22"); }
test { try parseIDNAFail("4.\x30021.\x200d\xda8f\xdd22"); }
test { try parseIDNAFail("4..1.xn--sf51d"); }
test { try parseIDNAFail("4..1.xn--1ug64613i"); }
test { try parseIDNAFail("xn--wsh.xn--tsh07994h"); }
test { try parseIDNAFail("xn--wsh.xn--1ug58o74922a"); }
test { try parseIDNAFail("\x10b3\xd805\xdf2b\x200d\xda1e\xdf53\xff0e\x6a7\xd807\xdc36"); }
test { try parseIDNAFail("\x10b3\xd805\xdf2b\x200d\xda1e\xdf53.\x6a7\xd807\xdc36"); }
test { try parseIDNAFail("\x2d13\xd805\xdf2b\x200d\xda1e\xdf53.\x6a7\xd807\xdc36"); }
test { try parseIDNAFail("xn--blj6306ey091d.xn--9jb4223l"); }
test { try parseIDNAFail("xn--1ugy52cym7p7xu5e.xn--9jb4223l"); }
test { try parseIDNAFail("\x2d13\xd805\xdf2b\x200d\xda1e\xdf53\xff0e\x6a7\xd807\xdc36"); }
test { try parseIDNAFail("xn--rnd8945ky009c.xn--9jb4223l"); }
test { try parseIDNAFail("xn--rnd479ep20q7x12e.xn--9jb4223l"); }
test { try parseIDNAFail("\xd802\xde3f.\xd83c\xdd06\x2014"); }
test { try parseIDNAFail("\xd802\xde3f.5,\x2014"); }
test { try parseIDNAFail("xn--0s9c.xn--5,-81t"); }
test { try parseIDNAFail("xn--0s9c.xn--8ug8324p"); }
test { try parseIDNAFail("\xda10\xdeb1\xd8c6\xddae\x6f8\x3002\xdb43\xdfad-"); }
test { try parseIDNAFail("xn--lmb18944c0g2z.xn----2k81m"); }
test { try parseIDNAFail("\xd83d\xdf85\xdb43\xdce1\xdb30\xdf59.\xd989\xddb7"); }
test { try parseIDNAFail("xn--ie9hi1349bqdlb.xn--oj69a"); }
test { try parseIDNAFail("\x20e7\xd97e\xdc4e-\xda6e\xdcdd.4\x10a4\x200c"); }
test { try parseIDNAFail("\x20e7\xd97e\xdc4e-\xda6e\xdcdd.4\x2d04\x200c"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-ivs"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-sgn589c"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-f0g"); }
test { try parseIDNAFail("xn----9snu5320fi76w.xn--4-f0g649i"); }
test { try parseIDNAFail("\xd805\xdc44\x226f\xff61\xd805\xdf24"); }
test { try parseIDNAFail("\xd805\xdc44>\x338\xff61\xd805\xdf24"); }
test { try parseIDNAFail("\xd805\xdc44\x226f\x3002\xd805\xdf24"); }
test { try parseIDNAFail("\xd805\xdc44>\x338\x3002\xd805\xdf24"); }
test { try parseIDNAFail("xn--hdh5636g.xn--ci2d"); }
test { try parseIDNAFail("\x10ab\x226e\xd887\xdc86\x3002\x200d\x7a7\xd800\xdee3"); }
test { try parseIDNAFail("\x10ab<\x338\xd887\xdc86\x3002\x200d\x7a7\xd800\xdee3"); }
test { try parseIDNAFail("\x2d0b<\x338\xd887\xdc86\x3002\x200d\x7a7\xd800\xdee3"); }
test { try parseIDNAFail("\x2d0b\x226e\xd887\xdc86\x3002\x200d\x7a7\xd800\xdee3"); }
test { try parseIDNAFail("xn--gdhz03bxt42d.xn--lrb6479j"); }
test { try parseIDNAFail("xn--gdhz03bxt42d.xn--lrb506jqr4n"); }
test { try parseIDNAFail("xn--jnd802gsm17c.xn--lrb6479j"); }
test { try parseIDNAFail("xn--jnd802gsm17c.xn--lrb506jqr4n"); }
test { try parseIDNAFail("\x17d2.\xd9db\xdf52\x226f"); }
test { try parseIDNAFail("\x17d2.\xd9db\xdf52>\x338"); }
test { try parseIDNAFail("xn--u4e.xn--hdhx0084f"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734\xff0e\xd802\xde3a\xc9\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734\xff0e\xd802\xde3aE\x301\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734.\xd802\xde3a\xc9\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734.\xd802\xde3aE\x301\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734.\xd802\xde3ae\x301\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734.\xd802\xde3a\xe9\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("xn--c0e34564d.xn--9ca207st53lg3f"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734\xff0e\xd802\xde3ae\x301\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("\xd8fc\xdc47\x1734\xff0e\xd802\xde3a\xe9\x2b13\xd804\xdd34"); }
test { try parseIDNAFail("\x10c3\xff0e\x653\x18a4"); }
test { try parseIDNAFail("\x10c3.\x653\x18a4"); }
test { try parseIDNAFail("\x2d23.\x653\x18a4"); }
test { try parseIDNAFail("xn--rlj.xn--vhb294g"); }
test { try parseIDNAFail("\x2d23\xff0e\x653\x18a4"); }
test { try parseIDNAFail("xn--7nd.xn--vhb294g"); }
test { try parseIDNAFail("\xdb40\xdd08\x813\xff0e\xc2c9\xd9d0\xddbb\x10c4\xd9ca\xdc50"); }
test { try parseIDNAFail("\xdb40\xdd08\x813\xff0e\x1109\x1174\x11b0\xd9d0\xddbb\x10c4\xd9ca\xdc50"); }
test { try parseIDNAFail("\xdb40\xdd08\x813.\xc2c9\xd9d0\xddbb\x10c4\xd9ca\xdc50"); }
test { try parseIDNAFail("\xdb40\xdd08\x813.\x1109\x1174\x11b0\xd9d0\xddbb\x10c4\xd9ca\xdc50"); }
test { try parseIDNAFail("\xdb40\xdd08\x813.\x1109\x1174\x11b0\xd9d0\xddbb\x2d24\xd9ca\xdc50"); }
test { try parseIDNAFail("\xdb40\xdd08\x813.\xc2c9\xd9d0\xddbb\x2d24\xd9ca\xdc50"); }
test { try parseIDNAFail("xn--oub.xn--sljz109bpe25dviva"); }
test { try parseIDNAFail("\xdb40\xdd08\x813\xff0e\x1109\x1174\x11b0\xd9d0\xddbb\x2d24\xd9ca\xdc50"); }
test { try parseIDNAFail("\xdb40\xdd08\x813\xff0e\xc2c9\xd9d0\xddbb\x2d24\xd9ca\xdc50"); }
test { try parseIDNAFail("xn--oub.xn--8nd9522gpe69cviva"); }
test { try parseIDNAFail("\xaa2c\xd807\xdcab\x226e\xff0e\x2902"); }
test { try parseIDNAFail("\xaa2c\xd807\xdcab<\x338\xff0e\x2902"); }
test { try parseIDNAFail("\xaa2c\xd807\xdcab\x226e.\x2902"); }
test { try parseIDNAFail("\xaa2c\xd807\xdcab<\x338.\x2902"); }
test { try parseIDNAFail("xn--gdh1854cn19c.xn--kqi"); }
test { try parseIDNAFail("\xd804\xdc45\x3002-"); }
test { try parseIDNAFail("xn--210d.-"); }
test { try parseIDNAFail("\xa866\x1851\x200d\x2488\x3002\xd800\xdee3-"); }
test { try parseIDNAFail("\xa866\x1851\x200d1.\x3002\xd800\xdee3-"); }
test { try parseIDNAFail("xn--1-o7j663bdl7m..xn----381i"); }
test { try parseIDNAFail("xn--h8e863drj7h.xn----381i"); }
test { try parseIDNAFail("xn--h8e470bl0d838o.xn----381i"); }
test { try parseIDNAFail("\x2488\x4c39\x200d-\x3002\xc6c8"); }
test { try parseIDNAFail("\x2488\x4c39\x200d-\x3002\x110b\x116e\x11bf"); }
test { try parseIDNAFail("1.\x4c39\x200d-\x3002\xc6c8"); }
test { try parseIDNAFail("1.\x4c39\x200d-\x3002\x110b\x116e\x11bf"); }
test { try parseIDNAFail("1.xn----tgnz80r.xn--kp5b"); }
test { try parseIDNAFail("xn----dcp160o.xn--kp5b"); }
test { try parseIDNAFail("xn----tgnx5rjr6c.xn--kp5b"); }
test { try parseIDNAFail("\x3066\x3002\x200c\xdb43\xdcfd\x7f3"); }
test { try parseIDNAFail("xn--m9j.xn--rtb10784p"); }
test { try parseIDNAFail("xn--m9j.xn--rtb154j9l73w"); }
test { try parseIDNAFail("\x3c2\xff61\xa9c0\x6e7"); }
test { try parseIDNAFail("\x3c2\x3002\xa9c0\x6e7"); }
test { try parseIDNAFail("\x3a3\x3002\xa9c0\x6e7"); }
test { try parseIDNAFail("\x3c3\x3002\xa9c0\x6e7"); }
test { try parseIDNAFail("xn--4xa.xn--3lb1944f"); }
test { try parseIDNAFail("xn--3xa.xn--3lb1944f"); }
test { try parseIDNAFail("\x3a3\xff61\xa9c0\x6e7"); }
test { try parseIDNAFail("\x3c3\xff61\xa9c0\x6e7"); }
test { try parseIDNAFail("\xbcd\xdb56\xdec5\xd9f0\xde51.\x10a2\x10b5"); }
test { try parseIDNAFail("\xbcd\xdb56\xdec5\xd9f0\xde51.\x2d02\x2d15"); }
test { try parseIDNAFail("\xbcd\xdb56\xdec5\xd9f0\xde51.\x10a2\x2d15"); }
test { try parseIDNAFail("xn--xmc83135idcxza.xn--tkjwb"); }
test { try parseIDNAFail("xn--xmc83135idcxza.xn--9md086l"); }
test { try parseIDNAFail("xn--xmc83135idcxza.xn--9md2b"); }
test { try parseIDNAFail("\x1c32\xd83c\xdd08\x2f9b\x5a6\xff0e\x200d\xda7e\xdd64\x7fd"); }
test { try parseIDNAFail("\x1c327,\x8d70\x5a6.\x200d\xda7e\xdd64\x7fd"); }
test { try parseIDNAFail("xn--7,-bid991urn3k.xn--1tb13454l"); }
test { try parseIDNAFail("xn--7,-bid991urn3k.xn--1tb334j1197q"); }
test { try parseIDNAFail("xn--xcb756i493fwi5o.xn--1tb13454l"); }
test { try parseIDNAFail("xn--xcb756i493fwi5o.xn--1tb334j1197q"); }
test { try parseIDNAFail("\x1897\xff61\x4c0\xd934\xdd3b"); }
test { try parseIDNAFail("\x1897\x3002\x4c0\xd934\xdd3b"); }
test { try parseIDNAFail("\x1897\x3002\x4cf\xd934\xdd3b"); }
test { try parseIDNAFail("xn--hbf.xn--s5a83117e"); }
test { try parseIDNAFail("\x1897\xff61\x4cf\xd934\xdd3b"); }
test { try parseIDNAFail("xn--hbf.xn--d5a86117e"); }
test { try parseIDNAFail("\xd807\xdc98\xdb40\xdd12\xd80d\xdc61\xff61\xd835\xdfea\x10bc"); }
test { try parseIDNAFail("\xd807\xdc98\xdb40\xdd12\xd80d\xdc61\x30028\x10bc"); }
test { try parseIDNAFail("\xd807\xdc98\xdb40\xdd12\xd80d\xdc61\x30028\x2d1c"); }
test { try parseIDNAFail("xn--7m3d291b.xn--8-vws"); }
test { try parseIDNAFail("\xd807\xdc98\xdb40\xdd12\xd80d\xdc61\xff61\xd835\xdfea\x2d1c"); }
test { try parseIDNAFail("xn--7m3d291b.xn--8-s1g"); }
test { try parseIDNAFail("\x1bab\xff61\xd83c\xdc89\xdb40\xdc70"); }
test { try parseIDNAFail("\x1bab\x3002\xd83c\xdc89\xdb40\xdc70"); }
test { try parseIDNAFail("xn--zxf.xn--fx7ho0250c"); }
test { try parseIDNAFail("\xdb71\xdeb6\xdba0\xded6\xda1a\xde70-\x3002\x200c"); }
test { try parseIDNAFail("xn----7i12hu122k9ire."); }
test { try parseIDNAFail("xn----7i12hu122k9ire.xn--0ug"); }
test { try parseIDNAFail("\xfe12\xff0e\xfe2f\xd805\xdc42"); }
test { try parseIDNAFail("\xfe12\xff0e\xd805\xdc42\xfe2f"); }
test { try parseIDNAFail("\x3002.\xd805\xdc42\xfe2f"); }
test { try parseIDNAFail("..xn--s96cu30b"); }
test { try parseIDNAFail("xn--y86c.xn--s96cu30b"); }
test { try parseIDNAFail("\xa92c\x3002\x200d"); }
test { try parseIDNAFail("xn--zi9a."); }
test { try parseIDNAFail("xn--zi9a.xn--1ug"); }
test { try parseIDNAFail("\xdb58\xde04\x3002-"); }
test { try parseIDNAFail("xn--xm38e.-"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee\xff0e\xda98\xde2e\xf18\xdf\x226f"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee\xff0e\xda98\xde2e\xf18\xdf>\x338"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee.\xda98\xde2e\xf18\xdf\x226f"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee.\xda98\xde2e\xf18\xdf>\x338"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee.\xda98\xde2e\xf18SS>\x338"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee.\xda98\xde2e\xf18SS\x226f"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee.\xda98\xde2e\xf18ss\x226f"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee.\xda98\xde2e\xf18ss>\x338"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee.\xda98\xde2e\xf18Ss>\x338"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee.\xda98\xde2e\xf18Ss\x226f"); }
test { try parseIDNAFail("xn--pgh4639f.xn--ss-ifj426nle504a"); }
test { try parseIDNAFail("xn--pgh4639f.xn--zca593eo6oc013y"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee\xff0e\xda98\xde2e\xf18SS>\x338"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee\xff0e\xda98\xde2e\xf18SS\x226f"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee\xff0e\xda98\xde2e\xf18ss\x226f"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee\xff0e\xda98\xde2e\xf18ss>\x338"); }
test { try parseIDNAFail("\x227c\x338\xd800\xdeee\xff0e\xda98\xde2e\xf18Ss>\x338"); }
test { try parseIDNAFail("\x22e0\xd800\xdeee\xff0e\xda98\xde2e\xf18Ss\x226f"); }
test { try parseIDNAFail("\x330\xff0e\xdb81\xdf31\x8680"); }
test { try parseIDNAFail("\x330.\xdb81\xdf31\x8680"); }
test { try parseIDNAFail("xn--xta.xn--e91aw9417e"); }
test { try parseIDNAFail("\xd83e\xdc9f\xd83c\xdd08\x200d\xa84e\xff61\xf84"); }
test { try parseIDNAFail("\xd83e\xdc9f7,\x200d\xa84e\x3002\xf84"); }
test { try parseIDNAFail("xn--7,-gh9hg322i.xn--3ed"); }
test { try parseIDNAFail("xn--7,-n1t0654eqo3o.xn--3ed"); }
test { try parseIDNAFail("xn--nc9aq743ds0e.xn--3ed"); }
test { try parseIDNAFail("xn--1ug4874cfd0kbmg.xn--3ed"); }
test { try parseIDNAFail("\xa854\x3002\x1039\x1887"); }
test { try parseIDNAFail("xn--tc9a.xn--9jd663b"); }
test { try parseIDNAFail("\x20eb\x226e.\xd836\xde16"); }
test { try parseIDNAFail("\x20eb<\x338.\xd836\xde16"); }
test { try parseIDNAFail("xn--e1g71d.xn--772h"); }
test { try parseIDNAFail("\x200c.\x226f"); }
test { try parseIDNAFail("\x200c.>\x338"); }
test { try parseIDNAFail("xn--0ug.xn--hdh"); }
test { try parseIDNAFail("\xd880\xdd67\xd94e\xde60-\xff0e\xabed-\x609c"); }
test { try parseIDNAFail("\xd880\xdd67\xd94e\xde60-.\xabed-\x609c"); }
test { try parseIDNAFail("xn----7m53aj640l.xn----8f4br83t"); }
test { try parseIDNAFail("\x1849\xd899\xdce7\x2b1e\x189c.-\x200d\xd83a\xdcd1\x202e"); }
test { try parseIDNAFail("xn--87e0ol04cdl39e.xn----qinu247r"); }
test { try parseIDNAFail("xn--87e0ol04cdl39e.xn----ugn5e3763s"); }
test { try parseIDNAFail("xn--ynd2415j.xn--5-dug9054m"); }
test { try parseIDNAFail("\x200d-\x1839\xfe6a.\x1de1\x1922"); }
test { try parseIDNAFail("\x200d-\x1839%.\x1de1\x1922"); }
test { try parseIDNAFail("xn---%-u4o.xn--gff52t"); }
test { try parseIDNAFail("xn---%-u4oy48b.xn--gff52t"); }
test { try parseIDNAFail("xn----c6jx047j.xn--gff52t"); }
test { try parseIDNAFail("xn----c6j614b1z4v.xn--gff52t"); }
test { try parseIDNAFail("\xd84e\xde6b\xff0e\xd9f1\xdc72"); }
test { try parseIDNAFail("\xd84e\xde6b.\xd9f1\xdc72"); }
test { try parseIDNAFail("xn--td3j.xn--4628b"); }
test { try parseIDNAFail("\xc4d\xd836\xde3e\x5a9\xd835\xdfed\x3002-\xd805\xdf28"); }
test { try parseIDNAFail("\xc4d\xd836\xde3e\x5a91\x3002-\xd805\xdf28"); }
test { try parseIDNAFail("xn--1-rfc312cdp45c.xn----nq0j"); }
test { try parseIDNAFail("\xda4f\xdfc8\x3002\xb64f"); }
test { try parseIDNAFail("\xda4f\xdfc8\x3002\x1104\x116b\x11ae"); }
test { try parseIDNAFail("xn--ph26c.xn--281b"); }
test { try parseIDNAFail("\xd916\xde1a\xdb40\xdd0c\xdb07\xdf40\x1840.\x8b6"); }
test { try parseIDNAFail("xn--z7e98100evc01b.xn--czb"); }
test { try parseIDNAFail("\x200d\xff61\xd8d4\xdc5b"); }
test { try parseIDNAFail("\x200d\x3002\xd8d4\xdc5b"); }
test { try parseIDNAFail(".xn--6x4u"); }
test { try parseIDNAFail("xn--1ug.xn--6x4u"); }
test { try parseIDNAFail("\xfff9\x200c\xff61\x66f3\x2f91\xd800\xdef0\x226f"); }
test { try parseIDNAFail("\xfff9\x200c\xff61\x66f3\x2f91\xd800\xdef0>\x338"); }
test { try parseIDNAFail("\xfff9\x200c\x3002\x66f3\x897e\xd800\xdef0\x226f"); }
test { try parseIDNAFail("\xfff9\x200c\x3002\x66f3\x897e\xd800\xdef0>\x338"); }
test { try parseIDNAFail("xn--vn7c.xn--hdh501y8wvfs5h"); }
test { try parseIDNAFail("xn--0ug2139f.xn--hdh501y8wvfs5h"); }
test { try parseIDNAFail("\x226f\x2488\x3002\xdf"); }
test { try parseIDNAFail(">\x338\x2488\x3002\xdf"); }
test { try parseIDNAFail(">\x338\x2488\x3002SS"); }
test { try parseIDNAFail("\x226f\x2488\x3002SS"); }
test { try parseIDNAFail("\x226f\x2488\x3002ss"); }
test { try parseIDNAFail(">\x338\x2488\x3002ss"); }
test { try parseIDNAFail(">\x338\x2488\x3002Ss"); }
test { try parseIDNAFail("\x226f\x2488\x3002Ss"); }
test { try parseIDNAFail("xn--hdh84f.ss"); }
test { try parseIDNAFail("xn--hdh84f.xn--zca"); }
test { try parseIDNAFail("\x200c\xff61\x2260"); }
test { try parseIDNAFail("\x200c\xff61=\x338"); }
test { try parseIDNAFail("\x200c\x3002\x2260"); }
test { try parseIDNAFail("\x200c\x3002=\x338"); }
test { try parseIDNAFail("xn--0ug.xn--1ch"); }
test { try parseIDNAFail("\xd805\xddbf\xd836\xde14.\x185f\xd805\xddbf\x1b42\x200c"); }
test { try parseIDNAFail("xn--461dw464a.xn--v8e29loy65a"); }
test { try parseIDNAFail("xn--461dw464a.xn--v8e29ldzfo952a"); }
test { try parseIDNAFail("\xda12\xdcf3\x200d\xda05\xdf71.\xd81a\xdf34\x2183\x2260-"); }
test { try parseIDNAFail("\xda12\xdcf3\x200d\xda05\xdf71.\xd81a\xdf34\x2183=\x338-"); }
test { try parseIDNAFail("\xda12\xdcf3\x200d\xda05\xdf71.\xd81a\xdf34\x2184=\x338-"); }
test { try parseIDNAFail("\xda12\xdcf3\x200d\xda05\xdf71.\xd81a\xdf34\x2184\x2260-"); }
test { try parseIDNAFail("xn--6j00chy9a.xn----81n51bt713h"); }
test { try parseIDNAFail("xn--1ug15151gkb5a.xn----81n51bt713h"); }
test { try parseIDNAFail("xn--6j00chy9a.xn----61n81bt713h"); }
test { try parseIDNAFail("xn--1ug15151gkb5a.xn----61n81bt713h"); }
test { try parseIDNAFail("\x200d\x252e\xdb40\xddd0\xff0e\xc00\xc4d\x1734\x200d"); }
test { try parseIDNAFail("\x200d\x252e\xdb40\xddd0.\xc00\xc4d\x1734\x200d"); }
test { try parseIDNAFail("xn--kxh.xn--eoc8m432a"); }
test { try parseIDNAFail("xn--1ug04r.xn--eoc8m432a40i"); }
test { try parseIDNAFail("\xdaa5\xdeaa\xff61\xd83c\xdd02"); }
test { try parseIDNAFail("\xdaa5\xdeaa\x30021,"); }
test { try parseIDNAFail("xn--n433d.1,"); }
test { try parseIDNAFail("xn--n433d.xn--v07h"); }
test { try parseIDNAFail("\xd804\xdf68\x520d.\xd83d\xdee6"); }
test { try parseIDNAFail("xn--rbry728b.xn--y88h"); }
test { try parseIDNAFail("\xdb40\xdf0f3\xff61\x1bf1\xd835\xdfd2"); }
test { try parseIDNAFail("\xdb40\xdf0f3\x3002\x1bf14"); }
test { try parseIDNAFail("xn--3-ib31m.xn--4-pql"); }
test { try parseIDNAFail("\xa87d\x226f\xff0e\xdaaf\xdc80\xda0b\xdcc4"); }
test { try parseIDNAFail("\xa87d>\x338\xff0e\xdaaf\xdc80\xda0b\xdcc4"); }
test { try parseIDNAFail("\xa87d\x226f.\xdaaf\xdc80\xda0b\xdcc4"); }
test { try parseIDNAFail("\xa87d>\x338.\xdaaf\xdc80\xda0b\xdcc4"); }
test { try parseIDNAFail("xn--hdh8193c.xn--5z40cp629b"); }
test { try parseIDNAFail("\xdb43\xdcdb\xff0e\x200d\x492b\x2260\x10be"); }
test { try parseIDNAFail("\xdb43\xdcdb\xff0e\x200d\x492b=\x338\x10be"); }
test { try parseIDNAFail("\xdb43\xdcdb.\x200d\x492b\x2260\x10be"); }
test { try parseIDNAFail("\xdb43\xdcdb.\x200d\x492b=\x338\x10be"); }
test { try parseIDNAFail("\xdb43\xdcdb.\x200d\x492b=\x338\x2d1e"); }
test { try parseIDNAFail("\xdb43\xdcdb.\x200d\x492b\x2260\x2d1e"); }
test { try parseIDNAFail("xn--1t56e.xn--1ch153bqvw"); }
test { try parseIDNAFail("xn--1t56e.xn--1ug73gzzpwi3a"); }
test { try parseIDNAFail("\xdb43\xdcdb\xff0e\x200d\x492b=\x338\x2d1e"); }
test { try parseIDNAFail("\xdb43\xdcdb\xff0e\x200d\x492b\x2260\x2d1e"); }
test { try parseIDNAFail("xn--1t56e.xn--2nd141ghl2a"); }
test { try parseIDNAFail("xn--1t56e.xn--2nd159e9vb743e"); }
test { try parseIDNAFail("3.1.xn--110d.j"); }
test { try parseIDNAFail("xn--tshd3512p.j"); }
test { try parseIDNAFail("\x34a\xff0e\xd802\xde0e"); }
test { try parseIDNAFail("\x34a.\xd802\xde0e"); }
test { try parseIDNAFail("xn--oua.xn--mr9c"); }
test { try parseIDNAFail("\xd6c9\x226e\xff61\xe34"); }
test { try parseIDNAFail("\x1112\x116e\x11ac<\x338\xff61\xe34"); }
test { try parseIDNAFail("\xd6c9\x226e\x3002\xe34"); }
test { try parseIDNAFail("\x1112\x116e\x11ac<\x338\x3002\xe34"); }
test { try parseIDNAFail("xn--gdh2512e.xn--i4c"); }
test { try parseIDNAFail("xn--fc9a.xn----qmg787k869k"); }
test { try parseIDNAFail("\x226e\xd834\xdd76\xff0e\xd987\xdc81\xaaec\x2e48\xdb82\xdd6d"); }
test { try parseIDNAFail("<\x338\xd834\xdd76\xff0e\xd987\xdc81\xaaec\x2e48\xdb82\xdd6d"); }
test { try parseIDNAFail("\x226e\xd834\xdd76.\xd987\xdc81\xaaec\x2e48\xdb82\xdd6d"); }
test { try parseIDNAFail("<\x338\xd834\xdd76.\xd987\xdc81\xaaec\x2e48\xdb82\xdd6d"); }
test { try parseIDNAFail("xn--gdh.xn--4tjx101bsg00ds9pyc"); }
test { try parseIDNAFail("xn--gdh0880o.xn--4tjx101bsg00ds9pyc"); }
test { try parseIDNAFail("\xd805\xdc42\xff61\x200d\xdb55\xdf80\xd83d\xdf95\xda54\xdc54"); }
test { try parseIDNAFail("\xd805\xdc42\x3002\x200d\xdb55\xdf80\xd83d\xdf95\xda54\xdc54"); }
test { try parseIDNAFail("xn--8v1d.xn--ye9h41035a2qqs"); }
test { try parseIDNAFail("xn--8v1d.xn--1ug1386plvx1cd8vya"); }
test { try parseIDNAFail("-\x200c\x2499\xd802\xdee5\xff61\xd836\xde35"); }
test { try parseIDNAFail("-\x200c18.\xd802\xdee5\x3002\xd836\xde35"); }
test { try parseIDNAFail("-18.xn--rx9c.xn--382h"); }
test { try parseIDNAFail("xn---18-9m0a.xn--rx9c.xn--382h"); }
test { try parseIDNAFail("xn----ddps939g.xn--382h"); }
test { try parseIDNAFail("xn----sgn18r3191a.xn--382h"); }
test { try parseIDNAFail("\xfe05\xfe12\x3002\xd858\xdc3e\x1ce0"); }
test { try parseIDNAFail("xn--y86c.xn--t6f5138v"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-\xdf\x200c\x2260"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-\xdf\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f.-\xdf\x200c\x2260"); }
test { try parseIDNAFail("\xdb41\xdd4f.-\xdf\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f.-SS\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f.-SS\x200c\x2260"); }
test { try parseIDNAFail("\xdb41\xdd4f.-ss\x200c\x2260"); }
test { try parseIDNAFail("\xdb41\xdd4f.-ss\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f.-Ss\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f.-Ss\x200c\x2260"); }
test { try parseIDNAFail("xn--u836e.xn---ss-gl2a"); }
test { try parseIDNAFail("xn--u836e.xn---ss-cn0at5l"); }
test { try parseIDNAFail("xn--u836e.xn----qfa750ve7b"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-SS\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-SS\x200c\x2260"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-ss\x200c\x2260"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-ss\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-Ss\x200c=\x338"); }
test { try parseIDNAFail("\xdb41\xdd4f\xff0e-Ss\x200c\x2260"); }
test { try parseIDNAFail("\x1859\x200c\xff61\x226f\xd800\xdef2\x2260"); }
test { try parseIDNAFail("\x1859\x200c\xff61>\x338\xd800\xdef2=\x338"); }
test { try parseIDNAFail("\x1859\x200c\x3002\x226f\xd800\xdef2\x2260"); }
test { try parseIDNAFail("\x1859\x200c\x3002>\x338\xd800\xdef2=\x338"); }
test { try parseIDNAFail("xn--p8e650b.xn--1ch3a7084l"); }
test { try parseIDNAFail("\xda7b\xdd5b\x613.\x10b5"); }
test { try parseIDNAFail("\xda7b\xdd5b\x613.\x2d15"); }
test { try parseIDNAFail("xn--1fb94204l.xn--dlj"); }
test { try parseIDNAFail("xn--1fb94204l.xn--tnd"); }
test { try parseIDNAFail("\x200c\xdb40\xdd37\xff61\xda09\xdc41"); }
test { try parseIDNAFail("\x200c\xdb40\xdd37\x3002\xda09\xdc41"); }
test { try parseIDNAFail(".xn--w720c"); }
test { try parseIDNAFail("xn--0ug.xn--w720c"); }
test { try parseIDNAFail("\x2488\xdd6\x7105.\xdb1e\xdc59\x200d\xa85f"); }
test { try parseIDNAFail("1.\xdd6\x7105.\xdb1e\xdc59\x200d\xa85f"); }
test { try parseIDNAFail("1.xn--t1c6981c.xn--4c9a21133d"); }
test { try parseIDNAFail("1.xn--t1c6981c.xn--1ugz184c9lw7i"); }
test { try parseIDNAFail("xn--t1c337io97c.xn--4c9a21133d"); }
test { try parseIDNAFail("xn--t1c337io97c.xn--1ugz184c9lw7i"); }
test { try parseIDNAFail("\xd804\xddc0\x258d.\x205e\x1830"); }
test { try parseIDNAFail("xn--9zh3057f.xn--j7e103b"); }
test { try parseIDNAFail("-3.\x200d\x30cc\x1895"); }
test { try parseIDNAFail("-3.xn--fbf739aq5o"); }
test { try parseIDNAFail("\x2132\x17d2\x200d\xff61\x2260\x200d\x200c"); }
test { try parseIDNAFail("\x2132\x17d2\x200d\xff61=\x338\x200d\x200c"); }
test { try parseIDNAFail("\x2132\x17d2\x200d\x3002\x2260\x200d\x200c"); }
test { try parseIDNAFail("\x2132\x17d2\x200d\x3002=\x338\x200d\x200c"); }
test { try parseIDNAFail("\x214e\x17d2\x200d\x3002=\x338\x200d\x200c"); }
test { try parseIDNAFail("\x214e\x17d2\x200d\x3002\x2260\x200d\x200c"); }
test { try parseIDNAFail("xn--u4e823bq1a.xn--0ugb89o"); }
test { try parseIDNAFail("\x214e\x17d2\x200d\xff61=\x338\x200d\x200c"); }
test { try parseIDNAFail("\x214e\x17d2\x200d\xff61\x2260\x200d\x200c"); }
test { try parseIDNAFail("xn--u4e319b.xn--1ch"); }
test { try parseIDNAFail("xn--u4e823bcza.xn--0ugb89o"); }
test { try parseIDNAFail("\xd9a9\xdd2f\xfa8\xff0e\x226f"); }
test { try parseIDNAFail("\xd9a9\xdd2f\xfa8\xff0e>\x338"); }
test { try parseIDNAFail("\xd9a9\xdd2f\xfa8.\x226f"); }
test { try parseIDNAFail("\xd9a9\xdd2f\xfa8.>\x338"); }
test { try parseIDNAFail("xn--4fd57150h.xn--hdh"); }
test { try parseIDNAFail("\xd802\xde3f\xdb40\xdd8c\x9e2e\xd805\xdeb6.\x3c2"); }
test { try parseIDNAFail("\xd802\xde3f\xdb40\xdd8c\x9e2e\xd805\xdeb6.\x3a3"); }
test { try parseIDNAFail("\xd802\xde3f\xdb40\xdd8c\x9e2e\xd805\xdeb6.\x3c3"); }
test { try parseIDNAFail("xn--l76a726rt2h.xn--4xa"); }
test { try parseIDNAFail("xn--l76a726rt2h.xn--3xa"); }
test { try parseIDNAFail("\x3c2-\x3002\x200c\xd835\xdfed-"); }
test { try parseIDNAFail("\x3c2-\x3002\x200c1-"); }
test { try parseIDNAFail("\x3a3-\x3002\x200c1-"); }
test { try parseIDNAFail("\x3c3-\x3002\x200c1-"); }
test { try parseIDNAFail("xn----zmb.xn--1--i1t"); }
test { try parseIDNAFail("xn----xmb.xn--1--i1t"); }
test { try parseIDNAFail("\x3a3-\x3002\x200c\xd835\xdfed-"); }
test { try parseIDNAFail("\x3c3-\x3002\x200c\xd835\xdfed-"); }
test { try parseIDNAFail("\x1734-\xce2\xff0e\xdb40\xdd29\x10a4"); }
test { try parseIDNAFail("\x1734-\xce2.\xdb40\xdd29\x10a4"); }
test { try parseIDNAFail("\x1734-\xce2.\xdb40\xdd29\x2d04"); }
test { try parseIDNAFail("xn----ggf830f.xn--vkj"); }
test { try parseIDNAFail("\x1734-\xce2\xff0e\xdb40\xdd29\x2d04"); }
test { try parseIDNAFail("xn----ggf830f.xn--cnd"); }
test { try parseIDNAFail("\x200d\x3002\xd838\xdc18\x2488\xa84d\x64c9"); }
test { try parseIDNAFail("\x200d\x3002\xd838\xdc181.\xa84d\x64c9"); }
test { try parseIDNAFail(".xn--1-1p4r.xn--s7uv61m"); }
test { try parseIDNAFail("xn--1ug.xn--1-1p4r.xn--s7uv61m"); }
test { try parseIDNAFail(".xn--tsh026uql4bew9p"); }
test { try parseIDNAFail("xn--1ug.xn--tsh026uql4bew9p"); }
test { try parseIDNAFail("\x2ad0\xff61\x10c0-\xdacd\xdc22"); }
test { try parseIDNAFail("\x2ad0\x3002\x10c0-\xdacd\xdc22"); }
test { try parseIDNAFail("\x2ad0\x3002\x2d20-\xdacd\xdc22"); }
test { try parseIDNAFail("xn--r3i.xn----2wst7439i"); }
test { try parseIDNAFail("\x2ad0\xff61\x2d20-\xdacd\xdc22"); }
test { try parseIDNAFail("xn--r3i.xn----z1g58579u"); }
test { try parseIDNAFail("\xd805\xdc42\x25ca\xff0e\x299f\x2220"); }
test { try parseIDNAFail("\xd805\xdc42\x25ca.\x299f\x2220"); }
test { try parseIDNAFail("xn--01h3338f.xn--79g270a"); }
test { try parseIDNAFail("\xd5c1\xdb21\xdd99\xe3a\xdb28\xdf5a\x3002\x6ba\xd835\xdfdc"); }
test { try parseIDNAFail("\x1112\x1164\x11bc\xdb21\xdd99\xe3a\xdb28\xdf5a\x3002\x6ba\xd835\xdfdc"); }
test { try parseIDNAFail("\xd5c1\xdb21\xdd99\xe3a\xdb28\xdf5a\x3002\x6ba4"); }
test { try parseIDNAFail("\x1112\x1164\x11bc\xdb21\xdd99\xe3a\xdb28\xdf5a\x3002\x6ba4"); }
test { try parseIDNAFail("xn--o4c1723h8g85gt4ya.xn--4-dvc"); }
test { try parseIDNAFail("\xa953.\x33d\xd804\xdcbd\x998b"); }
test { try parseIDNAFail("xn--3j9a.xn--bua0708eqzrd"); }
test { try parseIDNAFail("\xdae2\xdedd\xda69\xdef8\x200d\xff61\x4716"); }
test { try parseIDNAFail("\xdae2\xdedd\xda69\xdef8\x200d\x3002\x4716"); }
test { try parseIDNAFail("xn--g138cxw05a.xn--k0o"); }
test { try parseIDNAFail("xn--1ug30527h9mxi.xn--k0o"); }
test { try parseIDNAFail("\x186f\x2689\x59f6\xd83c\xdd09\xff0e\x6f7\x200d\xd83c\xdfaa\x200d"); }
test { try parseIDNAFail("\x186f\x2689\x59f68,.\x6f7\x200d\xd83c\xdfaa\x200d"); }
test { try parseIDNAFail("xn--8,-g9oy26fzu4d.xn--kmb859ja94998b"); }
test { try parseIDNAFail("xn--c9e433epi4b3j20a.xn--kmb6733w"); }
test { try parseIDNAFail("xn--c9e433epi4b3j20a.xn--kmb859ja94998b"); }
test { try parseIDNAFail("\x135f\x1848\x200c\xff0e\xfe12-\xd81b\xdf90-"); }
test { try parseIDNAFail("\x135f\x1848\x200c.\x3002-\xd81b\xdf90-"); }
test { try parseIDNAFail("xn--b7d82w..xn-----pe4u"); }
test { try parseIDNAFail("xn--b7d82wo4h..xn-----pe4u"); }
test { try parseIDNAFail("xn--b7d82w.xn-----c82nz547a"); }
test { try parseIDNAFail("xn--b7d82wo4h.xn-----c82nz547a"); }
test { try parseIDNAFail("\xd836\xde5c\x3002-\xb4d\x10ab"); }
test { try parseIDNAFail("\xd836\xde5c\x3002-\xb4d\x2d0b"); }
test { try parseIDNAFail("xn--792h.xn----bse820x"); }
test { try parseIDNAFail("xn--792h.xn----bse632b"); }
test { try parseIDNAFail("\xd835\xdff5\x9681\x2bee\xff0e\x180d\x200c"); }
test { try parseIDNAFail("9\x9681\x2bee.\x180d\x200c"); }
test { try parseIDNAFail("xn--9-mfs8024b.xn--0ug"); }
test { try parseIDNAFail("\x1bac\x10ac\x200c\x325\x3002\xd835\xdff8"); }
test { try parseIDNAFail("xn--mta176jjjm.c"); }
test { try parseIDNAFail("xn--mta176j97cl2q.c"); }
test { try parseIDNAFail("\x1bac\x2d0c\x200c\x325\x3002\xd835\xdff8"); }
test { try parseIDNAFail("xn--mta930emri.c"); }
test { try parseIDNAFail("xn--mta930emribme.c"); }
test { try parseIDNAFail("\xdb40\xdd01\x35f\x2fb6\xff61\x2087\xfe12\xb207\x226e"); }
test { try parseIDNAFail("\xdb40\xdd01\x35f\x2fb6\xff61\x2087\xfe12\x1102\x116e\x11aa<\x338"); }
test { try parseIDNAFail("\xdb40\xdd01\x35f\x98db\x30027\x3002\xb207\x226e"); }
test { try parseIDNAFail("\xdb40\xdd01\x35f\x98db\x30027\x3002\x1102\x116e\x11aa<\x338"); }
test { try parseIDNAFail("xn--9ua0567e.7.xn--gdh6767c"); }
test { try parseIDNAFail("xn--9ua0567e.xn--7-ngou006d1ttc"); }
test { try parseIDNAFail("\x200c\x3002\xffa0\xf84\xf96"); }
test { try parseIDNAFail("\x200c\x3002\x1160\xf84\xf96"); }
test { try parseIDNAFail(".xn--3ed0b"); }
test { try parseIDNAFail("xn--0ug.xn--3ed0b"); }
test { try parseIDNAFail(".xn--3ed0b20h"); }
test { try parseIDNAFail("xn--0ug.xn--3ed0b20h"); }
test { try parseIDNAFail(".xn--3ed0by082k"); }
test { try parseIDNAFail("xn--0ug.xn--3ed0by082k"); }
test { try parseIDNAFail("\x226f\xd9f5\xde05\xff0e\x200d\xd800\xdd7c\xda88\xdddb"); }
test { try parseIDNAFail(">\x338\xd9f5\xde05\xff0e\x200d\xd800\xdd7c\xda88\xdddb"); }
test { try parseIDNAFail("\x226f\xd9f5\xde05.\x200d\xd800\xdd7c\xda88\xdddb"); }
test { try parseIDNAFail(">\x338\xd9f5\xde05.\x200d\xd800\xdd7c\xda88\xdddb"); }
test { try parseIDNAFail("xn--hdh84488f.xn--xy7cw2886b"); }
test { try parseIDNAFail("xn--hdh84488f.xn--1ug8099fbjp4e"); }
test { try parseIDNAFail("xn--d5a07sn4u297k.xn--2e1b"); }
test { try parseIDNAFail("\xa8ea\xff61\xd818\xdd3f\xd804\xddbe\xdb40\xddd7"); }
test { try parseIDNAFail("\xa8ea\x3002\xd818\xdd3f\xd804\xddbe\xdb40\xddd7"); }
test { try parseIDNAFail("xn--3g9a.xn--ud1dz07k"); }
test { try parseIDNAFail("\xdadd\xdcd3\xd805\xdeb3\x3002\xd903\xddff\x226f\x2f87"); }
test { try parseIDNAFail("\xdadd\xdcd3\xd805\xdeb3\x3002\xd903\xddff>\x338\x2f87"); }
test { try parseIDNAFail("\xdadd\xdcd3\xd805\xdeb3\x3002\xd903\xddff\x226f\x821b"); }
test { try parseIDNAFail("\xdadd\xdcd3\xd805\xdeb3\x3002\xd903\xddff>\x338\x821b"); }
test { try parseIDNAFail("xn--3e2d79770c.xn--hdh0088abyy1c"); }
test { try parseIDNAFail("\xd944\xdd48\x782a\x226f\x1891\xff61\x226f\xd836\xde5a\xda0f\xdd14\x200c"); }
test { try parseIDNAFail("\xd944\xdd48\x782a>\x338\x1891\xff61>\x338\xd836\xde5a\xda0f\xdd14\x200c"); }
test { try parseIDNAFail("\xd944\xdd48\x782a\x226f\x1891\x3002\x226f\xd836\xde5a\xda0f\xdd14\x200c"); }
test { try parseIDNAFail("\xd944\xdd48\x782a>\x338\x1891\x3002>\x338\xd836\xde5a\xda0f\xdd14\x200c"); }
test { try parseIDNAFail("xn--bbf561cf95e57y3e.xn--hdh0834o7mj6b"); }
test { try parseIDNAFail("xn--bbf561cf95e57y3e.xn--0ugz6gc910ejro8c"); }
test { try parseIDNAFail("\x10c5.\xd804\xdd33\x32b8"); }
test { try parseIDNAFail("\x10c5.\xd804\xdd3343"); }
test { try parseIDNAFail("\x2d25.\xd804\xdd3343"); }
test { try parseIDNAFail("xn--tlj.xn--43-274o"); }
test { try parseIDNAFail("\x2d25.\xd804\xdd33\x32b8"); }
test { try parseIDNAFail("xn--9nd.xn--43-274o"); }
test { try parseIDNAFail("\xd91e\xdea8\xdb40\xdd09\xffa0\xfb7.\xd9a1\xdfb0\xa953"); }
test { try parseIDNAFail("\xd91e\xdea8\xdb40\xdd09\x1160\xfb7.\xd9a1\xdfb0\xa953"); }
test { try parseIDNAFail("xn--kgd72212e.xn--3j9au7544a"); }
test { try parseIDNAFail("xn--kgd36f9z57y.xn--3j9au7544a"); }
test { try parseIDNAFail("xn--kgd7493jee34a.xn--3j9au7544a"); }
test { try parseIDNAFail("\x618.\x6f3\x200c\xa953"); }
test { try parseIDNAFail("xn--6fb.xn--gmb0524f"); }
test { try parseIDNAFail("xn--6fb.xn--gmb469jjf1h"); }
test { try parseIDNAFail("\x184c\xff0e\xfe12\x1891"); }
test { try parseIDNAFail("xn--c8e.xn--bbf9168i"); }
test { try parseIDNAFail("\xd83b\xddcf\x3002\x1822\xda0d\xde06"); }
test { try parseIDNAFail("xn--hd7h.xn--46e66060j"); }
test { try parseIDNAFail("\xd9f0\xded4\xdb40\xdd8e\xdb40\xdd97\xd807\xdc95\x3002\x226e"); }
test { try parseIDNAFail("\xd9f0\xded4\xdb40\xdd8e\xdb40\xdd97\xd807\xdc95\x3002<\x338"); }
test { try parseIDNAFail("xn--4m3dv4354a.xn--gdh"); }
test { try parseIDNAFail("\xdb40\xdda6.\x8e3\x6680\x2260"); }
test { try parseIDNAFail("\xdb40\xdda6.\x8e3\x6680=\x338"); }
test { try parseIDNAFail(".xn--m0b461k3g2c"); }
test { try parseIDNAFail("\x40b9\xdbb9\xdd85\xd800\xdee6\xff0e\x200d"); }
test { try parseIDNAFail("\x40b9\xdbb9\xdd85\xd800\xdee6.\x200d"); }
test { try parseIDNAFail("xn--0on3543c5981i."); }
test { try parseIDNAFail("xn--0on3543c5981i.xn--1ug"); }
test { try parseIDNAFail("\xfe12\xff61\x10a3\x226f"); }
test { try parseIDNAFail("\xfe12\xff61\x10a3>\x338"); }
test { try parseIDNAFail("\xfe12\xff61\x2d03>\x338"); }
test { try parseIDNAFail("\xfe12\xff61\x2d03\x226f"); }
test { try parseIDNAFail("xn--y86c.xn--hdh782b"); }
test { try parseIDNAFail("..xn--bnd622g"); }
test { try parseIDNAFail("xn--y86c.xn--bnd622g"); }
test { try parseIDNAFail("\x7b83\x10c1-\xdb40\xdc5d\xff61\x2260-\xd83e\xdd16"); }
test { try parseIDNAFail("\x7b83\x10c1-\xdb40\xdc5d\xff61=\x338-\xd83e\xdd16"); }
test { try parseIDNAFail("\x7b83\x10c1-\xdb40\xdc5d\x3002\x2260-\xd83e\xdd16"); }
test { try parseIDNAFail("\x7b83\x10c1-\xdb40\xdc5d\x3002=\x338-\xd83e\xdd16"); }
test { try parseIDNAFail("\x7b83\x2d21-\xdb40\xdc5d\x3002=\x338-\xd83e\xdd16"); }
test { try parseIDNAFail("\x7b83\x2d21-\xdb40\xdc5d\x3002\x2260-\xd83e\xdd16"); }
test { try parseIDNAFail("xn----4wsr321ay823p.xn----tfot873s"); }
test { try parseIDNAFail("\x7b83\x2d21-\xdb40\xdc5d\xff61=\x338-\xd83e\xdd16"); }
test { try parseIDNAFail("\x7b83\x2d21-\xdb40\xdc5d\xff61\x2260-\xd83e\xdd16"); }
test { try parseIDNAFail("xn----11g3013fy8x5m.xn----tfot873s"); }
test { try parseIDNAFail("\x103a\x200d\x200c\x3002-\x200c"); }
test { try parseIDNAFail("xn--bkd.-"); }
test { try parseIDNAFail("xn--bkd412fca.xn----sgn"); }
test { try parseIDNAFail("\xfe12\xff61\x1b44\x1849"); }
test { try parseIDNAFail("\x3002\x3002\x1b44\x1849"); }
test { try parseIDNAFail("..xn--87e93m"); }
test { try parseIDNAFail("xn--y86c.xn--87e93m"); }
test { try parseIDNAFail("-\x1bab\xfe12\x200d.\xd90b\xdd88\xd957\xde53"); }
test { try parseIDNAFail("-\x1bab\x3002\x200d.\xd90b\xdd88\xd957\xde53"); }
test { try parseIDNAFail("xn----qml..xn--x50zy803a"); }
test { try parseIDNAFail("xn----qml.xn--1ug.xn--x50zy803a"); }
test { try parseIDNAFail("xn----qml1407i.xn--x50zy803a"); }
test { try parseIDNAFail("xn----qmlv7tw180a.xn--x50zy803a"); }
test { try parseIDNAFail("\xdb42\xddae.\x226f\xd838\xdc06"); }
test { try parseIDNAFail("\xdb42\xddae.>\x338\xd838\xdc06"); }
test { try parseIDNAFail("xn--t546e.xn--hdh5166o"); }
test { try parseIDNAFail("xn--skb.xn--osd737a"); }
test { try parseIDNAFail("\x3a1b\xd823\xdc4e.\xfe12\xd835\xdfd5\xd01"); }
test { try parseIDNAFail("xn--mbm8237g.xn--7-7hf1526p"); }
test { try parseIDNAFail("\xdf\x200c\xaaf6\x18a5\xff0e\x22b6\x10c1\x10b6"); }
test { try parseIDNAFail("\xdf\x200c\xaaf6\x18a5.\x22b6\x10c1\x10b6"); }
test { try parseIDNAFail("\xdf\x200c\xaaf6\x18a5.\x22b6\x2d21\x2d16"); }
test { try parseIDNAFail("SS\x200c\xaaf6\x18a5.\x22b6\x10c1\x10b6"); }
test { try parseIDNAFail("ss\x200c\xaaf6\x18a5.\x22b6\x2d21\x2d16"); }
test { try parseIDNAFail("Ss\x200c\xaaf6\x18a5.\x22b6\x10c1\x2d16"); }
test { try parseIDNAFail("xn--ss-4ep585bkm5p.xn--ifh802b6a"); }
test { try parseIDNAFail("xn--zca682johfi89m.xn--ifh802b6a"); }
test { try parseIDNAFail("\xdf\x200c\xaaf6\x18a5\xff0e\x22b6\x2d21\x2d16"); }
test { try parseIDNAFail("SS\x200c\xaaf6\x18a5\xff0e\x22b6\x10c1\x10b6"); }
test { try parseIDNAFail("ss\x200c\xaaf6\x18a5\xff0e\x22b6\x2d21\x2d16"); }
test { try parseIDNAFail("Ss\x200c\xaaf6\x18a5\xff0e\x22b6\x10c1\x2d16"); }
test { try parseIDNAFail("xn--ss-4epx629f.xn--5nd703gyrh"); }
test { try parseIDNAFail("xn--ss-4ep585bkm5p.xn--5nd703gyrh"); }
test { try parseIDNAFail("xn--ss-4epx629f.xn--undv409k"); }
test { try parseIDNAFail("xn--ss-4ep585bkm5p.xn--undv409k"); }
test { try parseIDNAFail("xn--zca682johfi89m.xn--undv409k"); }
test { try parseIDNAFail("\x200d\x3002\x3c2\xdb40\xdc49"); }
test { try parseIDNAFail("\x200d\x3002\x3a3\xdb40\xdc49"); }
test { try parseIDNAFail("\x200d\x3002\x3c3\xdb40\xdc49"); }
test { try parseIDNAFail(".xn--4xa24344p"); }
test { try parseIDNAFail("xn--1ug.xn--4xa24344p"); }
test { try parseIDNAFail("xn--1ug.xn--3xa44344p"); }
test { try parseIDNAFail("\x2492\xda61\xde19\xda8f\xdce0\xd805\xdcc0.-\xdb3a\xdc4a"); }
test { try parseIDNAFail("11.\xda61\xde19\xda8f\xdce0\xd805\xdcc0.-\xdb3a\xdc4a"); }
test { try parseIDNAFail("11.xn--uz1d59632bxujd.xn----x310m"); }
test { try parseIDNAFail("xn--3shy698frsu9dt1me.xn----x310m"); }
test { try parseIDNAFail("-\xff61\x200d"); }
test { try parseIDNAFail("-\x3002\x200d"); }
test { try parseIDNAFail("-.xn--1ug"); }
test { try parseIDNAFail("\x126c\xda12\xdc3c\xd8c5\xddf6\xff61\xd802\xde2c\xd835\xdfe0"); }
test { try parseIDNAFail("\x126c\xda12\xdc3c\xd8c5\xddf6\x3002\xd802\xde2c8"); }
test { try parseIDNAFail("xn--d0d41273c887z.xn--8-ob5i"); }
test { try parseIDNAFail("\x3c2\x200d-.\x10c3\xd859\xdfd9"); }
test { try parseIDNAFail("\x3c2\x200d-.\x2d23\xd859\xdfd9"); }
test { try parseIDNAFail("\x3a3\x200d-.\x10c3\xd859\xdfd9"); }
test { try parseIDNAFail("\x3c3\x200d-.\x2d23\xd859\xdfd9"); }
test { try parseIDNAFail("xn----zmb048s.xn--rlj2573p"); }
test { try parseIDNAFail("xn----xmb348s.xn--rlj2573p"); }
test { try parseIDNAFail("xn----zmb.xn--7nd64871a"); }
test { try parseIDNAFail("xn----zmb048s.xn--7nd64871a"); }
test { try parseIDNAFail("xn----xmb348s.xn--7nd64871a"); }
test { try parseIDNAFail("\xdad6\xdf3d.\x8814"); }
test { try parseIDNAFail("xn--g747d.xn--xl2a"); }
test { try parseIDNAFail("\x8e6\x200d\xff0e\xbf3d"); }
test { try parseIDNAFail("\x8e6\x200d\xff0e\x1108\x1168\x11c0"); }
test { try parseIDNAFail("\x8e6\x200d.\xbf3d"); }
test { try parseIDNAFail("\x8e6\x200d.\x1108\x1168\x11c0"); }
test { try parseIDNAFail("xn--p0b.xn--e43b"); }
test { try parseIDNAFail("xn--p0b869i.xn--e43b"); }
test { try parseIDNAFail("\xd8f6\xde3d\xff0e\xd8ef\xde15"); }
test { try parseIDNAFail("\xd8f6\xde3d.\xd8ef\xde15"); }
test { try parseIDNAFail("xn--pr3x.xn--rv7w"); }
test { try parseIDNAFail("\xd802\xdfc0\xd803\xde09\xd83a\xddcf\x3002\xd949\xdea7\x2084\x10ab\xd8cb\xde6b"); }
test { try parseIDNAFail("\xd802\xdfc0\xd803\xde09\xd83a\xddcf\x3002\xd949\xdea74\x10ab\xd8cb\xde6b"); }
test { try parseIDNAFail("\xd802\xdfc0\xd803\xde09\xd83a\xddcf\x3002\xd949\xdea74\x2d0b\xd8cb\xde6b"); }
test { try parseIDNAFail("xn--039c42bq865a.xn--4-wvs27840bnrzm"); }
test { try parseIDNAFail("\xd802\xdfc0\xd803\xde09\xd83a\xddcf\x3002\xd949\xdea7\x2084\x2d0b\xd8cb\xde6b"); }
test { try parseIDNAFail("xn--039c42bq865a.xn--4-t0g49302fnrzm"); }
test { try parseIDNAFail("\xd835\xdfd3\x3002\x6d7"); }
test { try parseIDNAFail("5\x3002\x6d7"); }
test { try parseIDNAFail("5.xn--nlb"); }
test { try parseIDNAFail("\x200c\xdaab\xde29.\x2f95"); }
test { try parseIDNAFail("\x200c\xdaab\xde29.\x8c37"); }
test { try parseIDNAFail("xn--i183d.xn--6g3a"); }
test { try parseIDNAFail("xn--0ug26167i.xn--6g3a"); }
test { try parseIDNAFail("\xfe12\xdafb\xdc07\x200d.-\x73c\x200c"); }
test { try parseIDNAFail("\x3002\xdafb\xdc07\x200d.-\x73c\x200c"); }
test { try parseIDNAFail(".xn--hh50e.xn----t2c"); }
test { try parseIDNAFail(".xn--1ug05310k.xn----t2c071q"); }
test { try parseIDNAFail("xn--y86c71305c.xn----t2c"); }
test { try parseIDNAFail("xn--1ug1658ftw26f.xn----t2c071q"); }
test { try parseIDNAFail("\x200d\xff0e\xd835\xdfd7"); }
test { try parseIDNAFail("\x200d.j"); }
test { try parseIDNAFail("\x200d.J"); }
test { try parseIDNAFail("xn--1ug.j"); }
test { try parseIDNAFail("\x10ad\xd8be\xdccd\xa868\x5ae\x3002\x10be\x200c\x200c"); }
test { try parseIDNAFail("\x2d0d\xd8be\xdccd\xa868\x5ae\x3002\x2d1e\x200c\x200c"); }
test { try parseIDNAFail("xn--5cb172r175fug38a.xn--mlj"); }
test { try parseIDNAFail("xn--5cb172r175fug38a.xn--0uga051h"); }
test { try parseIDNAFail("xn--5cb347co96jug15a.xn--2nd"); }
test { try parseIDNAFail("xn--5cb347co96jug15a.xn--2nd059ea"); }
test { try parseIDNAFail("\xd800\xdef0\x3002\xdb05\xdcf1"); }
test { try parseIDNAFail("xn--k97c.xn--q031e"); }
test { try parseIDNAFail("\x8df\x10ab\xd89b\xdff8\xade4\xff0e\xda40\xdd7c\xd835\xdfe2\xd72a\xae3"); }
test { try parseIDNAFail("\x8df\x10ab\xd89b\xdff8\x1100\x1172\x11af\xff0e\xda40\xdd7c\xd835\xdfe2\x1112\x1171\x11b9\xae3"); }
test { try parseIDNAFail("\x8df\x10ab\xd89b\xdff8\xade4.\xda40\xdd7c0\xd72a\xae3"); }
test { try parseIDNAFail("\x8df\x10ab\xd89b\xdff8\x1100\x1172\x11af.\xda40\xdd7c0\x1112\x1171\x11b9\xae3"); }
test { try parseIDNAFail("\x8df\x2d0b\xd89b\xdff8\x1100\x1172\x11af.\xda40\xdd7c0\x1112\x1171\x11b9\xae3"); }
test { try parseIDNAFail("\x8df\x2d0b\xd89b\xdff8\xade4.\xda40\xdd7c0\xd72a\xae3"); }
test { try parseIDNAFail("xn--i0b436pkl2g2h42a.xn--0-8le8997mulr5f"); }
test { try parseIDNAFail("\x8df\x2d0b\xd89b\xdff8\x1100\x1172\x11af\xff0e\xda40\xdd7c\xd835\xdfe2\x1112\x1171\x11b9\xae3"); }
test { try parseIDNAFail("\x8df\x2d0b\xd89b\xdff8\xade4\xff0e\xda40\xdd7c\xd835\xdfe2\xd72a\xae3"); }
test { try parseIDNAFail("xn--i0b601b6r7l2hs0a.xn--0-8le8997mulr5f"); }
test { try parseIDNAFail("\x784\xff0e\xd83a\xdc5d\x601"); }
test { try parseIDNAFail("\x784.\xd83a\xdc5d\x601"); }
test { try parseIDNAFail("xn--lqb.xn--jfb1808v"); }
test { try parseIDNAFail("\xacd\x2083.8\xa8c4\x200d\xd83c\xdce4"); }
test { try parseIDNAFail("\xacd3.8\xa8c4\x200d\xd83c\xdce4"); }
test { try parseIDNAFail("xn--3-yke.xn--8-sl4et308f"); }
test { try parseIDNAFail("xn--3-yke.xn--8-ugnv982dbkwm"); }
test { try parseIDNAFail("\xa855\x2260\x105e\xdb7b\xdff1\xff61\xd803\xdd67\xdb40\xdd2b\xffa0"); }
test { try parseIDNAFail("\xa855=\x338\x105e\xdb7b\xdff1\xff61\xd803\xdd67\xdb40\xdd2b\xffa0"); }
test { try parseIDNAFail("\xa855\x2260\x105e\xdb7b\xdff1\x3002\xd803\xdd67\xdb40\xdd2b\x1160"); }
test { try parseIDNAFail("\xa855=\x338\x105e\xdb7b\xdff1\x3002\xd803\xdd67\xdb40\xdd2b\x1160"); }
test { try parseIDNAFail("xn--cld333gn31h0158l.xn--3g0d"); }
test { try parseIDNAFail("\x9c4a\x3002\x200c"); }
test { try parseIDNAFail("xn--rt6a.xn--0ug"); }
test { try parseIDNAFail("\x200c\xd908\xdce0\xff0e\x200d"); }
test { try parseIDNAFail("\x200c\xd908\xdce0.\x200d"); }
test { try parseIDNAFail("xn--dj8y."); }
test { try parseIDNAFail("xn--0ugz7551c.xn--1ug"); }
test { try parseIDNAFail("\xd804\xddc0.\xdb42\xde31"); }
test { try parseIDNAFail("xn--wd1d.xn--k946e"); }
test { try parseIDNAFail("\x200c\x10ba\xff61\x3c2"); }
test { try parseIDNAFail("\x200c\x10ba\x3002\x3c2"); }
test { try parseIDNAFail("\x200c\x2d1a\x3002\x3c2"); }
test { try parseIDNAFail("\x200c\x10ba\x3002\x3a3"); }
test { try parseIDNAFail("\x200c\x2d1a\x3002\x3c3"); }
test { try parseIDNAFail("xn--0ug262c.xn--4xa"); }
test { try parseIDNAFail("xn--0ug262c.xn--3xa"); }
test { try parseIDNAFail("\x200c\x2d1a\xff61\x3c2"); }
test { try parseIDNAFail("\x200c\x10ba\xff61\x3a3"); }
test { try parseIDNAFail("\x200c\x2d1a\xff61\x3c3"); }
test { try parseIDNAFail("xn--ynd.xn--4xa"); }
test { try parseIDNAFail("xn--ynd.xn--3xa"); }
test { try parseIDNAFail("xn--ynd759e.xn--4xa"); }
test { try parseIDNAFail("xn--ynd759e.xn--3xa"); }
test { try parseIDNAFail("\x200d\x2f95\x3002\x200c\x310\xa953\xa84e"); }
test { try parseIDNAFail("\x200d\x2f95\x3002\x200c\xa953\x310\xa84e"); }
test { try parseIDNAFail("\x200d\x8c37\x3002\x200c\xa953\x310\xa84e"); }
test { try parseIDNAFail("xn--6g3a.xn--0sa8175flwa"); }
test { try parseIDNAFail("xn--1ug0273b.xn--0sa359l6n7g13a"); }
test { try parseIDNAFail("\xda72\xde29\x10b3\x2753\xff61\xd804\xdd28"); }
test { try parseIDNAFail("\xda72\xde29\x10b3\x2753\x3002\xd804\xdd28"); }
test { try parseIDNAFail("\xda72\xde29\x2d13\x2753\x3002\xd804\xdd28"); }
test { try parseIDNAFail("xn--8di78qvw32y.xn--k80d"); }
test { try parseIDNAFail("\xda72\xde29\x2d13\x2753\xff61\xd804\xdd28"); }
test { try parseIDNAFail("xn--rnd896i0j14q.xn--k80d"); }
test { try parseIDNAFail("\x17ff\xff61\xd83a\xdf33"); }
test { try parseIDNAFail("\x17ff\x3002\xd83a\xdf33"); }
test { try parseIDNAFail("xn--45e.xn--et6h"); }
test { try parseIDNAFail("\x652\x200d\xff61\xccd\xd805\xdeb3"); }
test { try parseIDNAFail("\x652\x200d\x3002\xccd\xd805\xdeb3"); }
test { try parseIDNAFail("xn--uhb.xn--8tc4527k"); }
test { try parseIDNAFail("xn--uhb882k.xn--8tc4527k"); }
test { try parseIDNAFail("\xdf\xd880\xdc3b\xd8da\xdf17\xff61\xd836\xde68\xd83d\xdd6e\xdf"); }
test { try parseIDNAFail("\xdf\xd880\xdc3b\xd8da\xdf17\x3002\xd836\xde68\xd83d\xdd6e\xdf"); }
test { try parseIDNAFail("SS\xd880\xdc3b\xd8da\xdf17\x3002\xd836\xde68\xd83d\xdd6eSS"); }
test { try parseIDNAFail("ss\xd880\xdc3b\xd8da\xdf17\x3002\xd836\xde68\xd83d\xdd6ess"); }
test { try parseIDNAFail("Ss\xd880\xdc3b\xd8da\xdf17\x3002\xd836\xde68\xd83d\xdd6eSs"); }
test { try parseIDNAFail("xn--ss-jl59biy67d.xn--ss-4d11aw87d"); }
test { try parseIDNAFail("xn--zca20040bgrkh.xn--zca3653v86qa"); }
test { try parseIDNAFail("SS\xd880\xdc3b\xd8da\xdf17\xff61\xd836\xde68\xd83d\xdd6eSS"); }
test { try parseIDNAFail("ss\xd880\xdc3b\xd8da\xdf17\xff61\xd836\xde68\xd83d\xdd6ess"); }
test { try parseIDNAFail("Ss\xd880\xdc3b\xd8da\xdf17\xff61\xd836\xde68\xd83d\xdd6eSs"); }
test { try parseIDNAFail("\x200d\x3002\x200c"); }
test { try parseIDNAFail("xn--1ug.xn--0ug"); }
test { try parseIDNAFail("\xdb41\xdc58\xff0e\xdb40\xdd2e"); }
test { try parseIDNAFail("\xdb41\xdc58.\xdb40\xdd2e"); }
test { try parseIDNAFail("xn--s136e."); }
test { try parseIDNAFail("\xa9b7\xdb37\xdd59\xba79\x3002\x249b\xdb42\xde07"); }
test { try parseIDNAFail("\xa9b7\xdb37\xdd59\x1106\x1167\x11b0\x3002\x249b\xdb42\xde07"); }
test { try parseIDNAFail("\xa9b7\xdb37\xdd59\xba79\x300220.\xdb42\xde07"); }
test { try parseIDNAFail("\xa9b7\xdb37\xdd59\x1106\x1167\x11b0\x300220.\xdb42\xde07"); }
test { try parseIDNAFail("xn--ym9av13acp85w.20.xn--d846e"); }
test { try parseIDNAFail("xn--ym9av13acp85w.xn--dth22121k"); }
test { try parseIDNAFail("\x200c\xff61\xfe12"); }
test { try parseIDNAFail("\x200c\x3002\x3002"); }
test { try parseIDNAFail("xn--0ug.."); }
test { try parseIDNAFail(".xn--y86c"); }
test { try parseIDNAFail("xn--0ug.xn--y86c"); }
test { try parseIDNAFail("\x1872-\xd835\xdff9.\xdf-\x200c-"); }
test { try parseIDNAFail("\x1872-3.\xdf-\x200c-"); }
test { try parseIDNAFail("\x1872-3.SS-\x200c-"); }
test { try parseIDNAFail("\x1872-3.ss-\x200c-"); }
test { try parseIDNAFail("\x1872-3.Ss-\x200c-"); }
test { try parseIDNAFail("xn---3-p9o.xn--ss---276a"); }
test { try parseIDNAFail("xn---3-p9o.xn-----fia9303a"); }
test { try parseIDNAFail("\x1872-\xd835\xdff9.SS-\x200c-"); }
test { try parseIDNAFail("\x1872-\xd835\xdff9.ss-\x200c-"); }
test { try parseIDNAFail("\x1872-\xd835\xdff9.Ss-\x200c-"); }
test { try parseIDNAFail("\xdb27\xdd9c\x1898\x3002\x1a7f\x2ea2"); }
test { try parseIDNAFail("xn--ibf35138o.xn--fpfz94g"); }
test { try parseIDNAFail("\xda1c\xdda7\xd835\xdfef\x3002\x2488\x1a76\xd835\xdfda\xda41\xde0c"); }
test { try parseIDNAFail("\xda1c\xdda73\x30021.\x1a762\xda41\xde0c"); }
test { try parseIDNAFail("xn--3-rj42h.1.xn--2-13k96240l"); }
test { try parseIDNAFail("xn--3-rj42h.xn--2-13k746cq465x"); }
test { try parseIDNAFail("\x200d\x2085\x2488\x3002\x226f\xd835\xdff4\x200d"); }
test { try parseIDNAFail("\x200d\x2085\x2488\x3002>\x338\xd835\xdff4\x200d"); }
test { try parseIDNAFail("\x200d51.\x3002\x226f8\x200d"); }
test { try parseIDNAFail("\x200d51.\x3002>\x3388\x200d"); }
test { try parseIDNAFail("xn--51-l1t..xn--8-ugn00i"); }
test { try parseIDNAFail("xn--5-ecp.xn--8-ogo"); }
test { try parseIDNAFail("xn--5-tgnz5r.xn--8-ugn00i"); }
test { try parseIDNAFail("\xd8bb\xddc2\xa42\x10aa\xd8c8\xdc9f.\x226e"); }
test { try parseIDNAFail("\xd8bb\xddc2\xa42\x10aa\xd8c8\xdc9f.<\x338"); }
test { try parseIDNAFail("\xd8bb\xddc2\xa42\x2d0a\xd8c8\xdc9f.<\x338"); }
test { try parseIDNAFail("\xd8bb\xddc2\xa42\x2d0a\xd8c8\xdc9f.\x226e"); }
test { try parseIDNAFail("xn--nbc229o4y27dgskb.xn--gdh"); }
test { try parseIDNAFail("xn--nbc493aro75ggskb.xn--gdh"); }
test { try parseIDNAFail("\xa67d\x200c\xd87e\xddf5\xd83c\xdd06\xff61\x200c\xd804\xdc42\x1b01"); }
test { try parseIDNAFail("\xa67d\x200c\x9723\xd83c\xdd06\xff61\x200c\xd804\xdc42\x1b01"); }
test { try parseIDNAFail("\xa67d\x200c\x97235,\x3002\x200c\xd804\xdc42\x1b01"); }
test { try parseIDNAFail("xn--5,-op8g373c.xn--4sf0725i"); }
test { try parseIDNAFail("xn--5,-i1tz135dnbqa.xn--4sf36u6u4w"); }
test { try parseIDNAFail("xn--2q5a751a653w.xn--4sf0725i"); }
test { try parseIDNAFail("xn--0ug4208b2vjuk63a.xn--4sf36u6u4w"); }
test { try parseIDNAFail("\x514e\xff61\x183c\xdb43\xdd1c\xd805\xdeb6\xd807\xdc3f"); }
test { try parseIDNAFail("\x514e\x3002\x183c\xdb43\xdd1c\xd805\xdeb6\xd807\xdc3f"); }
test { try parseIDNAFail("xn--b5q.xn--v7e6041kqqd4m251b"); }
test { try parseIDNAFail("\xd835\xdfd9\xff61\x200d\xd835\xdff8\x200d\x2077"); }
test { try parseIDNAFail("1\x3002\x200d2\x200d7"); }
test { try parseIDNAFail("1.xn--27-l1tb"); }
test { try parseIDNAFail("\x1868-\xff61\xdb43\xdecb\xd835\xdff7"); }
test { try parseIDNAFail("\x1868-\x3002\xdb43\xdecb1"); }
test { try parseIDNAFail("xn----z8j.xn--1-5671m"); }
test { try parseIDNAFail("\x10bc\xd9e3\xdded\xf80\x2f87\x3002\x10af\x2640\x200c\x200c"); }
test { try parseIDNAFail("\x10bc\xd9e3\xdded\xf80\x821b\x3002\x10af\x2640\x200c\x200c"); }
test { try parseIDNAFail("\x2d1c\xd9e3\xdded\xf80\x821b\x3002\x2d0f\x2640\x200c\x200c"); }
test { try parseIDNAFail("xn--zed372mdj2do3v4h.xn--e5h11w"); }
test { try parseIDNAFail("xn--zed372mdj2do3v4h.xn--0uga678bgyh"); }
test { try parseIDNAFail("\x2d1c\xd9e3\xdded\xf80\x2f87\x3002\x2d0f\x2640\x200c\x200c"); }
test { try parseIDNAFail("xn--zed54dz10wo343g.xn--nnd651i"); }
test { try parseIDNAFail("xn--zed54dz10wo343g.xn--nnd089ea464d"); }
test { try parseIDNAFail("\xd804\xdc46\xd835\xdff0.\x200d"); }
test { try parseIDNAFail("\xd804\xdc464.\x200d"); }
test { try parseIDNAFail("xn--4-xu7i."); }
test { try parseIDNAFail("xn--4-xu7i.xn--1ug"); }
test { try parseIDNAFail("\xd97b\xdd18\x10be\x7640\xff61\xd805\xde3f\x200d\x200c\xbdbc"); }
test { try parseIDNAFail("\xd97b\xdd18\x10be\x7640\xff61\xd805\xde3f\x200d\x200c\x1107\x1170\x11ab"); }
test { try parseIDNAFail("\xd97b\xdd18\x10be\x7640\x3002\xd805\xde3f\x200d\x200c\xbdbc"); }
test { try parseIDNAFail("\xd97b\xdd18\x10be\x7640\x3002\xd805\xde3f\x200d\x200c\x1107\x1170\x11ab"); }
test { try parseIDNAFail("\xd97b\xdd18\x2d1e\x7640\x3002\xd805\xde3f\x200d\x200c\x1107\x1170\x11ab"); }
test { try parseIDNAFail("\xd97b\xdd18\x2d1e\x7640\x3002\xd805\xde3f\x200d\x200c\xbdbc"); }
test { try parseIDNAFail("xn--mlju35u7qx2f.xn--et3bn23n"); }
test { try parseIDNAFail("xn--mlju35u7qx2f.xn--0ugb6122js83c"); }
test { try parseIDNAFail("\xd97b\xdd18\x2d1e\x7640\xff61\xd805\xde3f\x200d\x200c\x1107\x1170\x11ab"); }
test { try parseIDNAFail("\xd97b\xdd18\x2d1e\x7640\xff61\xd805\xde3f\x200d\x200c\xbdbc"); }
test { try parseIDNAFail("xn--2nd6803c7q37d.xn--et3bn23n"); }
test { try parseIDNAFail("xn--2nd6803c7q37d.xn--0ugb6122js83c"); }
test { try parseIDNAFail("\x1843\xd835\xdfe7\x226f\x1823\xff0e\x6c01\xd960\xdff1\xa06b"); }
test { try parseIDNAFail("\x1843\xd835\xdfe7>\x338\x1823\xff0e\x6c01\xd960\xdff1\xa06b"); }
test { try parseIDNAFail("\x18435\x226f\x1823.\x6c01\xd960\xdff1\xa06b"); }
test { try parseIDNAFail("\x18435>\x338\x1823.\x6c01\xd960\xdff1\xa06b"); }
test { try parseIDNAFail("xn--5-24jyf768b.xn--lqw213ime95g"); }
test { try parseIDNAFail("-\xd804\xde36\x248f\xff0e\x248e\xd881\xdee2\xdb40\xdfad"); }
test { try parseIDNAFail("-\xd804\xde368..7.\xd881\xdee2\xdb40\xdfad"); }
test { try parseIDNAFail("xn---8-bv5o..7.xn--c35nf1622b"); }
test { try parseIDNAFail("xn----scp6252h.xn--zshy411yzpx2d"); }
test { try parseIDNAFail("\x200c\x10a1\x755d\x200d\xff0e\x226e"); }
test { try parseIDNAFail("\x200c\x10a1\x755d\x200d\xff0e<\x338"); }
test { try parseIDNAFail("\x200c\x10a1\x755d\x200d.\x226e"); }
test { try parseIDNAFail("\x200c\x10a1\x755d\x200d.<\x338"); }
test { try parseIDNAFail("\x200c\x2d01\x755d\x200d.<\x338"); }
test { try parseIDNAFail("\x200c\x2d01\x755d\x200d.\x226e"); }
test { try parseIDNAFail("xn--0ugc160hb36e.xn--gdh"); }
test { try parseIDNAFail("\x200c\x2d01\x755d\x200d\xff0e<\x338"); }
test { try parseIDNAFail("\x200c\x2d01\x755d\x200d\xff0e\x226e"); }
test { try parseIDNAFail("xn--8md0962c.xn--gdh"); }
test { try parseIDNAFail("xn--8md700fea3748f.xn--gdh"); }
test { try parseIDNAFail("\xecb\x200d\xff0e\x9381\xdb43\xdc11"); }
test { try parseIDNAFail("\xecb\x200d.\x9381\xdb43\xdc11"); }
test { try parseIDNAFail("xn--t8c.xn--iz4a43209d"); }
test { try parseIDNAFail("xn--t8c059f.xn--iz4a43209d"); }
test { try parseIDNAFail("\xd9e5\xdef4.-\x1862\x592\xd836\xde20"); }
test { try parseIDNAFail("xn--ep37b.xn----hec165lho83b"); }
test { try parseIDNAFail("\xd8bc\xdc2b\xff0e\x1baa\x3c2\x10a6\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b.\x1baa\x3c2\x10a6\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b.\x1baa\x3c2\x2d06\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b.\x1baa\x3a3\x10a6\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b.\x1baa\x3c3\x2d06\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b.\x1baa\x3a3\x2d06\x200d"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa153j7im"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa153jk8cs1q"); }
test { try parseIDNAFail("xn--nu4s.xn--3xa353jk8cs1q"); }
test { try parseIDNAFail("\xd8bc\xdc2b\xff0e\x1baa\x3c2\x2d06\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b\xff0e\x1baa\x3a3\x10a6\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b\xff0e\x1baa\x3c3\x2d06\x200d"); }
test { try parseIDNAFail("\xd8bc\xdc2b\xff0e\x1baa\x3a3\x2d06\x200d"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa217dxri"); }
test { try parseIDNAFail("xn--nu4s.xn--4xa217dxriome"); }
test { try parseIDNAFail("xn--nu4s.xn--3xa417dxriome"); }
test { try parseIDNAFail("\x2488\x200c\xaaec\xfe12\xff0e\xacd"); }
test { try parseIDNAFail("1.\x200c\xaaec\x3002.\xacd"); }
test { try parseIDNAFail("1.xn--sv9a..xn--mfc"); }
test { try parseIDNAFail("1.xn--0ug7185c..xn--mfc"); }
test { try parseIDNAFail("xn--tsh0720cse8b.xn--mfc"); }
test { try parseIDNAFail("xn--0ug78o720myr1c.xn--mfc"); }
test { try parseIDNAFail("\xdf\x200d.\x1bf2\xd8d3\xdfbc"); }
test { try parseIDNAFail("SS\x200d.\x1bf2\xd8d3\xdfbc"); }
test { try parseIDNAFail("ss\x200d.\x1bf2\xd8d3\xdfbc"); }
test { try parseIDNAFail("Ss\x200d.\x1bf2\xd8d3\xdfbc"); }
test { try parseIDNAFail("ss.xn--0zf22107b"); }
test { try parseIDNAFail("xn--ss-n1t.xn--0zf22107b"); }
test { try parseIDNAFail("xn--zca870n.xn--0zf22107b"); }
test { try parseIDNAFail("\xd805\xdcc2\x200c\x226e.\x226e"); }
test { try parseIDNAFail("\xd805\xdcc2\x200c<\x338.<\x338"); }
test { try parseIDNAFail("xn--gdhz656g.xn--gdh"); }
test { try parseIDNAFail("xn--0ugy6glz29a.xn--gdh"); }
test { try parseIDNAFail("xn--my8h.xn--psd"); }
test { try parseIDNAFail("xn--my8h.xn--cl7c"); }
test { try parseIDNAFail("\x7215\xda8d\xde51\xff0e\xd835\xdff0\x6c17"); }
test { try parseIDNAFail("\x7215\xda8d\xde51.4\x6c17"); }
test { try parseIDNAFail("xn--1zxq3199c.xn--4-678b"); }
test { try parseIDNAFail("\xdb39\xdf43\x3002\xda04\xdd83\xd8e6\xdc97--"); }
test { try parseIDNAFail("xn--2y75e.xn-----1l15eer88n"); }
test { try parseIDNAFail("\x8530\x3002\xdb40\xdc79\x8dd-\xd804\xde35"); }
test { try parseIDNAFail("xn--sz1a.xn----mrd9984r3dl0i"); }
test { try parseIDNAFail("xn--4xa477d.xn--epb"); }
test { try parseIDNAFail("xn--3xa677d.xn--epb"); }
test { try parseIDNAFail("xn--pt9c.xn--hnd666l"); }
test { try parseIDNAFail("xn--pt9c.xn--hndy"); }
test { try parseIDNAFail("\x200c\x200c\x3124\xff0e\x32e\xdb16\xde11\x9c2"); }
test { try parseIDNAFail("\x200c\x200c\x3124.\x32e\xdb16\xde11\x9c2"); }
test { try parseIDNAFail("xn--1fk.xn--vta284a9o563a"); }
test { try parseIDNAFail("xn--0uga242k.xn--vta284a9o563a"); }
test { try parseIDNAFail("\x10b4\xd836\xde28\x2083\xdb40\xdc66\xff0e\xd835\xdff3\xd804\xdcb9\xb82"); }
test { try parseIDNAFail("\x10b4\xd836\xde283\xdb40\xdc66.7\xd804\xdcb9\xb82"); }
test { try parseIDNAFail("\x2d14\xd836\xde283\xdb40\xdc66.7\xd804\xdcb9\xb82"); }
test { try parseIDNAFail("xn--3-ews6985n35s3g.xn--7-cve6271r"); }
test { try parseIDNAFail("\x2d14\xd836\xde28\x2083\xdb40\xdc66\xff0e\xd835\xdff3\xd804\xdcb9\xb82"); }
test { try parseIDNAFail("xn--3-b1g83426a35t0g.xn--7-cve6271r"); }
test { try parseIDNAFail("\x43c8\x200c\x3002\x200c\x2488\xd986\xdc95"); }
test { try parseIDNAFail("\x43c8\x200c\x3002\x200c1.\xd986\xdc95"); }
test { try parseIDNAFail("xn--eco.1.xn--ms39a"); }
test { try parseIDNAFail("xn--0ug491l.xn--1-rgn.xn--ms39a"); }
test { try parseIDNAFail("xn--eco.xn--tsh21126d"); }
test { try parseIDNAFail("xn--0ug491l.xn--0ug88oot66q"); }
test { try parseIDNAFail("\xff11\xaaf6\xdf\xd807\xdca5\xff61\x1dd8"); }
test { try parseIDNAFail("1\xaaf6\xdf\xd807\xdca5\x3002\x1dd8"); }
test { try parseIDNAFail("1\xaaf6SS\xd807\xdca5\x3002\x1dd8"); }
test { try parseIDNAFail("1\xaaf6ss\xd807\xdca5\x3002\x1dd8"); }
test { try parseIDNAFail("xn--1ss-ir6ln166b.xn--weg"); }
test { try parseIDNAFail("xn--1-qfa2471kdb0d.xn--weg"); }
test { try parseIDNAFail("\xff11\xaaf6SS\xd807\xdca5\xff61\x1dd8"); }
test { try parseIDNAFail("\xff11\xaaf6ss\xd807\xdca5\xff61\x1dd8"); }
test { try parseIDNAFail("1\xaaf6Ss\xd807\xdca5\x3002\x1dd8"); }
test { try parseIDNAFail("\xff11\xaaf6Ss\xd807\xdca5\xff61\x1dd8"); }
test { try parseIDNAFail("xn--3j78f.xn--mkb20b"); }
test { try parseIDNAFail("\xd88a\xdd31\x249b\x2fb3\xff0e\xa866\x2488"); }
test { try parseIDNAFail("xn--dth6033bzbvx.xn--tsh9439b"); }
test { try parseIDNAFail("xn--tnd.xn--ss-jbe65aw27i"); }
test { try parseIDNAFail("xn--tnd.xn--zca912alh227g"); }
test { try parseIDNAFail("\x2132\xdb40\xdd7a\xd937\xdd52\x3002\x226f\x2f91"); }
test { try parseIDNAFail("\x2132\xdb40\xdd7a\xd937\xdd52\x3002>\x338\x2f91"); }
test { try parseIDNAFail("\x2132\xdb40\xdd7a\xd937\xdd52\x3002\x226f\x897e"); }
test { try parseIDNAFail("\x2132\xdb40\xdd7a\xd937\xdd52\x3002>\x338\x897e"); }
test { try parseIDNAFail("\x214e\xdb40\xdd7a\xd937\xdd52\x3002>\x338\x897e"); }
test { try parseIDNAFail("\x214e\xdb40\xdd7a\xd937\xdd52\x3002\x226f\x897e"); }
test { try parseIDNAFail("xn--73g39298c.xn--hdhz171b"); }
test { try parseIDNAFail("\x214e\xdb40\xdd7a\xd937\xdd52\x3002>\x338\x2f91"); }
test { try parseIDNAFail("\x214e\xdb40\xdd7a\xd937\xdd52\x3002\x226f\x2f91"); }
test { try parseIDNAFail("xn--f3g73398c.xn--hdhz171b"); }
test { try parseIDNAFail("\x200c.\xdf\x10a9-"); }
test { try parseIDNAFail("\x200c.\xdf\x2d09-"); }
test { try parseIDNAFail("\x200c.SS\x10a9-"); }
test { try parseIDNAFail("\x200c.ss\x2d09-"); }
test { try parseIDNAFail("\x200c.Ss\x2d09-"); }
test { try parseIDNAFail("xn--0ug.xn--ss--bi1b"); }
test { try parseIDNAFail("xn--0ug.xn----pfa2305a"); }
test { try parseIDNAFail(".xn--ss--4rn"); }
test { try parseIDNAFail("xn--0ug.xn--ss--4rn"); }
test { try parseIDNAFail("xn--0ug.xn----pfa042j"); }
test { try parseIDNAFail("\xdb42\xdea2-\x3002\xda2c\xdc8f\x226e\xd805\xdf2b"); }
test { try parseIDNAFail("\xdb42\xdea2-\x3002\xda2c\xdc8f<\x338\xd805\xdf2b"); }
test { try parseIDNAFail("xn----bh61m.xn--gdhz157g0em1d"); }
test { try parseIDNAFail("\x200c\xdb40\xde79\x200d\x3002\xd9f3\xdfe7\x226e\x10a9"); }
test { try parseIDNAFail("\x200c\xdb40\xde79\x200d\x3002\xd9f3\xdfe7<\x338\x10a9"); }
test { try parseIDNAFail("\x200c\xdb40\xde79\x200d\x3002\xd9f3\xdfe7<\x338\x2d09"); }
test { try parseIDNAFail("\x200c\xdb40\xde79\x200d\x3002\xd9f3\xdfe7\x226e\x2d09"); }
test { try parseIDNAFail("xn--3n36e.xn--gdh992byu01p"); }
test { try parseIDNAFail("xn--0ugc90904y.xn--gdh992byu01p"); }
test { try parseIDNAFail("xn--3n36e.xn--hnd112gpz83n"); }
test { try parseIDNAFail("xn--0ugc90904y.xn--hnd112gpz83n"); }
test { try parseIDNAFail("\xd836\xde9e\x10b0\xff61\xcaa1"); }
test { try parseIDNAFail("\xd836\xde9e\x10b0\xff61\x110d\x1168\x11a8"); }
test { try parseIDNAFail("\xd836\xde9e\x10b0\x3002\xcaa1"); }
test { try parseIDNAFail("\xd836\xde9e\x10b0\x3002\x110d\x1168\x11a8"); }
test { try parseIDNAFail("\xd836\xde9e\x2d10\x3002\x110d\x1168\x11a8"); }
test { try parseIDNAFail("\xd836\xde9e\x2d10\x3002\xcaa1"); }
test { try parseIDNAFail("xn--7kj1858k.xn--pi6b"); }
test { try parseIDNAFail("\xd836\xde9e\x2d10\xff61\x110d\x1168\x11a8"); }
test { try parseIDNAFail("\xd836\xde9e\x2d10\xff61\xcaa1"); }
test { try parseIDNAFail("xn--ond3755u.xn--pi6b"); }
test { try parseIDNAFail("\x1845\xff10\x200c\xff61\x23a2\xdb52\xde04"); }
test { try parseIDNAFail("\x18450\x200c\x3002\x23a2\xdb52\xde04"); }
test { try parseIDNAFail("xn--0-z6j.xn--8lh28773l"); }
test { try parseIDNAFail("xn--0-z6jy93b.xn--8lh28773l"); }
test { try parseIDNAFail("\xd88a\xdf9a\xff19\xa369\x17d3\xff0e\x200d\xdf"); }
test { try parseIDNAFail("\xd88a\xdf9a9\xa369\x17d3.\x200d\xdf"); }
test { try parseIDNAFail("\xd88a\xdf9a9\xa369\x17d3.\x200dSS"); }
test { try parseIDNAFail("\xd88a\xdf9a9\xa369\x17d3.\x200dss"); }
test { try parseIDNAFail("xn--9-i0j5967eg3qz.xn--ss-l1t"); }
test { try parseIDNAFail("xn--9-i0j5967eg3qz.xn--zca770n"); }
test { try parseIDNAFail("\xd88a\xdf9a\xff19\xa369\x17d3\xff0e\x200dSS"); }
test { try parseIDNAFail("\xd88a\xdf9a\xff19\xa369\x17d3\xff0e\x200dss"); }
test { try parseIDNAFail("\xd88a\xdf9a9\xa369\x17d3.\x200dSs"); }
test { try parseIDNAFail("\xd88a\xdf9a\xff19\xa369\x17d3\xff0e\x200dSs"); }
test { try parseIDNAFail("\x2490\x226f-\x3002\xfe12\xda65\xdc63-\xd939\xdee0"); }
test { try parseIDNAFail("\x2490>\x338-\x3002\xfe12\xda65\xdc63-\xd939\xdee0"); }
test { try parseIDNAFail("9.\x226f-\x3002\x3002\xda65\xdc63-\xd939\xdee0"); }
test { try parseIDNAFail("9.>\x338-\x3002\x3002\xda65\xdc63-\xd939\xdee0"); }
test { try parseIDNAFail("9.xn----ogo..xn----xj54d1s69k"); }
test { try parseIDNAFail("xn----ogot9g.xn----n89hl0522az9u2a"); }
test { try parseIDNAFail("\x10af\xdb40\xdd4b-\xff0e\x200d\x10a9"); }
test { try parseIDNAFail("\x10af\xdb40\xdd4b-.\x200d\x10a9"); }
test { try parseIDNAFail("\x2d0f\xdb40\xdd4b-.\x200d\x2d09"); }
test { try parseIDNAFail("xn----3vs.xn--1ug532c"); }
test { try parseIDNAFail("\x2d0f\xdb40\xdd4b-\xff0e\x200d\x2d09"); }
test { try parseIDNAFail("xn----00g.xn--hnd"); }
test { try parseIDNAFail("xn----00g.xn--hnd399e"); }
test { try parseIDNAFail("\x1714\x3002\xdb40\xdda3-\xd804\xdeea"); }
test { try parseIDNAFail("xn--fze.xn----ly8i"); }
test { try parseIDNAFail("\xabe8-\xff0e\xda60\xdfdc\x5bd\xdf"); }
test { try parseIDNAFail("\xabe8-.\xda60\xdfdc\x5bd\xdf"); }
test { try parseIDNAFail("\xabe8-.\xda60\xdfdc\x5bdSS"); }
test { try parseIDNAFail("\xabe8-.\xda60\xdfdc\x5bdss"); }
test { try parseIDNAFail("\xabe8-.\xda60\xdfdc\x5bdSs"); }
test { try parseIDNAFail("xn----pw5e.xn--ss-7jd10716y"); }
test { try parseIDNAFail("xn----pw5e.xn--zca50wfv060a"); }
test { try parseIDNAFail("\xabe8-\xff0e\xda60\xdfdc\x5bdSS"); }
test { try parseIDNAFail("\xabe8-\xff0e\xda60\xdfdc\x5bdss"); }
test { try parseIDNAFail("\xabe8-\xff0e\xda60\xdfdc\x5bdSs"); }
test { try parseIDNAFail("\xd835\xdfe5\x266e\xd805\xdf2b\x8ed\xff0e\x17d2\xd805\xdf2b8\xdb40\xdd8f"); }
test { try parseIDNAFail("3\x266e\xd805\xdf2b\x8ed.\x17d2\xd805\xdf2b8\xdb40\xdd8f"); }
test { try parseIDNAFail("xn--3-ksd277tlo7s.xn--8-f0jx021l"); }
test { try parseIDNAFail("-\xff61\xda14\xdf00\x200d\x2761"); }
test { try parseIDNAFail("-\x3002\xda14\xdf00\x200d\x2761"); }
test { try parseIDNAFail("-.xn--nei54421f"); }
test { try parseIDNAFail("-.xn--1ug800aq795s"); }
test { try parseIDNAFail("\xd835\xdfd3\x2631\xd835\xdfd0\xda57\xdc35\xff61\xd836\xdeae\xd902\xdc73"); }
test { try parseIDNAFail("5\x26312\xda57\xdc35\x3002\xd836\xdeae\xd902\xdc73"); }
test { try parseIDNAFail("xn--52-dwx47758j.xn--kd3hk431k"); }
test { try parseIDNAFail("-.-\x251c\xda1a\xdda3"); }
test { try parseIDNAFail("-.xn----ukp70432h"); }
test { try parseIDNAFail("\x3c2\xff0e\xfdc1\xd83d\xdf9b\x2488"); }
test { try parseIDNAFail("\x3a3\xff0e\xfdc1\xd83d\xdf9b\x2488"); }
test { try parseIDNAFail("\x3c3\xff0e\xfdc1\xd83d\xdf9b\x2488"); }
test { try parseIDNAFail("xn--4xa.xn--dhbip2802atb20c"); }
test { try parseIDNAFail("xn--3xa.xn--dhbip2802atb20c"); }
test { try parseIDNAFail("9\xdb40\xdde5\xff0e\xdb6b\xdd34\x1893"); }
test { try parseIDNAFail("9\xdb40\xdde5.\xdb6b\xdd34\x1893"); }
test { try parseIDNAFail("9.xn--dbf91222q"); }
test { try parseIDNAFail("\xfe12\x10b6\x366\xff0e\x200c"); }
test { try parseIDNAFail("\x3002\x10b6\x366.\x200c"); }
test { try parseIDNAFail("\x3002\x2d16\x366.\x200c"); }
test { try parseIDNAFail(".xn--hva754s.xn--0ug"); }
test { try parseIDNAFail("\xfe12\x2d16\x366\xff0e\x200c"); }
test { try parseIDNAFail("xn--hva754sy94k."); }
test { try parseIDNAFail("xn--hva754sy94k.xn--0ug"); }
test { try parseIDNAFail(".xn--hva929d."); }
test { try parseIDNAFail(".xn--hva929d.xn--0ug"); }
test { try parseIDNAFail("xn--hva929dl29p."); }
test { try parseIDNAFail("xn--hva929dl29p.xn--0ug"); }
test { try parseIDNAFail("xn--hva929d."); }
test { try parseIDNAFail("xn--hzb.xn--bnd2938u"); }
test { try parseIDNAFail("\x200d\x200c\x3002\xff12\x4af7\xdb42\xddf7"); }
test { try parseIDNAFail("\x200d\x200c\x30022\x4af7\xdb42\xddf7"); }
test { try parseIDNAFail(".xn--2-me5ay1273i"); }
test { try parseIDNAFail("xn--0ugb.xn--2-me5ay1273i"); }
test { try parseIDNAFail("-\xd838\xdc24\xdb32\xdc10\x3002\xd9e2\xdf16"); }
test { try parseIDNAFail("xn----rq4re4997d.xn--l707b"); }
test { try parseIDNAFail("\xdb8d\xdec2\xfe12\x200c\x37c0\xff0e\x624\x2488"); }
test { try parseIDNAFail("\xdb8d\xdec2\xfe12\x200c\x37c0\xff0e\x648\x654\x2488"); }
test { try parseIDNAFail("xn--z272f.xn--etl.xn--1-smc."); }
test { try parseIDNAFail("xn--etlt457ccrq7h.xn--jgb476m"); }
test { try parseIDNAFail("xn--0ug754gxl4ldlt0k.xn--jgb476m"); }
test { try parseIDNAFail("\x7fc\xd803\xde06.\xd80d\xdd8f\xfe12\xd8ea\xde29\x10b0"); }
test { try parseIDNAFail("\x7fc\xd803\xde06.\xd80d\xdd8f\x3002\xd8ea\xde29\x10b0"); }
test { try parseIDNAFail("\x7fc\xd803\xde06.\xd80d\xdd8f\x3002\xd8ea\xde29\x2d10"); }
test { try parseIDNAFail("xn--0tb8725k.xn--tu8d.xn--7kj73887a"); }
test { try parseIDNAFail("\x7fc\xd803\xde06.\xd80d\xdd8f\xfe12\xd8ea\xde29\x2d10"); }
test { try parseIDNAFail("xn--0tb8725k.xn--7kj9008dt18a7py9c"); }
test { try parseIDNAFail("xn--0tb8725k.xn--tu8d.xn--ond97931d"); }
test { try parseIDNAFail("xn--0tb8725k.xn--ond3562jt18a7py9c"); }
test { try parseIDNAFail("\x10c5\x26ad\xdb41\xddab\x22c3\xff61\xd804\xdf3c"); }
test { try parseIDNAFail("\x10c5\x26ad\xdb41\xddab\x22c3\x3002\xd804\xdf3c"); }
test { try parseIDNAFail("\x2d25\x26ad\xdb41\xddab\x22c3\x3002\xd804\xdf3c"); }
test { try parseIDNAFail("xn--vfh16m67gx1162b.xn--ro1d"); }
test { try parseIDNAFail("\x2d25\x26ad\xdb41\xddab\x22c3\xff61\xd804\xdf3c"); }
test { try parseIDNAFail("xn--9nd623g4zc5z060c.xn--ro1d"); }
test { try parseIDNAFail("\xd8c8\xde26\x5e37\xff61\x226f\x843a\x1dc8-"); }
test { try parseIDNAFail("\xd8c8\xde26\x5e37\xff61>\x338\x843a\x1dc8-"); }
test { try parseIDNAFail("\xd8c8\xde26\x5e37\x3002\x226f\x843a\x1dc8-"); }
test { try parseIDNAFail("\xd8c8\xde26\x5e37\x3002>\x338\x843a\x1dc8-"); }
test { try parseIDNAFail("xn--qutw175s.xn----mimu6tf67j"); }
test { try parseIDNAFail("\x200d\x650c\xabed\x3002\x1896-\x10b8"); }
test { try parseIDNAFail("\x200d\x650c\xabed\x3002\x1896-\x2d18"); }
test { try parseIDNAFail("xn--1ug592ykp6b.xn----mck373i"); }
test { try parseIDNAFail("xn--p9ut19m.xn----k1g451d"); }
test { try parseIDNAFail("xn--1ug592ykp6b.xn----k1g451d"); }
test { try parseIDNAFail("\x200c\xa5a8\xff0e\x2497\xff13\xd212\x6f3"); }
test { try parseIDNAFail("\x200c\xa5a8\xff0e\x2497\xff13\x1110\x116d\x11a9\x6f3"); }
test { try parseIDNAFail("\x200c\xa5a8.16.3\xd212\x6f3"); }
test { try parseIDNAFail("\x200c\xa5a8.16.3\x1110\x116d\x11a9\x6f3"); }
test { try parseIDNAFail("xn--0ug2473c.16.xn--3-nyc0117m"); }
test { try parseIDNAFail("xn--9r8a.xn--3-nyc678tu07m"); }
test { try parseIDNAFail("xn--0ug2473c.xn--3-nyc678tu07m"); }
test { try parseIDNAFail("\xd835\xdfcf\xd836\xde19\x2e16.\x200d"); }
test { try parseIDNAFail("1\xd836\xde19\x2e16.\x200d"); }
test { try parseIDNAFail("xn--1-5bt6845n.xn--1ug"); }
test { try parseIDNAFail("F\xdb40\xdd5f\xff61\xd9fd\xddc5\x265a"); }
test { try parseIDNAFail("F\xdb40\xdd5f\x3002\xd9fd\xddc5\x265a"); }
test { try parseIDNAFail("f\xdb40\xdd5f\x3002\xd9fd\xddc5\x265a"); }
test { try parseIDNAFail("f.xn--45hz6953f"); }
test { try parseIDNAFail("f\xdb40\xdd5f\xff61\xd9fd\xddc5\x265a"); }
test { try parseIDNAFail("\xb4d\xd804\xdd34\x1de9\x3002\xd835\xdfee\x10b8\xd838\xdc28\xd8ce\xdd47"); }
test { try parseIDNAFail("\xb4d\xd804\xdd34\x1de9\x30022\x10b8\xd838\xdc28\xd8ce\xdd47"); }
test { try parseIDNAFail("\xb4d\xd804\xdd34\x1de9\x30022\x2d18\xd838\xdc28\xd8ce\xdd47"); }
test { try parseIDNAFail("xn--9ic246gs21p.xn--2-nws2918ndrjr"); }
test { try parseIDNAFail("\xb4d\xd804\xdd34\x1de9\x3002\xd835\xdfee\x2d18\xd838\xdc28\xd8ce\xdd47"); }
test { try parseIDNAFail("xn--9ic246gs21p.xn--2-k1g43076adrwq"); }
test { try parseIDNAFail("\xda0e\xdc2d\x200c\x200c\x2488\x3002\x52c9\xd804\xdc45"); }
test { try parseIDNAFail("\xda0e\xdc2d\x200c\x200c1.\x3002\x52c9\xd804\xdc45"); }
test { try parseIDNAFail("xn--1-yi00h..xn--4grs325b"); }
test { try parseIDNAFail("xn--1-rgna61159u..xn--4grs325b"); }
test { try parseIDNAFail("xn--tsh11906f.xn--4grs325b"); }
test { try parseIDNAFail("xn--0uga855aez302a.xn--4grs325b"); }
test { try parseIDNAFail("\x1843.\x73bf\xd96c\xde1c\xdb15\xdf90"); }
test { try parseIDNAFail("xn--27e.xn--7cy81125a0yq4a"); }
test { try parseIDNAFail("\x200c\x200c\xff61\x2488\x226f\xd835\xdff5"); }
test { try parseIDNAFail("\x200c\x200c\xff61\x2488>\x338\xd835\xdff5"); }
test { try parseIDNAFail("\x200c\x200c\x30021.\x226f9"); }
test { try parseIDNAFail("\x200c\x200c\x30021.>\x3389"); }
test { try parseIDNAFail("xn--0uga.1.xn--9-ogo"); }
test { try parseIDNAFail(".xn--9-ogo37g"); }
test { try parseIDNAFail("xn--0uga.xn--9-ogo37g"); }
test { try parseIDNAFail("\x20da\xff0e\xd805\xde3f-"); }
test { try parseIDNAFail("\x20da.\xd805\xde3f-"); }
test { try parseIDNAFail("xn--w0g.xn----bd0j"); }
test { try parseIDNAFail("\x1082-\x200d\xa8ea\xff0e\xa84a\x200d\xd9b3\xde33"); }
test { try parseIDNAFail("\x1082-\x200d\xa8ea.\xa84a\x200d\xd9b3\xde33"); }
test { try parseIDNAFail("xn----gyg3618i.xn--jc9ao4185a"); }
test { try parseIDNAFail("xn----gyg250jio7k.xn--1ug8774cri56d"); }
test { try parseIDNAFail("\xd804\xde35\x5eca.\xd802\xdc0d"); }
test { try parseIDNAFail("xn--xytw701b.xn--yc9c"); }
test { try parseIDNAFail("\x10be\xd899\xdec0\xd82d\xddfb\xff0e\x1897\xb9ab"); }
test { try parseIDNAFail("\x10be\xd899\xdec0\xd82d\xddfb\xff0e\x1897\x1105\x1174\x11c2"); }
test { try parseIDNAFail("\x10be\xd899\xdec0\xd82d\xddfb.\x1897\xb9ab"); }
test { try parseIDNAFail("\x10be\xd899\xdec0\xd82d\xddfb.\x1897\x1105\x1174\x11c2"); }
test { try parseIDNAFail("\x2d1e\xd899\xdec0\xd82d\xddfb.\x1897\x1105\x1174\x11c2"); }
test { try parseIDNAFail("\x2d1e\xd899\xdec0\xd82d\xddfb.\x1897\xb9ab"); }
test { try parseIDNAFail("xn--mlj0486jgl2j.xn--hbf6853f"); }
test { try parseIDNAFail("\x2d1e\xd899\xdec0\xd82d\xddfb\xff0e\x1897\x1105\x1174\x11c2"); }
test { try parseIDNAFail("\x2d1e\xd899\xdec0\xd82d\xddfb\xff0e\x1897\xb9ab"); }
test { try parseIDNAFail("xn--2nd8876sgl2j.xn--hbf6853f"); }
test { try parseIDNAFail("\xdf\x200d\x103a\xff61\x2488"); }
test { try parseIDNAFail("xn--ss-f4j585j.b."); }
test { try parseIDNAFail("xn--zca679eh2l.b."); }
test { try parseIDNAFail("SS\x200d\x103a\xff61\x2488"); }
test { try parseIDNAFail("ss\x200d\x103a\xff61\x2488"); }
test { try parseIDNAFail("Ss\x200d\x103a\xff61\x2488"); }
test { try parseIDNAFail("xn--ss-f4j.xn--tsh"); }
test { try parseIDNAFail("xn--ss-f4j585j.xn--tsh"); }
test { try parseIDNAFail("xn--zca679eh2l.xn--tsh"); }
test { try parseIDNAFail("\xd835\xdfe0\x226e\x200c\xff61\xdb40\xdd71\x17b4"); }
test { try parseIDNAFail("\xd835\xdfe0<\x338\x200c\xff61\xdb40\xdd71\x17b4"); }
test { try parseIDNAFail("8\x226e\x200c\x3002\xdb40\xdd71\x17b4"); }
test { try parseIDNAFail("8<\x338\x200c\x3002\xdb40\xdd71\x17b4"); }
test { try parseIDNAFail("xn--8-sgn10i."); }
test { try parseIDNAFail("xn--8-ngo.xn--z3e"); }
test { try parseIDNAFail("xn--8-sgn10i.xn--z3e"); }
test { try parseIDNAFail("\x1895\x226f\xfe12\xd8d0\xdcaf\xff0e\x10a0"); }
test { try parseIDNAFail("\x1895>\x338\xfe12\xd8d0\xdcaf\xff0e\x10a0"); }
test { try parseIDNAFail("\x1895\x226f\x3002\xd8d0\xdcaf.\x10a0"); }
test { try parseIDNAFail("\x1895>\x338\x3002\xd8d0\xdcaf.\x10a0"); }
test { try parseIDNAFail("\x1895>\x338\x3002\xd8d0\xdcaf.\x2d00"); }
test { try parseIDNAFail("\x1895\x226f\x3002\xd8d0\xdcaf.\x2d00"); }
test { try parseIDNAFail("xn--fbf851c.xn--ko1u.xn--rkj"); }
test { try parseIDNAFail("\x1895>\x338\xfe12\xd8d0\xdcaf\xff0e\x2d00"); }
test { try parseIDNAFail("\x1895\x226f\xfe12\xd8d0\xdcaf\xff0e\x2d00"); }
test { try parseIDNAFail("xn--fbf851cq98poxw1a.xn--rkj"); }
test { try parseIDNAFail("xn--fbf851c.xn--ko1u.xn--7md"); }
test { try parseIDNAFail("xn--fbf851cq98poxw1a.xn--7md"); }
test { try parseIDNAFail("\xf9f\xff0e-\x82a"); }
test { try parseIDNAFail("\xf9f.-\x82a"); }
test { try parseIDNAFail("xn--vfd.xn----fhd"); }
test { try parseIDNAFail("\x1d6c\xdb40\xdda0\xff0e\xd552\x2492\x2488\xdbe0\xdd26"); }
test { try parseIDNAFail("\x1d6c\xdb40\xdda0\xff0e\x1111\x1175\x11bd\x2492\x2488\xdbe0\xdd26"); }
test { try parseIDNAFail("\x1d6c\xdb40\xdda0.\xd55211.1.\xdbe0\xdd26"); }
test { try parseIDNAFail("\x1d6c\xdb40\xdda0.\x1111\x1175\x11bd11.1.\xdbe0\xdd26"); }
test { try parseIDNAFail("xn--tbg.xn--11-5o7k.1.xn--k469f"); }
test { try parseIDNAFail("xn--tbg.xn--tsht7586kyts9l"); }
test { try parseIDNAFail("\x2488\x270c\xda3e\xdf1f\xff0e\xd835\xdfe1\xd943\xdc63"); }
test { try parseIDNAFail("1.\x270c\xda3e\xdf1f.9\xd943\xdc63"); }
test { try parseIDNAFail("1.xn--7bi44996f.xn--9-o706d"); }
test { try parseIDNAFail("xn--tsh24g49550b.xn--9-o706d"); }
test { try parseIDNAFail("\x3c2\xff0e\xa9c0\xa8c4"); }
test { try parseIDNAFail("\x3c2.\xa9c0\xa8c4"); }
test { try parseIDNAFail("\x3a3.\xa9c0\xa8c4"); }
test { try parseIDNAFail("\x3c3.\xa9c0\xa8c4"); }
test { try parseIDNAFail("xn--4xa.xn--0f9ars"); }
test { try parseIDNAFail("xn--3xa.xn--0f9ars"); }
test { try parseIDNAFail("\x3a3\xff0e\xa9c0\xa8c4"); }
test { try parseIDNAFail("\x3c3\xff0e\xa9c0\xa8c4"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5\x1ed7\x2488\xff0e\xda06\xdf12\xd945\xde2e\x85b\xd835\xdfeb"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5o\x302\x303\x2488\xff0e\xda06\xdf12\xd945\xde2e\x85b\xd835\xdfeb"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5\x1ed71..\xda06\xdf12\xd945\xde2e\x85b9"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5o\x302\x3031..\xda06\xdf12\xd945\xde2e\x85b9"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5O\x302\x3031..\xda06\xdf12\xd945\xde2e\x85b9"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5\x1ed61..\xda06\xdf12\xd945\xde2e\x85b9"); }
test { try parseIDNAFail("xn--1-3xm292b6044r..xn--9-6jd87310jtcqs"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5O\x302\x303\x2488\xff0e\xda06\xdf12\xd945\xde2e\x85b\xd835\xdfeb"); }
test { try parseIDNAFail("\x2786\xd99e\xddd5\x1ed6\x2488\xff0e\xda06\xdf12\xd945\xde2e\x85b\xd835\xdfeb"); }
test { try parseIDNAFail("xn--6lg26tvvc6v99z.xn--9-6jd87310jtcqs"); }
test { try parseIDNAFail("\x73c\x200c-\x3002\xd80d\xdc3e\xdf"); }
test { try parseIDNAFail("\x73c\x200c-\x3002\xd80d\xdc3eSS"); }
test { try parseIDNAFail("\x73c\x200c-\x3002\xd80d\xdc3ess"); }
test { try parseIDNAFail("\x73c\x200c-\x3002\xd80d\xdc3eSs"); }
test { try parseIDNAFail("xn----s2c.xn--ss-066q"); }
test { try parseIDNAFail("xn----s2c071q.xn--ss-066q"); }
test { try parseIDNAFail("xn----s2c071q.xn--zca7848m"); }
test { try parseIDNAFail("-\xda9d\xdf6c\x135e\xd805\xdf27.\x1deb-\xfe12"); }
test { try parseIDNAFail("-\xda9d\xdf6c\x135e\xd805\xdf27.\x1deb-\x3002"); }
test { try parseIDNAFail("xn----b5h1837n2ok9f.xn----mkm."); }
test { try parseIDNAFail("xn----b5h1837n2ok9f.xn----mkmw278h"); }
test { try parseIDNAFail("\xfe12.\xda2a\xdc21\x1a59"); }
test { try parseIDNAFail("\x3002.\xda2a\xdc21\x1a59"); }
test { try parseIDNAFail("..xn--cof61594i"); }
test { try parseIDNAFail("xn--y86c.xn--cof61594i"); }
test { try parseIDNAFail("\xd807\xdc3a.-\xda05\xdfcf"); }
test { try parseIDNAFail("xn--jk3d.xn----iz68g"); }
test { try parseIDNAFail("\xdb43\xdee9\xff0e\x8d4f"); }
test { try parseIDNAFail("\xdb43\xdee9.\x8d4f"); }
test { try parseIDNAFail("xn--2856e.xn--6o3a"); }
test { try parseIDNAFail("\x10ad\xff0e\xd8f4\xdde6\x200c"); }
test { try parseIDNAFail("\x10ad.\xd8f4\xdde6\x200c"); }
test { try parseIDNAFail("\x2d0d.\xd8f4\xdde6\x200c"); }
test { try parseIDNAFail("xn--4kj.xn--p01x"); }
test { try parseIDNAFail("xn--4kj.xn--0ug56448b"); }
test { try parseIDNAFail("\x2d0d\xff0e\xd8f4\xdde6\x200c"); }
test { try parseIDNAFail("xn--lnd.xn--p01x"); }
test { try parseIDNAFail("xn--lnd.xn--0ug56448b"); }
test { try parseIDNAFail("-\x200d.\x10be\xd800\xdef7"); }
test { try parseIDNAFail("-\x200d.\x2d1e\xd800\xdef7"); }
test { try parseIDNAFail("xn----ugn.xn--mlj8559d"); }
test { try parseIDNAFail("-.xn--2nd2315j"); }
test { try parseIDNAFail("xn----ugn.xn--2nd2315j"); }
test { try parseIDNAFail("\x200d\x3c2\xdf\x731\xff0e\xbcd"); }
test { try parseIDNAFail("\x200d\x3c2\xdf\x731.\xbcd"); }
test { try parseIDNAFail("\x200d\x3a3SS\x731.\xbcd"); }
test { try parseIDNAFail("\x200d\x3c3ss\x731.\xbcd"); }
test { try parseIDNAFail("\x200d\x3a3ss\x731.\xbcd"); }
test { try parseIDNAFail("xn--ss-ubc826a.xn--xmc"); }
test { try parseIDNAFail("xn--ss-ubc826ab34b.xn--xmc"); }
test { try parseIDNAFail("\x200d\x3a3\xdf\x731.\xbcd"); }
test { try parseIDNAFail("\x200d\x3c3\xdf\x731.\xbcd"); }
test { try parseIDNAFail("xn--zca39lk1di19a.xn--xmc"); }
test { try parseIDNAFail("xn--zca19ln1di19a.xn--xmc"); }
test { try parseIDNAFail("\x200d\x3a3SS\x731\xff0e\xbcd"); }
test { try parseIDNAFail("\x200d\x3c3ss\x731\xff0e\xbcd"); }
test { try parseIDNAFail("\x200d\x3a3ss\x731\xff0e\xbcd"); }
test { try parseIDNAFail("\x200d\x3a3\xdf\x731\xff0e\xbcd"); }
test { try parseIDNAFail("\x200d\x3c3\xdf\x731\xff0e\xbcd"); }
test { try parseIDNAFail("\x2260\xff0e\x200d"); }
test { try parseIDNAFail("=\x338\xff0e\x200d"); }
test { try parseIDNAFail("\x2260.\x200d"); }
test { try parseIDNAFail("=\x338.\x200d"); }
test { try parseIDNAFail("xn--1ch.xn--1ug"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3c2\xff0e\x3c2\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3c2.\x3c2\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3a3.\x3a3\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3c3.\x3c2\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3c3.\x3c3\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3a3.\x3c3\xd802\xde3f"); }
test { try parseIDNAFail("xn--4xa502av8297a.xn--4xa6055k"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3a3.\x3c2\xd802\xde3f"); }
test { try parseIDNAFail("xn--4xa502av8297a.xn--3xa8055k"); }
test { try parseIDNAFail("xn--3xa702av8297a.xn--3xa8055k"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3a3\xff0e\x3a3\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3c3\xff0e\x3c2\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3c3\xff0e\x3c3\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3a3\xff0e\x3c3\xd802\xde3f"); }
test { try parseIDNAFail("\xdb5c\xdef5\x9cd\x3a3\xff0e\x3c2\xd802\xde3f"); }
test { try parseIDNAFail("\xd94e\xdd12\xff61\xb967"); }
test { try parseIDNAFail("\xd94e\xdd12\xff61\x1105\x1172\x11b6"); }
test { try parseIDNAFail("\xd94e\xdd12\x3002\xb967"); }
test { try parseIDNAFail("\xd94e\xdd12\x3002\x1105\x1172\x11b6"); }
test { try parseIDNAFail("xn--s264a.xn--pw2b"); }
test { try parseIDNAFail("\x1846\xd805\xdcdd\xff0e\xd83b\xdd46"); }
test { try parseIDNAFail("\x1846\xd805\xdcdd.\xd83b\xdd46"); }
test { try parseIDNAFail("xn--57e0440k.xn--k86h"); }
test { try parseIDNAFail("\xdbef\xdfe6\xff61\x183d"); }
test { try parseIDNAFail("\xdbef\xdfe6\x3002\x183d"); }
test { try parseIDNAFail("xn--j890g.xn--w7e"); }
test { try parseIDNAFail("\x5b03\xd834\xdf4c\xff0e\x200d\xb44"); }
test { try parseIDNAFail("\x5b03\xd834\xdf4c.\x200d\xb44"); }
test { try parseIDNAFail("xn--b6s0078f.xn--0ic"); }
test { try parseIDNAFail("xn--b6s0078f.xn--0ic557h"); }
test { try parseIDNAFail("\x200c.\xd93d\xdee4"); }
test { try parseIDNAFail(".xn--q823a"); }
test { try parseIDNAFail("xn--0ug.xn--q823a"); }
test { try parseIDNAFail("\xdaa9\xded5\x10a3\x4805\xff0e\xd803\xde11"); }
test { try parseIDNAFail("\xdaa9\xded5\x10a3\x4805.\xd803\xde11"); }
test { try parseIDNAFail("\xdaa9\xded5\x2d03\x4805.\xd803\xde11"); }
test { try parseIDNAFail("xn--ukju77frl47r.xn--yl0d"); }
test { try parseIDNAFail("\xdaa9\xded5\x2d03\x4805\xff0e\xd803\xde11"); }
test { try parseIDNAFail("xn--bnd074zr557n.xn--yl0d"); }
test { try parseIDNAFail("-\xff61\xfe12"); }
test { try parseIDNAFail("-.xn--y86c"); }
test { try parseIDNAFail("\x200d.F"); }
test { try parseIDNAFail("\x200d.f"); }
test { try parseIDNAFail("xn--1ug.f"); }
test { try parseIDNAFail("\x200d\x3a32\xff61\xdf"); }
test { try parseIDNAFail("\x200d\x3a32\x3002\xdf"); }
test { try parseIDNAFail("\x200d\x3a32\x3002SS"); }
test { try parseIDNAFail("\x200d\x3a32\x3002ss"); }
test { try parseIDNAFail("\x200d\x3a32\x3002Ss"); }
test { try parseIDNAFail("xn--1ug914h.ss"); }
test { try parseIDNAFail("xn--1ug914h.xn--zca"); }
test { try parseIDNAFail("\x200d\x3a32\xff61SS"); }
test { try parseIDNAFail("\x200d\x3a32\xff61ss"); }
test { try parseIDNAFail("\x200d\x3a32\xff61Ss"); }
test { try parseIDNAFail("\x200d\xff0e\xdbc3\xde28"); }
test { try parseIDNAFail("\x200d.\xdbc3\xde28"); }
test { try parseIDNAFail(".xn--h327f"); }
test { try parseIDNAFail("xn--1ug.xn--h327f"); }
test { try parseIDNAFail("\xd94e\xdf7b\xd8f2\xdd41\xff61\x2260\xd835\xdff2"); }
test { try parseIDNAFail("\xd94e\xdf7b\xd8f2\xdd41\xff61=\x338\xd835\xdff2"); }
test { try parseIDNAFail("\xd94e\xdf7b\xd8f2\xdd41\x3002\x22606"); }
test { try parseIDNAFail("\xd94e\xdf7b\xd8f2\xdd41\x3002=\x3386"); }
test { try parseIDNAFail("xn--h79w4z99a.xn--6-tfo"); }
test { try parseIDNAFail("xn--98e.xn--om9c"); }
test { try parseIDNAFail("\xaaf6\x188f\xe3a\xff12.\xd800\xdee2\x745\xf9f\xfe12"); }
test { try parseIDNAFail("\xaaf6\x188f\xe3a2.\xd800\xdee2\x745\xf9f\x3002"); }
test { try parseIDNAFail("xn--2-2zf840fk16m.xn--sob093b2m7s."); }
test { try parseIDNAFail("xn--2-2zf840fk16m.xn--sob093bj62sz9d"); }
test { try parseIDNAFail("\xdad7\xdd27\xff61\x2260-\xdb41\xde44\x2f9b"); }
test { try parseIDNAFail("\xdad7\xdd27\xff61=\x338-\xdb41\xde44\x2f9b"); }
test { try parseIDNAFail("\xdad7\xdd27\x3002\x2260-\xdb41\xde44\x8d70"); }
test { try parseIDNAFail("\xdad7\xdd27\x3002=\x338-\xdb41\xde44\x8d70"); }
test { try parseIDNAFail("xn--gm57d.xn----tfo4949b3664m"); }
test { try parseIDNAFail("-\x2f86\xff0e\xaaf6"); }
test { try parseIDNAFail("-\x820c.\xaaf6"); }
test { try parseIDNAFail("xn----ef8c.xn--2v9a"); }
test { try parseIDNAFail("xn--jnd1986v.xn--gdh"); }
test { try parseIDNAFail("\x74bc\xd836\xde2d\xff61\x200c\xdb40\xdddf"); }
test { try parseIDNAFail("\x74bc\xd836\xde2d\x3002\x200c\xdb40\xdddf"); }
test { try parseIDNAFail("xn--gky8837e.xn--0ug"); }
test { try parseIDNAFail("\x200c.\x200c"); }
test { try parseIDNAFail("xn--0ug.xn--0ug"); }
test { try parseIDNAFail("\x10b7\xff0e\x5c2\xd804\xdd34\xa9b7\xd920\xdce8"); }
test { try parseIDNAFail("\x10b7\xff0e\xd804\xdd34\x5c2\xa9b7\xd920\xdce8"); }
test { try parseIDNAFail("\x10b7.\xd804\xdd34\x5c2\xa9b7\xd920\xdce8"); }
test { try parseIDNAFail("\x2d17.\xd804\xdd34\x5c2\xa9b7\xd920\xdce8"); }
test { try parseIDNAFail("xn--flj.xn--qdb0605f14ycrms3c"); }
test { try parseIDNAFail("\x2d17\xff0e\xd804\xdd34\x5c2\xa9b7\xd920\xdce8"); }
test { try parseIDNAFail("\x2d17\xff0e\x5c2\xd804\xdd34\xa9b7\xd920\xdce8"); }
test { try parseIDNAFail("xn--vnd.xn--qdb0605f14ycrms3c"); }
test { try parseIDNAFail("\x2488\x916b\xfe12\x3002\x8d6"); }
test { try parseIDNAFail("1.\x916b\x3002\x3002\x8d6"); }
test { try parseIDNAFail("1.xn--8j4a..xn--8zb"); }
test { try parseIDNAFail("xn--tsh4490bfe8c.xn--8zb"); }
test { try parseIDNAFail("\x2de3\x200c\x226e\x1a6b.\x200c\xe3a"); }
test { try parseIDNAFail("\x2de3\x200c<\x338\x1a6b.\x200c\xe3a"); }
test { try parseIDNAFail("xn--uof548an0j.xn--o4c"); }
test { try parseIDNAFail("xn--uof63xk4bf3s.xn--o4c732g"); }
test { try parseIDNAFail("xn--co6h.xn--1-kwssa"); }
test { try parseIDNAFail("xn--co6h.xn--1-h1g429s"); }
test { try parseIDNAFail("xn--co6h.xn--1-h1gs"); }
test { try parseIDNAFail("\xa806\x3002\xd8ad\xde8f\xfb0\x2495"); }
test { try parseIDNAFail("\xa806\x3002\xd8ad\xde8f\xfb014."); }
test { try parseIDNAFail("xn--l98a.xn--14-jsj57880f."); }
test { try parseIDNAFail("xn--l98a.xn--dgd218hhp28d"); }
test { try parseIDNAFail("\xd835\xdfe04\xdb40\xddd7\xd834\xde3b\xff0e\x200d\xd800\xdef5\x26e7\x200d"); }
test { try parseIDNAFail("84\xdb40\xddd7\xd834\xde3b.\x200d\xd800\xdef5\x26e7\x200d"); }
test { try parseIDNAFail("xn--84-s850a.xn--1uga573cfq1w"); }
test { try parseIDNAFail("\xd975\xdf0e\x2488\xff61\x200c\xd835\xdfe4"); }
test { try parseIDNAFail("\xd975\xdf0e1.\x3002\x200c2"); }
test { try parseIDNAFail("xn--1-ex54e..c"); }
test { try parseIDNAFail("xn--1-ex54e..xn--2-rgn"); }
test { try parseIDNAFail("xn--tsh94183d.c"); }
test { try parseIDNAFail("xn--tsh94183d.xn--2-rgn"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\xff61\xdf\xd805\xdcc3"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\x3002\xdf\xd805\xdcc3"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\x3002SS\xd805\xdcc3"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\x3002ss\xd805\xdcc3"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\x3002Ss\xd805\xdcc3"); }
test { try parseIDNAFail("xn--0ugb.xn--ss-bh7o"); }
test { try parseIDNAFail("xn--0ugb.xn--zca0732l"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\xff61SS\xd805\xdcc3"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\xff61ss\xd805\xdcc3"); }
test { try parseIDNAFail("\x200d\x200c\xdb40\xddaa\xff61Ss\xd805\xdcc3"); }
test { try parseIDNAFail("\xfe12\x200c\x30f6\x44a9.\xa86a"); }
test { try parseIDNAFail("\x3002\x200c\x30f6\x44a9.\xa86a"); }
test { try parseIDNAFail(".xn--0ug287dj0o.xn--gd9a"); }
test { try parseIDNAFail("xn--qekw60dns9k.xn--gd9a"); }
test { try parseIDNAFail("xn--0ug287dj0or48o.xn--gd9a"); }
test { try parseIDNAFail("\x200c\x2488\xd852\xdf8d.\xdb49\xdccb\x1a60"); }
test { try parseIDNAFail("\x200c1.\xd852\xdf8d.\xdb49\xdccb\x1a60"); }
test { try parseIDNAFail("1.xn--4x6j.xn--jof45148n"); }
test { try parseIDNAFail("xn--1-rgn.xn--4x6j.xn--jof45148n"); }
test { try parseIDNAFail("xn--tshw462r.xn--jof45148n"); }
test { try parseIDNAFail("xn--0ug88o7471d.xn--jof45148n"); }
test { try parseIDNAFail("\xd834\xdd75\xff61\xd835\xdfeb\xd838\xdc08\x4b3a\x2488"); }
test { try parseIDNAFail(".xn--9-ecp936non25a"); }
test { try parseIDNAFail("xn--3f1h.xn--91-030c1650n."); }
test { try parseIDNAFail("xn--3f1h.xn--9-ecp936non25a"); }
test { try parseIDNAFail("-\xdb40\xdd710\xff61\x17cf\x1dfd\xd187\xc2ed"); }
test { try parseIDNAFail("-\xdb40\xdd710\xff61\x17cf\x1dfd\x1110\x1168\x11aa\x1109\x1175\x11b8"); }
test { try parseIDNAFail("-\xdb40\xdd710\x3002\x17cf\x1dfd\xd187\xc2ed"); }
test { try parseIDNAFail("-\xdb40\xdd710\x3002\x17cf\x1dfd\x1110\x1168\x11aa\x1109\x1175\x11b8"); }
test { try parseIDNAFail("-0.xn--r4e872ah77nghm"); }
test { try parseIDNAFail("\x115f\x10bf\x10b5\x10e0\xff61\xb4d"); }
test { try parseIDNAFail("\x115f\x10bf\x10b5\x10e0\x3002\xb4d"); }
test { try parseIDNAFail("\x115f\x2d1f\x2d15\x10e0\x3002\xb4d"); }
test { try parseIDNAFail("\x115f\x10bf\x10b5\x1ca0\x3002\xb4d"); }
test { try parseIDNAFail("xn--1od555l3a.xn--9ic"); }
test { try parseIDNAFail("\x115f\x2d1f\x2d15\x10e0\xff61\xb4d"); }
test { try parseIDNAFail("\x115f\x10bf\x10b5\x1ca0\xff61\xb4d"); }
test { try parseIDNAFail("xn--tndt4hvw.xn--9ic"); }
test { try parseIDNAFail("xn--1od7wz74eeb.xn--9ic"); }
test { try parseIDNAFail("\x115f\x10bf\x2d15\x10e0\x3002\xb4d"); }
test { try parseIDNAFail("xn--3nd0etsm92g.xn--9ic"); }
test { try parseIDNAFail("\x115f\x10bf\x2d15\x10e0\xff61\xb4d"); }
test { try parseIDNAFail("xn--l96h.xn--o8e4044k"); }
test { try parseIDNAFail("xn--l96h.xn--03e93aq365d"); }
test { try parseIDNAFail("\xd835\xdfdb\xd834\xddaa\xa8c4\xff61\xa8ea-"); }
test { try parseIDNAFail("\xd835\xdfdb\xa8c4\xd834\xddaa\xff61\xa8ea-"); }
test { try parseIDNAFail("3\xa8c4\xd834\xddaa\x3002\xa8ea-"); }
test { try parseIDNAFail("xn--3-sl4eu679e.xn----xn4e"); }
test { try parseIDNAFail("\x1139\xff61\xeca\xda42\xdfe4\xdb40\xdd1e"); }
test { try parseIDNAFail("\x1139\x3002\xeca\xda42\xdfe4\xdb40\xdd1e"); }
test { try parseIDNAFail("xn--lrd.xn--s8c05302k"); }
test { try parseIDNAFail("\x10a6\xdaae\xdca9\xff0e\xdb40\xdda1\xfe09\xd83a\xdd0d"); }
test { try parseIDNAFail("\x10a6\xdaae\xdca9.\xdb40\xdda1\xfe09\xd83a\xdd0d"); }
test { try parseIDNAFail("\x2d06\xdaae\xdca9.\xdb40\xdda1\xfe09\xd83a\xdd2f"); }
test { try parseIDNAFail("xn--xkjw3965g.xn--ne6h"); }
test { try parseIDNAFail("\x2d06\xdaae\xdca9\xff0e\xdb40\xdda1\xfe09\xd83a\xdd2f"); }
test { try parseIDNAFail("xn--end82983m.xn--ne6h"); }
test { try parseIDNAFail("\x2d06\xdaae\xdca9.\xdb40\xdda1\xfe09\xd83a\xdd0d"); }
test { try parseIDNAFail("\x2d06\xdaae\xdca9\xff0e\xdb40\xdda1\xfe09\xd83a\xdd0d"); }
test { try parseIDNAFail("\xd91d\xdee8.\xd9d5\xdfe2\xd835\xdfe8\xa8c4"); }
test { try parseIDNAFail("\xd91d\xdee8.\xd9d5\xdfe26\xa8c4"); }
test { try parseIDNAFail("xn--mi60a.xn--6-sl4es8023c"); }
test { try parseIDNAFail("\xd800\xdef8\xdb79\xde0b\x10c2.\x10a1"); }
test { try parseIDNAFail("\xd800\xdef8\xdb79\xde0b\x2d22.\x2d01"); }
test { try parseIDNAFail("\xd800\xdef8\xdb79\xde0b\x10c2.\x2d01"); }
test { try parseIDNAFail("xn--qlj1559dr224h.xn--skj"); }
test { try parseIDNAFail("xn--6nd5215jr2u0h.xn--skj"); }
test { try parseIDNAFail("xn--6nd5215jr2u0h.xn--8md"); }
test { try parseIDNAFail("\xd91d\xdc7f\xa806\x2084\xda65\xdf86\xff61\xd88a\xde67\xdb41\xdcb9\x3c2"); }
test { try parseIDNAFail("\xd91d\xdc7f\xa8064\xda65\xdf86\x3002\xd88a\xde67\xdb41\xdcb9\x3c2"); }
test { try parseIDNAFail("\xd91d\xdc7f\xa8064\xda65\xdf86\x3002\xd88a\xde67\xdb41\xdcb9\x3a3"); }
test { try parseIDNAFail("\xd91d\xdc7f\xa8064\xda65\xdf86\x3002\xd88a\xde67\xdb41\xdcb9\x3c3"); }
test { try parseIDNAFail("xn--4-w93ej7463a9io5a.xn--4xa31142bk3f0d"); }
test { try parseIDNAFail("xn--4-w93ej7463a9io5a.xn--3xa51142bk3f0d"); }
test { try parseIDNAFail("\xd91d\xdc7f\xa806\x2084\xda65\xdf86\xff61\xd88a\xde67\xdb41\xdcb9\x3a3"); }
test { try parseIDNAFail("\xd91d\xdc7f\xa806\x2084\xda65\xdf86\xff61\xd88a\xde67\xdb41\xdcb9\x3c3"); }
test { try parseIDNAFail("\xd8ba\xdcac\x3002\x729\x3002\xcbd95"); }
test { try parseIDNAFail("\xd8ba\xdcac\x3002\x729\x3002\x110d\x1173\x11ac5"); }
test { try parseIDNAFail("xn--t92s.xn--znb.xn--5-y88f"); }
test { try parseIDNAFail("\x17ca.\x200d\xd835\xdfee\xd804\xdc3f"); }
test { try parseIDNAFail("\x17ca.\x200d2\xd804\xdc3f"); }
test { try parseIDNAFail("xn--m4e.xn--2-ku7i"); }
test { try parseIDNAFail("xn--m4e.xn--2-tgnv469h"); }
test { try parseIDNAFail("\xaaf6\x3002\x5b36\xdf\x847d"); }
test { try parseIDNAFail("\xaaf6\x3002\x5b36SS\x847d"); }
test { try parseIDNAFail("\xaaf6\x3002\x5b36ss\x847d"); }
test { try parseIDNAFail("\xaaf6\x3002\x5b36Ss\x847d"); }
test { try parseIDNAFail("xn--2v9a.xn--ss-q40dp97m"); }
test { try parseIDNAFail("xn--2v9a.xn--zca7637b14za"); }
test { try parseIDNAFail("\x3c2\xd805\xdc3d\xd896\xdc88\xd805\xdf2b\xff61\xd83a\xdf29\x200c\xd802\xdec4"); }
test { try parseIDNAFail("\x3c2\xd805\xdc3d\xd896\xdc88\xd805\xdf2b\x3002\xd83a\xdf29\x200c\xd802\xdec4"); }
test { try parseIDNAFail("\x3a3\xd805\xdc3d\xd896\xdc88\xd805\xdf2b\x3002\xd83a\xdf29\x200c\xd802\xdec4"); }
test { try parseIDNAFail("\x3c3\xd805\xdc3d\xd896\xdc88\xd805\xdf2b\x3002\xd83a\xdf29\x200c\xd802\xdec4"); }
test { try parseIDNAFail("xn--4xa2260lk3b8z15g.xn--tw9ct349a"); }
test { try parseIDNAFail("xn--4xa2260lk3b8z15g.xn--0ug4653g2xzf"); }
test { try parseIDNAFail("xn--3xa4260lk3b8z15g.xn--0ug4653g2xzf"); }
test { try parseIDNAFail("\x3a3\xd805\xdc3d\xd896\xdc88\xd805\xdf2b\xff61\xd83a\xdf29\x200c\xd802\xdec4"); }
test { try parseIDNAFail("\x3c3\xd805\xdc3d\xd896\xdc88\xd805\xdf2b\xff61\xd83a\xdf29\x200c\xd802\xdec4"); }
test { try parseIDNAFail("\x2ea2\xd9df\xde85\xd835\xdfe4\xff61\x200d\xd83d\xdeb7"); }
test { try parseIDNAFail("\x2ea2\xd9df\xde852\x3002\x200d\xd83d\xdeb7"); }
test { try parseIDNAFail("xn--2-4jtr4282f.xn--m78h"); }
test { try parseIDNAFail("xn--2-4jtr4282f.xn--1ugz946p"); }
test { try parseIDNAFail("\xd836\xde25\x3002\x2adf\xd804\xde3e"); }
test { try parseIDNAFail("xn--n82h.xn--63iw010f"); }
test { try parseIDNAFail("-\x1897\x200c\xd83c\xdd04.\xd805\xdf22"); }
test { try parseIDNAFail("-\x1897\x200c3,.\xd805\xdf22"); }
test { try parseIDNAFail("xn---3,-3eu.xn--9h2d"); }
test { try parseIDNAFail("xn---3,-3eu051c.xn--9h2d"); }
test { try parseIDNAFail("xn----pck1820x.xn--9h2d"); }
test { try parseIDNAFail("xn----pck312bx563c.xn--9h2d"); }
test { try parseIDNAFail("xn--z3e.xn----938f"); }
test { try parseIDNAFail("\x200c\xd805\xdcc2\x3002\x2488-\xdbc2\xde9b"); }
test { try parseIDNAFail("\x200c\xd805\xdcc2\x30021.-\xdbc2\xde9b"); }
test { try parseIDNAFail("xn--wz1d.1.xn----rg03o"); }
test { try parseIDNAFail("xn--0ugy057g.1.xn----rg03o"); }
test { try parseIDNAFail("xn--wz1d.xn----dcp29674o"); }
test { try parseIDNAFail("xn--0ugy057g.xn----dcp29674o"); }
test { try parseIDNAFail("\xf94\xa84b-\xff0e-\xd81a\xdf34"); }
test { try parseIDNAFail("\xf94\xa84b-.-\xd81a\xdf34"); }
test { try parseIDNAFail("xn----ukg9938i.xn----4u5m"); }
test { try parseIDNAFail("\xd9bd\xdcb3-\x22e2\x200c\xff0e\x6807-"); }
test { try parseIDNAFail("\xd9bd\xdcb3-\x2291\x338\x200c\xff0e\x6807-"); }
test { try parseIDNAFail("\xd9bd\xdcb3-\x22e2\x200c.\x6807-"); }
test { try parseIDNAFail("\xd9bd\xdcb3-\x2291\x338\x200c.\x6807-"); }
test { try parseIDNAFail("xn----9mo67451g.xn----qj7b"); }
test { try parseIDNAFail("xn----sgn90kn5663a.xn----qj7b"); }
test { try parseIDNAFail("-\xd914\xde74.\x6e0\x189a-"); }
test { try parseIDNAFail("xn----qi38c.xn----jxc827k"); }
test { try parseIDNAFail("\x3002\x635\x649\xe37\x644\x627\x3002\x5c93\x1bf2\xdb43\xdf83\x1842"); }
test { try parseIDNAFail(".xn--mgb1a7bt462h.xn--17e10qe61f9r71s"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2\xff0e\xdf"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2.\xdf"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2.SS"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2.ss"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2.Ss"); }
test { try parseIDNAFail("xn----9tg11172akr8b.ss"); }
test { try parseIDNAFail("xn----9tg11172akr8b.xn--zca"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2\xff0eSS"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2\xff0ess"); }
test { try parseIDNAFail("\x1039-\xd82a\xdfad\xd83d\xdfa2\xff0eSs"); }
test { try parseIDNAFail("\xd4d-\x200d\x200c\xff61\xd955\xdfa7\x2085\x2260"); }
test { try parseIDNAFail("\xd4d-\x200d\x200c\xff61\xd955\xdfa7\x2085=\x338"); }
test { try parseIDNAFail("\xd4d-\x200d\x200c\x3002\xd955\xdfa75\x2260"); }
test { try parseIDNAFail("\xd4d-\x200d\x200c\x3002\xd955\xdfa75=\x338"); }
test { try parseIDNAFail("xn----jmf.xn--5-ufo50192e"); }
test { try parseIDNAFail("xn----jmf215lda.xn--5-ufo50192e"); }
test { try parseIDNAFail("\x9523\x3002\xa4d\xdb41\xde3b\xdb41\xde86"); }
test { try parseIDNAFail("xn--gc5a.xn--ybc83044ppga"); }
test { try parseIDNAFail("xn--6-8cb306hms1a.xn--ss-2vq"); }
test { try parseIDNAFail("xn--6-8cb555h2b.xn--ss-2vq"); }
test { try parseIDNAFail("xn--6-8cb555h2b.xn--zca894k"); }
test { try parseIDNAFail("\xd9ee\xdc50\xff61\x226f\xd804\xdeea"); }
test { try parseIDNAFail("\xd9ee\xdc50\xff61>\x338\xd804\xdeea"); }
test { try parseIDNAFail("\xd9ee\xdc50\x3002\x226f\xd804\xdeea"); }
test { try parseIDNAFail("\xd9ee\xdc50\x3002>\x338\xd804\xdeea"); }
test { try parseIDNAFail("xn--eo08b.xn--hdh3385g"); }
test { try parseIDNAFail("\xdb40\xdd0f\xd81a\xdf34\xdb43\xdcbd\xff61\xffa0"); }
test { try parseIDNAFail("\xdb40\xdd0f\xd81a\xdf34\xdb43\xdcbd\x3002\x1160"); }
test { try parseIDNAFail("xn--619ep9154c."); }
test { try parseIDNAFail("xn--619ep9154c.xn--psd"); }
test { try parseIDNAFail("xn--619ep9154c.xn--cl7c"); }
test { try parseIDNAFail("\xdb42\xdf54.\xd800\xdef1\x2082"); }
test { try parseIDNAFail("\xdb42\xdf54.\xd800\xdef12"); }
test { try parseIDNAFail("xn--vi56e.xn--2-w91i"); }
test { try parseIDNAFail("\x2dbf.\xdf\x200d"); }
test { try parseIDNAFail("\x2dbf.SS\x200d"); }
test { try parseIDNAFail("\x2dbf.ss\x200d"); }
test { try parseIDNAFail("\x2dbf.Ss\x200d"); }
test { try parseIDNAFail("xn--7pj.ss"); }
test { try parseIDNAFail("xn--7pj.xn--ss-n1t"); }
test { try parseIDNAFail("xn--7pj.xn--zca870n"); }
test { try parseIDNAFail("\x6889\x3002\x200c"); }
test { try parseIDNAFail("xn--7zv.xn--0ug"); }
test { try parseIDNAFail("\x40da\x87e5-\x3002-\xd9b5\xdc98\x2488"); }
test { try parseIDNAFail("\x40da\x87e5-\x3002-\xd9b5\xdc981."); }
test { try parseIDNAFail("xn----n50a258u.xn---1-up07j."); }
test { try parseIDNAFail("xn----n50a258u.xn----ecp33805f"); }
test { try parseIDNAFail("\x1894\x2260\xdbec\xde42.\x200d\xd800\xdee2"); }
test { try parseIDNAFail("\x1894=\x338\xdbec\xde42.\x200d\xd800\xdee2"); }
test { try parseIDNAFail("xn--ebf031cf7196a.xn--587c"); }
test { try parseIDNAFail("xn--ebf031cf7196a.xn--1ug9540g"); }
test { try parseIDNAFail("\xdb43\xdc29\xd807\xdcac\xff0e\x65c"); }
test { try parseIDNAFail("\xdb43\xdc29\xd807\xdcac.\x65c"); }
test { try parseIDNAFail("xn--sn3d59267c.xn--4hb"); }
test { try parseIDNAFail("\xd800\xdf7a.\xd928\xddc3\x200c"); }
test { try parseIDNAFail("xn--ie8c.xn--2g51a"); }
test { try parseIDNAFail("xn--ie8c.xn--0ug03366c"); }
test { try parseIDNAFail("\x200d\x226e\xff0e\xdb41\xdfea\xd8a6\xdecf-"); }
test { try parseIDNAFail("\x200d<\x338\xff0e\xdb41\xdfea\xd8a6\xdecf-"); }
test { try parseIDNAFail("\x200d\x226e.\xdb41\xdfea\xd8a6\xdecf-"); }
test { try parseIDNAFail("\x200d<\x338.\xdb41\xdfea\xd8a6\xdecf-"); }
test { try parseIDNAFail("xn--gdh.xn----cr99a1w710b"); }
test { try parseIDNAFail("xn--1ug95g.xn----cr99a1w710b"); }
test { try parseIDNAFail("\x200d\x200d\x8954\x3002\x10bc5\xa86e\xd995\xdf4f"); }
test { try parseIDNAFail("\x200d\x200d\x8954\x3002\x2d1c5\xa86e\xd995\xdf4f"); }
test { try parseIDNAFail("xn--2u2a.xn--5-uws5848bpf44e"); }
test { try parseIDNAFail("xn--1uga7691f.xn--5-uws5848bpf44e"); }
test { try parseIDNAFail("xn--2u2a.xn--5-r1g7167ipfw8d"); }
test { try parseIDNAFail("xn--1uga7691f.xn--5-r1g7167ipfw8d"); }
test { try parseIDNAFail("\xa9b9\x200d\xd077\xd8af\xdda1\xff61\x2082"); }
test { try parseIDNAFail("\xa9b9\x200d\x110f\x1173\x11b2\xd8af\xdda1\xff61\x2082"); }
test { try parseIDNAFail("xn--0m9as84e2e21c.c"); }
test { try parseIDNAFail("xn--1ug1435cfkyaoi04d.c"); }
test { try parseIDNAFail("\x2260\x81a3\x3002\xf83"); }
test { try parseIDNAFail("=\x338\x81a3\x3002\xf83"); }
test { try parseIDNAFail("xn--1chy468a.xn--2ed"); }
test { try parseIDNAFail("\xd800\xdef7\x3002\x200d"); }
test { try parseIDNAFail("xn--r97c.xn--1ug"); }
test { try parseIDNAFail("\xd807\xdc33\xd804\xde2f\x3002\x296a"); }
test { try parseIDNAFail("xn--2g1d14o.xn--jti"); }
test { try parseIDNAFail("\xd804\xdd80\x4074\xd952\xdde3\xff0e\x10b5\xd835\xdfdc\x200c\x348"); }
test { try parseIDNAFail("\xd804\xdd80\x4074\xd952\xdde3.\x10b54\x200c\x348"); }
test { try parseIDNAFail("\xd804\xdd80\x4074\xd952\xdde3.\x2d154\x200c\x348"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb5123a"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb502tlsl"); }
test { try parseIDNAFail("\xd804\xdd80\x4074\xd952\xdde3\xff0e\x2d15\xd835\xdfdc\x200c\x348"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb324h"); }
test { try parseIDNAFail("xn--1mnx647cg3x1b.xn--4-zfb324h32o"); }

test { try parseIDNAPass("fass.de", "fass.de"); }
test { try parseIDNAPass("fa\xdf.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("Fa\xdf.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("xn--fa-hia.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("\xe0.\x5d0\x308", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("a\x300.\x5d0\x308", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("A\x300.\x5d0\x308", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("\xc0.\x5d0\x308", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("xn--0ca.xn--ssa73l", "xn--0ca.xn--ssa73l"); }
test { try parseIDNAPass("\xe0\x308.\x5d0", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("a\x300\x308.\x5d0", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("A\x300\x308.\x5d0", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("\xc0\x308.\x5d0", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("xn--0ca81i.xn--4db", "xn--0ca81i.xn--4db"); }
test { try parseIDNAPass("ab", "ab"); }
test { try parseIDNAPass("a\x94d\x200cb", "xn--ab-fsf604u"); }
test { try parseIDNAPass("A\x94d\x200cB", "xn--ab-fsf604u"); }
test { try parseIDNAPass("A\x94d\x200cb", "xn--ab-fsf604u"); }
test { try parseIDNAPass("xn--ab-fsf", "xn--ab-fsf"); }
test { try parseIDNAPass("a\x94db", "xn--ab-fsf"); }
test { try parseIDNAPass("A\x94dB", "xn--ab-fsf"); }
test { try parseIDNAPass("A\x94db", "xn--ab-fsf"); }
test { try parseIDNAPass("xn--ab-fsf604u", "xn--ab-fsf604u"); }
test { try parseIDNAPass("a\x94d\x200db", "xn--ab-fsf014u"); }
test { try parseIDNAPass("A\x94d\x200dB", "xn--ab-fsf014u"); }
test { try parseIDNAPass("A\x94d\x200db", "xn--ab-fsf014u"); }
test { try parseIDNAPass("xn--ab-fsf014u", "xn--ab-fsf014u"); }
test { try parseIDNAPass("\xa1", "xn--7a"); }
test { try parseIDNAPass("xn--7a", "xn--7a"); }
test { try parseIDNAPass("\x19da", "xn--pkf"); }
test { try parseIDNAPass("xn--pkf", "xn--pkf"); }
test { try parseIDNAPass("\x3002", "."); }
test { try parseIDNAPass(".", "."); }
test { try parseIDNAPass("\xab60", "xn--3y9a"); }
test { try parseIDNAPass("xn--3y9a", "xn--3y9a"); }
test { try parseIDNAPass("1234567890\xe41234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("1234567890a\x3081234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("1234567890A\x3081234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("1234567890\xc41234567890123456789012345678901234567890123456", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("xn--12345678901234567890123456789012345678901234567890123456-fxe", "xn--12345678901234567890123456789012345678901234567890123456-fxe"); }
test { try parseIDNAPass("www.eXample.cOm", "www.example.com"); }
test { try parseIDNAPass("B\xfccher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("Bu\x308cher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("bu\x308cher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("b\xfccher.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("B\xdcCHER.DE", "xn--bcher-kva.de"); }
test { try parseIDNAPass("BU\x308CHER.DE", "xn--bcher-kva.de"); }
test { try parseIDNAPass("xn--bcher-kva.de", "xn--bcher-kva.de"); }
test { try parseIDNAPass("\xd6BB", "xn--bb-eka"); }
test { try parseIDNAPass("O\x308BB", "xn--bb-eka"); }
test { try parseIDNAPass("o\x308bb", "xn--bb-eka"); }
test { try parseIDNAPass("\xf6bb", "xn--bb-eka"); }
test { try parseIDNAPass("\xd6bb", "xn--bb-eka"); }
test { try parseIDNAPass("O\x308bb", "xn--bb-eka"); }
test { try parseIDNAPass("xn--bb-eka", "xn--bb-eka"); }
test { try parseIDNAPass("FA\x1e9e.de", "xn--fa-hia.de"); }
test { try parseIDNAPass("FA\x1e9e.DE", "xn--fa-hia.de"); }
test { try parseIDNAPass("\x3b2\x3cc\x3bb\x3bf\x3c2.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("\x3b2\x3bf\x301\x3bb\x3bf\x3c2.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("\x392\x39f\x301\x39b\x39f\x3a3.COM", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\x392\x38c\x39b\x39f\x3a3.COM", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\x3b2\x3cc\x3bb\x3bf\x3c3.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\x3b2\x3bf\x301\x3bb\x3bf\x3c3.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\x392\x3bf\x301\x3bb\x3bf\x3c3.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\x392\x3cc\x3bb\x3bf\x3c3.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("xn--nxasmq6b.com", "xn--nxasmq6b.com"); }
test { try parseIDNAPass("\x392\x3bf\x301\x3bb\x3bf\x3c2.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("\x392\x3cc\x3bb\x3bf\x3c2.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("xn--nxasmm1c.com", "xn--nxasmm1c.com"); }
test { try parseIDNAPass("xn--nxasmm1c", "xn--nxasmm1c"); }
test { try parseIDNAPass("\x3b2\x3cc\x3bb\x3bf\x3c2", "xn--nxasmm1c"); }
test { try parseIDNAPass("\x3b2\x3bf\x301\x3bb\x3bf\x3c2", "xn--nxasmm1c"); }
test { try parseIDNAPass("\x392\x39f\x301\x39b\x39f\x3a3", "xn--nxasmq6b"); }
test { try parseIDNAPass("\x392\x38c\x39b\x39f\x3a3", "xn--nxasmq6b"); }
test { try parseIDNAPass("\x3b2\x3cc\x3bb\x3bf\x3c3", "xn--nxasmq6b"); }
test { try parseIDNAPass("\x3b2\x3bf\x301\x3bb\x3bf\x3c3", "xn--nxasmq6b"); }
test { try parseIDNAPass("\x392\x3bf\x301\x3bb\x3bf\x3c3", "xn--nxasmq6b"); }
test { try parseIDNAPass("\x392\x3cc\x3bb\x3bf\x3c3", "xn--nxasmq6b"); }
test { try parseIDNAPass("xn--nxasmq6b", "xn--nxasmq6b"); }
test { try parseIDNAPass("\x392\x3cc\x3bb\x3bf\x3c2", "xn--nxasmm1c"); }
test { try parseIDNAPass("\x392\x3bf\x301\x3bb\x3bf\x3c2", "xn--nxasmm1c"); }
test { try parseIDNAPass("www.\xdc1\xdca\x200d\xdbb\xdd3.com", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("WWW.\xdc1\xdca\x200d\xdbb\xdd3.COM", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("Www.\xdc1\xdca\x200d\xdbb\xdd3.com", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("www.xn--10cl1a0b.com", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("www.\xdc1\xdca\xdbb\xdd3.com", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("WWW.\xdc1\xdca\xdbb\xdd3.COM", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("Www.\xdc1\xdca\xdbb\xdd3.com", "www.xn--10cl1a0b.com"); }
test { try parseIDNAPass("www.xn--10cl1a0b660p.com", "www.xn--10cl1a0b660p.com"); }
test { try parseIDNAPass("\x646\x627\x645\x647\x200c\x627\x6cc", "xn--mgba3gch31f060k"); }
test { try parseIDNAPass("xn--mgba3gch31f", "xn--mgba3gch31f"); }
test { try parseIDNAPass("\x646\x627\x645\x647\x627\x6cc", "xn--mgba3gch31f"); }
test { try parseIDNAPass("xn--mgba3gch31f060k", "xn--mgba3gch31f060k"); }
test { try parseIDNAPass("xn--mgba3gch31f060k.com", "xn--mgba3gch31f060k.com"); }
test { try parseIDNAPass("\x646\x627\x645\x647\x200c\x627\x6cc.com", "xn--mgba3gch31f060k.com"); }
test { try parseIDNAPass("\x646\x627\x645\x647\x200c\x627\x6cc.COM", "xn--mgba3gch31f060k.com"); }
test { try parseIDNAPass("xn--mgba3gch31f.com", "xn--mgba3gch31f.com"); }
test { try parseIDNAPass("\x646\x627\x645\x647\x627\x6cc.com", "xn--mgba3gch31f.com"); }
test { try parseIDNAPass("\x646\x627\x645\x647\x627\x6cc.COM", "xn--mgba3gch31f.com"); }
test { try parseIDNAPass("a.b\xff0ec\x3002d\xff61", "a.b.c.d."); }
test { try parseIDNAPass("a.b.c\x3002d\x3002", "a.b.c.d."); }
test { try parseIDNAPass("A.B.C\x3002D\x3002", "a.b.c.d."); }
test { try parseIDNAPass("A.b.c\x3002D\x3002", "a.b.c.d."); }
test { try parseIDNAPass("a.b.c.d.", "a.b.c.d."); }
test { try parseIDNAPass("A.B\xff0eC\x3002D\xff61", "a.b.c.d."); }
test { try parseIDNAPass("A.b\xff0ec\x3002D\xff61", "a.b.c.d."); }
test { try parseIDNAPass("U\x308.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xdc.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xfc.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("u\x308.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\x308.XN--TDA", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xdc.XN--TDA", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xdc.xn--Tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\x308.xn--Tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("xn--tda.xn--tda", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xfc.\xfc", "xn--tda.xn--tda"); }
test { try parseIDNAPass("u\x308.u\x308", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\x308.U\x308", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xdc.\xdc", "xn--tda.xn--tda"); }
test { try parseIDNAPass("\xdc.\xfc", "xn--tda.xn--tda"); }
test { try parseIDNAPass("U\x308.u\x308", "xn--tda.xn--tda"); }
test { try parseIDNAPass("a1.com", "a1.com"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e\x3002\xff2a\xff30", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e\x3002JP", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e\x3002jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e\x3002Jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("xn--wgv71a119e.jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e.jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e.JP", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e.Jp", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e\x3002\xff4a\xff50", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x65e5\x672c\x8a9e\x3002\xff2a\xff50", "xn--wgv71a119e.jp"); }
test { try parseIDNAPass("\x2615", "xn--53h"); }
test { try parseIDNAPass("xn--53h", "xn--53h"); }
test { try parseIDNAPass("1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.assbcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\x15dssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.assbcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\x302ssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.ASSBCSSSSSSSSD\x3a3\x3a3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSSS\x302SSZ", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.ASSBCSSSSSSSSD\x3a3\x3a3SSSSSSSSSSSSSSSSESSSSSSSSSSSSSSSSSSSSXSSSSSSSSSSSSSSSSSSSSYSSSSSSSSSSSSSSS\x15cSSZ", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.Assbcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssss\x15dssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("1.Assbcssssssssd\x3c3\x3c3ssssssssssssssssessssssssssssssssssssxssssssssssssssssssssyssssssssssssssss\x302ssz", "1.xn--assbcssssssssdssssssssssssssssessssssssssssssssssssxssssssssssssssssssssysssssssssssssssssz-pxq1419aa"); }
test { try parseIDNAPass("xn--bss", "xn--bss"); }
test { try parseIDNAPass("\x5919", "xn--bss"); }
test { try parseIDNAPass("\x2e3\x34f\x2115\x200b\xfe63\xad\xff0d\x180c\x212c\xfe00\x17f\x2064\xd835\xdd30\xdb40\xddef\xfb04", "xn--bssffl"); }
test { try parseIDNAPass("x\x34fN\x200b-\xad-\x180cB\xfe00s\x2064s\xdb40\xddefffl", "xn--bssffl"); }
test { try parseIDNAPass("x\x34fn\x200b-\xad-\x180cb\xfe00s\x2064s\xdb40\xddefffl", "xn--bssffl"); }
test { try parseIDNAPass("X\x34fN\x200b-\xad-\x180cB\xfe00S\x2064S\xdb40\xddefFFL", "xn--bssffl"); }
test { try parseIDNAPass("X\x34fn\x200b-\xad-\x180cB\xfe00s\x2064s\xdb40\xddefffl", "xn--bssffl"); }
test { try parseIDNAPass("xn--bssffl", "xn--bssffl"); }
test { try parseIDNAPass("\x5921\x591e\x591c\x5919", "xn--bssffl"); }
test { try parseIDNAPass("\x2e3\x34f\x2115\x200b\xfe63\xad\xff0d\x180c\x212c\xfe00S\x2064\xd835\xdd30\xdb40\xddefFFL", "xn--bssffl"); }
test { try parseIDNAPass("x\x34fN\x200b-\xad-\x180cB\xfe00S\x2064s\xdb40\xddefFFL", "xn--bssffl"); }
test { try parseIDNAPass("\x2e3\x34f\x2115\x200b\xfe63\xad\xff0d\x180c\x212c\xfe00s\x2064\xd835\xdd30\xdb40\xddefffl", "xn--bssffl"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901234.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("\xe41234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("a\x3081234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("A\x3081234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("\xc41234567890123456789012345678901234567890123456789012345", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("xn--1234567890123456789012345678901234567890123456789012345-9te", "xn--1234567890123456789012345678901234567890123456789012345-9te"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xe4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xe4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xe4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901C", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901C", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xe41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xe41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789A.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xe41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890a\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890B", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("a.b..-q--a-.e", "a.b..-q--a-.e"); }
test { try parseIDNAPass("a.b..-q--\xe4-.e", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("a.b..-q--a\x308-.e", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.B..-Q--A\x308-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.B..-Q--\xc4-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.b..-Q--\xc4-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("A.b..-Q--A\x308-.E", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("a.b..xn---q----jra.e", "a.b..xn---q----jra.e"); }
test { try parseIDNAPass("a..c", "a..c"); }
test { try parseIDNAPass("a.-b.", "a.-b."); }
test { try parseIDNAPass("a.b-.c", "a.b-.c"); }
test { try parseIDNAPass("a.-.c", "a.-.c"); }
test { try parseIDNAPass("a.bc--de.f", "a.bc--de.f"); }
test { try parseIDNAPass("\xe4.\xad.c", "xn--4ca..c"); }
test { try parseIDNAPass("a\x308.\xad.c", "xn--4ca..c"); }
test { try parseIDNAPass("A\x308.\xad.C", "xn--4ca..c"); }
test { try parseIDNAPass("\xc4.\xad.C", "xn--4ca..c"); }
test { try parseIDNAPass("xn--4ca..c", "xn--4ca..c"); }
test { try parseIDNAPass("\xe4.-b.", "xn--4ca.-b."); }
test { try parseIDNAPass("a\x308.-b.", "xn--4ca.-b."); }
test { try parseIDNAPass("A\x308.-B.", "xn--4ca.-b."); }
test { try parseIDNAPass("\xc4.-B.", "xn--4ca.-b."); }
test { try parseIDNAPass("xn--4ca.-b.", "xn--4ca.-b."); }
test { try parseIDNAPass("\xe4.b-.c", "xn--4ca.b-.c"); }
test { try parseIDNAPass("a\x308.b-.c", "xn--4ca.b-.c"); }
test { try parseIDNAPass("A\x308.B-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("\xc4.B-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("\xc4.b-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("A\x308.b-.C", "xn--4ca.b-.c"); }
test { try parseIDNAPass("xn--4ca.b-.c", "xn--4ca.b-.c"); }
test { try parseIDNAPass("\xe4.-.c", "xn--4ca.-.c"); }
test { try parseIDNAPass("a\x308.-.c", "xn--4ca.-.c"); }
test { try parseIDNAPass("A\x308.-.C", "xn--4ca.-.c"); }
test { try parseIDNAPass("\xc4.-.C", "xn--4ca.-.c"); }
test { try parseIDNAPass("xn--4ca.-.c", "xn--4ca.-.c"); }
test { try parseIDNAPass("\xe4.bc--de.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("a\x308.bc--de.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("A\x308.BC--DE.F", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("\xc4.BC--DE.F", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("\xc4.bc--De.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("A\x308.bc--De.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("xn--4ca.bc--de.f", "xn--4ca.bc--de.f"); }
test { try parseIDNAPass("A0", "a0"); }
test { try parseIDNAPass("0A", "0a"); }
test { try parseIDNAPass("\x5d0\x5c7", "xn--vdbr"); }
test { try parseIDNAPass("xn--vdbr", "xn--vdbr"); }
test { try parseIDNAPass("\x5d09\x5c7", "xn--9-ihcz"); }
test { try parseIDNAPass("xn--9-ihcz", "xn--9-ihcz"); }
test { try parseIDNAPass("\x5d0\x5ea", "xn--4db6c"); }
test { try parseIDNAPass("xn--4db6c", "xn--4db6c"); }
test { try parseIDNAPass("\x5d0\x5f3\x5ea", "xn--4db6c0a"); }
test { try parseIDNAPass("xn--4db6c0a", "xn--4db6c0a"); }
test { try parseIDNAPass("\x5d07\x5ea", "xn--7-zhc3f"); }
test { try parseIDNAPass("xn--7-zhc3f", "xn--7-zhc3f"); }
test { try parseIDNAPass("\x5d0\x667\x5ea", "xn--4db6c6t"); }
test { try parseIDNAPass("xn--4db6c6t", "xn--4db6c6t"); }
test { try parseIDNAPass("\xbb9\xbcd\x200d", "xn--dmc4b194h"); }
test { try parseIDNAPass("xn--dmc4b", "xn--dmc4b"); }
test { try parseIDNAPass("\xbb9\xbcd", "xn--dmc4b"); }
test { try parseIDNAPass("xn--dmc4b194h", "xn--dmc4b194h"); }
test { try parseIDNAPass("xn--dmc", "xn--dmc"); }
test { try parseIDNAPass("\xbb9", "xn--dmc"); }
test { try parseIDNAPass("\xbb9\xbcd\x200c", "xn--dmc4by94h"); }
test { try parseIDNAPass("xn--dmc4by94h", "xn--dmc4by94h"); }
test { try parseIDNAPass("\x644\x670\x200c\x6ed\x6ef", "xn--ghb2gxqia7523a"); }
test { try parseIDNAPass("xn--ghb2gxqia", "xn--ghb2gxqia"); }
test { try parseIDNAPass("\x644\x670\x6ed\x6ef", "xn--ghb2gxqia"); }
test { try parseIDNAPass("xn--ghb2gxqia7523a", "xn--ghb2gxqia7523a"); }
test { try parseIDNAPass("\x644\x670\x200c\x6ef", "xn--ghb2g3qq34f"); }
test { try parseIDNAPass("xn--ghb2g3q", "xn--ghb2g3q"); }
test { try parseIDNAPass("\x644\x670\x6ef", "xn--ghb2g3q"); }
test { try parseIDNAPass("xn--ghb2g3qq34f", "xn--ghb2g3qq34f"); }
test { try parseIDNAPass("\x644\x200c\x6ed\x6ef", "xn--ghb25aga828w"); }
test { try parseIDNAPass("xn--ghb25aga", "xn--ghb25aga"); }
test { try parseIDNAPass("\x644\x6ed\x6ef", "xn--ghb25aga"); }
test { try parseIDNAPass("xn--ghb25aga828w", "xn--ghb25aga828w"); }
test { try parseIDNAPass("\x644\x200c\x6ef", "xn--ghb65a953d"); }
test { try parseIDNAPass("xn--ghb65a", "xn--ghb65a"); }
test { try parseIDNAPass("\x644\x6ef", "xn--ghb65a"); }
test { try parseIDNAPass("xn--ghb65a953d", "xn--ghb65a953d"); }
test { try parseIDNAPass("xn--ghb2gxq", "xn--ghb2gxq"); }
test { try parseIDNAPass("\x644\x670\x6ed", "xn--ghb2gxq"); }
test { try parseIDNAPass("xn--cmba", "xn--cmba"); }
test { try parseIDNAPass("\x6ef\x6ef", "xn--cmba"); }
test { try parseIDNAPass("xn--ghb", "xn--ghb"); }
test { try parseIDNAPass("\x644", "xn--ghb"); }
test { try parseIDNAPass("a\x3002\x3002b", "a..b"); }
test { try parseIDNAPass("A\x3002\x3002B", "a..b"); }
test { try parseIDNAPass("a..b", "a..b"); }
test { try parseIDNAPass("..xn--skb", "..xn--skb"); }
test { try parseIDNAPass("$", "$"); }
test { try parseIDNAPass("\x2477.four", "(4).four"); }
test { try parseIDNAPass("(4).four", "(4).four"); }
test { try parseIDNAPass("\x2477.FOUR", "(4).four"); }
test { try parseIDNAPass("\x2477.Four", "(4).four"); }
test { try parseIDNAPass("ascii", "ascii"); }
test { try parseIDNAPass("unicode.org", "unicode.org"); }
test { try parseIDNAPass("\xf951\xd87e\xdc68\xd87e\xdc74\xd87e\xdd1f\xd87e\xdd5f\xd87e\xddbf", "xn--snl253bgitxhzwu2arn60c"); }
test { try parseIDNAPass("\x964b\x36fc\x5f53\xd850\xdfab\x7aee\x45d7", "xn--snl253bgitxhzwu2arn60c"); }
test { try parseIDNAPass("xn--snl253bgitxhzwu2arn60c", "xn--snl253bgitxhzwu2arn60c"); }
test { try parseIDNAPass("\x96fb\xd844\xdf6a\x5f33\x43ab\x7aae\x4d57", "xn--kbo60w31ob3z6t3av9z5b"); }
test { try parseIDNAPass("xn--kbo60w31ob3z6t3av9z5b", "xn--kbo60w31ob3z6t3av9z5b"); }
test { try parseIDNAPass("xn--A-1ga", "xn--a-1ga"); }
test { try parseIDNAPass("a\xf6", "xn--a-1ga"); }
test { try parseIDNAPass("ao\x308", "xn--a-1ga"); }
test { try parseIDNAPass("AO\x308", "xn--a-1ga"); }
test { try parseIDNAPass("A\xd6", "xn--a-1ga"); }
test { try parseIDNAPass("A\xf6", "xn--a-1ga"); }
test { try parseIDNAPass("Ao\x308", "xn--a-1ga"); }
test { try parseIDNAPass("\xff1d\x338", "xn--1ch"); }
test { try parseIDNAPass("\x2260", "xn--1ch"); }
test { try parseIDNAPass("=\x338", "xn--1ch"); }
test { try parseIDNAPass("xn--1ch", "xn--1ch"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b.", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x308123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc4123456789012345678901234567890123456789012345.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c", "123456789012345678901234567890123456789012345678901234567890123.xn--1234567890123456789012345678901234567890123456789012345-kue.123456789012345678901234567890123456789012345678901234567890123.1234567890123456789012345678901234567890123456789012345678901c"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a.", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.12345678901234567890123456789012345678901234567890123456789a."); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890A\x3081234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("123456789012345678901234567890123456789012345678901234567890123.1234567890\xc41234567890123456789012345678901234567890123456.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b", "123456789012345678901234567890123456789012345678901234567890123.xn--12345678901234567890123456789012345678901234567890123456-fxe.123456789012345678901234567890123456789012345678901234567890123.123456789012345678901234567890123456789012345678901234567890b"); }
test { try parseIDNAPass("\xa863.\x7cf", "xn--8c9a.xn--qsb"); }
test { try parseIDNAPass("xn--8c9a.xn--qsb", "xn--8c9a.xn--qsb"); }
test { try parseIDNAPass("xn--jbf911clb.xn----p9j493ivi4l", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("\x2260\x1899\x226f.\xc1a3-\x1874\x2d00", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("=\x338\x1899>\x338.\x1109\x1169\x11be-\x1874\x2d00", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("=\x338\x1899>\x338.\x1109\x1169\x11be-\x1874\x10a0", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("\x2260\x1899\x226f.\xc1a3-\x1874\x10a0", "xn--jbf911clb.xn----p9j493ivi4l"); }
test { try parseIDNAPass("xn--gl0as212a.i.", "xn--gl0as212a.i."); }
test { try parseIDNAPass("\x7e71\xd805\xddbf.i.", "xn--gl0as212a.i."); }
test { try parseIDNAPass("\x7e71\xd805\xddbf.I.", "xn--gl0as212a.i."); }
test { try parseIDNAPass("xn--1ug6928ac48e.i.", "xn--1ug6928ac48e.i."); }
test { try parseIDNAPass("\x7e71\xd805\xddbf\x200d.i.", "xn--1ug6928ac48e.i."); }
test { try parseIDNAPass("\x7e71\xd805\xddbf\x200d.I.", "xn--1ug6928ac48e.i."); }
test { try parseIDNAPass("xn--ss-59d.", "xn--ss-59d."); }
test { try parseIDNAPass("ss\x6eb.", "xn--ss-59d."); }
test { try parseIDNAPass("SS\x6eb.", "xn--ss-59d."); }
test { try parseIDNAPass("Ss\x6eb.", "xn--ss-59d."); }
test { try parseIDNAPass("\xd83a\xdd37.\xd802\xdf90\xd83a\xdc81\xd803\xde60\x624", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xd83a\xdd37.\xd802\xdf90\xd83a\xdc81\xd803\xde60\x648\x654", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xd83a\xdd15.\xd802\xdf90\xd83a\xdc81\xd803\xde60\x648\x654", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xd83a\xdd15.\xd802\xdf90\xd83a\xdc81\xd803\xde60\x624", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("xn--ve6h.xn--jgb1694kz0b2176a", "xn--ve6h.xn--jgb1694kz0b2176a"); }
test { try parseIDNAPass("\xd83a\xdd25\xdb40\xdd6e\xff0e\x1844\x10ae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd25\xdb40\xdd6e.\x1844\x10ae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd25\xdb40\xdd6e.\x1844\x2d0e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd03\xdb40\xdd6e.\x1844\x10ae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd03\xdb40\xdd6e.\x1844\x2d0e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("xn--de6h.xn--37e857h", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd25.\x1844\x2d0e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd03.\x1844\x10ae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd03.\x1844\x2d0e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd25\xdb40\xdd6e\xff0e\x1844\x2d0e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd03\xdb40\xdd6e\xff0e\x1844\x10ae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd03\xdb40\xdd6e\xff0e\x1844\x2d0e", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("\xd83a\xdd25.\x1844\x10ae", "xn--de6h.xn--37e857h"); }
test { try parseIDNAPass("xn--ej0b.xn----d87b", "xn--ej0b.xn----d87b"); }
test { try parseIDNAPass("xn----1fa1788k.", "xn----1fa1788k."); }
test { try parseIDNAPass("xn--9ob.xn--4xa", "xn--9ob.xn--4xa"); }
test { try parseIDNAPass("\x756.\x3c3", "xn--9ob.xn--4xa"); }
test { try parseIDNAPass("\x756.\x3a3", "xn--9ob.xn--4xa"); }
test { try parseIDNAPass("\xdf\xff61\xd800\xdef3\x10ac\xfb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xdf\x3002\xd800\xdef3\x10ac\xfb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xdf\x3002\xd800\xdef3\x2d0c\xfb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("SS\x3002\xd800\xdef3\x10ac\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss\x3002\xd800\xdef3\x2d0c\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("Ss\x3002\xd800\xdef3\x10ac\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss.xn--lgd921mvv0m", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss.\xd800\xdef3\x2d0c\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("SS.\xd800\xdef3\x10ac\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("Ss.\xd800\xdef3\x10ac\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("xn--zca.xn--lgd921mvv0m", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xdf.\xd800\xdef3\x2d0c\xfb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\xdf\xff61\xd800\xdef3\x2d0c\xfb8", "xn--zca.xn--lgd921mvv0m"); }
test { try parseIDNAPass("SS\xff61\xd800\xdef3\x10ac\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("ss\xff61\xd800\xdef3\x2d0c\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("Ss\xff61\xd800\xdef3\x10ac\xfb8", "ss.xn--lgd921mvv0m"); }
test { try parseIDNAPass("\x16ad\xff61\xd834\xdf20\xdf\xd81a\xdef1", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\x16ad\x3002\xd834\xdf20\xdf\xd81a\xdef1", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\x16ad\x3002\xd834\xdf20SS\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\x16ad\x3002\xd834\xdf20ss\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\x16ad\x3002\xd834\xdf20Ss\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("xn--hwe.xn--ss-ci1ub261a", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\x16ad.\xd834\xdf20ss\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\x16ad.\xd834\xdf20SS\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\x16ad.\xd834\xdf20Ss\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("xn--hwe.xn--zca4946pblnc", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\x16ad.\xd834\xdf20\xdf\xd81a\xdef1", "xn--hwe.xn--zca4946pblnc"); }
test { try parseIDNAPass("\x16ad\xff61\xd834\xdf20SS\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\x16ad\xff61\xd834\xdf20ss\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("\x16ad\xff61\xd834\xdf20Ss\xd81a\xdef1", "xn--hwe.xn--ss-ci1ub261a"); }
test { try parseIDNAPass("xn--09e4694e..xn--ye6h", "xn--09e4694e..xn--ye6h"); }
test { try parseIDNAPass("xn--1-o7j0610f..xn----381i", "xn--1-o7j0610f..xn----381i"); }
test { try parseIDNAPass("1.xn----zw5a.xn--kp5b", "1.xn----zw5a.xn--kp5b"); }
test { try parseIDNAPass("-\xd800\xdef7\xd81b\xdf91\x3002\xdb40\xddac", "xn----991iq40y."); }
test { try parseIDNAPass("xn----991iq40y.", "xn----991iq40y."); }
test { try parseIDNAPass(".xn--hdh", ".xn--hdh"); }
test { try parseIDNAPass("\xd83a\xdd53\xff0e\x718", "xn--of6h.xn--inb"); }
test { try parseIDNAPass("\xd83a\xdd53.\x718", "xn--of6h.xn--inb"); }
test { try parseIDNAPass("xn--of6h.xn--inb", "xn--of6h.xn--inb"); }
test { try parseIDNAPass("\xdb40\xdd3d-\xff0e-\xdca", "-.xn----ptf"); }
test { try parseIDNAPass("\xdb40\xdd3d-.-\xdca", "-.xn----ptf"); }
test { try parseIDNAPass("-.xn----ptf", "-.xn----ptf"); }
test { try parseIDNAPass("\x10ba\xd800\xdef8\xdb40\xdd04\x3002\xd835\xdfdd\xd7f6\x103a", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\x10ba\xd800\xdef8\xdb40\xdd04\x30025\xd7f6\x103a", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\x2d1a\xd800\xdef8\xdb40\xdd04\x30025\xd7f6\x103a", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("xn--ilj2659d.xn--5-dug9054m", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\x2d1a\xd800\xdef8.5\xd7f6\x103a", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\x10ba\xd800\xdef8.5\xd7f6\x103a", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\x2d1a\xd800\xdef8\xdb40\xdd04\x3002\xd835\xdfdd\xd7f6\x103a", "xn--ilj2659d.xn--5-dug9054m"); }
test { try parseIDNAPass("\x2260.\x183f", "xn--1ch.xn--y7e"); }
test { try parseIDNAPass("=\x338.\x183f", "xn--1ch.xn--y7e"); }
test { try parseIDNAPass("xn--1ch.xn--y7e", "xn--1ch.xn--y7e"); }
test { try parseIDNAPass("\x723\x5a3\xff61\x332a", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("\x723\x5a3\x3002\x30cf\x30a4\x30c4", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("xn--ucb18e.xn--eck4c5a", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("\x723\x5a3.\x30cf\x30a4\x30c4", "xn--ucb18e.xn--eck4c5a"); }
test { try parseIDNAPass("xn--skb", "xn--skb"); }
test { try parseIDNAPass("\x6b9", "xn--skb"); }
test { try parseIDNAPass("\x226f1.\x3002\xdf", "xn--1-ogo..xn--zca"); }
test { try parseIDNAPass(">\x3381.\x3002\xdf", "xn--1-ogo..xn--zca"); }
test { try parseIDNAPass(">\x3381.\x3002SS", "xn--1-ogo..ss"); }
test { try parseIDNAPass("\x226f1.\x3002SS", "xn--1-ogo..ss"); }
test { try parseIDNAPass("\x226f1.\x3002ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass(">\x3381.\x3002ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass(">\x3381.\x3002Ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass("\x226f1.\x3002Ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass("xn--1-ogo..ss", "xn--1-ogo..ss"); }
test { try parseIDNAPass("xn--1-ogo..xn--zca", "xn--1-ogo..xn--zca"); }
test { try parseIDNAPass(".xn--1ch", ".xn--1ch"); }
test { try parseIDNAPass("\xa846\x3002\x2183\xfb5\xb1ae-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xa846\x3002\x2183\xfb5\x1102\x116a\x11c1-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xa846\x3002\x2184\xfb5\x1102\x116a\x11c1-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xa846\x3002\x2184\xfb5\xb1ae-", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("xn--fc9a.xn----qmg097k469k", "xn--fc9a.xn----qmg097k469k"); }
test { try parseIDNAPass("\xdf\x9c1\x1ded\x3002\x6208\x2085", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("\xdf\x9c1\x1ded\x3002\x62085", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("SS\x9c1\x1ded\x3002\x62085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("ss\x9c1\x1ded\x3002\x62085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("Ss\x9c1\x1ded\x3002\x62085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("xn--ss-e2f077r.xn--85-psd", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("ss\x9c1\x1ded.\x62085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("SS\x9c1\x1ded.\x62085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("Ss\x9c1\x1ded.\x62085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("xn--zca266bwrr.xn--85-psd", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("\xdf\x9c1\x1ded.\x62085", "xn--zca266bwrr.xn--85-psd"); }
test { try parseIDNAPass("SS\x9c1\x1ded\x3002\x6208\x2085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("ss\x9c1\x1ded\x3002\x6208\x2085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("Ss\x9c1\x1ded\x3002\x6208\x2085", "xn--ss-e2f077r.xn--85-psd"); }
test { try parseIDNAPass("\xfe0d\xa9b\x3002\x5d68", "xn--6dc.xn--tot"); }
test { try parseIDNAPass("xn--6dc.xn--tot", "xn--6dc.xn--tot"); }
test { try parseIDNAPass("\xa9b.\x5d68", "xn--6dc.xn--tot"); }
test { try parseIDNAPass("\xfe05\x3002\x3002\xd858\xdc3e\x1ce0", "..xn--t6f5138v"); }
test { try parseIDNAPass("..xn--t6f5138v", "..xn--t6f5138v"); }
test { try parseIDNAPass("xn--t6f5138v", "xn--t6f5138v"); }
test { try parseIDNAPass("\xd858\xdc3e\x1ce0", "xn--t6f5138v"); }
test { try parseIDNAPass("xn--p8e.xn--1ch3a7084l", "xn--p8e.xn--1ch3a7084l"); }
test { try parseIDNAPass("\x1859.\x226f\xd800\xdef2\x2260", "xn--p8e.xn--1ch3a7084l"); }
test { try parseIDNAPass("\x1859.>\x338\xd800\xdef2=\x338", "xn--p8e.xn--1ch3a7084l"); }
test { try parseIDNAPass("-3.xn--fbf115j", "-3.xn--fbf115j"); }
test { try parseIDNAPass("xn--u4e969b.xn--1ch", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\x214e\x17d2.\x2260", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\x214e\x17d2.=\x338", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\x2132\x17d2.=\x338", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("\x2132\x17d2.\x2260", "xn--u4e969b.xn--1ch"); }
test { try parseIDNAPass("xn----zmb.1-", "xn----zmb.1-"); }
test { try parseIDNAPass("xn--8,-g9oy26fzu4d.xn--kmb6733w", "xn--8,-g9oy26fzu4d.xn--kmb6733w"); }
test { try parseIDNAPass("xn--9-mfs8024b.", "xn--9-mfs8024b."); }
test { try parseIDNAPass("9\x9681\x2bee.", "xn--9-mfs8024b."); }
test { try parseIDNAPass("xn--2ib43l.xn--te6h", "xn--2ib43l.xn--te6h"); }
test { try parseIDNAPass("\x67d\x943.\xd83a\xdd35", "xn--2ib43l.xn--te6h"); }
test { try parseIDNAPass("\x67d\x943.\xd83a\xdd13", "xn--2ib43l.xn--te6h"); }
test { try parseIDNAPass("\xa9d0\x4c0\x1baa\x8f6\xff0e\xb235", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xa9d0\x4c0\x1baa\x8f6\xff0e\x1102\x116f\x11bc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xa9d0\x4c0\x1baa\x8f6.\xb235", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xa9d0\x4c0\x1baa\x8f6.\x1102\x116f\x11bc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xa9d0\x4cf\x1baa\x8f6.\x1102\x116f\x11bc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xa9d0\x4cf\x1baa\x8f6.\xb235", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("xn--s5a04sn4u297k.xn--2e1b", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xa9d0\x4cf\x1baa\x8f6\xff0e\x1102\x116f\x11bc", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("\xa9d0\x4cf\x1baa\x8f6\xff0e\xb235", "xn--s5a04sn4u297k.xn--2e1b"); }
test { try parseIDNAPass("xn--9hb7344k.", "xn--9hb7344k."); }
test { try parseIDNAPass("\xd802\xdec7\x661.", "xn--9hb7344k."); }
test { try parseIDNAPass("\x184c.\x3002\x1891", "xn--c8e..xn--bbf"); }
test { try parseIDNAPass("xn--c8e..xn--bbf", "xn--c8e..xn--bbf"); }
test { try parseIDNAPass("\x3002\x3002\x10a3\x226f", "..xn--hdh782b"); }
test { try parseIDNAPass("\x3002\x3002\x10a3>\x338", "..xn--hdh782b"); }
test { try parseIDNAPass("\x3002\x3002\x2d03>\x338", "..xn--hdh782b"); }
test { try parseIDNAPass("\x3002\x3002\x2d03\x226f", "..xn--hdh782b"); }
test { try parseIDNAPass("..xn--hdh782b", "..xn--hdh782b"); }
test { try parseIDNAPass("\x7e5.\x6b5", "xn--dtb.xn--okb"); }
test { try parseIDNAPass("xn--dtb.xn--okb", "xn--dtb.xn--okb"); }
test { try parseIDNAPass(".xn--3e6h", ".xn--3e6h"); }
test { try parseIDNAPass("xn--3e6h", "xn--3e6h"); }
test { try parseIDNAPass("\xd83a\xdd3f", "xn--3e6h"); }
test { try parseIDNAPass("\xd83a\xdd1d", "xn--3e6h"); }
test { try parseIDNAPass("\x6b9\xff0e\x1873\x115f", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("\x6b9.\x1873\x115f", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("xn--skb.xn--g9e", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("\x6b9.\x1873", "xn--skb.xn--g9e"); }
test { try parseIDNAPass("\x3a1b\xd823\xdc4e.\x30027\xd01", "xn--mbm8237g..xn--7-7hf"); }
test { try parseIDNAPass("xn--mbm8237g..xn--7-7hf", "xn--mbm8237g..xn--7-7hf"); }
test { try parseIDNAPass("xn--ss-4epx629f.xn--ifh802b6a", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("ss\xaaf6\x18a5.\x22b6\x2d21\x2d16", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("SS\xaaf6\x18a5.\x22b6\x10c1\x10b6", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("Ss\xaaf6\x18a5.\x22b6\x10c1\x2d16", "xn--ss-4epx629f.xn--ifh802b6a"); }
test { try parseIDNAPass("-.", "-."); }
test { try parseIDNAPass("xn----zmb.xn--rlj2573p", "xn----zmb.xn--rlj2573p"); }
test { try parseIDNAPass("\x2260\x3002\xd83d\xdfb3\xd835\xdff2", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("=\x338\x3002\xd83d\xdfb3\xd835\xdff2", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("\x2260\x3002\xd83d\xdfb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("=\x338\x3002\xd83d\xdfb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("xn--1ch.xn--6-dl4s", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("\x2260.\xd83d\xdfb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass("=\x338.\xd83d\xdfb36", "xn--1ch.xn--6-dl4s"); }
test { try parseIDNAPass(".j", ".j"); }
test { try parseIDNAPass("j", "j"); }
test { try parseIDNAPass("xn--rt6a.", "xn--rt6a."); }
test { try parseIDNAPass("\x9c4a.", "xn--rt6a."); }
test { try parseIDNAPass("xn--4-0bd15808a.", "xn--4-0bd15808a."); }
test { try parseIDNAPass("\xd83a\xdd3a\x7cc4.", "xn--4-0bd15808a."); }
test { try parseIDNAPass("\xd83a\xdd18\x7cc4.", "xn--4-0bd15808a."); }
test { try parseIDNAPass("-\xff61\x43db", "-.xn--xco"); }
test { try parseIDNAPass("-\x3002\x43db", "-.xn--xco"); }
test { try parseIDNAPass("-.xn--xco", "-.xn--xco"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15\x226f\xdf", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15>\x338\xdf", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\x820c.\xa8485\x226f\xdf", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\x820c.\xa8485>\x338\xdf", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\x820c.\xa8485>\x338SS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x820c.\xa8485\x226fSS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x820c.\xa8485\x226fss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x820c.\xa8485>\x338ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x820c.\xa8485>\x338Ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x820c.\xa8485\x226fSs", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("xn--tc1a.xn--5ss-3m2a5009e", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("xn--tc1a.xn--5-qfa988w745i", "xn--tc1a.xn--5-qfa988w745i"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15>\x338SS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15\x226fSS", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15\x226fss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15>\x338ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15>\x338Ss", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\x2f86\xff0e\xa848\xff15\x226fSs", "xn--tc1a.xn--5ss-3m2a5009e"); }
test { try parseIDNAPass("\xd83a\xdd2a.\x3c2", "xn--ie6h.xn--3xa"); }
test { try parseIDNAPass("\xd83a\xdd08.\x3a3", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("\xd83a\xdd2a.\x3c3", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("\xd83a\xdd08.\x3c3", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("xn--ie6h.xn--4xa", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("\xd83a\xdd08.\x3c2", "xn--ie6h.xn--3xa"); }
test { try parseIDNAPass("xn--ie6h.xn--3xa", "xn--ie6h.xn--3xa"); }
test { try parseIDNAPass("\xd83a\xdd2a.\x3a3", "xn--ie6h.xn--4xa"); }
test { try parseIDNAPass("xn--ilj.xn--4xa", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\x2d1a.\x3c3", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\x10ba.\x3a3", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\x2d1a.\x3c2", "xn--ilj.xn--3xa"); }
test { try parseIDNAPass("\x10ba.\x3c2", "xn--ilj.xn--3xa"); }
test { try parseIDNAPass("xn--ilj.xn--3xa", "xn--ilj.xn--3xa"); }
test { try parseIDNAPass("\x10ba.\x3c3", "xn--ilj.xn--4xa"); }
test { try parseIDNAPass("\x6dfd\x3002\x183e", "xn--34w.xn--x7e"); }
test { try parseIDNAPass("xn--34w.xn--x7e", "xn--34w.xn--x7e"); }
test { try parseIDNAPass("\x6dfd.\x183e", "xn--34w.xn--x7e"); }
test { try parseIDNAPass("..", ".."); }
test { try parseIDNAPass("xn---3-p9o.ss--", "xn---3-p9o.ss--"); }
test { try parseIDNAPass("51..xn--8-ogo", "51..xn--8-ogo"); }
test { try parseIDNAPass("\xa860\xff0e\x6f2", "xn--5c9a.xn--fmb"); }
test { try parseIDNAPass("\xa860.\x6f2", "xn--5c9a.xn--fmb"); }
test { try parseIDNAPass("xn--5c9a.xn--fmb", "xn--5c9a.xn--fmb"); }
test { try parseIDNAPass("1.2h", "1.2h"); }
test { try parseIDNAPass("xn--skjy82u.xn--gdh", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\x2d01\x755d.\x226e", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\x2d01\x755d.<\x338", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\x10a1\x755d.<\x338", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\x10a1\x755d.\x226e", "xn--skjy82u.xn--gdh"); }
test { try parseIDNAPass("\xd83d\xdd7c\xff0e\xffa0", "xn--my8h."); }
test { try parseIDNAPass("\xd83d\xdd7c.\x1160", "xn--my8h."); }
test { try parseIDNAPass("xn--my8h.", "xn--my8h."); }
test { try parseIDNAPass("\xd83d\xdd7c.", "xn--my8h."); }
test { try parseIDNAPass("\x3c2\x10c5\x3002\x75a", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("\x3c2\x2d25\x3002\x75a", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("\x3a3\x10c5\x3002\x75a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\x3c3\x2d25\x3002\x75a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\x3a3\x2d25\x3002\x75a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("xn--4xa203s.xn--epb", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\x3c3\x2d25.\x75a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\x3a3\x10c5.\x75a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("\x3a3\x2d25.\x75a", "xn--4xa203s.xn--epb"); }
test { try parseIDNAPass("xn--3xa403s.xn--epb", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("\x3c2\x2d25.\x75a", "xn--3xa403s.xn--epb"); }
test { try parseIDNAPass("xn--vkb.xn--08e172a", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\x6bc.\x1e8f\x1864", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\x6bc.y\x307\x1864", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\x6bc.Y\x307\x1864", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("\x6bc.\x1e8e\x1864", "xn--vkb.xn--08e172a"); }
test { try parseIDNAPass("xn--pt9c.xn--0kjya", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xd802\xde57.\x2d09\x2d15", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xd802\xde57.\x10a9\x10b5", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xd802\xde57.\x10a9\x2d15", "xn--pt9c.xn--0kjya"); }
test { try parseIDNAPass("\xd88a\xdd3120.\x97f3.\xa8661.", "xn--20-9802c.xn--0w5a.xn--1-eg4e."); }
test { try parseIDNAPass("xn--20-9802c.xn--0w5a.xn--1-eg4e.", "xn--20-9802c.xn--0w5a.xn--1-eg4e."); }
test { try parseIDNAPass("\x10b5\x3002\x6f0\x226e\xdf\x745", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\x10b5\x3002\x6f0<\x338\xdf\x745", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\x2d15\x3002\x6f0<\x338\xdf\x745", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\x2d15\x3002\x6f0\x226e\xdf\x745", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\x10b5\x3002\x6f0\x226eSS\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x10b5\x3002\x6f0<\x338SS\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x2d15\x3002\x6f0<\x338ss\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x2d15\x3002\x6f0\x226ess\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x10b5\x3002\x6f0\x226eSs\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x10b5\x3002\x6f0<\x338Ss\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("xn--dlj.xn--ss-jbe65aw27i", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x2d15.\x6f0\x226ess\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x2d15.\x6f0<\x338ss\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x10b5.\x6f0<\x338SS\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x10b5.\x6f0\x226eSS\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x10b5.\x6f0\x226eSs\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("\x10b5.\x6f0<\x338Ss\x745", "xn--dlj.xn--ss-jbe65aw27i"); }
test { try parseIDNAPass("xn--dlj.xn--zca912alh227g", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\x2d15.\x6f0\x226e\xdf\x745", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("\x2d15.\x6f0<\x338\xdf\x745", "xn--dlj.xn--zca912alh227g"); }
test { try parseIDNAPass("xn--ge6h.xn--oc9a", "xn--ge6h.xn--oc9a"); }
test { try parseIDNAPass("\xd83a\xdd28.\xa84f", "xn--ge6h.xn--oc9a"); }
test { try parseIDNAPass("\xd83a\xdd06.\xa84f", "xn--ge6h.xn--oc9a"); }
test { try parseIDNAPass(".xn--ss--bi1b", ".xn--ss--bi1b"); }
test { try parseIDNAPass("\x9f59--\xd835\xdff0.\xdf", "xn----4-p16k.xn--zca"); }
test { try parseIDNAPass("\x9f59--4.\xdf", "xn----4-p16k.xn--zca"); }
test { try parseIDNAPass("\x9f59--4.SS", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\x9f59--4.ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\x9f59--4.Ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("xn----4-p16k.ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("xn----4-p16k.xn--zca", "xn----4-p16k.xn--zca"); }
test { try parseIDNAPass("\x9f59--\xd835\xdff0.SS", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\x9f59--\xd835\xdff0.ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("\x9f59--\xd835\xdff0.Ss", "xn----4-p16k.ss"); }
test { try parseIDNAPass("xn--9-i0j5967eg3qz.ss", "xn--9-i0j5967eg3qz.ss"); }
test { try parseIDNAPass("\xd88a\xdf9a9\xa369\x17d3.ss", "xn--9-i0j5967eg3qz.ss"); }
test { try parseIDNAPass("\xd88a\xdf9a9\xa369\x17d3.SS", "xn--9-i0j5967eg3qz.ss"); }
test { try parseIDNAPass("\xa5f7\xd804\xdd80.\x75d\xd802\xde52", "xn--ju8a625r.xn--hpb0073k"); }
test { try parseIDNAPass("xn--ju8a625r.xn--hpb0073k", "xn--ju8a625r.xn--hpb0073k"); }
test { try parseIDNAPass("xn----3vs.xn--0kj", "xn----3vs.xn--0kj"); }
test { try parseIDNAPass("\x3c2.\x641\x645\x64a\xd83d\xdf9b1.", "xn--3xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("\x3a3.\x641\x645\x64a\xd83d\xdf9b1.", "xn--4xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("\x3c3.\x641\x645\x64a\xd83d\xdf9b1.", "xn--4xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("xn--4xa.xn--1-gocmu97674d.", "xn--4xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass("xn--3xa.xn--1-gocmu97674d.", "xn--3xa.xn--1-gocmu97674d."); }
test { try parseIDNAPass(".xn--hva754s.", ".xn--hva754s."); }
test { try parseIDNAPass("xn--hva754s.", "xn--hva754s."); }
test { try parseIDNAPass("\x2d16\x366.", "xn--hva754s."); }
test { try parseIDNAPass("\x10b6\x366.", "xn--hva754s."); }
test { try parseIDNAPass("xn--hzb.xn--ukj4430l", "xn--hzb.xn--ukj4430l"); }
test { try parseIDNAPass("\x8bb.\x2d03\xd838\xdc12", "xn--hzb.xn--ukj4430l"); }
test { try parseIDNAPass("\x8bb.\x10a3\xd838\xdc12", "xn--hzb.xn--ukj4430l"); }
test { try parseIDNAPass("\xdb40\xdd93\x26cf-\x3002\xa852", "xn----o9p.xn--rc9a"); }
test { try parseIDNAPass("xn----o9p.xn--rc9a", "xn----o9p.xn--rc9a"); }
test { try parseIDNAPass("xn--p9ut19m.xn----mck373i", "xn--p9ut19m.xn----mck373i"); }
test { try parseIDNAPass("\x650c\xabed.\x1896-\x2d18", "xn--p9ut19m.xn----mck373i"); }
test { try parseIDNAPass("\x650c\xabed.\x1896-\x10b8", "xn--p9ut19m.xn----mck373i"); }
test { try parseIDNAPass("xn--9r8a.16.xn--3-nyc0117m", "xn--9r8a.16.xn--3-nyc0117m"); }
test { try parseIDNAPass("\xa5a8.16.3\xd212\x6f3", "xn--9r8a.16.xn--3-nyc0117m"); }
test { try parseIDNAPass("\xa5a8.16.3\x1110\x116d\x11a9\x6f3", "xn--9r8a.16.xn--3-nyc0117m"); }
test { try parseIDNAPass("xn--1-5bt6845n.", "xn--1-5bt6845n."); }
test { try parseIDNAPass("1\xd836\xde19\x2e16.", "xn--1-5bt6845n."); }
test { try parseIDNAPass(".1.xn--9-ogo", ".1.xn--9-ogo"); }
test { try parseIDNAPass("xn--ss-f4j.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("ss\x103a.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("SS\x103a.B.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("Ss\x103a.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("SS\x103a.b.", "xn--ss-f4j.b."); }
test { try parseIDNAPass("\x6cc\xd802\xde3f\xff0e\xdf\xf84\xd804\xdf6c", "xn--clb2593k.xn--zca216edt0r"); }
test { try parseIDNAPass("\x6cc\xd802\xde3f.\xdf\xf84\xd804\xdf6c", "xn--clb2593k.xn--zca216edt0r"); }
test { try parseIDNAPass("\x6cc\xd802\xde3f.SS\xf84\xd804\xdf6c", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\x6cc\xd802\xde3f.ss\xf84\xd804\xdf6c", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("xn--clb2593k.xn--ss-toj6092t", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("xn--clb2593k.xn--zca216edt0r", "xn--clb2593k.xn--zca216edt0r"); }
test { try parseIDNAPass("\x6cc\xd802\xde3f\xff0eSS\xf84\xd804\xdf6c", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\x6cc\xd802\xde3f\xff0ess\xf84\xd804\xdf6c", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\x6cc\xd802\xde3f.Ss\xf84\xd804\xdf6c", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("\x6cc\xd802\xde3f\xff0eSs\xf84\xd804\xdf6c", "xn--clb2593k.xn--ss-toj6092t"); }
test { try parseIDNAPass("xn--8-ngo.", "xn--8-ngo."); }
test { try parseIDNAPass("8\x226e.", "xn--8-ngo."); }
test { try parseIDNAPass("8<\x338.", "xn--8-ngo."); }
test { try parseIDNAPass("\x7f9a\xff61\x226f", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\x7f9a\xff61>\x338", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\x7f9a\x3002\x226f", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\x7f9a\x3002>\x338", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("xn--xt0a.xn--hdh", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\x7f9a.\x226f", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass("\x7f9a.>\x338", "xn--xt0a.xn--hdh"); }
test { try parseIDNAPass(".xn--ye6h", ".xn--ye6h"); }
test { try parseIDNAPass("xn--ye6h", "xn--ye6h"); }
test { try parseIDNAPass("\xd83a\xdd3a", "xn--ye6h"); }
test { try parseIDNAPass("\xd83a\xdd18", "xn--ye6h"); }
test { try parseIDNAPass("\xd835\xdfdb\xff0e\xf9f8", "3.xn--6vz"); }
test { try parseIDNAPass("\xd835\xdfdb\xff0e\x7b20", "3.xn--6vz"); }
test { try parseIDNAPass("3.\x7b20", "3.xn--6vz"); }
test { try parseIDNAPass("3.xn--6vz", "3.xn--6vz"); }
test { try parseIDNAPass("-.xn--mlj8559d", "-.xn--mlj8559d"); }
test { try parseIDNAPass("xn--1ch.", "xn--1ch."); }
test { try parseIDNAPass("\x2260.", "xn--1ch."); }
test { try parseIDNAPass("=\x338.", "xn--1ch."); }
test { try parseIDNAPass("-\x3002\x3002", "-.."); }
test { try parseIDNAPass("-..", "-.."); }
test { try parseIDNAPass(".f", ".f"); }
test { try parseIDNAPass("f", "f"); }
test { try parseIDNAPass("xn--9bm.ss", "xn--9bm.ss"); }
test { try parseIDNAPass("\x3a32.ss", "xn--9bm.ss"); }
test { try parseIDNAPass("\x3a32.SS", "xn--9bm.ss"); }
test { try parseIDNAPass("\x3a32.Ss", "xn--9bm.ss"); }
test { try parseIDNAPass("\xd835\xdfce\x3002\x752f", "0.xn--qny"); }
test { try parseIDNAPass("0\x3002\x752f", "0.xn--qny"); }
test { try parseIDNAPass("0.xn--qny", "0.xn--qny"); }
test { try parseIDNAPass("0.\x752f", "0.xn--qny"); }
test { try parseIDNAPass("-\xff61\x1898", "-.xn--ibf"); }
test { try parseIDNAPass("-\x3002\x1898", "-.xn--ibf"); }
test { try parseIDNAPass("-.xn--ibf", "-.xn--ibf"); }
test { try parseIDNAPass("\xd83c\xdcb4\x10ab.\x226e", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("\xd83c\xdcb4\x10ab.<\x338", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("\xd83c\xdcb4\x2d0b.<\x338", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("\xd83c\xdcb4\x2d0b.\x226e", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("xn--2kj7565l.xn--gdh", "xn--2kj7565l.xn--gdh"); }
test { try parseIDNAPass("xn--gky8837e.", "xn--gky8837e."); }
test { try parseIDNAPass("\x74bc\xd836\xde2d.", "xn--gky8837e."); }
test { try parseIDNAPass("xn--157b.xn--gnb", "xn--157b.xn--gnb"); }
test { try parseIDNAPass("\xd29b.\x716", "xn--157b.xn--gnb"); }
test { try parseIDNAPass("\x1110\x1171\x11c2.\x716", "xn--157b.xn--gnb"); }
test { try parseIDNAPass("xn--84-s850a.xn--59h6326e", "xn--84-s850a.xn--59h6326e"); }
test { try parseIDNAPass("84\xd834\xde3b.\xd800\xdef5\x26e7", "xn--84-s850a.xn--59h6326e"); }
test { try parseIDNAPass("\x226e\xd835\xdfd5\xff0e\x8b16\xdf\x226f", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\x338\xd835\xdfd5\xff0e\x8b16\xdf>\x338", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("\x226e7.\x8b16\xdf\x226f", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\x3387.\x8b16\xdf>\x338", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\x3387.\x8b16SS>\x338", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\x226e7.\x8b16SS\x226f", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\x226e7.\x8b16ss\x226f", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\x3387.\x8b16ss>\x338", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\x3387.\x8b16Ss>\x338", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\x226e7.\x8b16Ss\x226f", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("xn--7-mgo.xn--ss-xjvv174c", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("xn--7-mgo.xn--zca892oly5e", "xn--7-mgo.xn--zca892oly5e"); }
test { try parseIDNAPass("<\x338\xd835\xdfd5\xff0e\x8b16SS>\x338", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\x226e\xd835\xdfd5\xff0e\x8b16SS\x226f", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\x226e\xd835\xdfd5\xff0e\x8b16ss\x226f", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\x338\xd835\xdfd5\xff0e\x8b16ss>\x338", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("<\x338\xd835\xdfd5\xff0e\x8b16Ss>\x338", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass("\x226e\xd835\xdfd5\xff0e\x8b16Ss\x226f", "xn--7-mgo.xn--ss-xjvv174c"); }
test { try parseIDNAPass(".xn--ss-bh7o", ".xn--ss-bh7o"); }
test { try parseIDNAPass("xn--ss-bh7o", "xn--ss-bh7o"); }
test { try parseIDNAPass("ss\xd805\xdcc3", "xn--ss-bh7o"); }
test { try parseIDNAPass("SS\xd805\xdcc3", "xn--ss-bh7o"); }
test { try parseIDNAPass("Ss\xd805\xdcc3", "xn--ss-bh7o"); }
test { try parseIDNAPass(".xn--qekw60d.xn--gd9a", ".xn--qekw60d.xn--gd9a"); }
test { try parseIDNAPass("xn--qekw60d.xn--gd9a", "xn--qekw60d.xn--gd9a"); }
test { try parseIDNAPass("\x30f6\x44a9.\xa86a", "xn--qekw60d.xn--gd9a"); }
test { try parseIDNAPass("\xd834\xdd75\x30029\xd838\xdc08\x4b3a1.", ".xn--91-030c1650n."); }
test { try parseIDNAPass(".xn--91-030c1650n.", ".xn--91-030c1650n."); }
test { try parseIDNAPass("xn--8c1a.xn--2ib8jn539l", "xn--8c1a.xn--2ib8jn539l"); }
test { try parseIDNAPass("\x821b.\x67d\xd83a\xdd34\x6bb", "xn--8c1a.xn--2ib8jn539l"); }
test { try parseIDNAPass("\x821b.\x67d\xd83a\xdd12\x6bb", "xn--8c1a.xn--2ib8jn539l"); }
test { try parseIDNAPass("\x17b4.\xcb87-", ".xn----938f"); }
test { try parseIDNAPass("\x17b4.\x110d\x1170\x11ae-", ".xn----938f"); }
test { try parseIDNAPass(".xn----938f", ".xn----938f"); }
test { try parseIDNAPass(".xn--hcb32bni", ".xn--hcb32bni"); }
test { try parseIDNAPass("xn--hcb32bni", "xn--hcb32bni"); }
test { try parseIDNAPass("\x6bd\x663\x596", "xn--hcb32bni"); }
test { try parseIDNAPass("\x188c\xff0e-\x85a", "xn--59e.xn----5jd"); }
test { try parseIDNAPass("\x188c.-\x85a", "xn--59e.xn----5jd"); }
test { try parseIDNAPass("xn--59e.xn----5jd", "xn--59e.xn----5jd"); }
test { try parseIDNAPass("xn--8gb2338k.xn--lhb0154f", "xn--8gb2338k.xn--lhb0154f"); }
test { try parseIDNAPass("\x63d\xd804\xde3e.\x649\xa92b", "xn--8gb2338k.xn--lhb0154f"); }
test { try parseIDNAPass("\x10c1\x10b16\x318\x3002\xdf\x1b03", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("\x2d21\x2d116\x318\x3002\xdf\x1b03", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("\x10c1\x10b16\x318\x3002SS\x1b03", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\x2d21\x2d116\x318\x3002ss\x1b03", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\x10c1\x2d116\x318\x3002Ss\x1b03", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("xn--6-8cb7433a2ba.xn--ss-2vq", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\x2d21\x2d116\x318.ss\x1b03", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\x10c1\x10b16\x318.SS\x1b03", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("\x10c1\x2d116\x318.Ss\x1b03", "xn--6-8cb7433a2ba.xn--ss-2vq"); }
test { try parseIDNAPass("xn--6-8cb7433a2ba.xn--zca894k", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("\x2d21\x2d116\x318.\xdf\x1b03", "xn--6-8cb7433a2ba.xn--zca894k"); }
test { try parseIDNAPass("xn--7zv.", "xn--7zv."); }
test { try parseIDNAPass("\x6889.", "xn--7zv."); }
test { try parseIDNAPass("xn--iwb.ss", "xn--iwb.ss"); }
test { try parseIDNAPass("\x853.ss", "xn--iwb.ss"); }
test { try parseIDNAPass("\x853.SS", "xn--iwb.ss"); }
test { try parseIDNAPass("-\xff61\x2e90", "-.xn--6vj"); }
test { try parseIDNAPass("-\x3002\x2e90", "-.xn--6vj"); }
test { try parseIDNAPass("-.xn--6vj", "-.xn--6vj"); }
test { try parseIDNAPass("xn--ix9c26l.xn--q0s", "xn--ix9c26l.xn--q0s"); }
test { try parseIDNAPass("\xd802\xdedc\xd804\xdf3c.\x5a40", "xn--ix9c26l.xn--q0s"); }
test { try parseIDNAPass("\xd802\xdec0\xff0e\x689\xd804\xdf00", "xn--pw9c.xn--fjb8658k"); }
test { try parseIDNAPass("\xd802\xdec0.\x689\xd804\xdf00", "xn--pw9c.xn--fjb8658k"); }
test { try parseIDNAPass("xn--pw9c.xn--fjb8658k", "xn--pw9c.xn--fjb8658k"); }
test { try parseIDNAPass("xn--r97c.", "xn--r97c."); }
test { try parseIDNAPass("\xd800\xdef7.", "xn--r97c."); }
