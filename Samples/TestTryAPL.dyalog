:Namespace TestTryAPL

    ∇ r←Basic;S;result
     ⍝ Verify that TryAPL is working - return error message if it isn't
     
      S←##.Selenium
      S.InitBrowser''
      S.GoTo'http://tryapl.org'
     
      'APLedit'S.SendKeys'1 2 3+4 5 6'
      S.('APLedit'SendKeys Keys.Return)
      result←'ClassName'S.Find'result'
      r←result S.WaitFor'5 7 9' '1 2 3+4 5 6 failed'
    ∇

:EndNamespace 