 CoverageView = require './coverage-view'

 module.exports =
   config:
    pathToLCOV:
      type: 'string'
      default: '/Users/Developer/Projects/foo/test/coverage/PhantomJS 1.9.8 (Mac OS X)/lcov.info'
    basePath:
      type: 'string'
      default: '/Users/Developer/Projects/foo'
   activate: ->
     atom.workspaceView.eachEditorView (editorView) ->
       if editorView.attached and editorView.getPaneView()?
         new CoverageView(editorView)
   deactivate: ->
     #atom.workspaceView.eachEditorView (editorView) ->
