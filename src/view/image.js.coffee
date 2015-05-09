class CB.Image
  constructor: (nameOrUrl) ->
    if !nameOrUrl
      throw CB.ArgumentError("Expect argument 1 to be String")
    if nameOrUrl.match(/https?:\/\//)
      @_url = nameOrUrl
      @_path = nameOrUrl
    else
      @_name = nameOrUrl
      this.__imageMetadataQuery(@_name)

  @property "readonly", "name"

  @property "readonly", "size"

  @property "readonly", "url"

  @property "readonly", "path"

  __imageMetadataQuery: (name) ->
    imageMetadata = CB.__ImageMetadata
    pixelRatio = window.devicePixelRatio
    if name.match(/\.(png|jpg|svg|bmp)/)
      foundName = name
      pureName = name.substring(0, name.length - 4)
      extensionName = name.substring(name.length - 3)
    else
      for calculatedName in [name + ".png", name + ".jpg", name + ".svg", name + ".bmp"]
        if imageMetadata[calculatedName]
          foundName = calculatedName
          pureName = name
          extensionName = foundName.substring(foundName.length - 3)
          break
    throw "Image not found" unless foundName
    data = imageMetadata[foundName]
    width = data["width"]
    height = data["height"]
    @_size = new CB.Size(width, height)
    theOthers = [1, 2, 3].reject (i) =>
      i == pixelRatio
    pixelRatios = [pixelRatio].concat(theOthers)
    for r in pixelRatios
      if data["@" + r + "x"]
        if r == 1
          @_path = "assets/" + pureName + "." + extensionName
        else
          @_path = "assets/" + pureName + "@" + r + "x" + "." + extensionName
        break
    return
