# r←{selector}Find id

Allows searching for DOM elements by Id (the default if no left argument is provided) or one of the other selectors: ClassName,  CssSelector, Id, LinkText, Name, PartialLinkText, TagName or XPath.

In order to find multiple elements (when using options such as `ClassName`, `CssSelector` etc.) simply append a plural-s to the criteria (i.e. `'ClassNames'Find'...'`)

The result `r` will either be an instance of `IWebElement` or the scalar 0 if the element was not found.

`Find` will retry the search for an element until `RETRYLIMIT` has elapsed, so if it takes time for a page to render completely, or an element is created by an earlier action, it will wait for a while.
While it is possible to find hidden elements, it is not possible to interact with them (click or enter text into input controls). The `IWebElement`instances provide a boolean `Displayed` that can be used to check if an element is visible or not.

!!!info
   Our own test `Tests/test_find.aplf` illustrates practical uses of `Find` with diverse criteria.
<!--- can we link directly to the file? -->
