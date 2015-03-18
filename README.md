Test coverage package
=====================

Package that allow to show test coverage in gutter.

![Coverage in gutter](https://raw.githubusercontent.com/gskachkov/tstatompackage/master/content/SnipImage.JPG)

Information about test coverage is extracted form LCOV file that generated by unite test framework reporter. For instance karma coverage allow to generate such LCOV files: ...[http://karma-runner.github.io/0.8/config/coverage.html] , ...[https://github.com/karma-runner/karma-coverage]

-	**pathToLCOV** - path to file where LCOV is placed
-	**basePath** - base path for the tests For instance project is placed by following path: /Users/Developer/Projects/foo and has following structure: */Users/Developer/Projects/foo/web/src/module1/file1.js**/Users/Developer/Projects/foo/web/src/module1/file2.js* */Users/Developer/Projects/foo/web/src/module2/file1.js* */Users/Developer/Projects/foo/web/src/module2/file2.js* */Users/Developer/Projects/foo/test/karma.conf.js*

LCOV generate report into: */Users/Developer/Projects/foo/test/coverage/lcov.info* and in LCOV file has following paths:

> SF:./src/module2/file2.js ... SF:./src/module2/file2.js ...

BasePath has to be selected: ***/Users/Developer/Projects/foo/web***

---

-	green line - fully covered line
-	orange line - some of the branch in if condition is not covered
-	red line - color is uncovered by test line

--- If you found bug or you have some question in configuration please use this link  
 https://github.com/gskachkov/tstatompackage/issues ---
