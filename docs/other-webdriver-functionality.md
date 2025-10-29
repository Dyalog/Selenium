# Other WebDriver Functionality

Instances of the Selenium WebDriver classes support significant functionality which is not covered by the existing Selenium namespace. The full set of methods and properties exposed by WebDriver.dll and WebDriver.Support.dll, which are documented here on the Selenium web site:
[https://www.selenium.dev/documentation/webdriver/](https://www.selenium.dev/documentation/webdriver/)

After [`InitBrowser`](InitBrowser.md) has been called, the variable `BROWSER` is a reference to the current instance. It exposes several methods which are not covered by the Selenium namespace, but can be called from APL after consulting the Selenium documentation. It also exposes a number of interesting properties.

The ACTIONS variable is a reference to an instance of an Actions object, which also exposes functions not currently supported by any of the functions in the Selenium namespace:

    - DragAndDropToOffset  
    - KeyDown  
    - KeyUp  
    - Release

It is also worth mentioning `Selenium.BROWSER.Navigate.Refresh` which can be useful when experimenting in the session to refresh the current page.
There is scope for future extensions to the tool, suggestions and pull requests are most welcome!
