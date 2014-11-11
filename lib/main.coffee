 CoverageView = require './coverage-view'

 module.exports =
   config:
    pathToLCOV:
      type: 'string'
      default: '/Users/Developer/Projects/ppjs_1/test/coverage/PhantomJS 1.9.8 (Mac OS X)/lcov.info'
    basePath:
      type: 'string'
      default: '/Users/Developer/Projects/ppjs_1/test/coverage/PhantomJS 1.9.8 (Mac OS X)/lcov.info'
   activate: ->
     atom.workspaceView.eachEditorView (editorView) ->
       if editorView.attached and editorView.getPaneView()?
         new CoverageView(editorView)
   deactivate: ->
     atom.workspaceView.eachEditorView (editorView) ->
