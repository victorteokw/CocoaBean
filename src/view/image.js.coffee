class CB.Image
  constructor: (nameOrUrl, size) ->
    if !nameOrUrl or !size
      throw CB.ArgumentError("Expect argument 1 to be String, argument 2 to be CB.Size")
    if nameOrUrl.match(/https?:\/\//)
      @_url = nameOrUrl
    else
      @_name = nameOrUrl
    @_size = size

  @property "readonly", "name"

  @property "readonly", "size"

  @property "readonly", "url"

  @property "readonly", "path",
    get: () ->
      if @url
        @url
      else
        "assets/" + @name
