class CB.Size

  constructor: (width, height) ->
    @_width = width
    @_height = height

  @property "readonly", "width"

  @property "readonly", "height"
