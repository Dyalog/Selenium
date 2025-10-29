# Goto url

Calls the `Navigate.GoToUrl` method and verifies that the Url property subsequently has the desired value. Signals an error if navigation fails. While `Navigate.GoToUrl` requires a complete URL, you may also specify relative URLs here (omitting protocol, domain & port).
If the first 4 characters of the URL match either `'http'` or `'file'`, we assume it is a complete URL, otherwise it wil be treated as being relative to the current URL.

## We hope to be helpful

There is an interesting challenge when writing cross-platform tests that run on local .html files: you typically have to specify a fully qualified path, such as `c:/documents/foo.html` on Windows or `/Users/Dyalog/Documents/foo.html` on macOS.

The URL for these files uses the `file://` protocol. The standard URI syntax requires a hostname after the protocol, which is represented by two slashes, `//`. Since local files have no hostname, a third slash is used to indicate the start of the file path. This leads to the standard prefix `file:///`.

The correct URLs are therefore:
- On **Windows**: `file:///c:/documents/foo.html`
- On **macOS**: `file:///Users/Dyalog/Documents/foo.html`

The challenge arises if you try to build this URL dynamically. If you have a variable containing the platform-specific path and then prepend `file://`, you will be missing a slash on both Windows and macOS, resulting in an incorrect URI.

To mitigate this common cross-platform issue, the `GoTo` command has a built-in tolerance. It will detect occurrences of `file://` followed by a path that begins with `/` (on macOS) or a drive letter (on Windows) and will intelligently add the missing third slash to form the correct `file:///` prefix, ensuring the command works as expected on both platforms.