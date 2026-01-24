const std = @import("std");
const builtin = @import("builtin");
const net = @import("net");
const extras = @import("extras");
const unicode_idna = @import("unicode-idna");

pub const URL = struct {
    href: []const u8,
    scheme: []const u8 = "",
    protocol: []const u8,
    username: []const u8,
    password: []const u8,
    hostname: []const u8,
    hostname_kind: HostKind,
    port: []const u8,
    host: []const u8,
    pathname: []const u8,
    search: []const u8,
    hash: []const u8,

    pub const HostKind = enum {
        unset,
        name,
        ipv4,
        ipv6,
    };

    const Host = union(HostKind) {
        unset: void,
        name: []const u8,
        ipv4: u32,
        ipv6: u128,
    };

    /// Caller owns memory and is responsible for freeing `url.href`.
    pub fn parse(alloc: std.mem.Allocator, input: []const u8, base: ?[]const u8) !URL {
        if (base) |b| {
            const b_url = try parseBasic(alloc, b, null, null);
            defer alloc.free(b_url.href);
            return parseBasic(alloc, input, b_url, null);
        }
        return parseBasic(alloc, input, if (base) |b| try parseBasic(alloc, b, null, null) else null, null);
    }

    /// https://url.spec.whatwg.org/#concept-basic-url-parser
    fn parseBasic(alloc: std.mem.Allocator, input: []const u8, base: ?URL, state_override: ?BasicParserState) error{ InvalidURL, OutOfMemory }!URL {
        // input is a scalar value string
        if (!std.unicode.utf8ValidateSlice(input)) return error.InvalidURL;

        var inputl = std.ArrayList(u8).init(alloc);
        defer inputl.deinit();
        try inputl.appendSlice(input);

        // 1.
        while (inputl.items.len > 0 and is_c0control_or_space(inputl.items[0])) _ = inputl.orderedRemove(0);
        while (inputl.items.len > 0 and is_c0control_or_space(inputl.getLast())) inputl.items.len -= 1;

        // 3.
        while (std.mem.indexOfScalar(u8, inputl.items, '\t')) |i| _ = inputl.orderedRemove(i);
        while (std.mem.indexOfScalar(u8, inputl.items, '\n')) |i| _ = inputl.orderedRemove(i);
        while (std.mem.indexOfScalar(u8, inputl.items, '\r')) |i| _ = inputl.orderedRemove(i);

        const length = inputl.items.len;

        // 4.
        // this doesn't need to be var since the switch below uses label to jump with the new prong
        var state = state_override orelse .scheme_start;

        // 5.
        // we always do utf-8

        // 6.
        var buffer = std.ArrayList(u8).init(alloc);
        defer buffer.deinit();

        // 7.
        var atSignSeen = false;
        _ = &atSignSeen;
        var insideBrackets = false;
        _ = &insideBrackets;
        var passwordTokenSeen = false;
        _ = &passwordTokenSeen;

        // 8.
        // codepoint index into inputl
        var pointer: usize = 0;
        // byte index into inputl
        // moved at the same time as pointer
        // if pointer is > length, i must not be read
        var i: usize = 0;
        // inputl[i], must change in tandem with i
        var c: u8 = if (length > 0) inputl.items[i] else 0;

        var href = ManyArrayList(8 + 7, u8).init(alloc);
        defer href.deinit();
        var hostname_kind: HostKind = .unset;
        // scheme
        // :
        // //
        // username
        // :
        // password
        // @
        // hostname
        // :
        // port
        // path
        // ?
        // query
        // #
        // fragment

        // 9.
        while (true) {
            switch (state) {
                .scheme_start => {
                    std.debug.assert(pointer == 0);
                    // 1. If c is an ASCII alpha, append c, lowercased, to buffer, and set state to scheme state.
                    if (i < length and std.ascii.isAlphabetic(c)) {
                        try buffer.append(std.ascii.toLower(c));
                        state = .scheme;
                    }
                    // 2. Otherwise, if state override is not given, set state to no scheme state and decrease pointer by 1.
                    else if (state_override == null) {
                        state = .no_scheme;
                        continue; // pointer goes to -1 then +1'd
                    }
                    // 3. Otherwise, return failure.
                    else {
                        return error.InvalidURL;
                    }
                },
                .scheme => {
                    // 1. If c is an ASCII alphanumeric, U+002B (+), U+002D (-), or U+002E (.), append c, lowercased, to buffer.
                    if (std.ascii.isAlphanumeric(c) or c == '+' or c == '-' or c == '.') {
                        try buffer.append(std.ascii.toLower(c));
                    }
                    // 2. Otherwise, if c is U+003A (:), then:
                    else if (c == ':') {
                        try href.set(1, ":");
                        // 1. If state override is given, then:
                        if (state_override != null) {
                            @panic("TODO");
                            // 1. If url’s scheme is a special scheme and buffer is not a special scheme, then return.
                            // 2. If url’s scheme is not a special scheme and buffer is a special scheme, then return.
                            // 3. If url includes credentials or has a non-null port, and buffer is "file", then return.
                            // 4. If url’s scheme is "file" and its host is an empty host, then return.
                        }
                        // 2. Set url’s scheme to buffer.
                        try href.set(0, buffer.items);
                        // 3. If state override is given, then:
                        if (state_override != null) {
                            @panic("TODO");
                            // 1. If url’s port is url’s scheme’s default port, then set url’s port to null.
                            // 2. Return.
                        }
                        // 4. Set buffer to the empty string.
                        buffer.clearRetainingCapacity();
                        // 5. If url’s scheme is "file", then:
                        if (std.mem.eql(u8, href.items(0), "file")) {
                            // 1. If remaining does not start with "//", special-scheme-missing-following-solidus validation error.
                            {}
                            // 2. Set state to file state.
                            state = .file;
                        }
                        // 6. Otherwise, if url is special, base is non-null, and base’s scheme is url’s scheme:
                        else if (isSchemeSpecial(href.items(0)) and base != null and std.mem.eql(u8, base.?.scheme, href.items(0))) {
                            @panic("TODO");
                            // 1. Assert: base is special (and therefore does not have an opaque path).
                            // 2. Set state to special relative or authority state.
                        }
                        // 7. Otherwise, if url is special, set state to special authority slashes state.
                        else if (isSchemeSpecial(href.items(0))) {
                            state = .special_authority_slashes;
                        }
                        // 8. Otherwise, if remaining starts with an U+002F (/), set state to path or authority state and increase pointer by 1.
                        else if (std.mem.startsWith(u8, inputl.items[i + l(c) ..], "/")) {
                            state = .path_or_authority;
                            i += l(c);
                            c = inputl.items[i];
                            pointer += 1;
                        }
                        // 9. Otherwise, set url’s path to the empty string and set state to opaque path state.
                        else {
                            href.clear(10);
                            state = .opaque_path;
                        }
                    }
                    // 3. Otherwise, if state override is not given, set buffer to the empty string, state to no scheme state, and start over (from the first code point in input).
                    else if (state_override == null) {
                        buffer.clearRetainingCapacity();
                        state = .no_scheme;
                        pointer = 0;
                        i = 0;
                        c = inputl.items[i];
                    }
                    // 4. Otherwise, return failure.
                    else {
                        return error.InvalidURL;
                    }
                },
                .no_scheme => {
                    // 1. If base is null, or base has an opaque path and c is not U+0023 (#), missing-scheme-non-relative-URL validation error, return failure.
                    if (base == null) return error.InvalidURL;
                    // 2. Otherwise, if base has an opaque path and c is U+0023 (#), set url’s scheme to base’s scheme, url’s path to base’s path, url’s query to base’s query, url’s fragment to the empty string, and set state to fragment state.
                    // 3. Otherwise, if base’s scheme is not "file", set state to relative state and decrease pointer by 1.
                    // 4. Otherwise, set state to file state and decrease pointer by 1.
                    return error.InvalidURL;
                },
                .special_relative_or_authority => {
                    // 1. If c is U+002F (/) and remaining starts with U+002F (/), then set state to special authority ignore slashes state and increase pointer by 1.
                    if (c == '/' and std.mem.startsWith(u8, inputl.items[i + l(c) ..], "/")) {
                        state = .special_authority_ignore_slashes;
                        i += l(c);
                        c = inputl.items[i];
                        pointer += 1;
                    }
                    // 2. Otherwise, special-scheme-missing-following-solidus validation error, set state to relative state and decrease pointer by 1.
                    else {
                        state = .relative;
                        @panic("TODO");
                    }
                },
                .path_or_authority => {
                    // 1. If c is U+002F (/), then set state to authority state.
                    if (c == '/') {
                        state = .authority;
                    }
                    // 2. Otherwise, set state to path state, and decrease pointer by 1.
                    else {
                        state = .path;
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                        try href.appendSlice(10, "/");
                    }
                },
                .relative => {
                    // 1. Assert: base’s scheme is not "file".
                    std.debug.assert(!std.mem.eql(u8, base.?.scheme, "file"));
                    // 2. Set url’s scheme to base’s scheme.
                    try href.set(0, base.?.scheme);
                    // 3. If c is U+002F (/), then set state to relative slash state.
                    if (c == '/') {
                        state = .relative_slash;
                    }
                    // 4. Otherwise, if url is special and c is U+005C (\), invalid-reverse-solidus validation error, set state to relative slash state.
                    else if (isSchemeSpecial(href.items(0)) and c == '\\') {
                        state = .relative_slash;
                    }
                    // 5. Otherwise:
                    else {
                        // 1. Set url’s username to base’s username, url’s password to base’s password, url’s host to base’s host, url’s port to base’s port, url’s path to a clone of base’s path, and url’s query to base’s query.
                        // try username.appendSlice(base.?.username);
                        // try password.appendSlice(base.?.password);
                        // host = base.?.host;
                        // try port.writer().print("{d}", .{base.?.port.?});
                        // try path.appendSlice(base.?.path);
                        // try query.appendSlice(base.?.query.?);
                        // 2. If c is U+003F (?), then set url’s query to the empty string, and state to query state.
                        if (c == '?') {
                            href.clear(12);
                            state = .query;
                            try href.appendSlice(11, &.{c});
                        }
                        // 3. Otherwise, if c is U+0023 (#), set url’s fragment to the empty string and state to fragment state.
                        else if (c == '#') {
                            href.clear(14);
                            state = .fragment;
                            try href.appendSlice(13, &.{c});
                        }
                        // 4. Otherwise, if c is not the EOF code point:
                        else if (i < length) {
                            // 1. Set url’s query to null.
                            href.clear(12);
                            // 2. Shorten url’s path.
                            @panic("TODO");
                            // 3. Set state to path state and decrease pointer by 1.
                            // state = .path;
                            // pointer -= 1;
                            // i = lastcpi(inputl.items[0..i]);
                            // c = inputl.items[i];
                        }
                    }
                },
                .relative_slash => {
                    // 1. If url is special and c is U+002F (/) or U+005C (\), then:
                    if (isSchemeSpecial(href.items(0)) and (c == '/' or c == '\\')) {
                        // 1. If c is U+005C (\), invalid-reverse-solidus validation error.
                        // 2. Set state to special authority ignore slashes state.
                        state = .special_authority_ignore_slashes;
                    }
                    // 2. Otherwise, if c is U+002F (/), then set state to authority state.
                    else if (c == '/') {
                        state = .authority;
                    }
                    // 3. Otherwise, set url’s username to base’s username, url’s password to base’s password, url’s host to base’s host, url’s port to base’s port, state to path state, and then, decrease pointer by 1.
                    else {
                        // try username.appendSlice(base.?.username);
                        // try password.appendSlice(base.?.password);
                        // host = base.?.host;
                        // try port.writer().print("{d}", .{base.?.port.?});
                        state = .path;
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                        @panic("TODO");
                    }
                },
                .special_authority_slashes => {
                    // 1. If c is U+002F (/) and remaining starts with U+002F (/), then set state to special authority ignore slashes state and increase pointer by 1.
                    if (c == '/' and std.mem.startsWith(u8, inputl.items[i + l(c) ..], "/")) {
                        state = .special_authority_ignore_slashes;
                        i += l(c);
                        c = if (i < length) inputl.items[i] else 0;
                        pointer += 1;
                    }
                    // 2. Otherwise, special-scheme-missing-following-solidus validation error, set state to special authority ignore slashes state and decrease pointer by 1.
                    else {
                        state = .special_authority_ignore_slashes;
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                    }
                },
                .special_authority_ignore_slashes => {
                    // 1. If c is neither U+002F (/) nor U+005C (\), then set state to authority state and decrease pointer by 1.
                    if (c != '/' and c != '\\') {
                        state = .authority;
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                    }
                    // 2. Otherwise, special-scheme-missing-following-solidus validation error.
                    else {
                        //
                    }
                },
                .authority => {
                    // 1. If c is U+0040 (@), then:
                    if (c == '@') {
                        // 1. Invalid-credentials validation error.
                        // 2. If atSignSeen is true, then prepend "%40" to buffer.
                        if (atSignSeen) try buffer.insertSlice(0, "%40");
                        // 3. Set atSignSeen to true.
                        atSignSeen = true;
                        // 4. For each codePoint in buffer:
                        var it = std.unicode.Utf8View.initUnchecked(buffer.items).iterator();
                        while (it.nextCodepointSlice()) |sl| {
                            // 1. If codePoint is U+003A (:) and passwordTokenSeen is false, then set passwordTokenSeen to true and continue.
                            if (sl[0] == ':' and !passwordTokenSeen) {
                                passwordTokenSeen = true;
                                continue;
                            }
                            // 2. Let encodedCodePoints be the result of running UTF-8 percent-encode codePoint using the userinfo percent-encode set.
                            // 3. If passwordTokenSeen is true, then append encodedCodePoints to url’s password.
                            // 4. Otherwise, append encodedCodePoints to url’s username.
                            if (passwordTokenSeen) {
                                try percentEncodeScalarML(&href, 5, sl, is_userinfo_percent_char);
                            } else {
                                try percentEncodeScalarML(&href, 3, sl, is_userinfo_percent_char);
                            }
                        }
                        // 5. Set buffer to the empty string.
                        buffer.clearRetainingCapacity();
                    }
                    // 2. Otherwise, if one of the following is true:
                    //      - c is the EOF code point, U+002F (/), U+003F (?), or U+0023 (#)
                    //      - url is special and c is U+005C (\)
                    // then:
                    else if ((i == length or c == '/' or c == '?' or c == '#') or (isSchemeSpecial(href.items(0)) and c == '\\')) {
                        // 1. If atSignSeen is true and buffer is the empty string, host-missing validation error, return failure.
                        if (atSignSeen and buffer.items.len == 0) return error.InvalidURL;
                        // 2. Decrease pointer by buffer’s code point length + 1, set buffer to the empty string, and set state to host state.
                        for (0..(std.unicode.utf8CountCodepoints(buffer.items) catch unreachable) + 1) |_| {
                            pointer -= 1;
                            i = lastcpi(inputl.items[0..i]);
                            c = inputl.items[i];
                        }
                        buffer.clearRetainingCapacity();
                        state = .host;
                    }
                    // 3. Otherwise, append c to buffer.
                    else {
                        try buffer.appendSlice(inputl.items[i..][0..l(c)]);
                    }
                },
                .host, .hostname => {
                    // 1. If state override is given and url’s scheme is "file", then decrease pointer by 1 and set state to file host state.
                    if (state_override != null and std.mem.eql(u8, href.items(0), "file")) {
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                        state = .file_host;
                    }
                    // 2. Otherwise, if c is U+003A (:) and insideBrackets is false:
                    else if (c == ':' and insideBrackets == false) {
                        // 1. If buffer is the empty string, host-missing validation error, return failure.
                        if (buffer.items.len == 0) return error.InvalidURL;
                        // 2. If state override is given and state override is hostname state, then return failure.
                        if (state_override != null and state_override.? == .hostname) return error.InvalidURL;
                        // 3. Let host be the result of host parsing buffer with url is not special.
                        // 4. If host is failure, then return failure.
                        const h = try parseHost(alloc, buffer.items, !isSchemeSpecial(href.items(0)));
                        defer if (h == .name) alloc.free(h.name);
                        // 5. Set url’s host to host, buffer to the empty string, and state to port state.
                        try setHost(&href, h);
                        hostname_kind = h;
                        buffer.clearRetainingCapacity();
                        state = .port;
                    }
                    // 3. Otherwise, if one of the following is true:
                    //  - c is the EOF code point, U+002F (/), U+003F (?), or U+0023 (#)
                    //  - url is special and c is U+005C (\)
                    // then decrease pointer by 1, and:
                    else if ((i == length or c == '/' or c == '?' or c == '#') or (isSchemeSpecial(href.items(0)) and c == '\\')) {
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                        // 1. If url is special and buffer is the empty string, host-missing validation error, return failure.
                        if (isSchemeSpecial(href.items(0)) and buffer.items.len == 0) return error.InvalidURL
                        // 2. Otherwise, if state override is given, buffer is the empty string, and either url includes credentials or url’s port is non-null, then return failure.
                        else if (state_override != null and buffer.items.len == 0 and (href.lengths[3] > 0 or href.lengths[5] > 0)) return error.InvalidURL;
                        // 3. Let host be the result of host parsing buffer with url is not special.
                        // 4. If host is failure, then return failure.
                        const h = try parseHost(alloc, buffer.items, !isSchemeSpecial(href.items(0)));
                        defer if (h == .name) alloc.free(h.name);
                        // 5. Set url’s host to host, buffer to the empty string, and state to path start state.
                        try setHost(&href, h);
                        hostname_kind = h;
                        buffer.clearRetainingCapacity();
                        state = .path_start;
                        // 6. If state override is given, then return.
                        if (state_override != null) break;
                    }
                    // 4. Otherwise:
                    else {
                        // 1. If c is U+005B ([), then set insideBrackets to true.
                        if (c == '[') insideBrackets = true;
                        // 2. If c is U+005D (]), then set insideBrackets to false.
                        if (c == ']') insideBrackets = false;
                        // 3. Append c to buffer.
                        try buffer.appendSlice(inputl.items[i..][0..l(c)]);
                    }
                },
                .port => {
                    // 1. If c is an ASCII digit, append c to buffer.
                    if (std.ascii.isDigit(c)) {
                        try buffer.appendSlice(inputl.items[i..][0..l(c)]);
                    }
                    // 2. Otherwise, if one of the following is true:
                    //  - c is the EOF code point, U+002F (/), U+003F (?), or U+0023 (#);
                    //  - url is special and c is U+005C (\); or
                    //  - state override is given,
                    // then:
                    else if ((i == length or c == '/' or c == '?' or c == '#') or (isSchemeSpecial(href.items(0)) and c == '\\') or (state_override != null)) {
                        // 1. If buffer is not the empty string:
                        if (buffer.items.len > 0) {
                            // 1. Let port be the mathematical integer value that is represented by buffer in radix-10 using ASCII digits for digits with values 0 through 9.
                            // 2. If port is not a 16-bit unsigned integer, port-out-of-range validation error, return failure.
                            const p = std.fmt.parseInt(u16, buffer.items, 10) catch return error.InvalidURL;
                            // 3. Set url’s port to null, if port is url’s scheme’s default port; otherwise to port.
                            if (schemeDefaultPort(href.items(0)) != p) try href.print(9, "{d}", .{p});
                            // 4. Set buffer to the empty string.
                            buffer.clearRetainingCapacity();
                            // 5. If state override is given, then return.
                            if (state_override != null) break;
                        }
                        // 2. If state override is given, then return failure.
                        if (state_override != null) return error.InvalidURL;
                        // 3. Set state to path start state and decrease pointer by 1.
                        state = .path_start;
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                    }
                    // 3. Otherwise, port-invalid validation error, return failure.
                    else {
                        return error.InvalidURL;
                    }
                },
                .file => {
                    // 1. Set url’s scheme to "file".
                    try href.set(0, "file");
                    // 2. Set url’s host to the empty string.
                    href.clear(7);
                    hostname_kind = .name;
                    // 3. If c is U+002F (/) or U+005C (\), then:
                    if (c == '/' or c == '\\') {
                        // 1. If c is U+005C (\), invalid-reverse-solidus validation error.
                        {}
                        // 2. Set state to file slash state.
                        state = .file_slash;
                    }
                    // 4. Otherwise, if base is non-null and base’s scheme is "file":
                    else if (base != null and std.mem.eql(u8, base.?.scheme, "file")) {
                        // 1. Set url’s host to base’s host, url’s path to a clone of base’s path, and url’s query to base’s query.
                        // host = base.?.host;
                        // try path.appendSlice(base.?.path.?);
                        // try query.appendSlice(base.?.query.?);
                        // 2. If c is U+003F (?), then set url’s query to the empty string and state to query state.
                        if (c == '?') {
                            href.clear(12);
                            state = .query;
                            try href.appendSlice(11, &.{c});
                        }
                        // 3. Otherwise, if c is U+0023 (#), set url’s fragment to the empty string and state to fragment state.
                        else if (c == '#') {
                            href.clear(14);
                            state = .fragment;
                            try href.appendSlice(13, &.{c});
                        }
                        // 4. Otherwise, if c is not the EOF code point:
                        else if (i < length) {
                            // 1. Set url’s query to null.
                            href.clear(12);
                            // 2. If the code point substring from pointer to the end of input does not start with a Windows drive letter, then shorten url’s path.
                            // 3. Otherwise:
                            // This is a (platform-independent) Windows drive letter quirk.
                            if (builtin.target.os.tag == .windows) @compileError("TODO");
                            {
                                // 1. File-invalid-Windows-drive-letter validation error.
                                // 2. Set url’s path to « ».
                            }
                            // 4. Set state to path state and decrease pointer by 1.
                            state = .path;
                            pointer -= 1;
                            i = lastcpi(inputl.items[0..i]);
                            c = inputl.items[i];
                        }
                    }
                    // 5. Otherwise, set state to path state, and decrease pointer by 1.
                    else {
                        state = .path;
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                        try href.appendSlice(10, "/");
                    }
                },
                .file_slash => {
                    // 1. If c is U+002F (/) or U+005C (\), then:
                    if (c == '/' or c == '\\') {
                        // 1. If c is U+005C (\), invalid-reverse-solidus validation error.
                        {}
                        // 2. Set state to file host state.
                        state = .file_host;
                    }
                    // 2. Otherwise:
                    else {
                        // 1. If base is non-null and base’s scheme is "file", then:
                        if (base != null and std.mem.eql(u8, base.?.scheme, "file")) {
                            // 1. Set url’s host to base’s host.
                            // host = base.?.host;
                            // 2. If the code point substring from pointer to the end of input does not start with a Windows drive letter and base’s path[0] is a normalized Windows drive letter, then append base’s path[0] to url’s path.
                            // > This is a (platform-independent) Windows drive letter quirk.
                            if (builtin.target.os.tag == .windows) @compileError("TODO");
                        }
                        // 2. Set state to path state, and decrease pointer by 1.
                        state = .path;
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                        try href.appendSlice(10, "/");
                    }
                },
                .file_host => {
                    // 1. If c is the EOF code point, U+002F (/), U+005C (\), U+003F (?), or U+0023 (#), then decrease pointer by 1 and then:
                    if (i == length or c == '/' or c == '\\' or c == '?' or c == '#') {
                        pointer -= 1;
                        i = lastcpi(inputl.items[0..i]);
                        c = inputl.items[i];
                        // 1. If state override is not given and buffer is a Windows drive letter, file-invalid-Windows-drive-letter-host validation error, set state to path state.
                        // > This is a (platform-independent) Windows drive letter quirk. buffer is not reset here and instead used in the path state.
                        if (state_override == null and isWindowsDriveLetter(buffer.items)) {
                            state = .path;
                            try href.appendSlice(10, "/");
                        }
                        // 2. Otherwise, if buffer is the empty string, then:
                        else if (buffer.items.len == 0) {
                            // 1. Set url’s host to the empty string.
                            href.clear(7);
                            hostname_kind = .name;
                            // 2. If state override is given, then return.
                            if (state_override != null) break;
                            // 3. Set state to path start state.
                            state = .path_start;
                        }
                        // 3. Otherwise, run these steps:
                        else {
                            // 1. Let host be the result of host parsing buffer with url is not special.
                            // 2. If host is failure, then return failure.
                            var h = try parseHost(alloc, buffer.items, !isSchemeSpecial(href.items(0)));
                            defer if (h == .name) alloc.free(h.name);
                            // 3. If host is "localhost", then set host to the empty string.
                            if (h == .name and std.mem.eql(u8, h.name, "localhost")) {
                                alloc.free(h.name);
                                h = .{ .name = "" };
                            }
                            // 4. Set url’s host to host.
                            try setHost(&href, h);
                            hostname_kind = h;
                            // 5. If state override is given, then return.
                            if (state_override != null) break;
                            // 6. Set buffer to the empty string and state to path start state.
                            buffer.clearRetainingCapacity();
                            state = .path_start;
                        }
                    }
                    // 2. Otherwise, append c to buffer.
                    else {
                        try buffer.appendSlice(inputl.items[i..][0..l(c)]);
                    }
                },
                .path_start => {
                    // 1. If url is special, then:
                    if (isSchemeSpecial(href.items(0))) {
                        // 1. If c is U+005C (\), invalid-reverse-solidus validation error.
                        {}
                        // 2. Set state to path state.
                        state = .path;
                        // 3. If c is neither U+002F (/) nor U+005C (\), then decrease pointer by 1.
                        if (c != '/' and c != '\\') {
                            pointer -= 1;
                            i = lastcpi(inputl.items[0..i]);
                            c = inputl.items[i];
                        }
                        try href.appendSlice(10, "/");
                    }
                    // 2. Otherwise, if state override is not given and c is U+003F (?), set url’s query to the empty string and state to query state.
                    else if (state_override == null and c == '?') {
                        href.clear(12);
                        state = .query;
                        try href.appendSlice(11, &.{c});
                    }
                    // 3. Otherwise, if state override is not given and c is U+0023 (#), set url’s fragment to the empty string and state to fragment state.
                    else if (state_override == null and c == '#') {
                        href.clear(14);
                        state = .fragment;
                        try href.appendSlice(13, &.{c});
                    }
                    // 4. Otherwise, if c is not the EOF code point:
                    else if (i < length) {
                        // 1. Set state to path state.
                        state = .path;
                        // 2. If c is not U+002F (/), then decrease pointer by 1.
                        if (c != '/') {
                            pointer -= 1;
                            i = lastcpi(inputl.items[0..i]);
                            c = inputl.items[i];
                        } else {
                            try href.appendSlice(10, &.{c});
                        }
                    }
                    // 5. Otherwise, if state override is given and url’s host is null, append the empty string to url’s path.
                    else if (state_override != null) {
                        @panic("TODO");
                    }
                },
                .path => {
                    const is_lsep = c == '/';
                    const is_rsep = isSchemeSpecial(href.items(0)) and c == '\\';
                    // 1. If one of the following is true:
                    //  - c is the EOF code point or U+002F (/)
                    //  - url is special and c is U+005C (\)
                    //  - state override is not given and c is U+003F (?) or U+0023 (#)
                    // then:
                    if ((i == length or is_lsep) or (is_rsep) or (state_override == null and (c == '?' or c == '#'))) {
                        // 1. If url is special and c is U+005C (\), invalid-reverse-solidus validation error.
                        {}
                        // 2. If buffer is a double-dot URL path segment, then:
                        if (isDoubleDotPathSeg(buffer.items)) {
                            const olen = href.lengths[10];
                            const idx = std.mem.lastIndexOfScalar(u8, href.items(10)[0 .. olen - 1], '/') orelse 0;
                            try href.replace(10, idx + 1, olen - idx - 1, "");
                            // 1. Shorten url’s path.
                            // 2. If neither c is U+002F (/), nor url is special and c is U+005C (\), append the empty string to url’s path.
                            // > This means that for input /usr/.. the result is / and not a lack of a path.
                        }
                        // 3. Otherwise, if buffer is a single-dot URL path segment and if neither c is U+002F (/), nor url is special and c is U+005C (\), append the empty string to url’s path.
                        else if (isSingleDotPathSeg(buffer.items) and (c != '/' or !(is_rsep))) {
                            // =no action needed
                        }
                        // 4. Otherwise, if buffer is not a single-dot URL path segment, then:
                        else if (!isSingleDotPathSeg(buffer.items)) {
                            // 1. If url’s scheme is "file", url’s path is empty, and buffer is a Windows drive letter, then replace the second code point in buffer with U+003A (:).
                            // > This is a (platform-independent) Windows drive letter quirk.
                            if (std.mem.eql(u8, href.items(0), "file") and href.lengths[10] <= 1 and isWindowsDriveLetter(buffer.items)) {
                                buffer.items[1] = ':';
                            }
                            // 2. Append buffer to url’s path.
                            // if (!std.mem.endsWith(u8, href.items(10), "/")) try href.appendSlice(10, "/");
                            try href.appendSlice(10, buffer.items);
                            if (is_lsep) try href.appendSlice(10, "/");
                            if (is_rsep) try href.appendSlice(10, "/");
                        }
                        // 5. Set buffer to the empty string.
                        buffer.clearRetainingCapacity();
                        // 6. If c is U+003F (?), then set url’s query to the empty string and state to query state.
                        if (c == '?') {
                            href.clear(12);
                            state = .query;
                            try href.appendSlice(11, &.{c});
                        }
                        // 7. If c is U+0023 (#), then set url’s fragment to the empty string and state to fragment state.
                        if (c == '#') {
                            href.clear(14);
                            state = .fragment;
                            try href.appendSlice(13, &.{c});
                        }
                    }
                    // 2. Otherwise, run these steps:
                    else {
                        // 1. If c is not a URL code point and not U+0025 (%), invalid-URL-unit validation error.
                        {}
                        // 2. If c is U+0025 (%) and remaining does not start with two ASCII hex digits, invalid-URL-unit validation error.
                        {}
                        // 3. UTF-8 percent-encode c using the path percent-encode set and append the result to buffer.
                        if (is_path_percent_char(c)) {
                            const pe = try percentEncode(alloc, inputl.items[i..][0..l(c)], is_path_percent_char);
                            defer alloc.free(pe);
                            try buffer.appendSlice(pe);
                        } else {
                            try buffer.appendSlice(inputl.items[i..][0..l(c)]);
                        }
                    }
                },
                .opaque_path => {
                    // 1. If c is U+003F (?), then set url’s query to the empty string and state to query state.
                    if (c == '?') {
                        href.clear(12);
                        state = .query;
                        try href.appendSlice(11, &.{c});
                    }
                    // 2. Otherwise, if c is U+0023 (#), then set url’s fragment to the empty string and state to fragment state.
                    else if (c == '#') {
                        href.clear(14);
                        state = .fragment;
                        try href.appendSlice(13, &.{c});
                    }
                    // 3. Otherwise, if c is U+0020 SPACE:
                    else if (c == ' ') {
                        // 1. If remaining starts with U+003F (?) or U+003F (#), then append "%20" to url’s path.
                        const rem = inputl.items[i + l(c) ..];
                        if (std.mem.startsWith(u8, rem, "?") or std.mem.startsWith(u8, rem, "#")) {
                            try href.appendSlice(10, "%20");
                        }
                        // 2. Otherwise, append U+0020 SPACE to url’s path.
                        else {
                            try href.appendSlice(10, " ");
                        }
                    }
                    // 4. Otherwise, if c is not the EOF code point:
                    else if (i < length) {
                        // 1. If c is not a URL code point and not U+0025 (%), invalid-URL-unit validation error.
                        {}
                        // 2. If c is U+0025 (%) and remaining does not start with two ASCII hex digits, invalid-URL-unit validation error.
                        {}
                        // 3. UTF-8 percent-encode c using the C0 control percent-encode set and append the result to url’s path.
                        try percentEncodeScalarML(&href, 10, inputl.items[i..][0..l(c)], is_c0control_percent_char);
                    }
                },
                .query => {
                    // 1. If encoding is not UTF-8 and one of the following is true:
                    //  - url is not special
                    //  - url’s scheme is "ws" or "wss"
                    // then set encoding to UTF-8.
                    // 2. If one of the following is true:
                    //  - state override is not given and c is U+0023 (#)
                    //  - c is the EOF code point
                    // then:
                    if ((state_override == null and c == '#') or (i == length)) {
                        // 1. Let queryPercentEncodeSet be the special-query percent-encode set if url is special; otherwise the query percent-encode set.
                        // 2. Percent-encode after encoding, with encoding, buffer, and queryPercentEncodeSet, and append the result to url’s query.
                        // > This operation cannot be invoked code-point-for-code-point due to the stateful ISO-2022-JP encoder.
                        if (isSchemeSpecial(href.items(0))) {
                            try percentEncodeML(&href, 12, buffer.items, is_special_query_percent_char);
                        } else {
                            try percentEncodeML(&href, 12, buffer.items, is_query_percent_char);
                        }
                        // 3. Set buffer to the empty string.
                        buffer.clearRetainingCapacity();
                        // 4. If c is U+0023 (#), then set url’s fragment to the empty string and state to fragment state.
                        if (c == '#') {
                            href.clear(14);
                            state = .fragment;
                            try href.appendSlice(13, &.{c});
                        }
                    }
                    // 3. Otherwise, if c is not the EOF code point:
                    else if (i < length) {
                        // 1. If c is not a URL code point and not U+0025 (%), invalid-URL-unit validation error.
                        {}
                        // 2. If c is U+0025 (%) and remaining does not start with two ASCII hex digits, invalid-URL-unit validation error.
                        {}
                        // 3. Append c to buffer.
                        try buffer.appendSlice(inputl.items[i..][0..l(c)]);
                    }
                },
                .fragment => {
                    // 1. If c is not the EOF code point, then:
                    if (i < length) {
                        // 1. If c is not a URL code point and not U+0025 (%), invalid-URL-unit validation error.
                        {}
                        // 2. If c is U+0025 (%) and remaining does not start with two ASCII hex digits, invalid-URL-unit validation error.
                        {}
                        // 3. UTF-8 percent-encode c using the fragment percent-encode set and append the result to url’s fragment.
                        try percentEncodeScalarML(&href, 14, inputl.items[i..][0..l(c)], is_fragment_percent_char);
                    }
                },
            }

            // If after a run pointer points to the EOF code point, go to the next step. Otherwise, increase pointer by 1 and continue with the state machine.
            if (i == length) {
                if (state == .fragment) break;
                state = @enumFromInt(@intFromEnum(state) + 1);
            } else {
                i += l(c);
                c = if (i < length) inputl.items[i] else 0;
                pointer += 1;
            }
        }

        if (hostname_kind != .unset) {
            try href.appendSlice(2, "//");
        }
        if (href.lengths[5] > 0) {
            try href.set(4, ":");
        }
        if (href.lengths[3] > 0 or href.lengths[5] > 0) {
            try href.set(6, "@");
        }
        if (href.lengths[9] > 0) {
            try href.set(8, ":");
        }

        var path_offset: usize = 0;
        if (hostname_kind == .unset and std.mem.startsWith(u8, href.items(10), "//")) {
            try href.replace(10, 0, 0, "/.");
            path_offset += 2;
        }

        const _href = try href.list.toOwnedSlice();

        const url: URL = .{
            .href = _href,
            .protocol = _href[0..extras.sum(usize, href.lengths[0..2])],
            .username = _href[extras.sum(usize, href.lengths[0..3])..][0..href.lengths[3]],
            .password = _href[extras.sum(usize, href.lengths[0..5])..][0..href.lengths[5]],
            .hostname = _href[extras.sum(usize, href.lengths[0..7])..][0..href.lengths[7]],
            .hostname_kind = hostname_kind,
            .port = _href[extras.sum(usize, href.lengths[0..9])..][0..href.lengths[9]],
            .host = _href[extras.sum(usize, href.lengths[0..7])..][0..extras.sum(usize, href.lengths[7..][0..if (href.lengths[9] == 0) 1 else 3])],
            .pathname = _href[extras.sum(usize, href.lengths[0..10])..][0..href.lengths[10]][path_offset..],
            .search = if (href.lengths[12] == 0) "" else _href[extras.sum(usize, href.lengths[0..11])..][0..extras.sum(usize, href.lengths[11..][0..2])],
            .hash = if (href.lengths[14] == 0) "" else _href[extras.sum(usize, href.lengths[0..13])..][0..extras.sum(usize, href.lengths[13..][0..2])],
        };
        return url;
    }

    const BasicParserState = enum {
        scheme_start,
        scheme,
        no_scheme,
        special_relative_or_authority,
        path_or_authority,
        relative,
        relative_slash,
        special_authority_slashes,
        special_authority_ignore_slashes,
        authority,
        host,
        hostname,
        port,
        file,
        file_slash,
        file_host,
        path_start,
        path,
        opaque_path,
        query,
        fragment,
    };

    pub fn isSpecial(u: URL) bool {
        return isSchemeSpecial(u.scheme);
    }
};

/// https://url.spec.whatwg.org/#special-scheme
fn isSchemeSpecial(scheme: []const u8) bool {
    if (std.mem.eql(u8, scheme, "ftp")) return true;
    if (std.mem.eql(u8, scheme, "file")) return true;
    if (std.mem.eql(u8, scheme, "http")) return true;
    if (std.mem.eql(u8, scheme, "https")) return true;
    if (std.mem.eql(u8, scheme, "ws")) return true;
    if (std.mem.eql(u8, scheme, "wss")) return true;
    return false;
}

/// https://url.spec.whatwg.org/#default-port
fn schemeDefaultPort(scheme: []const u8) ?u16 {
    if (std.mem.eql(u8, scheme, "ftp")) return 21;
    if (std.mem.eql(u8, scheme, "file")) return null;
    if (std.mem.eql(u8, scheme, "http")) return 80;
    if (std.mem.eql(u8, scheme, "https")) return 443;
    if (std.mem.eql(u8, scheme, "ws")) return 80;
    if (std.mem.eql(u8, scheme, "wss")) return 443;
    return null;
}

/// https://url.spec.whatwg.org/#double-dot-path-segment
fn isDoubleDotPathSeg(segment: []const u8) bool {
    if (std.mem.eql(u8, segment, "..")) return true;
    if (std.ascii.eqlIgnoreCase(segment, ".%2e")) return true;
    if (std.ascii.eqlIgnoreCase(segment, "%2e.")) return true;
    if (std.ascii.eqlIgnoreCase(segment, "%2e%2e")) return true;
    return false;
}

/// https://url.spec.whatwg.org/#single-dot-path-segment
fn isSingleDotPathSeg(segment: []const u8) bool {
    if (std.mem.eql(u8, segment, ".")) return true;
    if (std.ascii.eqlIgnoreCase(segment, "%2e")) return true;
    return false;
}

/// https://url.spec.whatwg.org/#windows-drive-letter
fn isWindowsDriveLetter(buffer: []const u8) bool {
    if (buffer.len != 2) return false;
    if (!std.ascii.isAlphabetic(buffer[0])) return false;
    if (!(buffer[1] == ':' or buffer[1] == '|')) return false;
    return true;
}

/// https://url.spec.whatwg.org/#concept-host-parser
fn parseHost(allocator: std.mem.Allocator, input: []u8, isOpaque: bool) !URL.Host {
    // 1. If input starts with U+005B ([), then:
    if (std.mem.startsWith(u8, input, "[")) {
        // 1. If input does not end with U+005D (]), IPv6-unclosed validation error, return failure.
        if (!std.mem.endsWith(u8, input, "]")) return error.InvalidURL;
        // 2. Return the result of IPv6 parsing input with its leading U+005B ([) and trailing U+005D (]) removed.
        const adr = try parseIPv6(input[1 .. input.len - 1]);
        return .{ .ipv6 = adr };
    }
    // 2. If isOpaque is true, then return the result of opaque-host parsing input.
    if (isOpaque) return .{ .name = try parseHostOpaque(allocator, input) };
    // 3. Assert: input is not the empty string.
    std.debug.assert(input.len > 0);
    // 4. Let domain be the result of running UTF-8 decode without BOM on the percent-decoding of input.
    // > Alternatively UTF-8 decode without BOM or fail can be used, coupled with an early return for failure, as domain to ASCII fails on U+FFFD (�).
    const domain = try percentDecode(allocator, input);
    defer allocator.free(domain);
    if (!std.unicode.utf8ValidateSlice(domain)) return error.InvalidURL;
    // 5. Let asciiDomain be the result of running domain to ASCII with domain and false.
    // 6. If asciiDomain is failure, then return failure.
    const asciidomain = try domainToAscii(allocator, domain, false);
    // 7. If asciiDomain ends in a number, then return the result of IPv4 parsing asciiDomain.
    if (endsInANumber(asciidomain)) {
        defer allocator.free(asciidomain);
        const adr = try parseIPv4(input);
        return .{ .ipv4 = adr };
    }
    // 8. Return asciiDomain.
    return .{ .name = asciidomain };
}

/// https://url.spec.whatwg.org/#concept-ipv6-parser
fn parseIPv6(input: []const u8) !u128 {
    // 1. Let address be a new IPv6 address whose pieces are all 0.
    var address: [8]u16 = @splat(0);
    _ = &address;
    // 2. Let pieceIndex be 0.
    var pieceIndex: u8 = 0;
    _ = &pieceIndex;
    // 3. Let compress be null.
    var compress: ?u8 = null;
    _ = &compress;
    // 4. Let pointer be a pointer for input.
    std.debug.assert(extras.matchesAll(u8, input, std.ascii.isAscii));
    var pointer: usize = 0;
    // 5. If c is U+003A (:), then:
    if (input.len > 0 and input[pointer] == ':') {
        // 1. If remaining does not start with U+003A (:), IPv6-invalid-compression validation error, return failure.
        if (!std.mem.startsWith(u8, input[pointer + 1 ..], ":")) return error.InvalidURL;
        // 2. Increase pointer by 2.
        pointer += 2;
        // 3. Increase pieceIndex by 1 and then set compress to pieceIndex.
        pieceIndex += 1;
        compress = pieceIndex;
    }
    // 6. While c is not the EOF code point:
    while (pointer != input.len) {
        // 1. If pieceIndex is 8, IPv6-too-many-pieces validation error, return failure.
        if (pieceIndex == 8) return error.InvalidURL;
        // 2. If c is U+003A (:), then:
        if (input[pointer] == ':') {
            // 1. If compress is non-null, IPv6-multiple-compression validation error, return failure.
            if (compress != null) return error.InvalidURL;
            // 2. Increase pointer and pieceIndex by 1, set compress to pieceIndex, and then continue.
            pointer += 1;
            pieceIndex += 1;
            compress = pieceIndex;
            continue;
        }
        // 3. Let value and length be 0.
        var value: u16 = 0;
        var length: usize = 0;
        // 4. While length is less than 4 and c is an ASCII hex digit, set value to value × 0x10 + c interpreted as hexadecimal number, and increase pointer and length by 1.
        const hex_alpha_upper = "0123456789ABCDEF";
        const hex_alpha_lower = "0123456789abcdef";
        while (length < 4 and pointer < input.len and std.ascii.isHex(input[pointer])) {
            const as_hex: u16 = @intCast(std.mem.indexOfScalar(u8, hex_alpha_lower, input[pointer]) orelse std.mem.indexOfScalar(u8, hex_alpha_upper, input[pointer]) orelse unreachable);
            value = value * 0x10 + as_hex;
            pointer += 1;
            length += 1;
        }
        // 5. If c is U+002E (.), then:
        if (pointer < input.len and input[pointer] == '.') {
            // 1. If length is 0, IPv4-in-IPv6-invalid-code-point validation error, return failure.
            if (length == 0) return error.InvalidURL;
            // 2. Decrease pointer by length.
            pointer -= length;
            // 3. If pieceIndex is greater than 6, IPv4-in-IPv6-too-many-pieces validation error, return failure.
            if (pieceIndex > 6) return error.InvalidURL;
            // 4. Let numbersSeen be 0.
            var numbersSeen: usize = 0;
            // 5. While c is not the EOF code point:
            if (pointer < input.len) {
                // 1. Let ipv4Piece be null.
                var ipv4Piece: ?u16 = null;
                // 2. If numbersSeen is greater than 0, then:
                if (numbersSeen > 0) {
                    // 1. If c is a U+002E (.) and numbersSeen is less than 4, then increase pointer by 1.
                    if (input[pointer] == '.' and numbersSeen < 4) {
                        pointer += 1;
                    }
                    // 2. Otherwise, IPv4-in-IPv6-invalid-code-point validation error, return failure.
                    else {
                        return error.InvalidURL;
                    }
                }
                // 3. If c is not an ASCII digit, IPv4-in-IPv6-invalid-code-point validation error, return failure.
                if (!std.ascii.isDigit(input[pointer])) return error.InvalidURL;
                // 4. While c is an ASCII digit:
                while (std.ascii.isDigit(input[pointer])) {
                    // 1. Let number be c interpreted as decimal number.
                    const dec_alpha = "0123456789";
                    const number: u8 = @intCast(std.mem.indexOfScalar(u8, dec_alpha, input[pointer]).?);
                    // 2. If ipv4Piece is null, then set ipv4Piece to number.
                    if (ipv4Piece == null) {
                        ipv4Piece = number;
                    }
                    // Otherwise, if ipv4Piece is 0, IPv4-in-IPv6-invalid-code-point validation error, return failure.
                    else if (ipv4Piece == 0) {
                        return error.InvalidURL;
                    }
                    // Otherwise, set ipv4Piece to ipv4Piece × 10 + number.
                    else {
                        ipv4Piece = ipv4Piece.? * 10 + number;
                    }
                    // 3. If ipv4Piece is greater than 255, IPv4-in-IPv6-out-of-range-part validation error, return failure.
                    if (ipv4Piece.? > 255) return error.InvalidURL;
                    // 4. Increase pointer by 1.
                    pointer += 1;
                }
                // 5. Set address[pieceIndex] to address[pieceIndex] × 0x100 + ipv4Piece.
                address[pieceIndex] = address[pieceIndex] * 0x100 + ipv4Piece.?;
                // 6. Increase numbersSeen by 1.
                numbersSeen += 1;
                // 7. If numbersSeen is 2 or 4, then increase pieceIndex by 1.
                if (numbersSeen == 2 or numbersSeen == 4) pieceIndex += 1;
            }
            // 6. If numbersSeen is not 4, IPv4-in-IPv6-too-few-parts validation error, return failure.
            if (numbersSeen != 4) return error.InvalidURL;
            // 7. Break.
            break;
        }
        // 6. Otherwise, if c is U+003A (:):
        else if (pointer < input.len and input[pointer] == ':') {
            // 1. Increase pointer by 1.
            pointer += 1;
            // 2. If c is the EOF code point, IPv6-invalid-code-point validation error, return failure.
            if (pointer == input.len) return error.InvalidURL;
        }
        // 7. Otherwise, if c is not the EOF code point, IPv6-invalid-code-point validation error, return failure.
        else if (pointer < input.len) {
            return error.InvalidURL;
        }
        // 8. Set address[pieceIndex] to value.
        address[pieceIndex] = value;
        // 9. Increase pieceIndex by 1.
        pieceIndex += 1;
    }
    // 7. If compress is non-null, then:
    if (compress != null) {
        // 1. Let swaps be pieceIndex − compress.
        var swaps = pieceIndex - compress.?;
        // 2. Set pieceIndex to 7.
        pieceIndex = 7;
        // 3. While pieceIndex is not 0 and swaps is greater than 0, swap address[pieceIndex] with address[compress + swaps − 1], and then decrease both pieceIndex and swaps by 1.
        while (pieceIndex != 0 and swaps > 0) {
            std.mem.swap(u16, &address[pieceIndex], &address[compress.? + swaps - 1]);
            pieceIndex -= 1;
            swaps -= 1;
        }
    }
    // 8. Otherwise, if compress is null and pieceIndex is not 8, IPv6-too-few-pieces validation error, return failure.
    else if (compress == null and pieceIndex != 8) {
        return error.InvalidURL;
    }
    // 9. Return address.
    return @bitCast(address);
}

/// https://url.spec.whatwg.org/#concept-opaque-host-parser
fn parseHostOpaque(allocator: std.mem.Allocator, input: []const u8) ![]const u8 {
    // 1. If input contains a forbidden host code point, host-invalid-code-point validation error, return failure.
    if (extras.matchesAny(u8, input, is_forbidden_host_codepoint)) return error.InvalidURL;
    // 2. If input contains a code point that is not a URL code point and not U+0025 (%), invalid-URL-unit validation error.
    {}
    // 3. If input contains a U+0025 (%) and the two code points following it are not ASCII hex digits, invalid-URL-unit validation error.
    {}
    // 4. Return the result of running UTF-8 percent-encode on input using the C0 control percent-encode set.
    return percentEncode(allocator, input, is_c0control_percent_char);
}

/// https://url.spec.whatwg.org/#utf-8-percent-encode
fn percentEncode(allocator: std.mem.Allocator, input: []const u8, comptime set: fn (u8) bool) ![]u8 {
    if (!extras.matchesAny(u8, input, set)) return allocator.dupe(u8, input);
    var result = std.ArrayList(u8).init(allocator);
    errdefer result.deinit();
    try result.ensureUnusedCapacity(input.len);
    try percentEncodeAL(&result, input, set);
    return result.toOwnedSlice();
}

/// https://url.spec.whatwg.org/#string-percent-decode
fn percentDecode(allocator: std.mem.Allocator, input: []const u8) ![]u8 {
    var result = std.ArrayList(u8).init(allocator);
    errdefer result.deinit();
    try result.ensureUnusedCapacity(input.len);
    var i: usize = 0;
    while (i < input.len) : (i += 1) {
        if (input[i] == '%') {
            if (input.len >= i + 1 + 2) {
                if (std.ascii.isHex(input[i + 1]) and std.ascii.isHex(input[i + 2])) {
                    try result.append(std.fmt.parseInt(u8, input[i + 1 ..][0..2], 16) catch unreachable);
                    i += 2;
                    continue;
                }
            }
        }
        try result.append(input[i]);
    }
    return result.toOwnedSlice();
}

/// https://url.spec.whatwg.org/#concept-domain-to-ascii
fn domainToAscii(allocator: std.mem.Allocator, domain: []const u8, beStrict: bool) ![]u8 {
    const result = unicode_idna.ToASCII(allocator, domain, beStrict, true, true, beStrict, false, beStrict, false) catch |err| switch (err) {
        error.IDNAFailure => return error.InvalidURL,
        error.OutOfMemory => return error.OutOfMemory,
    };
    errdefer allocator.free(result);
    if (!beStrict) {
        if (result.len == 0) return error.InvalidURL;
        if (extras.matchesAny(u8, result, is_forbidden_domain_codepoint)) return error.InvalidURL;
        return result;
    }
    std.debug.assert(result.len > 0);
    std.debug.assert(!extras.matchesAny(u8, result, is_forbidden_domain_codepoint));
    return result;
}

// https://url.spec.whatwg.org/#ends-in-a-number-checker
fn endsInANumber(input: []const u8) bool {
    // 1. Let parts be the result of strictly splitting input on U+002E (.).
    // 2. If the last item in parts is the empty string, then:
    {
        // 1. If parts’s size is 1, then return false.
        // 2. Remove the last item from parts.
    }
    // 3. Let last be the last item in parts.
    // 4. If last is non-empty and contains only ASCII digits, then return true.
    // > The erroneous input "09" will be caught by the IPv4 parser at a later stage.
    // 5. If parsing last as an IPv4 number does not return failure, then return true.
    // > This is equivalent to checking that last is "0X" or "0x", followed by zero or more ASCII hex digits.
    // 6. Return false.

    var end = input.len;
    var start: usize = if (std.mem.lastIndexOfScalar(u8, input[0..end], '.')) |i| i + 1 else 0;
    if (end - start == 0) {
        if (std.mem.count(u8, input, ".") == 0) return false;
        end = start - 1;
        start = if (std.mem.lastIndexOfScalar(u8, input[0..end], '.')) |i| i + 1 else 0;
    }
    const last = input[start..end];
    if (last.len > 0 and extras.matchesAll(u8, last, std.ascii.isDigit)) return true;
    parseIPv4Number(last, void) catch return false;
    return true;
}

/// https://url.spec.whatwg.org/#concept-ipv4-parser
fn parseIPv4(input: []const u8) !u32 {
    // 1. Let parts be the result of strictly splitting input on U+002E (.).
    var end = input.len;
    var parts_size = std.mem.count(u8, input[0..end], ".") + 1;
    // 2. If the last item in parts is the empty string, then:
    if (std.mem.endsWith(u8, input, ".")) {
        // 1. IPv4-empty-part validation error.
        // 2. If parts’s size is greater than 1, then remove the last item from parts.
        if (parts_size > 1) {
            end = std.mem.lastIndexOfScalar(u8, input, '.').?;
            parts_size -= 1;
        }
    }
    var iter = std.mem.splitScalar(u8, input[0..end], '.');
    // 3. If parts’s size is greater than 4, IPv4-too-many-parts validation error, return failure.
    if (parts_size > 4) return error.InvalidURL;
    // 4. Let numbers be an empty list.
    var numbers: [4]u32 = @splat(0);
    var numbers_len: u8 = 0;
    // 5. For each part of parts:
    while (iter.next()) |part| {
        // 1. Let result be the result of parsing part.
        // 2. If result is failure, IPv4-non-numeric-part validation error, return failure.
        const result = parseIPv4Number(part, u32) catch return error.InvalidURL;
        // 3. If result[1] is true, IPv4-non-decimal-part validation error.
        {}
        // 4. Append result[0] to numbers.
        numbers[numbers_len] = result;
        numbers_len += 1;
    }
    // 6. If any item in numbers is greater than 255, IPv4-out-of-range-part validation error.
    {}
    // 7. If any but the last item in numbers is greater than 255, then return failure.
    for (0..numbers_len - 1) |i| if (numbers[i] > 255) return error.InvalidURL;
    // 8. If the last item in numbers is greater than or equal to 256^(5 − numbers’s size), then return failure.
    if (numbers[numbers_len - 1] >= std.math.pow(u64, 256, 5 - numbers_len)) return error.InvalidURL;
    // 9. Let ipv4 be the last item in numbers.
    var ipv4 = numbers[numbers_len - 1];
    // 10. Remove the last item from numbers.
    numbers_len -= 1;
    // 11. Let counter be 0.
    // 12. For each n of numbers:
    for (numbers[0..numbers_len], 0..) |n, counter| {
        // 1. Increment ipv4 by n × 256^(3 − counter).
        ipv4 += @as(u32, @intCast(n)) * std.math.pow(u32, 256, 3 - @as(u8, @intCast(counter)));
        // 2. Increment counter by 1.
    }
    // 13. Return ipv4.
    return ipv4;
}

// https://url.spec.whatwg.org/#ipv4-number-parser
fn parseIPv4Number(input_: []const u8, T: type) !T {
    var input = input_;
    // 1. If input is the empty string, then return failure.
    if (input.len == 0) return error.Invalid;
    // 2. Let validationError be false.
    var validationError = false;
    // 3. Let R be 10.
    var radix: u8 = 10;
    // 4. If input contains at least two code points and the first two code points are either "0X" or "0x", then:
    if (std.mem.startsWith(u8, input, "0X") or std.mem.startsWith(u8, input, "0x")) {
        // 1. Set validationError to true.
        validationError = true;
        // 2. Remove the first two code points from input.
        input = input[2..];
        // 3. Set R to 16.
        radix = 16;
    }
    // 5. Otherwise, if input contains at least two code points and the first code point is U+0030 (0), then:
    else if (input.len >= 2 and input[0] == '0') {
        // 1. Set validationError to true.
        validationError = true;
        // 2. Remove the first code point from input.
        input = input[1..];
        // 3. Set R to 8.
        radix = 8;
    }
    // 6. If input is the empty string, then return (0, true).
    if (input.len == 0 and T == void) return;
    if (input.len == 0 and T != void) return 0;
    // 7. If input contains a code point that is not a radix-R digit, then return failure.
    switch (radix) {
        8 => for (input) |c| switch (c) {
            '0'...'7' => {},
            else => return error.Invalid,
        },
        10 => for (input) |c| if (!std.ascii.isDigit(c)) return error.Invalid,
        16 => for (input) |c| if (!std.ascii.isHex(c)) return error.Invalid,
        else => unreachable,
    }
    // 8. Let output be the mathematical integer value that is represented by input in radix-R notation, using ASCII hex digits for digits with values 0 through 15.
    // 9. Return (output, validationError).
    if (T == void) return;
    const output = std.fmt.parseInt(T, input, radix) catch return error.Invalid;
    return output;
}

//
//
//
//

/// https://infra.spec.whatwg.org/#c0-control
fn is_c0control(c: u8) bool {
    if (c >= 0x00 and c <= 0x1F) return true;
    return false;
}
/// https://infra.spec.whatwg.org/#c0-control-or-space
fn is_c0control_or_space(c: u8) bool {
    if (is_c0control(c)) return true;
    if (c == ' ') return true;
    return false;
}
/// https://url.spec.whatwg.org/#forbidden-host-code-point
fn is_forbidden_host_codepoint(c: u8) bool {
    if (c == 0) return true;
    if (c == '\t') return true;
    if (c == '\n') return true;
    if (c == '\r') return true;
    if (c == ' ') return true;
    if (c == '#') return true;
    if (c == '/') return true;
    if (c == ':') return true;
    if (c == '<') return true;
    if (c == '>') return true;
    if (c == '?') return true;
    if (c == '@') return true;
    if (c == '[') return true;
    if (c == '\\') return true;
    if (c == ']') return true;
    if (c == '^') return true;
    if (c == '|') return true;
    return false;
}
/// https://url.spec.whatwg.org/#forbidden-domain-code-point
fn is_forbidden_domain_codepoint(c: u8) bool {
    if (is_forbidden_host_codepoint(c)) return true;
    if (is_c0control(c)) return true;
    if (c == '%') return true;
    if (c == 0x7f) return true;
    return false;
}
/// https://url.spec.whatwg.org/#url-code-points
fn is_url_codepoint(c: u21) bool {
    if (c < 128 and std.ascii.isAlphanumeric(@intCast(c))) return true;
    if (c == '!') return true;
    if (c == '$') return true;
    if (c == '&') return true;
    if (c == '\'') return true;
    if (c == '(') return true;
    if (c == ')') return true;
    if (c == '*') return true;
    if (c == '+') return true;
    if (c == ',') return true;
    if (c == '-') return true;
    if (c == '.') return true;
    if (c == '/') return true;
    if (c == ':') return true;
    if (c == ';') return true;
    if (c == '=') return true;
    if (c == '?') return true;
    if (c == '@') return true;
    if (c == '_') return true;
    if (c == '~') return true;
    // and code points in the range U+00A0 to U+10FFFD, inclusive,
    // excluding surrogates and noncharacters.
    if (c >= 0x00A0 and c <= 0x10FFFD) return true;
    return false;
}
/// https://url.spec.whatwg.org/#c0-control-percent-encode-set
fn is_c0control_percent_char(c: u8) bool {
    if (c >= 0x00 and c <= 0x1F) return true;
    return c > 0x7E;
}
/// https://url.spec.whatwg.org/#query-percent-encode-set
fn is_query_percent_char(c: u8) bool {
    if (c == ' ') return true;
    if (c == '"') return true;
    if (c == '#') return true;
    if (c == '<') return true;
    if (c == '>') return true;
    return is_c0control_percent_char(c);
}
/// https://url.spec.whatwg.org/#path-percent-encode-set
fn is_path_percent_char(c: u8) bool {
    if (c == '?') return true;
    if (c == '^') return true;
    if (c == '`') return true;
    if (c == '{') return true;
    if (c == '}') return true;
    return is_query_percent_char(c);
}
/// https://url.spec.whatwg.org/#special-query-percent-encode-set
fn is_special_query_percent_char(c: u8) bool {
    if (c == '\'') return true;
    return is_query_percent_char(c);
}
/// https://url.spec.whatwg.org/#fragment-percent-encode-set
fn is_fragment_percent_char(c: u8) bool {
    if (c == ' ') return true;
    if (c == '"') return true;
    if (c == '<') return true;
    if (c == '>') return true;
    if (c == '`') return true;
    return is_c0control_percent_char(c);
}
/// https://url.spec.whatwg.org/#userinfo-percent-encode-set
fn is_userinfo_percent_char(c: u8) bool {
    if (c == '/') return true;
    if (c == ':') return true;
    if (c == ';') return true;
    if (c == '=') return true;
    if (c == '@') return true;
    if (c >= '[' and c <= ']') return true;
    if (c == '|') return true;
    return is_path_percent_char(c);
}
// /// https://url.spec.whatwg.org/#component-percent-encode-set
// fn is_component_percent_char(c: u8) bool {
//     if (c >= '$' and c <= '&') return true;
//     if (c == '+') return true;
//     if (c == ',') return true;
//     return is_userinfo_percent_char(c);
// }
// /// https://url.spec.whatwg.org/#application-x-www-form-urlencoded-percent-encode-set
// fn is_formurlencoded_percent_char(c: u8) bool {
//     if (c == '!') return true;
//     if (c >= '\'' and c <= ')') return true;
//     if (c == '~') return true;
//     return is_component_percent_char(c);
// }

/// Asserts b is a valid UTF-8 codepoint
fn l(b: u8) u3 {
    return std.unicode.utf8ByteSequenceLength(b) catch unreachable;
}
fn lastcpi(haystack: []const u8) usize {
    var i = haystack.len - 1;
    while (haystack[i] & 0xC0 == 0x80) : (i -= 1) {}
    return i;
}
fn percentEncodeScalarAL(list: *std.ArrayList(u8), cp: []const u8, comptime set: fn (u8) bool) !void {
    if (set(cp[0])) {
        for (cp) |b| {
            try list.append('%');
            try list.writer().print("{X:0>2}", .{b});
        }
    } else {
        try list.append(cp[0]);
    }
}
fn percentEncodeAL(list: *std.ArrayList(u8), input: []const u8, comptime set: fn (u8) bool) !void {
    var it = std.unicode.Utf8View.initUnchecked(input).iterator();
    while (it.nextCodepointSlice()) |sl| {
        if (set(sl[0])) {
            for (sl) |b| {
                try list.append('%');
                try list.writer().print("{X:0>2}", .{b});
            }
        } else {
            try list.appendSlice(sl);
        }
    }
}
fn percentEncodeScalarML(list: *ManyArrayList(15, u8), n: usize, cp: []const u8, comptime set: fn (u8) bool) !void {
    if (set(cp[0])) {
        for (cp) |b| {
            try list.appendSlice(n, &.{'%'});
            try list.print(n, "{X:0>2}", .{b});
        }
    } else {
        try list.appendSlice(n, &.{cp[0]});
    }
}
fn percentEncodeML(list: *ManyArrayList(15, u8), n: usize, input: []const u8, comptime set: fn (u8) bool) !void {
    var it = std.unicode.Utf8View.initUnchecked(input).iterator();
    while (it.nextCodepointSlice()) |sl| {
        if (set(sl[0])) {
            for (sl) |b| {
                try list.appendSlice(n, &.{'%'});
                try list.print(n, "{X:0>2}", .{b});
            }
        } else {
            try list.appendSlice(n, sl);
        }
    }
}
fn setHost(href: *ManyArrayList(15, u8), h: URL.Host) !void {
    switch (h) {
        .unset => unreachable,
        .name => {
            try href.set(7, h.name);
        },
        .ipv4 => {
            const bytes: [4]u8 = @bitCast(h.ipv4);
            try href.print(7, "{d}.{d}.{d}.{d}", .{ bytes[3], bytes[2], bytes[1], bytes[0] });
        },
        .ipv6 => {
            const pieces: [8]u16 = @bitCast(h.ipv6);
            try href.appendSlice(7, "[");
            const compress = blk: {
                var longest: struct { ?usize, u8 } = .{ null, 1 };
                var found: struct { ?usize, u8 } = .{ null, 0 };
                for (&pieces, 0..) |piece, pieceIndex| {
                    if (piece != 0) {
                        if (found[1] > longest[1]) {
                            longest[0] = found[0];
                            longest[1] = found[1];
                        }
                        found[0] = null;
                        found[1] = 0;
                    } else {
                        if (found[0] == null) found[0] = pieceIndex;
                        found[1] += 1;
                    }
                }
                if (found[1] > longest[1]) break :blk found[0];
                break :blk longest[0];
            };
            var ignore0 = false;
            for (&pieces, 0..) |piece, pieceIndex| {
                if (ignore0) {
                    if (piece == 0) continue;
                    ignore0 = false;
                }
                if (compress == pieceIndex) {
                    try href.appendSlice(7, if (pieceIndex == 0) "::" else ":");
                    ignore0 = true;
                    continue;
                }
                try href.print(7, "{x}", .{piece});
                if (pieceIndex != 7) try href.appendSlice(7, ":");
            }
            try href.appendSlice(7, "]");
        },
    }
}
pub fn replaceInPlace(comptime T: type, input: []T, needle: []const T, replacement: []const T) usize {
    // Empty needle will loop until output buffer overflows.
    std.debug.assert(needle.len > 0);
    std.debug.assert(needle.len >= replacement.len);

    var slide: usize = 0;
    var replacements: usize = 0;
    while (std.mem.indexOf(u8, input[slide..], needle)) |idx| {
        slide += idx;
        std.mem.copyForwards(u8, input[slide..], replacement);
        slide += replacement.len;
        std.mem.copyForwards(u8, input[slide..], input[slide..][needle.len - replacement.len ..]);
        slide += needle.len - replacement.len;
        replacements += 1;
    }
    return replacements;
}

pub fn ManyArrayList(N: usize, T: type) type {
    return struct {
        list: std.ArrayList(T),
        lengths: [N]usize,

        pub fn init(allocator: std.mem.Allocator) @This() {
            return .{
                .list = .init(allocator),
                .lengths = @splat(0),
            };
        }

        pub fn deinit(self: *@This()) void {
            self.list.deinit();
        }

        pub fn set(self: *@This(), n: usize, slice: []const T) !void {
            const real_n = extras.sum(usize, self.lengths[0..n]);
            try self.list.replaceRange(real_n, self.lengths[n], slice);
            self.lengths[n] = slice.len;
        }

        pub fn items(self: *@This(), n: usize) []T {
            const real_n = extras.sum(usize, self.lengths[0..n]);
            const len = self.lengths[n];
            return self.list.items[real_n..][0..len];
        }

        pub fn clear(self: *@This(), n: usize) void {
            const real_n = extras.sum(usize, self.lengths[0..n]);
            self.list.replaceRangeAssumeCapacity(real_n, self.lengths[n], &.{});
            self.lengths[n] = 0;
        }

        pub fn print(self: *@This(), n: usize, comptime fmt: []const u8, args: anytype) !void {
            var buffer: [64]u8 = undefined;
            const slice = std.fmt.bufPrint(&buffer, fmt, args) catch unreachable;
            return self.appendSlice(n, slice);
        }

        pub fn appendSlice(self: *@This(), n: usize, slice: []const T) !void {
            const real_n = extras.sum(usize, self.lengths[0 .. n + 1]);
            try self.list.insertSlice(real_n, slice);
            self.lengths[n] += slice.len;
        }

        pub fn replace(self: *@This(), n: usize, o: usize, c: usize, slice: []const T) !void {
            std.debug.assert(o + c <= self.lengths[n]);
            const real_n = extras.sum(usize, self.lengths[0..n]);
            try self.list.replaceRange(real_n + o, c, slice);
            self.lengths[n] -= c;
            self.lengths[n] += slice.len;
        }
    };
}
