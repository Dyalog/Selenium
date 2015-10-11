:Namespace TestTryAPL

    ∇ r←Basic;S;result
     ⍝ Verify that TryAPL is working
     
      S←##.Selenium
      S.InitBrowser''
      S.GoTo'http://tryapl.org'

      'APLedit'S.SendKeys'1 2 3+4 5 6'
      S.('APLedit'SendKeys Keys.Return)
      result←('ClassName'#.Selenium.Find'result')

      :If '5 7 9'≡result.Text
          r←'TRYAPL is working'
      :Else
          r←'1 2 3+4 5 6 failed'
      :EndIf
    ∇

:EndNamespace 