﻿ msg←Test dummy
 ')clear'Gives'clear ws'
 Se'var←''Hej Morten'''Enter
 'var'Gives'Hej Morten'
 Se'var←''Hello'',3↓var'Enter
 'var'Gives'Hello John'
 Se'∇res←fn;name'Enter
 Se'name←⍞'Enter
 Se'res←''Hello '',name'Enter
 Se'∇'Enter
 Se'fn'Enter
 'Morten'Gives'Hello Morten'
 Se'∇fn[2]''Hej '',name∇'Enter
 Se'fn'Enter
 'Morten'Gives'Hej Morten'
⍝ RegEx:
 '?9'Gives'$\d$'
⍝ wait up to 10 seconds:
 '⊢⎕DL 6'Gives'6.0'⊣RETRYTIMEOUT←10
