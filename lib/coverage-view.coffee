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

    pathToLCOV = '/Users/Developer/Projects/ppjs_1/test/coverage/PhantomJS 1.9.8 (Mac OS X)/lcov.info'
    #pw.watch p, (event, path) ->
    #  console.log(event, path)

    file = new pw.File(pathToLCOV)

    content = file.readSync()
    arr = content.split('\n')

    parser = new ParseLCOV(arr)
    coverages = parser.parse()
    bathPath = '/Users/Developer/Projects/ppjs_1'
    currFile = "./src/scripts/app/modules/common/cmsfactory/cms-factory.js"
    currCoverage = coverages[currFile]

    #@subscribe @editor.onDidChangeScrollTop =>
    #    lastScreenRow = @editor.getLastVisibleScreenRow()
    #    firstScreenRow = @editor.getFirstVisibleScreenRow()
    #    console.log 'Did onDidChangeScrollTop ' + lastScreenRow + ' to ' + firstScreenRow

    #    for line in currCoverage.coverdLines
    #      if line.line <= lastScreenRow && line.line >= firstScreenRow

    for line in currCoverage.coverdLines
      marker = @editor.markBufferRange([[line.line, 0], [line.line, Infinity]], invalidate: 'never')
      if line.count > 0?
        @editor.decorateMarker(marker, type: 'gutter', class: 'covered')
      else
        @editor.decorateMarker(marker, type: 'gutter', class: 'not-covered')

      @markers ?= []
      @markers.push(marker)
