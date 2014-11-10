module.exports =
class ParseLCOV
  constructor: (array) ->
    @data = array
    #console.log 'constrauct'
  parse: ->
    #console.log 'parse 1'
    i = 0
    length = @data.length
    coverage = {}

    while i < length
      record = @data[i]
      headerLength = record.indexOf(':')
      if headerLength > -1
        header = record.substr(0, headerLength)
        value = record.substr(headerLength + 1, record.length - headerLength)

        #console.log header, value

        if header == 'SF'
          coverage[value] = {}
          currFc = coverage[value]

        if header == 'DA'
          if !currFc['coverdLines']
            currFc['coverdLines'] = []
          position = value.indexOf(',')
          line = value.substr(0, position)
          count = value.substr(position + 1, value.length - 1)
          currFc['coverdLines'].push({line : parseInt(line), count : parseInt(count)})

      i++

    #console.log coverage
    return coverage
