# Inspecting the Contents of the Page

The Selenium namespace contains a number of functions which manipulate the browser in various ways (see the next section for details).

## html←PageSource
<a name="pagesource"></a>

You can verify whether the page has been correctly loaded by inspecting the PageSource, for example:
````
      ∨/'<link href="/Styles/tryapl.css"'⍷Selenium.BROWSER.PageSource
````

## {ok}←(fn Retry) arg 
<a name="retry"></a>

Following any action, an unknown amount of time may pass before the server responds and a response is detectable in the browser. The `Retry` operator is provided to allow waiting for an expected effect. The time to wait is controlled by the variable `Selenium.DEFAULTRETRYLIMIT` . `Retry` invokes `fn` on `arg`, and retries until the result is true, or `DEFAULTRETRYLIMI`T seconds have passed.

For example:
````
      {(Find 'result').Text=⍵} Retry 'You pressed the button!'
````      

`Retry` returns the result of the final application of the function.

## {msg}←element WaitFor text [message]
<a name=waitfor"></a>

The left argument can be the id or a reference to an element to be tested or a two element vector containing the left and right arguments of the [`Find`](Find.md) function. `WaitFor` will use `Retry` to wait until the element in question contains the specified text anywhere within its Text property. If the element is of type input, (element.GetAttribute⊂'value') is tested instead.

For example:
````
      'result' WaitFor 'Welcome!'
````      
An optional second character vector can be used in message to replace the default, which is "Expected output did not appear".
