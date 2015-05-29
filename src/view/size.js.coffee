class CB.Size

  constructor: (width, height) ->
    @_width = width
    @_height = height

  @property "readonly", "width"

  @property "readonly", "height"

  equals: (rhs) ->
    @width == rhs.width and @height == rhs.height

  copy: ->
    new CB.Size(@width, @height)

  @provided Equalable, Copyable
