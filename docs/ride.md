# Testing RIDE with Selenium

The namespace `Selenium.ride` contains functions that support testing RIDE (standalone or zero footprint). The folder `Samples/RIDE` contains several tests that illustrate its usage.

## Usage

### InitRIDE (browser port)

The function `InitRIDE` launches a new interpreter instance.

#### browser

Selects how and where you want to run Ride:

* to run zero footprint Ride in a browser, pick an entry from Selenium's [settings.json5](settings.md) file (ie. `Chrome`, `Firefox` or even `HtmlRenderer`).

* to test the native Ride client, pass the fully qualified name of its executable.

In any case, `InitRIDE` will also launch an interpreter (a 2nd instance of the one in which you called it) and connect Ride to it. (Or the Ride client will start it.)

#### Port
 It is always an "interesting question" which port to use. Fortunately v20 significantly improves this
process by allowing to assign port 0 and have the interpreter use a free one. For versions &lt; 20, this is a manual process: the system will attempt to use the default
port and the user has to observe the launch and see if Dyalog started w/o an error message about the port being used or not. Two different statements to continue
processing depending on the result will be printed into the session and then InitRIDE will temporary interrupt with an intended error.

## Special considerations

When testing against [CEF](terminology.md#CEF) we are dealing with reduced functionality in Selenium. In addition, Ride 
internally uses the [Monaco editor](terminology.md#MonacoEditor)