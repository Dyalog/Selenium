# Driving Selenium from Dyalog APL

[Selenium](http://seleniumhq.org) is a widely used open-source tool for automating browsers, with growing support from browser vendors. The GitHub repository [Dyalog/Selenium](https://github.com/Dyalog/Selenium) contains code which allows Dyalog applications to drive browsers via Selenium.

The namespace Selenium contained in this repository contains cover-functions for some of the most frequently used features of Selenium. The tool uses two Microsoft.NET assemblies and, depending on the browser used, browser-dependent support executables that are brought in using NuGet.

In contrast to earlier versions it is not neccessary to search for version-specific browser-related
binaries, instead a .json file needs to indicate which browser (and which version) are used for testing.
