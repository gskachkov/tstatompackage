fs = require 'fs-plus'
path = require 'path'
ParseLCOV = require './parselcov'
{View} = require 'atom'

module.exports =
class CoverageView extends View
  @content: ->
    @div =>
      @div class: 'coverage-view', style: 'display: none', outlet: 'startView'
      @div class: 'coverage-view', style: 'display: none', outlet: 'endView'
  initialize: (@editorView) ->
    @editor = @editorView.getModel()
    basePath = atom.config.get('tstpackage.basePath')
    filePath = @editor.getPath()

    if typeof(filePath) == 'undefined'
      return

    currFile = "./" + path.relative(basePath, filePath).replace(/\\/g,'/')

    pathToLCOV = atom.config.get('tstpackage.pathToLCOV')

    @markers = []

    @watcher = fs.watch pathToLCOV, =>
      @showCoverage(@editor, pathToLCOV, currFile)

    @subscribe @editor.onDidDestroy =>
      @watcher.close()
      #TODO Reafctor later
      @currCoverage = undefined

    @subscribe @editor.onDidChange =>
      @showCoverage(@editor, pathToLCOV, currFile)

    @showCoverage(@editor, pathToLCOV, currFile)

  showCoverage: (editor, pathToLCOV, currFile) ->
    if editor.isDestroyed()
      return

    @currCoverage = @getCoverage(pathToLCOV, currFile)
    if @currCoverage?
      @markGutter editor, @currCoverage

  getCoverage: (pathToLCOV, currFile) ->
    content = fs.readFileSync(pathToLCOV,  {encoding: 'utf8'})

    arr = content.split('\n')

    parser = new ParseLCOV(arr)
    coverages = parser.parse()

    return coverages[currFile]

  markGutter: (editor, currCoverage) ->
    for marker in @markers
      marker.destroy()

    @markers = []

    for line in currCoverage.coveredLines
      marker = editor.markBufferRange([[line.line - 1, 0], [line.line - 1, Infinity]], invalidate: 'never')
      if line.count > 0
        editor.decorateMarker(marker, type: 'gutter', class: 'covered')
      else
        editor.decorateMarker(marker, type: 'gutter', class: 'not-covered')

      @markers.push(marker)
