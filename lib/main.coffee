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
     atom.workspace.getTextEditors().forEach (editor) ->
       new CoverageView(editor)

     atom.workspace.onDidAddTextEditor (event) ->
       new CoverageView(event.textEditor)
   deactivate: ->
     #atom.workspaceView.eachEditorView (editorView) ->
