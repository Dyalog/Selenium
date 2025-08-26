# Testing RIDE with Selenium (work in progress)

The namespace `Selenium.ride` contains functions that support testing RIDE (standalone or zero footprint). The folder `Samples/RIDE` contains several tests that illustrate its usage.

## Status

This is work in progress currently. Some of the fns do not work as advertised.

## Expectations

This section lists the underlying assumptions made in the RIDE tests when accessing the session etc.

- Lines of the session should have the class "view-lines"

## Usage

### InitRIDE

The function `InitRIDE` launches a new interpreter instance. It is always an "interesting question" which port to use. Fortunately v20 significantly improves this
process by allowing to assign port 0 and have the interpreter use a free one. For versions &lt; 20, this is a manual process: the system will attempt to use the default
port and the user has to observe the launch and see if Dyalog started w/o an error message about the port being used or not. Two different statements to continue
processing depending on the result will be printed into the session and then InitRIDE will temporary interrupt with an intended error.
