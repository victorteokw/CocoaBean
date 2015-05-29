class CB.Point

  constructor: (x, y) ->
    @_x = x
    @_y = y

  @property "readonly", "x"

  @property "readonly", "y"

  equals: (rhs) ->
    @x == rhs.x && @y == rhs.y

  copy: ->
    new CB.Point(@x, @y)

  @provided Equalable, Copyable
