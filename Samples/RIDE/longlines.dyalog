 msg←longlines dummy
 :If 1
     Se')clear'S.Keys.Enter
 :AndIf LastIs'clear ws'
     Se'var←''Hej Morten'''S.Keys.Enter'var'S.Keys.Enter
 :AndIf LastIs'Hej Morten'
     Se'var'S.Keys.(⊂Shift,Enter)
     Ed S.Keys.(Home,(3/Delete)),'Hello'S.Keys.Escape
     Se S.Keys.Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'S.Keys.(⊂Shift,Enter)
     Ed';name'S.Keys.Home
     2 MonacoInput'res←'  ⍝ APL chararacters should not be entered with SendKeys (as used in Se)
     Ed S.Keys.Down
     2 MonacoInput 'name←⍞'
     Ed S.Keys.Enter
     2 MonacoInput'res←''Hello '',name'
     Es S.Keys.Escape
     Se S.Keys.Enter'Morten'S.Keys.Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'S.Keys.(⊂Control,Enter)
     Ed S.Keys.(End(Shift,Enter)Down Left,(5/⊂Shift Right),'Hej'Escape)
     Tb'RM'
     Se'Morten'S.Keys.Enter
 :AndIf LastIs'Hej Morten'
 :EndIf