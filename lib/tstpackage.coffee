TstpackageView = require './tstpackage-view'

module.exports =
  tstpackageView: null

  activate: (state) ->
    @tstpackageView = new TstpackageView(state.tstpackageViewState)

  deactivate: ->
    @tstpackageView.destroy()

  serialize: ->
    tstpackageViewState: @tstpackageView.serialize()
