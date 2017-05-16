 msg←Test dummy⍝;Into;Se;Ed;Ans;Tb;LastIs
 :If 1
     Se')clear'Enter
 :AndIf LastIs'clear ws'
     Se'var←''Hej Morten'''Enter
     Se'var'Enter
 :AndIf LastIs'Hej Morten'
     Se'var'
     Se Shift Enter
     Ed Home,3/Delete
     Ed'Hello'
     Ed Escape
     Se Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'
     Se Shift Enter
     Ed';name'Home'res←'Down
     Ed'name←⍞'Enter
     Ed'res←''Hello '',name'
     Ed Escape
     Se Enter
     Se'Morten'
     Se Enter
 :AndIf LastIs'Hello Morten'
     Se'fn'
     Se Control Enter
     Ed End(Shift Enter)
     Ed Down Left
     Ed 5/⊂Shift Right
     Ed'Hej'
     Ed Escape
     Tb'RM'
     Se'Morten'
     Se Enter
 :AndIf LastIs'Hej Morten'
     Lb '+∘÷/⍳'
     Se '10'Enter
 :AndIf LastIs'1.433127427'
 :EndIf
