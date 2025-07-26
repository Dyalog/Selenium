# Browser Automation Functions

The following functions manipulate the browser in various ways. Note that, wherever a `{selector}` is used, a reference to an IWebElement (returned by [`Find`](Find.md) or the argument(s) of [`Find`](Find.md) can be used instead.

<a name="clearinput"></a>
## ClearInput {selector}
Clears the content of input-fields or textarea.

<a name="click"></a>
## {selector} Click id 
Clicks on the selected element. Both arguments are passed directly to the Find function, and the Click method is invoked on the result. For example:
````
       Click 'btn1'
````

<a name="executescript"></a>
## {R}←{args}ExecuteScript sc

Executes the Javascript code passed in sc. The optional left argument can be used to pass arguments to it.

A good use case for this is this line of the [SetInputValue](#setinputvalue) function:
````
      (obj text)ExecuteScript'arguments[0].value = arguments[1];'
````

<a name="draganddrop"></a>
## fromid DragAndDrop toid 

Drag the element <fromid> and drop it on <toid>. For example:
````
      'draggable'#.S.DragAndDrop'droppable' 
````

<a name="draganddroptooffset"></a>
## fromid DragAndDropToOffset xy

Drag the element <fromid> and drop it at the given offset. For example:
````
      'draggable'#.S.DragAndDropToOffset 10 10
````

<a name="getlogs"></a>
## R←{level}GetLogs type

This function retrieves the logs. Valid values for `type` are `browser`, `webdriver` and `performance`, the optional `level` must be one of `All`, `Debug`, `Info`, `Off`, `Severe` or `Warning`.

!!!info
   By default, only browser and webdriver logs are enabled.
   If you want to access performance logs, they needs to be enabled in `settings.json5` first.

<a name="movetoelement"></a>
## {action} MoveToElement toid [x y] 

Move the mouse to the middle of an element, or optionally to the (x y) coordinates.
If the optional left argument is provided and is a character vector containing one of the strings `Click` | `ClickAndHold` | `ContextClick` | `DoubleClick`, that mouse action will be performed after the move.

For example:
````
       'DoubleClick' MoveToElement 'btn1' 10 10
````

<a name="select"></a>
## {ok}←id Select text 

Select the item with a given text in a dropdown. For example:
````
       'fruits' Select 'apples'
````

The right argument `text` can also be a two-element vector containing `(srch crit)`where

- `srch` specifies what you're searching for
- and `crit` describes the criteria:
 
    - `CssSelector`: find the element using a CSS Selector
    - `Index`: `srch` gives the index of the element you want to select
    - `PartialText`: `srch` is a partial text
    - `Text`: `srch`is the full text that needs to match
    - `Value`: `srch` must match the `value` attribute of the element you're looking for
    - a boolean value in `crit` indicates whether partial matches are accepted (=1) or not (=0, default)

The boolean result `ok` indicates if the selection was successful (=1) or not (=0).

<a name="selectitemtext"></a>
## {ok}←id SelectItemText text 

Much like the previous function, this function can be used to select elements in a `select` control based on the item text. While it does not provide the flexibility regarding selections, it also enables you to de-select elements by providing a prefix `-` and to de-select all element by passing the value `~`.

<a name="sendkeys"></a>
## id SendKeys text 

see separate [doc](SendKeys.md)

<a name="setinputvalue"></a>
## id SetInputValue text
This method  is an alternative to SendKeys. While SendKeys focusses on sending actual keystrokes, this function provides an easy way to send text to an input control. It is recommended when sending "complex" text that may require key-combinations to enter it, for example APL-Symbols or special characters like "@".
