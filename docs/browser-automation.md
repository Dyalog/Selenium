# Browser Automation Functions

The following functions manipulate the browser in various ways. Note that, wherever a `{selector}` is used, a reference to an IWebElement (returned by [`Find`](Find.md) or the argument(s) of [`Find`](Find.md) can be used instead.

## ClearInput {selector}
<a name="clearinput"></a>
Clears the content of input-fields or textarea.

## {selector} Click id 
<a name="click"></a>
Clicks on the selected element. Both arguments are passed directly to the Find function, and the Click method is invoked on the result. For example:
````
       Click 'btn1'
````

## fromid DragAndDrop toid 
<a name="draganddrop"></a>

Drag the element <fromid> and drop it on <toid>. For example:
````
      'draggable'#.S.DragAndDrop'droppable' 
````
<!--
## {open} ejAccordionTab (tabText ctlId) 

Ensure that the Syncfusion ejAccordionTab with the selected tabText has the desired state (open or closed), verifying the state by checking the visibility of the element with Id <ctlId>.
id ListMgrSelect items 
In a ListManager object with Id <id>, select items with Text properties found in <items>, by dragging them from the list on the left to list on the right.
-->

## {action} MoveToElement toid [x y] 
<a name="movetoelement"></a>

Move the mouse to the middle of an element, or optionally to the (x y) coordinates. 
If the optional left argument is provided and is a character vector containing one of the strings Click | ClickAndHold | ContextClick | DoubleClick, that mouse action will be performed after the move.

For example:
````
       'DoubleClick' MoveToElement 'btn1' 10 10
````

## id Select text 
<a name="select"></a>

Select the item with a given text in a dropdown. For example:
````
       'fruits' Select 'apples'
````

## id SendKeys text 
<a name="sendkeys"></a>

see separate [doc](SendKeys.md)

## id SetInputValue text
<a name="setinputvalue"></a>
This method  is an alternative to SendKeys. While SendKeys focusses on sending actual keystrokes, this function provides an easy way to send text to an input control. It is recommended when sending "complex" text that may require key-combinations to enter it, for example APL-Symbols or special characters like "@".
