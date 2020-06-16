:Namespace Selenium ⍝ V 2.10
⍝ This namespace allows scripted browser actions. Use it to QA websites, inluding RIDE.
⍝
⍝ 2017 05 09 Adam: Version info added
⍝ 2017 05 23 Adam: now gives helpful messages for DLL problems, harmonised ADOC utils
⍝ 2020 02 12 MBaas 2.10: updated to use a config (.json)-file to facilitate testing with various browsers (incl. HTMLRenderer)
⍝ 2020 05 08 MBaas: praparing for cross-platformness;new folder-structure for drivers

    :Section ADOC
    ∇ t←Describe
      t←1↓∊(⎕UCS 10),¨{⍵/⍨∧\(⊂'')≢¨⍵}Comments ⎕SRC ⎕THIS ⍝ first block of non-empty comment lines
    ∇

    ∇ (n v d)←Version;f;s
      s←⎕SRC ⎕THIS
      f←Words⊃s                     ⍝ split first line
      n←2⊃f                         ⍝ ns name
      v←'.0',⍨'V'~⍨⊃⌽f              ⍝ version number
      d←1↓∊'-',¨3↑Words⊃⌽Comments s ⍝ date
    ∇

    Words←{⎕ML←3 ⋄ ⍵⊂⍨' '≠⍵}
    Comments←{1↓¨⍵/⍨∧\'⍝'=⊃∘{(∨\' '≠⍵)/⍵}¨⍵}1∘↓


    :EndSection ───────────────────────────────────────────────────────────────────────────────────

    :Section INITIALISATION

    ⎕WX←3

    DEFAULTBROWSER←'Chrome'
    DLLPATH←'' ⍝  might be overridden through ⍺[4] when calling Test
    RETRYLIMIT←DEFAULTRETRYLIMIT←5 ⍝ seconds

    EXT←'.dyalog'
    RIDEEXT←'.ridetest'

    PORT←8080
    :EndSection ───────────────────────────────────────────────────────────────────────────────────

    :Section MAIN FRAMEWORK PROGRAMS
    ∇ failed←{stop_site_match_config}Test path_filter;⎕USING;stop;match;site
      ⍝ stop: 0 (default) ignore but report errors; 1 stop on error; 2 stop before every test
      ⍝ site: port number (default is PORT) or URL
      ⍝ match: 0 (default) run all tests on the baseURL; 1 run tests on baseURL matching dir struct
      ⍝ config: points to an entry of your settinghs.json-Foöe
      'stop_site_match_config'DefaultTo 0
      :If 82=⎕DR stop_site_match_config  ⍝ handle mode where just the name of a config is given
          stop_site_match_config←0 0 0,⊂stop_site_match_config
      :EndIf
      :If 0<≢4⊃4↑stop_site_match_config
      :AndIf 0<≢4⊃stop_site_match_config
          ApplySettings 4⊃stop_site_match_config
      :EndIf
      InitBrowser''
      (⍎,∘'←∊Keys.(',,∘')')⍕Keys.⎕NL ¯2 ⍝ Localize non-alphanumeric key names for easy access
      failed←({3<≢⍵:3↑⍵ ⋄ ⍵}stop_site_match_config)RunAllTests path_filter
      BROWSER.Quit
    ∇

    ∇ R←ApplySettings name;settings;ref
     
      settings←GetSettings
      ref←settings{6::'' ⋄ 0=≢⍵:⍺⍎⍺.default ⋄ ⍺⍎⍵}name
      :If ref≡''
          ('Settings "',name,'" not found!')⎕SIGNAL 11
          ref←settings.{6::'' ⋄ ⍺⍎⍺⍎⍵}'default'
      :EndIf
      :For go :In 'DLLPATH' 'PORT'  ⍝ transfer config-params that are set on a global level into the selected config
          :If 0=ref.⎕NC go   ⍝ DLLPATH can also be set on a global level...
          :AndIf 2=settings.⎕NC go
              ⍎'ref.',go,'←settings.',go
          :EndIf
      :EndFor
      SETTINGS←ref  ⍝ memorize them in the NS (in case we need them again...)
      DLLPATH←(1⊃⎕NPARTS SourceFile ⎕THIS)NormalizePath ref{6::2⊃⍵ ⋄ ⍺⍎1⊃⍵}'DLLPATH'DLLPATH
      DEFAULTBROWSER←ref{6::2⊃⍵ ⋄ ⍺⍎1⊃⍵}'BROWSER'DEFAULTBROWSER
      PORT←ref{6::2⊃⍵ ⋄ ⍺⍎1⊃⍵}'PORT'PORT
      BROWSEROPTIONS←⍬  ⍝ no options found...
      :If 9=ref.⎕NC'Options'
          BROWSEROPTIONS←ref.Options
      :EndIf
     
      ⍝ are settings plausible?
      ⎕USING←'System'
      :If 4=Environment.Version.Major  ⍝ .net Framework
          :If '4'=⊢/DLLPATH ⋄ 'Can not use WebDriver4 with .net Framework!'⎕SIGNAL 11 ⋄ :EndIf
      :Else
          :If '3'=⊢/DLLPATH ⋄ 'Can not use WebDriver3 with .NET Core!'⎕SIGNAL 11 ⋄ :EndIf
      :EndIf
    ∇


    ∇ path←base NormalizePath path
      path base←{('/'@{'\'=⍵})⍵}¨path base
      base←base,('/'≠⊃⌽base)/'/'
      :If './'≡2↑path ⋄ path←base,2↓path   ⍝ relative path
 ⍝     :ElseIf... ⍝ are there any more cases to consider???
      :EndIf
    ∇

    ∇ InitBrowser browser;files;msg;path;len;options;opt;pth;subF;suffix;drv;opts
      options←''
      :If ×⎕NC'BROWSER' ⍝ close any open browser
          BROWSER.Quit
      :Else
          :If 0=⎕NC'SETTINGS' ⋄ ApplySettings browser ⋄ :EndIf
      :EndIf
     
      :If 0=⍴browser ⋄ browser←DEFAULTBROWSER ⋄ :EndIf       ⍝ Empty rarg => Use DEFAULTBROWSER
      files←browser SetUsing path←DLLPATH
      'CURRENTBROWSER'DefaultTo'' ⍝ Avoid VALUE ERRORs
      ⎕EX'BROWSER'/⍨browser≢CURRENTBROWSER     ⍝ We want to switch or need a new one
      :Trap 0 ⍝ Try to find out if Browser is alive - not always reliable
          {}BROWSER.Url
      :Else
          subF←(('WLM'⍳1 1⊃'.'⎕WG'APLVersion')⊃'Win' 'Linux' 'Mac'),'/'  ⍝ subfolder for platform-specific driver files
          suffix←('W'=1 1⊃'.'⎕WG'APLVersion')/'.exe'
          :If 2=SETTINGS.⎕NC'Executable'
              drv←SETTINGS.Executable,suffix
          :Else
⍝              drv←(⎕C browser),'driver',suffix
              drv←(0(819⌶)browser),'driver',suffix
          :EndIf
          :If 2=SETTINGS.⎕NC'DRIVERS' ⋄ path←SETTINGS.DRIVERS ⋄ :EndIf
          pth←path
          :If '.'=⊃pth
          :AndIf (2⊃pth)∊'\/'
              pth←∊1 ⎕NPARTS(SourcePath ⎕THIS),2↓pth
          :EndIf
          :If ~(⎕NEXISTS⍠1)pth,drv        ⍝ will this work on Linux?
          :AndIf (⎕NEXISTS⍠1)pth,subF,drv
              pth←pth,subF   ⍝ pick subfolder depending on platform
          :ElseIf (⎕NEXISTS⍠1)pth,(subF←subF,((1+∨/'64'⍷1⊃'.'⎕WG'APLVersion')⊃'32' '64'),'/'),drv   ⍝ test adding bits to folder (see folder-structure for Edge/Win!)
              pth←pth,subF   ⍝ pick subfolder depending on platform
          :EndIf
     
          :If 2=⎕NC'BROWSEROPTIONS'  ⍝ if var exists
          :AndIf 0<≢BROWSEROPTIONS
              :If ~0{6::⍺ ⋄ ⍎⍵}'QUIETMODE' ⋄ ⎕←'Processing browseroptions',(⎕UCS 13),⎕JSON BROWSEROPTIONS ⋄ :EndIf
              options←InitOptions browser
              ∘∘∘∘
              :For opt :In BROWSEROPTIONS.⎕NL-2
                  ⍎'options.',opt,'←opts.',opt
              :EndFor
            ⍝   :ElseIf 0<≢BROWSEROPTIONS
            ⍝       options←⎕NEW⍎BROWSEROPTIONS
          :EndIf
          :If 2=SETTINGS.⎕NC'AdditionalCapabilities'
          :AndIf 0 ⍝ not yet ripe for production!
              :If options≡'' ⋄ options←InitOptions browser ⋄ :EndIf
              :For cap :In SETTINGS.AdditionalCapabilities
                  options.AddAdditionalCapability(cap.name)(cap.value)
              :EndFor
          :EndIf
⍝          ∘∘∘
          :If 2=SETTINGS.⎕NC'AddArguments'
              :If options≡'' ⋄ options←InitOptions browser ⋄ :EndIf
              :For opt :In SETTINGS.AddArguments
                  options.AddArgument⊂opt
              :EndFor
          :EndIf
          :If 2=SETTINGS.⎕NC'LoggingPreferences'
              :If options≡'' ⋄ options←InitOptions browser ⋄ :EndIf
              cap←options.ToCapabilities
              
              :For p :In SETTINGS.LoggingPreferences
                  options.SetLoggingPreference p.type(⍎p.level)
              :EndFor
          :EndIf
          :If ~0{6::⍺ ⋄ ⍎⍵}'QUIETMODE' ⋄ ⎕←'Starting ',browser ⋄ :EndIf
          :Trap 0/0  ⍝ ###TEMP### remove after testing
              BSVC←(⍎browser,'DriverService').CreateDefaultService(pth)(drv)
              :If options≡''
                  BROWSER←⎕NEW(⍎browser,'Driver')BSVC
              :Else
                ⍝  ∘∘∘
                ⍝  options.SetLoggingPreference(LogType.Browser 0)
                  BROWSER←⎕NEW(⍎browser,'Driver')(BSVC options)
              :EndIf
          :Else
              msg←'Could not load '
              len←≢path
              msg,←len↓⊃files
              msg,←' and ',len↓⊃⌽files
              msg,←' from ',path,' ─ they may be '
              :If 1 1≡⎕NEXISTS¨files
                  msg,←'blocked (Properties>General>Unblock)',⎕UCS 13
                  msg,←'Or maybe something else is wrong. Here are the details of the exception:',⎕UCS 13
                  msg,←⎕EXCEPTION.Message
                  msg ⎕SIGNAL 19
              :Else
                  (msg,'missing')⎕SIGNAL 22
              :EndIf
          :EndTrap
          CURRENTBROWSER←browser
          ACTIONS←⎕NEW OpenQA.Selenium.Interactions.Actions BROWSER
      :End
      :If ~×#.⎕NC'MAX'
          :Trap 90           ⍝ can't do that with CEF
              BROWSER.Manage.Window.Maximize
          :EndTrap
      :EndIf
    ∇
    ∇ options←InitOptions browser
      options←⎕NEW⍎browser,'Options'
    ∇

∇ SaveScreenshot ToFile 
BROWSER.GetScreenshot.SaveAsFile⊂ ToFile 
∇

    ∇ failed←stop_site_match RunAllTests path_filter;files;maxlen;n;start;i;file;msg;time;path;filter;allfiles;hasfilter;shutUp;showMsg;prefix
      path filter←2↑(eis path_filter),⊂''
      shutUp←0{6::⍺ ⋄ ⍎⍵}'QUIETMODE'  ⍝ use QUIETMODE to suppress everything BUT error-messages
      showMsg←⍎(1+shutUp⊃)'{⍵}' '{}'
      allfiles←(≢path)↓¨FindAllFiles path
      hasfilter←×≢filter
      files←filter ⎕S'%'⍣hasfilter⊢allfiles
      n←≢files
      showMsg'Selected: ',(⍕n),(hasfilter/' of ',⍕≢allfiles),' tests.'
      maxlen←⌈/≢¨files
      failed←''
      start←⎕AI[3]
      :For i file :InEach (⍳n)files
          prefix←(⎕UCS 13),maxlen↑file
          msg←stop_site_match Run1Test path file
          :If 0=⍴msg
              showMsg prefix,' *** PASSED ***'
          :Else
              failed,←⊂file
              ⎕←prefix,' *** FAILED *** #',(⍕i),' of ',(⍕n),': ',msg
          :EndIf
      :EndFor
      time←∊'ms',¨⍨⍕¨24 60⊤⌊0.5+0.001×⎕AI[3]-start
      showMsg←'Total of ',(⍕n),' samples tested in ',time,': ',(⍕≢failed),' failed.'
    ∇

    ∇ r←stop_site_match Run1Test(path file);name;Test;stop;site;match
      stop site match←3↑stop_site_match
      site←Urlify site
      {~UrlIs ⍵:GoTo ⍵}site,'/',match/file↓⍨¯7×EXT≡¯7↑file
      :Select ⊃⌽'.'Split file
      :Case RIDEEXT
          name←⎕FX'msg←Test dummy' 'RideScript','⍝',¨⊃⎕NGET(path,file)1 ⍝ Create Test function from raw RIDE script
      :Case EXT
          name←⎕SE.SALT.Load path,file
      :EndSelect
      :If ×⎕NC'name'
      :AndIf 'Test'≡name
          :Trap 0/⍨0=stop
              'Test'⎕STOP⍨1/⍨2=stop ⍝ stop on line 1 if stop=2
              r←Test ⍬
              :If stop⌊×≢r
                  ⎕←'test for ',file,' failed:'
                  ⎕←r
                  ⎕←'Rerun:'
                  ⎕←'      Test ⍬'
                  ∘∘∘
              :EndIf
          :Else
              r←'Trapped error: ',,⍕⎕DMX.EN
          :EndTrap
      :EndIf
    ∇
    :EndSection ───────────────────────────────────────────────────────────────────────────────────

    :Section MISERVER UTILITIES
    ∇ {ok}←id ListMgrSelect items;elements
     ⍝ Move items from left to right in a MiServer ejListManager control
      ok←1
      elements←(id,'_left')FindListItems items
      elements DragAndDrop¨⊂id,'_right_container'
    ∇

    ∇ {ok}←{open}ejAccordionTab(tabText ctlId)
     ⍝ Make sure that a control, within an accordiontab, is visible or not
      ok←1
      'open'DefaultTo 1
      :If open≠(BROWSER.FindElementById⊂ctlId).Displayed ⍝ If it doesn't have the desired state
          'LinkText'Click tabText
          {(open ctlId)←⍵
              open=(BROWSER.FindElementById⊂ctlId).Displayed}Retry open ctlId
      :EndIf
    ∇

    ∇ r←id FindListItems text;li;ok
     ⍝ Find list items with a given text within element with id (e.g. [Syncfusion ej]ListBox items)
      (ok li)←{li←⌷'CssSelectors'Find'#',⍵,' li' ⋄ (0≠⍴li)li}Retry id
      r←(li.Text∊eis text)/li
    ∇
    :EndSection ───────────────────────────────────────────────────────────────────────────────────

    :Section COVER FUNCTIONS
    ∇ {ok}←obj SendKeys text;q;i;k
     ⍝ Send keystrokes - see Keys.⎕NL -2 for special keys like Keys.Enter
     ⍝ Note that even 'A' Control 'X' will be interpreted as Ctrl+A,X
     ⍝ To get A,Ctrl+X use 'A'(Control 'X')
      ok←1
      q←Find obj
      text←eis text
      i←4~⍨Keys.(Shift Control Alt)⍳¯1↓text
      :For k :In i
          (ACTIONS.(KeyDown ##.k⌷Keys.(Shift Control Alt))).Build.Perform
      :EndFor
      q.SendKeys,¨text~Keys.(Shift Control Alt)
     
    ∇


    ∇ {ok}←id SetInputValue text;s;i;r
⍝ Set the value of an input control to text.
      :If ∨/i←text='"'
          text←(1+i)/text
          text[(⍸i)+(0,¯1↓+\i)[⍸i]]←'\'
      :EndIf
      s←'document.getElementById("',id,'").value= "',text,'";'
      ok←1
      :Trap 0
          r←ExecuteScript s
      :Else
          ok←0
      :EndTrap
    ∇

    ∇ {ok}←{type}Click id;b;ok;time
     ⍝ Click on an element, by default identified by id. See "Find" for options
      ok←1
      'type'DefaultTo'Id'
      b←type Find id
      ('Control "',id,'" not found')⎕SIGNAL(0≡b)/11
      b.Click
    ∇

    ∇ {ok}←fromid DragAndDrop toid;from;to
     ⍝ Drag and Drop
      ok←1
      (from to)←Find¨fromid toid
      (ACTIONS.DragAndDrop from to).Perform
    ∇

    ∇ {ok}←fromid DragAndDropToOffset xy;from
     ⍝ Drag
      ok←1
      from←Find fromid
      (ACTIONS.DragAndDropToOffset from,xy).Build.Perform
    ∇

    ∇ {ok}←{action}MoveToElement args;id;target
     ⍝ Move to element with optional x & y offsets
     ⍝ And perform optional action (Click|ClickAndHold|ContextClick|DoubleClick)
      ok←1
      (⊃args)←Find⊃args ⍝ Elements [2 3] optional x & y offsets (integers)
      (ACTIONS.MoveToElement args).Build.Perform
      ⎕DL 0.1
      :If 2=⎕NC'action'
          :If (⊂action)∊'Click' 'ClickAndHold' 'ContextClick' 'DoubleClick'
              ((ACTIONS⍎action)⍬).Build.Perform
          :Else
              ('Unsupported action: ',action)⎕SIGNAL 11
          :EndIf
      :EndIf
    ∇

    ∇ {r}←ExecuteScript script ⍝ cover for awkward syntax and meaningless result
      r←BROWSER.ExecuteScript script ⍬
    ∇

    ∇ r←GetLogs
    ⍝ chould/should take ⍵ to select desired log(s) - once we have some data in them...;)
      r←''
      :For type :In BROWSER.Manage.Logs.AvailableLogTypes
          lb←BROWSER.Manage.Logs.GetLog⊂type
          r,←⊂'Log: ',type
          :If 0<lb.Count
              r,←⊂(⍕lb.Count),' entries:'
              :For e :In ⍳lb.Count
                  r,←⊂' ',' ',⍕e⌷lb
              :EndFor
          :Else
              r[≢r]←⊂((≢r)⊃r),': no entries'
          :EndIf
      :EndFor
    ∇
    :EndSection ───────────────────────────────────────────────────────────────────────────────────

    :Section USER UTILITIES FOR QA SCRIPTS
    ∇ r←Text element;f
    ⍝ Retrieves (visible) text of element
      :If 9≠⎕NC'element' ⋄ element←Find element ⋄ :EndIf
      :If element.TagName≡'input'
          r←element.GetAttribute⊂'value'
      :Else
          r←element.Text
      :EndIf
    ∇

    ∇ {ok}←selectId Select itemText;sp;se;type
      ⍝ Select an item in a select element
      ok←1
     ⍝ ↓↓↓ Id can be tuple of (type identifier - see Find)
      :If 2=≡selectId ⋄ (type selectId)←selectId
      :Else ⋄ type←'Id'
      :EndIf
      'Select not found'⎕SIGNAL(0≡sp←type Find selectId)/11
      se←⎕NEW OpenQA.Selenium.Support.UI.SelectElement sp
      se.SelectByText⊂,itemText
    ∇

    ∇ {ok}←selectId SelectItemText itemsText;item;se
     ⍝ Select items in a select control
     ⍝ Each item can be deselected by preceding it with '-'.
     ⍝ A single '-' deselects all
      ok←1
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

    ∇ r←{type}Find id;f;ok;time;value;attr;search;elms;mask
      :If 9=⎕NC'id'
          r←id ⍝ Already an object
      :Else
          'type'DefaultTo'Id'
          ⍝ See auto-complete on BROWSER.F for a list of possible ways to find things
          (id attr value)←{3↑⍵,(⍴⍵)↓'' '' ''}eis id
          :If search←~0∊⍴attr
              type,←('s'=¯1↑type)↓'s'
          :EndIf
          :If 's'=¯1↑type ⍝ The call FindElements*
              f←⍎'BROWSER.FindElementsBy',¯1↓type
          :Else
              f←⍎'BROWSER.FindElementBy',type
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
          :Until ok∨(⎕AI[3]-time)>1000×RETRYLIMIT ⍝ Try for a second
          :If ok
          :AndIf search
              :If 0<r.Count
                  elms←⌷r
                  :If r←∨/mask←<\(⊂value)≡¨attr∘{⍵.GetAttribute⊂⍺}¨elms
                      r←⊃mask/elms
                  :EndIf
              :Else
                  r←0   ⍝ nothing found!
              :EndIf
          :EndIf
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
      :Until (⊃ok)∨(⎕AI[3]-time)>1000×RETRYLIMIT ⍝ Try for a second
    ∇

    ∇ {ok}←Wait msec
      ok←×⎕DL msec÷1000
    ∇

    ∇ r←element WaitFor args;f;text;msg
    ⍝ Retry until text/value of element begins with text
    ⍝ Return msg on failure, '' on success
      :If 9≠⎕NC'element' ⋄ element←Find element ⋄ :EndIf
      args←eis args
      (text msg)←2↑args,(⍴args)↓'Thank You!' 'Expected output did not appear'
      f←'{∨/''',((1+text='''')/text),'''','≡⍷'[1+×⍴,text]
      :If element.TagName≡'input'
          f,←'element.GetAttribute⊂''value''}'
      :Else
          f,←'element.Text}'
      :EndIf
      r←(~(⍎f)Retry ⍬)/msg
    ∇
    :EndSection ───────────────────────────────────────────────────────────────────────────────────

    :Section RIDE-IN-BROWSER QA SCRIPT UTILITIES
    :Namespace Cache ⍝ to be populated by SeRef, EdRef, Lb
    :EndNamespace

    ∇ se←SeRef ⍝ Get ref to Session
      :Trap 2 6 90 ⍝ SYNTAX (not found) VALUE (first use) EXCEPTION (stale - probably won't happen)
          {}Cache.SE.Displayed
      :Else
          Cache.SE←'CssSelector'Find'.ride_win textarea'
      :EndTrap
      se←Cache.SE
    ∇
    Se←{Do:SeRef SendKeys¨⊂⍣(1=≡,⍵)⊢⍵ ⋄ 1}Retry ⍝ SendKeys in Session

    ∇ ed←EdRef ⍝ Get ref to Editor
      :Trap 6 90 ⍝ VALUE (first use) EXCEPTION (stale = new editor)
          {}Cache.ED.Displayed
      :Else
          Cache.ED←'CssSelector'Find'.ride_win_cm textarea'
      :EndTrap
      ed←Cache.ED
    ∇
    Ed←{Do:EdRef SendKeys¨⊂⍣(1=≡,⍵)⊢⍵ ⋄ 1}Retry ⍝ SendKeys in Editor

    ∇ {oks}←Lb glyphs ⍝ Click Language Bar buttons
      :If 0∊Cache.⎕NC'LB' 'LB_Text'
          Cache.LB_Text←(Cache.LB←⌷'CssSelectors'Find'#lb b').Text
      :EndIf
      oks←{Click Cache.LB⊃⍨Cache.LB_Text⍳⊂,⍵}¨glyphs
    ∇

    Tb←{'ClassName'Click'tb_',⍵}Retry ⍝ click toolbar button

    LastIs←{Do:''≡msg,←EndsWith Nested ⍵ ⋄ 1}Retry ⍝ Check last non-empty line in session

      EndsWith←{ ⍝ last session line(s) contain patterns
          h←-≢⍵
          se←h↑¯1↓Session~⊂''
          ∧/2</¯1,∊⍵ Has¨se:'' ⍝ last line is 6-space prompt
          'Session had "',(NlFmt se),'"; expected "',(NlFmt ⍵),'". '
      }

    ∇ r←Session ⍝ Session text
      r←(⌷'CssSelectors'Find'.CodeMirror-line span').Text
    ∇

      Has←{ ⍝ Location of pattern ⍵ in source ⍺
          rot←,¯1⌽⍵
          '$$'≡2↑rot:(2↓rot)⎕S 0⊢⍺
          '$;$'≡3↑rot:('^',(rot[4]~'^'),4↓rot)⎕S 0⊢⍺
          ';'=⊃⍵:0/⍨(1↓rot)≡⍺↑⍨¯1+≢⍵
          loc←⍺⍷⍵
          ∨/loc:loc⍳1
          ¯1
      }

    Fix←{⍺←2 ⋄ Se((⍕⍺),'⎕FIX''file://',⍵,'''')Enter} ⍝ Execute ⎕FIX in Session

    Gives←{Do:r←LastIs¨eis ⍵⊣Se ⍺ Enter ⋄ r←1}

    ∇ r←Do ⍝ Enables skipping to end if a problem has already occured
      :If 0=⎕NC'msg'
          msg←''
      :EndIf
      r←''≡msg
    ∇

    ∇ {r}←RideScript;lines;l;major;minor ⍝ Script processor
      ⍝ To be called before one or more comment lines
      ⍝ each script line may have one, two, or three major sections:
      ⍝     command: results: timeout
      ⍝ : is the major separator and ; is the minor separator for results
      ⍝ command gets typed into the session, and then Enter is pressed
      ⍝ if there is a "results", then (before the timemout) each of these must occur in the given order
      ⍝ the first target in results specifies the beginning of the line (so skip this with :;)
      ⍝ targets are RegEx when enclosed in Dollar signs ($)
      ⍝ the timeout may be temporarily adjusted from the default by specifying a number of seconds
      ⍝     var←6
      ⍝ just enters the assignment in the session
      ⍝     var×7: 42
      ⍝ checks that the expected result is given.
      ⍝     ⊢⎕DL 6:
      lines←{⍵/⍨'⍝'≠⊃¨⍵}{1↓¨⍵/⍨∧\'⍝'=⊃¨⍵}{⍵{((∨\⍵)∧⌽∨\⌽⍵)/⍺}' '≠⍵}¨(1+2⊃⎕LC)↓⎕NR'Test'
      msg←''
      :For l :In lines/⍨'⍝'≠⊃¨lines
          major←1↓¨':'Split l
          :If 1=≢major
              Se(⊃major)Enter
          :Else
              :If 3≤≢major
                  RETRYLIMIT←⊃∊(//⎕VFI⊃2↓major),DEFAULTRETRYLIMIT
              :EndIf
              minor←';'Split 2⊃major
              (⊃minor)↓⍨←1
              r←(⊃major)Gives minor
          :EndIf
          →0/⍨''≢msg
      :EndFor
    ∇
    :EndSection

    :Section UTILS
    Nested←{(+/∨\' '≠⌽⍵)↑¨↓⍵}⊢⍴⍨¯2↑1,⍴ ⍝ Vector of vectors from simple vector or matrix

    NlFmt←{1↓∊'¶',¨⍵} ⍝ Convert VTV to ¶-separated simple vector

    Split←,⊂⍨⊣=, ⍝ Split ⍵ at separator ⍺, but keep the separators as prefixes to each section

    ∇ r←lc R  ⍝ lowercase
      :If 18≤2⊃⎕VFI 2↑2⊃'.'⎕WG'aplversion'
          r←⎕C R
      :Else
          r←0(819⌶)R
      :EndIf
    ∇

    ∇ {ok}←GoTo url;z;base ⍝ Ask the browser to navigate to a URL and check that it did it
      ok←1
      :If 'http'≢lc 4↑url  ⍝ it's probably a relative URL (does this text need be more detailed?)
          base←BROWSER.Url
          :While (≢url)>z←url⍳'/'
              :If z=1
                  base←((2≥+\base='/')/base),'/'
              :ElseIf '../'≡z↑url
                  base←()↑base
              :ElseIf './'≡z↑url  ⍝ do nothing
              :Else
                  base←base,z↑url
              :EndIf
              url←z↓url
          :EndWhile
          url←base,url
      :EndIf
      BROWSER.Navigate.GoToUrl⊂url
      :Trap 90
          ('Could not navigate from ',BROWSER.Url,' to ',url)⎕SIGNAL 11/⍨~UrlIs url
      :Else
          ('Alert running "',url,'": ',⎕EXCEPTION.Message)⎕SIGNAL 11
      :EndTrap
    ∇

    UrlIs←{(⊂BROWSER.Url)∊⍵(⍵,'/')} ⍝ Is the browser currently at ⍵?

    List←0 1⎕NINFO⍠1⊢ ⍝ List names and types in directory ⍵

    Files←⊃(/⍨∘(2∘=))/ ⍝ Filter for files only

    Folders←⊃(/⍨∘(1∘=))/ ⍝ Filter for folders only

    DefaultTo←{0=⎕NC ⍺:⍎⍺,'←⍵' ⋄ _←⍵} ⍝ set ⍺ to ⍵ if undefined

    PathOf←{⍵↓⍨1-⌊/'/\'⍳⍨⌽⍵} ⍝ Extract path from path/filename.ext

    eis←{(≡⍵)∊0 1:,⊂,⍵ ⋄ ⍵} ⍝ Enlose (even scalars) If Simple

    Urlify←{0''⍬∊⍨⊂⍵:∇ PORT ⋄ ⍬≡0⍴⍵:'http://127.0.0.1:',⍕⍵ ⋄ ⍵} ⍝ Ensure URL even if given just port number

    ∇ r←FindAllFiles root ⍝ Recursive
      :If ∨/' '≠root
          root,←'/'/⍨~'/\'∊⍨¯1↑root ⍝ append trailing / if missing
          r←Files List root,'*',EXT
          r,←Files List root,'*',RIDEEXT
          r,←⊃,/FindAllFiles¨Folders List root,'*'
      :Else
          r←0⍴⊂''
      :EndIf
    ∇

    ∇ {files}←browser SetUsing path ⍝ Set the path to the Selenium DLLs
      :If path≡'' ⋄ path←SourcePath ⎕THIS
      :Else ⋄ path←path,(~'/\'∊⍨⊢/path)/'/' ⋄ :EndIf
      :If ~⎕NEXISTS path,'WebDriver.dll'
          path,←(('WLM'⍳1 1⊃'.'⎕WG'APLVersion')⊃'Win' 'Linux' 'Mac'),'/'  ⍝ subfolder for platform-specific driver files
      :EndIf
      path←('/'⎕R'\\')path
      files←'dll' 'Support.dll',¨⍨⊂path,'WebDriver.' ⍝ 3.141
      ⎕USING←0⍴⎕USING
      ⎕USING,←⊂'OpenQA.Selenium,',⊃files
      ⎕USING,←⊂'OpenQA,',⊃files ⍝ if we need to dig into deeper into Selenium...
      :If ⎕NEXISTS⊃⌽files   ⍝ no WebDriver.Support.dll with v4.⍺
          ⎕USING,←⊂',',⊃⌽files
      :EndIf
      ⎕USING,←⊂'OpenQA.Selenium.',browser,',',⊃files
      ⎕USING,←⊂''  ⍝ VC 200513 via mail to MB
      :If 4≠System.Environment.Version.Major  ⍝ if not .NET 4, it is likely Core!
          ⎕USING,←⊂∊'Newtonsoft.Json,',(1⊃1 ⎕NPARTS(SourcePath ⎕THIS)),'Drivers/more/newtonsoft_120r3-netstandard2.0/Newtonsoft.Json.dll'
      :EndIf
      ⍝ make sure we use the correct path-separator (⎕USING)
      :If 'W'=1⊃1⊃'.'⎕WG'APLVersion'
          ⎕USING←{'\'@('/'∘=)⍵}¨⎕USING
      :Else
          ⎕USING←{'/'@('\'∘=)⍵}¨⎕USING
      :EndIf
     
    ∇

      SourceFile←{ ⍝ Get full pathname of sourcefile for ref ⍵
          file←4⊃5179⌶⍵ ⍝ ⎕FIX
          ''≡file~' ':⍵.SALT_Data.SourceFile ⍝ SALT
          file
      }

    SourcePath←{⊃1⎕nparts SourceFile ⍵}  ⍝ just the path of the SourceFile in questions

    ∇ R←GetSettings
      R←⎕JSON 1⊃⎕NGET(SourcePath ⎕THIS),'settings.json'
    ∇

   ⍝ Local←{⍵,⍨PathOf 1↓⊃('§'∘=⊂⊢)⊃⌽⎕NR'Test'} ⍝ Path of currently running Test function (may need updating if ⎕FIX is used instead of ⎕SE.SALT.Load) ⍝ cadidate for removal...
    :EndSection ───────────────────────────────────────────────────────────────────────────────────
:EndNamespace
