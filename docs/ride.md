# Testing RIDE with Selenium

The namespace `Selenium.ride` contains functions that support testing RIDE (standalone or zero footprint). The folder [`Samples/RIDE`](../Samples/RIDE) contains several tests that illustrate its usage.

## Status

This is work in progress currently. Some of the fns do not work as advertised and the connection process is a bit "flaky" - interpreter work is on the way to improve the situation.

## Expectations

This section lists the underlying assumptions made in the RIDE tests when accessing the session etc.

- Lines of the session should have the class "view-lines"