# FAQ

## Where do we live?

Determining a function's home folder (that it was loaded from) is a popular question in times of text-based code. Selenium needs to answer it so that it knows where to look for its settings file (settings.json5).

Because Selenium can be brought into the WS in a variety of ways (recommened: using Tatin) it tries to handle this using several alternative techniques:

- look for an environment variable `SELENIUM_HOME`
- use `50[⎕ATX](https://dyalog.github.io/documentation/20.0/language-reference-guide/system-functions/atx/)`
- look for a `SALT_Data` namespace in the Selenium ns (as `]Load` would create)

If one of these approaches gives us a valid path, it is assigned to the variable `SELENIUM_HOME` which is used to answer the question the next time it is asked.
Therefore, depending on the setup in which you use Selenium, you can also initialise `Selenium.SELENIUM_HOME` with the path to `settings.json5` or rely on Tatin or Link and not worry about it all.

!!!Hint
   Please note that `SELENIUM_HOME` points to Selenium's base folder (the folder that contains the `APLSource` directory witht the individual functions.)