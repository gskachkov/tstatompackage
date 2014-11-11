#_ = require 'underscore-plus'
fs = require 'fs-plus'
pw = require 'pathwatcher'
ParseLCOV = require './parselcov'
{Range, View, TextEditor, TextEditorView} = require 'atom'
#TagFinder = require './tag-finder'

module.exports =
class CoverageView extends View
  @content: ->
    @div =>
      @div class: 'coverage-view', style: 'display: none', outlet: 'startView'
      @div class: 'coverage-view', style: 'display: none', outlet: 'endView'

  initialize: (@editorView) ->
    @editor = @editorView.getModel()
    basePath = pathToLCOV = atom.config.get('tstpackage.basePath')
    currFile = @editor.getPath().replace(basePath, '.')
    pathToLCOV = atom.config.get('tstpackage.pathToLCOV')

    @markers = []

    pw.watch pathToLCOV, =>
      @showCoverage(@editor, pathToLCOV, currFile)

    @subscribe @editor.onDidChange =>
      @showCoverage(@editor, pathToLCOV, currFile)

    @showCoverage(@editor, pathToLCOV, currFile)

  showCoverage: (editor, pathToLCOV, currFile) ->
    currCoverage = @getCoverage(pathToLCOV, currFile)
    if currCoverage?
      @markGutter editor, currCoverage

  getCoverage: (pathToLCOV, currFile) ->
    file = new pw.File(pathToLCOV)

    content = file.readSync()
    arr = content.split('\n')

    parser = new ParseLCOV(arr)
    coverages = parser.parse()

    return coverages[currFile]

  markGutter: (editor, currCoverage) ->
    for marker in @markers
      marker.destroy()

    @markers = []

    for line in currCoverage.coverdLines
      marker = editor.markBufferRange([[line.line - 1, 0], [line.line - 1, Infinity]], invalidate: 'never')
      if line.count > 0
        editor.decorateMarker(marker, type: 'gutter', class: 'covered')
      else
        editor.decorateMarker(marker, type: 'gutter', class: 'not-covered')

      @markers.push(marker)
      deactivate: ->
