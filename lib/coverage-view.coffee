fs = require 'fs-plus'
path = require 'path'
ParseLCOV = require './parselcov'
{View} = require 'atom-space-pen-views'
{CompositeDisposable} = require 'event-kit'

module.exports =
class CoverageView extends View
  @content: ->
    @div =>
      @div class: 'coverage-view', style: 'display: none', outlet: 'startView'
      @div class: 'coverage-view', style: 'display: none', outlet: 'endView'
  initialize: (@_editor) ->
    @subscriptions = new CompositeDisposable

    @editor = @_editor
    basePath = atom.config.get('coverage-gutter.basePath')
    filePath = @editor.getPath()

    if typeof(filePath) == 'undefined'
      return

    currFile = "./" + path.relative(basePath, filePath).replace(/\\/g,'/')

    pathToLCOV = atom.config.get('coverage-gutter.pathToLCOV')

    if !fs.existsSync(pathToLCOV)
      console.log 'Could not find file by pathToLCOV property.'
      alert 'Could not find file by pathToLCOV property.'
      return

    @markers = []

    @watcher = fs.watch pathToLCOV, =>
      @showCoverage(@editor, pathToLCOV, currFile)

    @subscriptions.add @editor.onDidDestroy =>
      @watcher.close()
      #TODO Reafctor later
      @currCoverage = undefined

    @subscriptions.add @editor.onDidChange =>
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

      cssClass = 'not-covered'
      if line.count > 0
        cssClass = 'covered'
        if currCoverage.uncoveredBranches?
          cssClass = if currCoverage.uncoveredBranches.indexOf(line.line) > -1 then 'partly-covered' else 'covered'

      editor.decorateMarker(marker, {type: 'line-number', class: cssClass})

      @markers.push(marker)
  destroy: ->
    @subscriptions.dispose() # Dispose of all subscriptions at once
