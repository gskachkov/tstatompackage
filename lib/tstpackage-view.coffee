fs = require 'fs-plus'
pw = require 'pathwatcher'
ParseLCOV = require './parselcov'


module.exports =
class TstpackageView
  constructor: (serializeState) ->
    # Create root element
    @element = document.createElement('div')
    @element.classList.add('tstpackage',  'overlay', 'from-top')

    # Create message element
    message = document.createElement('div')
    message.textContent = "The Tstpackage package is Alive! It's ALIVE!"
    message.classList.add('message')
    @element.appendChild(message)

    # Register command that toggles this view
    atom.commands.add 'atom-workspace', 'tstpackage:toggle': => @toggle()

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  # Toggle the visibility of this view
  toggle: ->
    console.log 'TstpackageView was toggled!'

    if @element.parentElement?
      @element.remove()
    else
      atom.workspaceView.append(@element)
      p = '/Users/Developer/Projects/ppjs_1/test/coverage/PhantomJS 1.9.8 (Mac OS X)/lcov.info'
      #pw.watch p, (event, path) ->
      #  console.log(event, path)

      file = new pw.File(p)

      content = file.readSync()
      arr = content.split('\n')

      parser = new ParseLCOV(arr)
      coverages = parser.parse()
      bathPath = '/Users/Developer/Projects/ppjs_1'
      currFile = "./src/scripts/app/modules/common/cmsfactory/cms-factory.js"
      currCoverage = coverages[currFile]

      currentView = atom.workspaceView.getActiveView()[0]
      @editor = atom.workspaceView.getEditorViews()[0].getModel()
      #for i = 0; i < currCoverage.coverdLines.length; i++

      @subscribe @editor.onDidChange =>
      console.log 'did change'

      console.log currentView
      console.log atom.workspaceView.getEditorViews()[0].getModel()
