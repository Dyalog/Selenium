# Simple example

A basic example is provided in the `Samples\` folder of the [GitHub repository](https://github.com/Dyalog/Selenium) where the code in `TestUppercase.aplf` controls the website coded in text-uppercase.html that accepts text input and shows its representation in uppercase upon clicking the "Transform" button.

````
  r←TestUppercase nul;S;path;demoText;expect;errMsg
 path←1⊃1 ⎕NPARTS{6::50 ⎕ATX ⍵ ⋄ SALT_Data.SourceFile}1⊃⎕SI   ⍝ where does this file come from?
 11 ⎕SIGNAL(0=≢path)/'Unable to determine source path'
 demoText←'Hello World!'
 expect←1 ⎕C demoText
 errMsg←'Did not find expected output!'
 S←Selenium
 S.InitBrowser'LatestChrome'
 S.GoTo'file:///',path,'text-uppercase.html'
 'inputText'S.SendKeys demoText
 (S.Find'transformButton').Click
 r←'outputText'S.WaitFor expect errMsg
 ````

There is some initialisation work to do by assigning path as the directory where the code was loaded from. (This approach is compatible with SALT's `]Load` as well as with Link´s `]Import` or `⎕FIX`.) It then assigns `demoText` as the text that we want to operate on and uses `⎕C` to determine the expected value, which we will compare against the result that the web page delivers.
 The above code assumes that the `Selenium` namespace has been loaded into the same namespace as the `TestUppercase` function itself and creates a reference to it using the variable `S`.

After this setup work, the test is executed:

Expression | Discussion
-----------|-------------------
 `S.InitBrowser'LatestChrome'` | Launch the browser
 `S.GoTo'file:///',path,'text-uppercase.html'` | Open the local version of the uppercase application
 `'inputText'S.SendKeys demoText` | Enter the sample text into the input field
 `(S.Find'transformButton').Click` | Click the "Transform" button
 `r←'outputText'S.WaitFor expect errMsg` | Wait until the expected text appears in the output field, otherwise print an error message
