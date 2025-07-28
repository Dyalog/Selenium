# Goto url

Calls the `Navigate.GoToUrl` method and verifies that the Url property subsequently has the desired value. Signals an error if navigation fails. While `Navigate.GoToUrl` requires a complete URL, you may also specify relative URLs here (omitting protocol, domain & port).
If the first 4 characters of the URL match either `'http'` or `'file'`, we assume it is a complete URL, otherwise it wil be treated as being relative to the current URL.
