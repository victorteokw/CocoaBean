class CB.ImageView extends CB.View
  constructor: (frame) ->
    super(frame)
    @_userInteractionEnabled = false

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

  sizeThatFits: () ->
    @image.size || new CB.Size(0, 0)

  updateDisplayingImage: () ->
    @layer.attr("src", @image.path)
