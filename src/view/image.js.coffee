class CB.ImageNotFoundError extends Error

  constructor: (args...) ->
    super(args...)
    @name = "ImageNotFoundError"
    @message ||= "Image not found."

class CB.Image

  constructor: (nameOrUrl, resizingMode) ->
    if !nameOrUrl
      throw CB.ArgumentError("Please provide image name or url.")

    if nameOrUrl.match(/https?:\/\//)
      @_path = nameOrUrl
      @_scale = 1
      @_local = false
      @_name = "web image somehow" # TODO: make this random string
    else
      @_name = nameOrUrl
      this.__imageMetadataQuery(@_name)
      @_local = true

    @_resizingMode = resizingMode || "stretch"

  @property "readonly", "name"

  @property "readonly", "size"

  @property "readonly", "path"

  @property "readonly", "scale"

  @property "readonly", "local"

  # 'tile' or 'stretch'
  # default value is 'stretch'
  @property "readonly", "resizingMode"

  __imageMetadataQuery: (name) ->
    imageMetadata = CB.__ImageMetadata
    pixelRatio = window.devicePixelRatio
    if name.match(/\.(png|jpg|svg|bmp)/)
      foundName = name
      pureName = name.substring(0, name.length - 4)
      extensionName = name.substring(name.length - 3)
    else
      names = [name + ".png", name + ".jpg", name + ".svg", name + ".bmp"]
      for calculatedName in names
        if imageMetadata[calculatedName]
          foundName = calculatedName
          pureName = name
          extensionName = foundName.substring(foundName.length - 3)
          break
    unless foundName
      throw new CB.ImageNotFoundError "Imaged named #{name} is not found."
    data = imageMetadata[foundName]
    width = data["width"]
    height = data["height"]
    @_size = new CB.Size(width, height)
    theOthers = [1, 2, 3].reject (i) ->
      i == pixelRatio
    pixelRatios = [pixelRatio].concat(theOthers)
    for r in pixelRatios
      if data["@" + r + "x"]
        @_scale = r
        if r == 1
          @_path = "assets/" + pureName + "." + extensionName
        else
          @_path = "assets/" + pureName + "@" + r + "x" + "." + extensionName
        break
    return

class CB.ImageConfig
  # will be used

class CB.ImageMetadata
  @__md = {}
  @load: (obj) ->
    @__md = obj
