# Settings browser options

Selenium provide several layers to control its behavior (and that of the browser it controls):

## Environment variables / Configuration settings

This refers to variables that are set up in the environment that the interpreter's executable runs in or in a CONFIGFILE or USERCONFIGFILE that it uses.

### SELENIUM_HOME

The config variable `SELENIUM_HOME` is the first candidate that Selenium looks at when it searches its [home directory](faq.md#where-do-we-live).

### SELENIUM_CONFIGFILE

This optional variable can be defined to point to a .json5 file with the configuration to use. This file will then complement the settings found in Selenium's `settings.json5`.

## Setting options in the Selenium namespace

### DEFAULTRETRYLIMIT

The number of seconds that the Retry operator and its derivatives should retry an operation.


### SELENIUM_HOME

The variable `SELENIUM_HOME` is supposed to contain the path to Selenium's settings file. If is not defined, we [determine](faq.md#where-do-we-live) the path and store it in this variable for further references.

### PORT

The address of the port that the browser uses to retrieve content.

## The configuration file `settings.json5`

In earlier versions of our implementation, this file needed frequent updates in order to adjust to the latest browser versions. 
With the release 2.0 we are using new features of Selenium that help to identify browsers version and load suitable drivers.
Consequently this file now has a more static nature and should not need updates by the user.

When new versions of Selenium and its drivers are released, we may update the file - it is therefore advised to no longer keep 
local versions of it, but instead treat it as part of the code.