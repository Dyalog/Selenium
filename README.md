# Selenium QA Tools for Dyalog APL

This folder contains code which allows Dyalog to automate browsers using [Selenium WebDriver](http://www.seleniumhq.org/)
under Microsoft Windows, using the Microsoft.Net bindings for Selenium.

It has been tested with Firefox and Google Chrome; drivers should also be available for Internet Explorer
and other browsers.

## Required DLLs

You may need to download the C# language bindings from the Selenium site (we provide the current version in the WebDrivers-Folder).
**Note that in recent versions of Microsoft Windows, you will need to "Unblock" them after downloading them, before Windows will allow you to use them.**

If you will be using Mozilla FireFox, the above 2 DLL's are all you need. Other browsers require the installation of additional components, support is available for several browsers.

For example, to use Google Chrome, you need to [download the file chromedriver.exe](https://sites.google.com/a/chromium.org/chromedriver/downloads).

## Documentation

See "[Selenium from Dyalog.pdf](/Selenium%20from%20Dyalog.pdf)" (docx source in the DocSrc folder).

## Issues

* can we put the common files webdriver.dll and webdriver.support.dll into one place (ie Drivers)?
