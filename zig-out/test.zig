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
    _ = input;
    _ = base;
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
    return error.SkipZigTest;
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





