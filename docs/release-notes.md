# Release notes

## 2017 05 09 Adam

* Version info added

## 2017 05 23 Adam

* now gives helpful messages for DLL problems, harmonised ADOC utils

## 2020 02 12 MBaas 2.10

*  updated to use a config (.json)-file to facilitate testing with various browsers (incl. HTMLRenderer)

## 2020 05 08 MBaas

* preparing for cross-platformness;
* new folder-structure for drivers

## 2020 07 11 MBaas

* lots of changes to make it working on ALL platforms
* revised structure of settings (AND names of parameter DRIVERS → DRIVER)

## 2021 11 15 MBaas: 2.11.0 

* settings.json may now use "SELENIUM_DRIVERPATH" to point to the folder with the downloaded drivers -this way it becomes more generally usable and less platform-dependent. 
* Changed to semantic versioning. 
* Settings file now uses JSON5.

## 2021 02 22 MBaas: MAJOR UPDATE (branch WebDriver4)

* now using WebDriver4 and NuGet. This removes the need to distribute DLLs. (started development on branch "WebDriver4")
* removed all paths from settings.json
* * we're aiming to keep all changes "under the cover". Selenium should behave as before.

## 2024 04 15 MBaas

* replaced BHC's NugetConsum with the Dyalog's "officiat" NuGet package (this should really be a Tatin dependency and will soon be changed)
* enhanced WaitFor to not only WaitFor a text to appear but also to wait for the element itself to appear
* No other outstanding items atm...(more testing needed)
* Not yet cross-platform (BHC is on it...)

**NB**: if you previously did `ApplySettings 'foo'` followed by `InitBrowser''`, you should now combine these calls with `InitBrowser 'foo'`

## 2024 05 08 MBaas 

* optional ⍺ to ReInitBrowser to support re-initialization of the browser (useful to reconnect when HtmlRenderer was closed and re-opened)
* *SetInputValue did not work as expected - fixed. (NB: it now clears the control before setting text)


## 2025 07 30 MBaas, V2.0.0 - major update

* in addition to Chrome, we now also support Firefox and Edge browsers
* Selenium should work with the browser version that's installed 
* without any tweaking of settings...
* uses Cider & Tatin
* converted doc to be MkDocs based, updated it.
* converted from scripted ns to individual files for the functions
* GoTo now also supports file:// URLs
* "WaitFor" was not working as expected with textarea-elements
* remove ⍺ from InitBrowser
* added "End" method to dispose .NET artifacts from memory and disc
* ExecuteScript now supports passing arguments to the js code (in ⍺) - see SetInputValue for an example
* SetInputValue passes values with JS which means that even APL characters can be set
* SendKeys simplified internally thanks to recent changes in Selenium and WebDriver4
* MoveToElement did no work as expected when only ⍵[1] was given - fixed
* new functions Savescreenshot and CompareScreenshots to deal with screenshots
* function GetLogs can be used to access the browser logs
* Select has been significantly improved and offers more options to identify the target element

**BREAKING CHANGES:**
* Dyalog no longer distributes the Syncfusion controls, so the utilities dealing with them (`ejAccordinTab` and `ListMgrSelect`) were removed.
