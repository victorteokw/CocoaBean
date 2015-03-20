class CB.Rect

  constructor: (x, y, width, height) ->
    @_origin = new CB.Point(x, y)
    @_size = new CB.Size(width, height)

  @property "readonly", "origin"

  @property "readonly", "size"
