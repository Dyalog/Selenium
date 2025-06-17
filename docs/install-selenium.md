# Installing Selenium

Selenium is available as a [Tatin](http://tatin.dev) package.

### when using Tatin

First, use `]TATIN.ListPackages [tatin] -tags=selenium` to find out which versions are available.
***to be continued***

### when not using Tatin (and still using it)

Even when not using Tatin (in the code you write and want to deploy) you probably have Tatin installed
and can use it. If you feel comfortable doing so, `]Tatin.LoadPackages dyalog-selenium,dyalog-nuget` can be used to bring in the Selenium namespace (and the NuGet package that it depends on) into #.

### without Tatin

You'll need the Selenium namespace as well as NuGet. There are infinite ways to get them, such as

* cloning the repositories
* downloading the required files from the home repositories
* and more.

 We'll trust you'll have your own methods to get the files.
