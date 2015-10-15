:Namespace Selenium

(⎕IO ⎕ML ⎕WX)←1 1 3

CURRENTBROWSER←'Chrome'
DEFAULTBROWSER←'Chrome'
DLLPATH←'C:\Devt\Selenium\'
RETRYLIMIT←2000

∇ {type}Click id;b;ok;time
  ⍝ Click on an element, by default identified by id. See "Find" for options
     
 :If 0=⎕NC'type' ⋄ type←'Id' ⋄ :EndIf
     
 b←type Find id
 b.Click
∇

∇ fromid DragNDrop toid;from;to
     ⍝ Drag and Drop
     
 (from to)←Find¨fromid toid
 ((⎕NEW OpenQA.Selenium.Interactions.Actions BROWSER).DragAndDrop from to).Perform
∇

∇ r←{type}Find id;f;ok;time
 :If 9=⎕NC'id' ⋄ r←id ⍝ Already an object
 :Else
     
     :If 0=⎕NC'type' ⋄ type←'Id' ⋄ :EndIf
          ⍝ See auto-complete on BROWSER.F for a list of possible ways to find things
     
     :If 's'=¯1↑type ⍝ The call FindElements*
         f←⍎'BROWSER.FindElementsBy',¯1↓type
     :Else ⋄ f←⍎'BROWSER.FindElementBy',type
     :EndIf
     
     time←⎕AI[3]
     :Repeat ⍝ Other functions use Retry operator, but we need to collect the result
         :Trap 0
             r←f⊂id
             ok←1
         :Else
             r←0
             :If RETRYLIMIT>0 ⋄ ⎕DL 0.1 ⋄ ok←0 ⋄ :EndIf
         :EndTrap
     :Until ok∨(⎕AI[3]-time)>RETRYLIMIT ⍝ Try for a second
 :EndIf
∇

∇ r←id FindListBoxItems text;li;ok
     ⍝ Find items within a [Syncfusion ej]ListBox
     
 (ok li)←{li←⌷'CssSelectors'Find'#',⍵,' li' ⋄ (0≠⍴li)li}Retry id
 r←(li.Text∊eis text)/li
∇

∇ GoTo url
     ⍝ Ask the browser to navigate to a URL and check that it did it
     
 BROWSER.Navigate.GoToUrl⊂url
 :If ~(⊂BROWSER.Url)∊url(url,'/')
     ('did not work - url is ',BROWSER.Url)⎕SIGNAL 11
 :EndIf
∇

∇ InitBrowser browser;z
     
 :If 0=⍴browser ⋄ browser←DEFAULTBROWSER ⋄ :EndIf       ⍝ Empty rarg => Use DEFAULTBROWSER
 :If 0=⎕NC'CURRENTBROWSER' ⋄ CURRENTBROWSER←'' ⋄ :EndIf ⍝ Avoid VALUE ERRORs
     
 :If browser≢CURRENTBROWSER ⋄ ⎕EX'BROWSER' ⋄ :EndIf     ⍝ We want to switch or need a new one
     
 SetUsing
     
 :Trap 0 ⍝ Try to find out if Browser is alive - not always reliable
     z←BROWSER.Url
 :Else
     ⎕←'Starting ',browser
     BROWSER←⎕NEW⍎'OpenQA.Selenium.',browser,'.',browser,'Driver'
     CURRENTBROWSER←browser
 :End
∇

∇ id ListMgrSelect items;elements
     ⍝ Move items from left to right in a MiServer ejListManager control
     
 elements←(id,'_left')FindListBoxItems items
 elements DragNDrop¨⊂id,'_right_container'
∇

∇ selectId Select itemText;sp;se;type
      ⍝ Select an item in a select element
     
     ⍝ ↓↓↓ Id can be tuple of (type identifier - see Find)
 :If 2=≡selectId ⋄ (type selectId)←selectId
 :Else ⋄ type←'Id'
 :EndIf
     
 'Select not found'⎕SIGNAL(0≡sp←type Find selectId)/11
 se←⎕NEW OpenQA.Selenium.Support.UI.SelectElement sp
 se.SelectByText⊂,itemText
∇

∇ selectId SelectItemText itemsText;item;se
     ⍝ Select items in a select control
     ⍝ Each item can be deselected by preceding it with '-'.
     ⍝ A single '-' deselects all
     
 se←⎕NEW OpenQA.Selenium.Support.UI.SelectElement,⊂Find selectId
 :For item :In eis itemsText
     :If item≡'~'
         se.DeselectAll
     :ElseIf '~'=1↑item
         se.DeselectByText⊂1↓item
     :Else
         se.SelectByText⊂,item
     :EndIf
 :EndFor
∇

∇ obj SendKeys text;q
     ⍝ Send keystrokes - see Keys.⎕NL -2 for special keys like Keys.Enter
     
 q←Find obj
 {q.SendKeys⊂,⍵ ⋄ ⎕DL 0.1}¨,⍕text ⍝ Give a little time to respond to each one
∇

∇ SetUsing
 ⍝ Set the path to the Selenium DLLs
     
 ⎕USING←0⍴⎕USING
 ⎕USING,←⊂('/'⎕r'\\')'OpenQA.Selenium,',DLLPATH,'webdriver.dll'
 ⎕USING,←⊂('/'⎕r'\\')',',DLLPATH,'webdriver.support.dll'
∇


∇ Start
 ⎕←'DLLPATH←''',DLLPATH,''''
 ⎕←'DEFAULTBROWSER←''',DEFAULTBROWSER,''' ⍝ Chrome Firefox supported'
∇

∇ Wait msec
 {}⎕DL msec÷1000
∇

∇ x←eis x
     ⍝ Enclose if simple
 :If (≡x)∊0 1 ⋄ x←,⊂,x ⋄ :EndIf
∇

∇ {open}ejAccordionTab(tabText ctlId)
     ⍝ Make sure that a control, within an accordiontab, is visible or not
     
 :If 0=⎕NC'open' ⋄ open←1 ⋄ :EndIf
     
 :If open≠(BROWSER.FindElementById⊂ctlId).Displayed⍝ If it doesn't have the desired state
     'LinkText'Click tabText
     {(open ctlId)←⍵
         open=(BROWSER.FindElementById⊂ctlId).Displayed}Retry open ctlId
 :EndIf
∇

∇ {ok}←(fn Retry)arg;time;z
⍝ Retry fn for a while

 ok←0 ⋄ time←⎕AI[3]
 :Repeat
     :Trap 0
         ok←fn arg
     :Else
         ⎕DL 0.1
     :EndTrap
 :Until (⊃ok)∨(⎕AI[3]-time)>RETRYLIMIT ⍝ Try for a second
∇

:EndNamespace 