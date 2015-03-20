class CB.Point

  constructor: (x, y) ->
    @_x = x
    @_y = y

  @property "readonly", "x"

  @property "readonly", "y"
