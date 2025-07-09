# {r}←obj SendKeys keys

The SendKeys function sends they keystrokes given in the right argument `keys` to the object `obj`.

## Argument `obj`

The target object can either be passed as a previously found object or it can be the right argument of the [Find](Find.md) function.

## Argument `keys`

The right argument specifies the keystrokes that are to be sent as a vector.

To send special keys like `Escape`, `Shift` or others, use the BROWSER.Keys enumeration and pass it as a nested element optionally joined by the basic key.

<h3 class="example">Example: Send the keystrokes Ctrl+A</h3>

`SendKeys ⊂BROWSER.Keys.Ctrl 'A'`

!!!note
   * If you want to test input controls, it is recommended to use [SetInputValue](./SetInputValue.md) to set their values instead, 
   as that function will also pass unicode values reliably without requiring keystroke translation.
   * It is also worth noting that the underlying Selenium function `SendKeys` supports extended features such as "unicode keystrokes" in
   varying degress on different browsers: while sending the keystroke `'≢'` to Chrome will cause the symbol `≢` to appear in the control,
   [CEF](./terminology.md#cef---chromium-embedded-framework) (as used in Dyalog's HtmlRenderer object) does not support that.

## Complete list of key names

````
Add
Alt
ArrowDown
ArrowLeft
ArrowRight
ArrowUp
Backspace
Cancel
Clear
Command
Control
Decimal
Delete
Divide
Down
End
Enter
Equal
Escape
F1
F10
F11
F12
F2
F3
F4
F5
F6
F7
F8
F9
Help
Home
Insert
Left
LeftAlt
LeftControl
LeftShift
Meta
Multiply
Null
NumberPad0
NumberPad1
NumberPad2
NumberPad3
NumberPad4
NumberPad5
NumberPad6
NumberPad7
NumberPad8
NumberPad9
PageDown
PageUp
Pause
Return
Right
Semicolon
Separator
Shift
Space
Subtract
Tab
Up
ZenkakuHankaku
````