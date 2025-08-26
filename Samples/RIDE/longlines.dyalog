 msg←longlines dummy
 :If 1
     Se')clear'Keys.Enter
 :AndIf LastIs'clear ws'
     Se'var←''Hej Morten'''Keys.Enter'var'Keys.Enter
 :AndIf LastIs'Hej Morten'
     Se'var'Keys.(⊂Shift,Enter)
     Ed Keys.(Home,(3/Delete)),'Hello'Keys.Escape
     Se Keys.Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'Keys.(⊂Shift,Enter)
     Ed';name'Home'res←'Down'name←⍞'Keys.Enter'res←''Hello '',name'Keys.Escape
     Se Keys.Enter'Morten'Keys.Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'Keys.(⊂Control,Enter)
     Ed Keys.(End(Shift,Enter)Down Left,(5/⊂Shift Right),'Hej'Escape)
     Tb'RM'
     Se'Morten'Keys.Enter
 :AndIf LastIs'Hej Morten'
 :EndIf
