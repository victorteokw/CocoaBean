class CB.Image
  constructor: (name, size) ->
    if !name or !size
      throw CB.ArgumentError("Expect argument 1 to be String, argument 2 to be CB.Size")
    @_name = name
    @_size = size

  @property "readonly", "name"

  @property "readonly", "size"

  @property "readonly", "path",
    get: () ->
      "images/" + @name
