# Dealing with Screenshots

Screenshots can be useful in testing as they can help to ensure proper rendering and identify regressions over time (when comparing screenshots from different runs).

## SaveScreenshot filename
<a name="savescreenshot"></a>

This function saves a screenshot to the file that you specified in the argument. The file should have a PNG extension.

## z←ref CompareScreenshots file
<a name="comparescreenshots"></a>

This function compares the screenshots in the two files given in the left and right argument. If they are the same, z←0. If they differ, z←1 and a file indicating the differences will be created (named like file2 with a suffix "-diff").