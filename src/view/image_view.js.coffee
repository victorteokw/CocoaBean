class CB.ImageView extends CB.View
  constructor: (frame) ->
    super(frame)

  @property "image",
    set: (newImage) ->
      @_image = newImage
      this.updateDisplayingImage()

  layerDescription: () ->
    # Make it easy now
    layer = $("<img></img>")
    # <div><img></img></div> is better to have view mode
    layer.css("display", "block")
    layer

  updateDisplayingImage: () ->
    @layer.attr("src", @image.path)
