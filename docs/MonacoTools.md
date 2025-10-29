# Monaco tools

When testing applications that use the [Monaco editor](terminology.md#MonacoEditor), it is not possible
to use the default tools to emulate input or send keystrokes.

For such cases we provide a set of alternate tools. Their usage can be seen in the [ride tests](ride.md).

## `loc MonacoInput txt`

This function is used to emulate entering text.

* `loc` selects the target. The value `1` picks the session, `2` is the editor.
* `txt` is the text you want to enter. You can also pass a 2-element vector which will be used to edit the current content 
of the active line: `txt[⎕IO]` will be prefixed and `txt[⎕IO+1]` will be appended to the current content. 

## `{combo}MonacoEnter loc`

Sends the Enter key to submit the current line. The left argument `combo` can be used to specify they key you want to combine `Enter` with:

* `shift`
* `ctrl`
* `ctrl-shift`