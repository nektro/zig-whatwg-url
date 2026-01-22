import casesraw from "./urltestdata.json";
import casesidna from "./IdnaTestV2.json";

const cases = casesraw.filter((v) => typeof v !== "string");
const f = Bun.file(process.argv[2]!);
const w = f.writer();

w.write(`const std = @import("std");\n`);
w.write(`const url = @import("url");\n`);
w.write(`const expect = @import("expect").expect;\n`);
w.write(`\n`);
w.write(`// zig fmt: off\n`);

function stringEscape(s?: string) {
  if (!s) return "";
  return s
    .split("")
    .map((x) => {
      if (x === "\n") return "\\n";
      if (x === "\r") return "\\r";
      if (x === "\t") return "\\t";
      if (x === "\\") return "\\\\";
      if (x === '"') return `\\"`;
      if (x === "'") return x;
      if (x === " ") return x;
      if (x === "!") return x;
      if (x.codePointAt(0)! >= "#".codePointAt(0)! && x.codePointAt(0)! <= "&".codePointAt(0)!) return x;
      if (x.codePointAt(0)! >= "(".codePointAt(0)! && x.codePointAt(0)! <= "[".codePointAt(0)!) return x;
      if (x.codePointAt(0)! >= "]".codePointAt(0)! && x.codePointAt(0)! <= "~".codePointAt(0)!) return x;
      return `\\x${x.codePointAt(0)!.toString(16).padStart(2, "0")}`;
    })
    .join("");
}
const E = stringEscape;

w.write(`
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
`);

w.write(`\n`);
for (const c of cases.filter((v) => v.base == null && !!v.failure)) {
  w.write(`test { try parseFail("${stringEscape(c.input)}", null); }\n`);
}

w.write(`\n`);
// prettier-ignore
if (false)
for (const c of cases.filter((v) => v.base != null && !!v.failure)) {
  w.write(`test { try parseFail("${stringEscape(c.input)}", "${stringEscape(c.base!)}"); }\n`);
}

w.write(`\n`);
for (const c of cases.filter((v) => v.base == null && !v.failure)) {
  w.write(`test { try parsePass("${E(c.input)}", null, "${E(c.href)}", "${E(c.origin)}", "${E(c.protocol)}", "${E(c.username)}", "${E(c.password)}", "${E(c.host)}", "${E(c.hostname)}", "${E(c.port)}", "${E(c.pathname)}", "${E(c.search)}", "${E(c.hash)}"); }\n`);
}

w.write(`\n`);
// prettier-ignore
if (false)
for (const c of cases.filter((v) => v.base != null && !v.failure)) {
  w.write(`test { try parsePass("${E(c.input)}", "${E(c.base!)}", "${E(c.href)}", "${E(c.origin)}", "${E(c.protocol)}", "${E(c.username)}", "${E(c.password)}", "${E(c.host)}", "${E(c.hostname)}", "${E(c.port)}", "${E(c.pathname)}", "${E(c.search)}", "${E(c.hash)}"); }\n`);
}

w.write(`\n`);
// prettier-ignore
if (false)
for (const c of casesidna.filter((v) => typeof v !== "string").filter((v) => !v.output)) {
  w.write(`test { try parseIDNAFail("${stringEscape(c.input)}"); }\n`);
}

w.write(`\n`);
// prettier-ignore
if (false)
for (const c of casesidna.filter((v) => typeof v !== "string").filter((v) => !!v.output)) {
  w.write(`test { try parseIDNAPass("${stringEscape(c.input)}", "${stringEscape(c.output!)}"); }\n`);
}

w.flush();
