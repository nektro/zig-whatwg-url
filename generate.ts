type Case = {
  input: string;
  base: string | null;
  href: string;
  origin: string;
  protocol: string;
  username: string;
  password: string;
  host: string;
  hostname: string;
  port: string;
  pathname: string;
  search: string;
  hash: string;
  failure: undefined;
};
type CaseFail = {
  input: string;
  base: string | null;
  failure: true;
};
type CaseIDNA = {
  input: string;
  output: string | null;
};
const casesraw = (await fetch("https://github.com/web-platform-tests/wpt/raw/master/url/resources/urltestdata.json").then((x) => x.json())) as (string | Case | CaseFail)[];
const casesidna = (await fetch("https://github.com/web-platform-tests/wpt/raw/master/url/resources/IdnaTestV2.json").then((x) => x.json())) as (string | CaseIDNA)[];

const cases = casesraw.filter((v) => typeof v !== "string");
const f = Bun.file(process.argv[2]!);
const w = f.writer();
const encoder = new TextEncoder();

w.write(`const std = @import("std");\n`);
w.write(`const url = @import("url");\n`);
w.write(`const expect = @import("expect").expect;\n`);
w.write(`\n`);
w.write(`// zig fmt: off\n`);

function stringEscape(s?: string) {
  if (!s) return "";
  return Array.from(encoder.encode(s.replace(/\\u([0-9A-F]{4})/g, (s) => String.fromCodePoint(parseInt(s.slice(2), 16)))))
    .map((x) => {
      if (x === 0x09) return "\\t";
      if (x === 0x0a) return "\\n";
      if (x === 0x0d) return "\\r";
      if (x === 0x20) return " ";
      if (x === 0x21) return "!";
      if (x === 0x22) return `\\"`;
      if (x >= 0x23 && x <= 0x26) return String.fromCodePoint(x);
      if (x === 0x27) return "'";
      if (x >= 0x28 && x <= 0x5b) return String.fromCodePoint(x);
      if (x === 0x5c) return "\\\\";
      if (x >= 0x5d && x <= 0x7e) return String.fromCodePoint(x);
      return `\\x${x.toString(16).padStart(2, "0")}`;
    })
    .join("");
}
const E = stringEscape;

w.write(`
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
    _ = origin;
    try expect(u.protocol).toEqualString(protocol);
    try expect(u.username).toEqualString(username);
    try expect(u.password).toEqualString(password);
    try expect(u.hostname).toEqualString(hostname);
    try expect(u.port).toEqualString(port);
    try expect(u.host).toEqualString(host);
    try expect(u.pathname).toEqualString(pathname);
    try expect(u.search).toEqualString(search);
    try expect(u.hash).toEqualString(hash);
    try expect(u.href).toEqualString(href);
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
    // new URL('https://{idnaTest.input}/x');
    const allocator = std.testing.allocator;
    const u = try url.URL.parse(allocator, "https://" ++ input ++ "/x", null);
    defer allocator.free(u.href);
    try expect(u.hostname).toEqualString(output);
    try expect(u.host).toEqualString(output);
    try expect(u.pathname).toEqualString("/x");
    // assert_equals(url.href, 'https://{idnaTest.output}/x');
}
`);

w.write(`\n`);
for (const c of cases) {
  if (c.base !== null) continue;
  if (!c.failure) continue;
  w.write(`test { try parseFail("${stringEscape(c.input)}", null); }\n`);
}

w.write(`\n`);
for (const c of cases) {
  if (c.base === null) continue;
  if (!c.failure) continue;
  w.write(`test { try parseFail("${stringEscape(c.input)}", "${stringEscape(c.base!)}"); }\n`);
}

w.write(`\n`);
for (const c of cases) {
  if (c.base !== null) continue;
  if (c.failure) continue;
  w.write(`test { try parsePass("${E(c.input)}", null, "${E(c.href)}", "${E(c.origin)}", "${E(c.protocol)}", "${E(c.username)}", "${E(c.password)}", "${E(c.host)}", "${E(c.hostname)}", "${E(c.port)}", "${E(c.pathname)}", "${E(c.search)}", "${E(c.hash)}"); }\n`);
}

w.write(`\n`);
// prettier-ignore
if (false)
for (const c of cases) {
  if (c.base === null) continue;
  if (c.failure) continue;
  w.write(`test { try parsePass("${E(c.input)}", "${E(c.base!)}", "${E(c.href)}", "${E(c.origin)}", "${E(c.protocol)}", "${E(c.username)}", "${E(c.password)}", "${E(c.host)}", "${E(c.hostname)}", "${E(c.port)}", "${E(c.pathname)}", "${E(c.search)}", "${E(c.hash)}"); }\n`);
}

w.write(`\n`);
for (const c of casesidna.filter((v) => typeof v !== "string")) {
  if (c.input.length === 0) continue;
  if (c.output !== null) continue;
  w.write(`test { try parseIDNAFail("${stringEscape(c.input)}"); }\n`);
}

w.write(`\n`);
for (const c of casesidna.filter((v) => typeof v !== "string")) {
  if (c.input.length === 0) continue;
  if (c.output === null) continue;
  w.write(`test { try parseIDNAPass("${stringEscape(c.input)}", "${stringEscape(c.output)}"); }\n`);
}

w.flush();
