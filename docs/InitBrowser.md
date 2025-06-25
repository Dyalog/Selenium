InitBrowser ⍵

The function InitBrowser takes a right argument which is a character vector indicating the name of the browser. If ⍵ is empty, the first found of Chrome, Firefox or Edge will be used. If the element is empty, the `Browser` element from `settings.json5` will be used and if that is also not available, we'll check the `DEFAULTBROWSER` variable in the Selenium namespace.