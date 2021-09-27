through2 = require 'through2'
util = require('util')


module.exports = (options) ->
  words = 0
  chars = 0
  bytes = 0
  lines = 1

  transform = (chunk, encoding, cb) ->
    # char and bytes count
    chars += chunk.length
    bytes += new util.TextEncoder().encode(chunk).length

    chunk = chunk.split('\n')
    # edge case when there's an extra newline at the end
    if chunk[chunk.length-1] == ""
      chunk.pop()

    lines = chunk.length

    for c in chunk
      # quoted strings
      if c[0] == '"' && c[c.length-1] == '"'
        words += 1
        continue

      # camel case
      # only separate if it's not all capital
      if c != c.toUpperCase()
        c = camelToSentence(c)
      tokens = c.split(' ')
      words += tokens.length
    return cb()

  flush = (cb) ->
    returnObj = {words, lines}
    if options && options.charCount
      returnObj['chars'] = chars 
    if options && options.byteCount
      returnObj['bytes'] = bytes

    this.push returnObj
    this.push null
    return cb()

  return through2.obj transform, flush

camelToSentence = (word) ->
  return word.replace(/[A-Z]/g, (v, i) ->
    if i == 0
      return v
    return " " + v
  )