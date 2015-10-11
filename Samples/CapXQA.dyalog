:Namespace CapXQA

∇ Assumptions
     ⍝ Test the CapX assumption editor page
     
 InitBrowser''
 GoTo'http://127.0.0.1:8081/assumptions'
     
     ⍝ Set Scope Assumption Type
 'asstype'Select'Growth'
 'FG11'Select'AltRegion'
 'FG12'Select'AltRegion_1'
     
 'asssel'Select'1'
∇

∇ Report1;expect;got
     ⍝ Test the CapX report_1 page
     
 InitBrowser''
 GoTo'http://127.0.0.1:8081/report_1'
     
     ⍝ Set Scope
 'StartPeriod' 'EndPeriod'Select¨'2015-07' '2017-06'
 0 ejAccordionTab'Scope' 'StartPeriod'  ⍝ Close
     
     ⍝ Set Filters
 ejAccordionTab'Filter Levels' 'listDomHry' ⍝ Open
 'listDomHry'ListMgrSelect'State'
 Click'btnDomHrySave'
 'selectOneFilter'Select'State'
 'listFilterValues'ListMgrSelect'AL' 'FL' 'GA'
 Click'btnFilterValuesSave'
 0 ejAccordionTab'Filter Levels' 'listDomHry' ⍝ Close
     
     ⍝ Set Summarization
 ejAccordionTab'Summarization' 'GB21'   ⍝ Open Accordion Tab
 'GB21'Select'1'                        ⍝ Make "State" the first dimension
 Click'RBCK22'                          ⍝ Select "State" level for rollup
 'GB41'Select'2'                        ⍝ Make "ProdGrp" the 2nd dimension
 Click'btnRunReport'                    ⍝ Run the report
 0 ejAccordionTab'Summarization' 'GB21' ⍝ Close Accordion Tab
     
     ⍝ View the report
 ejAccordionTab'Output' 'report1'       ⍝ Open Accordion Tab
 expect←'Grand Total' '458.2' '422,496.0' '42,573.5'
 :If expect≡got←(⌷'CssSelectors'Find'#report1 td')[1 2 3 4].Text
     ⎕←'Expected Grand Total Computed'
 :Else
     ⎕←'Oops! Expected: 'expect', got:'got
 :EndIf
∇

:EndNamespace 