:Namespace SeleniumTests

⍝ === VARIABLES ===

MS3ROOT←'C:/Devt/MiServer/MS3'
MS3SITE←'http://127.0.0.1:8080'

∇ r←MS3Test sample;name
     ⍝ eg MS3Test 'DC/InputGridSimple'
     
 InitBrowser''
 GoTo MS3SITE,'/Examples/',sample
 name←(sample⍳'/')↓sample
 ⎕SE.SALT.Load MS3ROOT,'/QA/Examples/',sample
 r←⍎name
∇

∇ MS3Tests n;count;ctl;examples;f;fail;folders;nodot;start;t;time;z;i;START;COUNT;FAIL
     
 START←⎕AI[3] ⋄ COUNT←0 ⋄ FAIL←0
 :For i :In ⍳n
     start←⎕AI[3]
     nodot←{('.'≠⊃¨⍵)/⍵}
     examples←MS3ROOT,'/QA/Examples'
     folders←nodot Files.Dir examples,'/*'
     
     count←fail←0
     :For f :In folders
         :For ctl :In ¯7↓¨nodot Files.Dir examples,'/',f,'/*.dyalog'
             count+←1
             :If 0=⍴t←MS3Test z←f,'/',ctl
                 ⍞←'.'
             :Else
                 fail+←1
                 ⎕←'*** FAILED *** ',z,': ',t
             :EndIf
             :If 3=⎕NC ctl ⋄ ⎕EX ctl ⋄ :EndIf
         :EndFor
     :EndFor
     
     time←⎕AI[3]-start
     t←(n≠1)/'Run #',(⍕i),'/',(⍕n),': '
     ⎕←t,(⍕count),' samples tested in ',(1⍕time÷1000),'s. ',(⍕fail),' failed.'
     COUNT+←count ⋄ FAIL+←fail
 :EndFor
     
 ⎕←'Total of ',(⍕COUNT),' samples tested in ',(∊(⍕¨24 60⊤⌊0.5+(⎕AI[3]-START)÷1000),¨'ms'),': ',(⍕FAIL),' failed.'
∇

:EndNamespace 