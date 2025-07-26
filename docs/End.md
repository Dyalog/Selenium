# End
<a name="end"></a>

As you have noticed, running a test opens a console-window showing the output of the webdriver that was launched – which will in turn launch the browser. In order to close the windows at the end of a test, it is recommended to call the `End` function which will close those windows and dispose all objects it created.

As the code uses NuGet, [`InitBrowser`](InitBrowser.md) will create a temporary project folder for NuGet to work with which `End` will also delete. (If you do not call `End` in your tests, you may want to check the variable `Selenium.myNuGetFolder` and make sure the folder is deleted.)
