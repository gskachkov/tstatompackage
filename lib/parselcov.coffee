module.exports =
class ParseLCOV
  constructor: (array) ->
    @data = array
  parse: ->
    i = 0
    length = @data.length
    coverage = {}

    while i < length
      record = @data[i]
      headerLength = record.indexOf(':')

      if headerLength > -1
        header = record.substr(0, headerLength)
        value = record.substr(headerLength + 1, record.length - headerLength)

        #SF: ./path/tofile.js
        if header == 'SF'
          coverage[value] = {}
          currFc = coverage[value]

        #DA:72,12
        if header == 'DA'
          if !currFc['coveredLines']
            currFc['coveredLines'] = []
          position = value.indexOf(',')
          line = value.substr(0, position)
          count = value.substr(position + 1, value.length - 1)
          currFc['coveredLines'].push({line : parseInt(line), count : parseInt(count)})

        #BRDA:76,10,0,11
        if header == 'BRDA'
          values = value.split(',')
          line = values[0];
          #block = values[1];
          #branch = values[2];
          notTaken = values[3] == '0'
          if notTaken
            if !currFc['uncoveredBranches']
              currFc['uncoveredBranches'] = []
            currFc['uncoveredBranches'].push(parseInt(line))

      i++

    #console.log coverage
    return coverage
