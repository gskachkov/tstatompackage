{WorkspaceView} = require 'atom'
Tstpackage = require '../lib/tstpackage'

# Use the command `window:run-package-specs` (cmd-alt-ctrl-p) to run specs.
#
# To run a specific `it` or `describe` block add an `f` to the front (e.g. `fit`
# or `fdescribe`). Remove the `f` to unfocus the block.

describe "Tstpackage", ->
  activationPromise = null

  beforeEach ->
    atom.workspaceView = new WorkspaceView
    activationPromise = atom.packages.activatePackage('tstpackage')

  describe "when the tstpackage:toggle event is triggered", ->
    it "attaches and then detaches the view", ->
      expect(atom.workspaceView.find('.tstpackage')).not.toExist()

      # This is an activation event, triggering it will cause the package to be
      # activated.
      atom.commands.dispatch atom.workspaceView.element, 'tstpackage:toggle'

      waitsForPromise ->
        activationPromise

      runs ->
        expect(atom.workspaceView.find('.tstpackage')).toExist()
        atom.commands.dispatch atom.workspaceView.element, 'tstpackage:toggle'
        expect(atom.workspaceView.find('.tstpackage')).not.toExist()
