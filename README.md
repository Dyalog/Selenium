Selenium QA Tools for Dyalog APL
=====
This folder contains code which allows Dyalog to automate browsers using [Selenium WebDriver](http://www.seleniumhq.org/)
under Microsoft Windows, using the Microsoft.Net bindings for Selenium.

It has been tested with Firefox and Google Chrome; drivers should also be available for Internet Explorer
and other browsers.

##Required DLLs
You need to download the C# language bindings from the Selenium site. In particular, you need
to put the files WebDriver.dll and WebDriver.Support.dll in a known location. Note that in recent versions of Microsoft Windows, you will need to "Unblock" them after downloading them, before Windows will allow you to use them.

If you will be useing FireFox, the above 2 DLL's are all you need. Other browesers require the installation of additional components, support is available for several browsers.

For example, to use Google Chrome, you need to [download the file chromedriver.exe](https://sites.google.com/a/chromium.org/chromedriver/downloads).

##Documentation
Is coming... Until then, see the files in the Samples folder.
