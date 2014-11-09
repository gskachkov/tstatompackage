 CoverageView = require './coverage-view'

 module.exports =
   activate: ->
     atom.workspaceView.eachEditorView (editorView) ->
       if editorView.attached and editorView.getPaneView()?
         new CoverageView(editorView)
         console.log 'Activate'
