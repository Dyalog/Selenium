# Selenium QA Tools for Dyalog APL

This folder contains code which allows Dyalog to automate browsers using [Selenium WebDriver](http://www.seleniumhq.org/)
under Microsoft Windows, using the Microsoft.Net bindings for Selenium.

It has been tested with Firefox and Google Chrome; drivers should also be available for Internet Explorer
and other browsers.

## Required DLLs

Depending on the browser you are using, you  may need different drivers.
We have collected various versions of drivers for Chrome, Firefox end Edge
which are available in the folder-layout documented here on the [Downloads](https://github.com/Dyalog/Selenium/releases/latest) page of this repository.
If you need to find other versions, the "Browser"-Section of the [Selenium Downloads-page](https://www.selenium.dev/downloads/) is a good starting-point.

**Note that in recent versions of Microsoft Windows, you will need to "Unblock" them after downloading them, before Windows will allow you to use them.**

### Folder-Layout

The following folder-structure has proven to be useful.

````language=text
Drivers--+-->Chrome81---+->Linux
         |              +->Mac
         |              +->Win
         +-->Chrome80...
         +-->WebDriver3
         +-->WebDriver4
         +-->more-------+---->newtonsoft-120r3net47
                        +---->newtonsoft_120r3-netstandard2.0
````
NB: depending on your use of .Net, you may only need one of the two folders for (Newtonsoft)[https://www.newtonsoft.com/json]. Seleniums does not require a specific version of it (but needs at least ≥12.0 ) and the path (below DRIVER) is configureable in settings.json.

With Microsoft Egde, the structure gets another level of differentiation, as Egde has different drivers for Windows-32 and Windows-64:

````language=text
Drivers--+-->Edge83----+->Linux
                       +->Mac
                       +->Win
                            +->32
                            +->64
````

When looking for a driver, we will first look in the `Drivers`-folder that the corresponding entry in settings.json points to.
If we do not find the driver there, we'll look for a platform-specific subfolder and possibly look for the appropriate bits-folder.
The filename of the driver is by default composed using the `BROWSER`-Entry to the corresponding setting prefixed to the text "Driver". On Windows, the extension `.exe` is appended.
You will need to pick the appropriate driver for the browsers you're testing against. (With Chrome, for example, click `⁞` at the right edge of the URL-bar to open a menu with more
options, select "Help" and "About Chrome". If that version is not included, [download the file chromedriver.exe](https://chromedriver.chromium.org/downloads) and
put it into a folder within that structure.)

### Configuration (settings.json)

The file settings.json holds the configuration of drivers and spexcifies associated details such as location of required files. It has the following mandatory components:

* a char-field "**DLLPATH**" which holds the path for the WebDriver to use. Currently WebDriver3 is 2yrs old while WebDriver4
  is being developed, but still in alpha-stage. Which driver you use depends on whether you're using the .net Framework (WebDriver3)
  or .NET Core (WebDriver4).
  * **Newtonpath**: name of a subfolder (below DLLPATH= that has the DLLs for (Newtonsoft)[https://www.newtonsoft.com/json] (a dependency of Selenium)
* a numeric field "**PORT**" defining the port that the browser uses to retrieve data
* named configurations (settings of parameters) with these elements:
  * **BROWSER**: the name of the brower
  * **DRIVER**: specifies the path where the driver-files are stored.  If drivers are available for different platforms, create subdirectories named `Linux`, `Win` and/or `Mac`..
  * [**PORT**]: while the first 2 settings are mandatory for a browser-configuration, this parameter
    as well as the following ones are optional.
  * [**Executable**]: we assume that the required driverfile is BROWSER (lowercace),"driver". If this does not apply
      (the driver for Firefox is called geckodriver), this options enables you to specify the name directly (no extension!)
  * [**OptionsInstanceOf**]: (*advanced stuff*) if present, can be used to create additional parameters that are
    passed to the constructor of the browser-service that we're instiating.
  * [**Options**]: when OptionsInstanceOf is used, this parameter is mandatory. It contains a JSON-description of an
    array with one or more options of the specific driver. (See [this link](https://www.selenium.dev/selenium/docs/api/dotnet/html/T_OpenQA_Selenium_Chrome_ChromeOptions.htm) for an example of ChromeOptions)



## Demos or Samples

### DUI-Tests
(The following assumes a folder-structure which has the [DUI-Repository](https://github.com/Dyalog/DUI) in /git. Adjust paths as neccessary.)

Start one APL-Session, `)load /git/dui/DUI` and `Start'./MS3' 8080`
Start another APL-Session, `)load /git/dui/DUI` and `[1] DUI.Test'./MS3'`. The syntax of Test is `[pause]DUI.Test site[page [browser]]`:  if the optional left argument `pause=1`, we will pause after a test has failed. `page` is the name of the specific page you want to test Chrome81 is the name of a config for most recent Chrome (at the time of writing this).

### Plain tests
To write your own tests of website, you can ]LOAD Selenium.dyalog and then

````
Selenium.ApplySettings''  ⍝ get default-settings (recommended)
b←Selenium.InitBrowser''  ⍝ instantiate configured browser
````

## More Documentation

See "[Selenium from Dyalog.pdf](./Selenium%20from%20Dyalog.pdf)" (docx source in the DocSrc folder).

## Issues

* occassionally the client may throw an error similar to the following one when creating a Selenium-Instance:

```language=text
Could not load webdriver.dll and webdriver.support.dll from c:/Selenium/Drivers/ChromeDriver79/ ─ they may be blocked (Properties>General>Unblock)

Test[..] Selenium.InitBrowser''
         ∧
```

"Unblocking" as described may help (the first time). However, since other reasons may cause this problem as well, we also show exceptions (usually .net-Exceptions give clear indication of the problem, though they may be verbose at times...)
