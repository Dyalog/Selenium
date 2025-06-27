 msg←fixfns dummy
 :If 1
     Fix Local'factorial.dfn'
 :AndIf LastIs'factorial'
     Se'factorial¨⍳9'Enter
 :AndIf LastIs'1 2 6 24 120 720 5040 40320 362880'
 :EndIf
