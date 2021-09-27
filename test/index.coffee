assert = require 'assert'
WordCount = require '../lib'


helper = (input, expected, done, options) ->
  pass = false
  counter = new WordCount(options)

  counter.on 'readable', ->
    return unless result = this.read()
    assert.deepEqual result, expected
    assert !pass, 'Are you sure everything works as expected?'
    pass = true

  counter.on 'end', ->
    if pass then return done()
    done new Error 'Looks like transform fn does not work'

  counter.write input
  counter.end()


describe '10-word-count', ->

  it 'should count a single word', (done) ->
    input = 'test'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count words in a phrase', (done) ->
    input = 'this is a basic test'
    expected = words: 5, lines: 1
    helper input, expected, done

  it 'should count quoted characters as a single word', (done) ->
    input = '"this is one word!"'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should count camel cased word as multiple words', (done) ->
    input = 'FunPuzzle'
    expected = words: 2, lines: 1
    helper input, expected, done
  
  it 'should be able to count lines', (done) ->
    input = "First\nSecond"
    expected = words: 2, lines: 2
    helper input, expected, done

  it 'should count all capital word as one word', (done) ->
    input = 'FUNPUZZLE'
    expected = words: 1, lines: 1
    helper input, expected, done

  it 'should return char count if option is activated', (done) ->
    input = 'Fun'
    expected = words: 1, lines: 1, chars: 3
    helper input, expected, done, {charCount: true}

  it 'should return byte count if option is activated', (done) ->
    input = 'Fun'
    expected = words: 1, lines: 1, bytes: 3
    helper input, expected, done, {byteCount: true}

  it 'should be able to count words, lines, chars and bytes in multiline test fixtures', (done) ->
    input = 'The\n"Quick Brown Fox"\njumps over the lazy dog\n'
    expected = words: 7, lines: 3, chars: 46, bytes: 46
    helper input, expected, done, {byteCount: true, charCount: true}

  # !!!!!
  # Make the above tests pass and add more tests!
  # !!!!!
