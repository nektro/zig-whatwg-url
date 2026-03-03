const std = @import("std");
const url = @import("url");
const expect = @import("expect").expect;

test {
    _ = @import("./zig-out/test.zig");
}

test {
    _ = @import("./test.SearchParams.zig");
}

test {
    const allocator = std.testing.allocator;
    const u = try url.URL.parse(allocator, "https://en.wikipedia.org/w/index.php?title=URL", null);
    defer allocator.free(u.href);
    try expect(u.host).toEqualString("en.wikipedia.org");
    var search = try u.searchParams(allocator);
    defer search.deinit();
    try expect(search.get("title")).toEqualString("URL");
}
