 msg←fixfns dummy
 :If 1
     Fix Local'factorial.aplf'
 :AndIf LastIs'factorial'
     1 MonacoInput'factorial¨⍳9'
     MonacoEnter 1
 :AndIf LastIs'1 2 6 24 120 720 5040 40320 362880'
 :EndIf
