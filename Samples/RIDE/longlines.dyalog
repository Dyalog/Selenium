 msg←Test dummy
 :If 1
     Se')clear'Enter
 :AndIf LastIs'clear ws'
     Se'var←''Hej Morten'''Enter'var'Enter
 :AndIf LastIs'Hej Morten'
     Se'var'(Shift Enter)
     Ed Home,(3/Delete),'Hello'Escape
     Se Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'(Shift Enter)
     Ed';name'Home'res←'Down'name←⍞'Enter'res←''Hello '',name'Escape
     Se Enter'Morten'Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'(Control Enter)
     Ed End(Shift Enter)Down Left,(5/⊂Shift Right),'Hej'Escape
     Tb'RM'
     Se'Morten'Enter
 :AndIf LastIs'Hej Morten'
 :EndIf
