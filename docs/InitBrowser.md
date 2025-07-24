{⍺}InitBrowser ⍵

The function InitBrowser takes a right argument which is a character vector indicating the name of the browser. If the element is empty, the system will look for an environment variable `SELENIUM_DRIVER` or used the `Browser` element from `settings.json5` will be used and if both are also not available, check the `DEFAULTBROWSER` variable in the Selenium namespace.

The name should either be one of the browsers currently supported by Selenium (`Chrome`, `Firefox`, `Edge`) or one of the browsers defined in settings.json5.

!!!Note
   The browser names are case-senstive!

The optional left argument is a boolean indicating if we're re-initialising the browser - it saves the time required to setup of the NuGet components and simply re-initializes the browser driver. This can be useful when the browser was closed.

`InitBrowser` creates an object `BROWSER` in the Selenium namespace which is used for further interaction with the browser. `BROWSER` is an instance of the [Selenium WebDriver](https://www.selenium.dev/documentation/webdriver/) linked to your specific browser's .NET driver. It will also create a variable `CURRENTBROWSER` with the name of the driver instantiated in `BROWSER` and `ACTIONS` which is a reference to an instance of Selenium.Interactions.Actions, used to automate mouse movements.
