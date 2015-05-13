class CB.Range
  constructor: (start, length) ->
    if typeof length == 'undefined' and typeof start == 'object'
      length = start[1] - start[0]
      start = start[0]
    @_start = start
    @_length = length

  @property "readonly", "start"
  @property "readonly", "length"
  @property "readonly", "end",
    set: (newEnd) ->
      len = newEnd - @_start
      @_length = len
    get: () ->
      @_start + @_length

  equals: (rhs) ->
    this.start == rhs.start and this.length == rhs.length
