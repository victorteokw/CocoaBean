class CB.ImageView extends CB.View
  constructor: (frameOrImage, image) ->
    if !frameOrImage
      super()
    else if frameOrImage.class == CB.Rect
      super(frame)
    else if frameOrImage.class == CB.Image
      image = frameOrImage
      super()
    @image = image if image
    @_userInteractionEnabled = false

  @property "image",
    set: (newImage) ->
      @_image = newImage
      this.updateDisplayingImage()

  layerDescription: () ->
    @img = $("<img></img>")
    layer = $("<div></div>")
    layer.append(@img)
    @img.css("display", "block")
    this.renderDelegate.normalizeLayer(@img)
    layer

  sizeThatFits: () ->
    @image.size || new CB.Size(0, 0)

  updateDisplayingImage: () ->
    @img.attr("src", @image.path)
    this.syncWithContentMode()

  @property "contentMode",
    set: (newMode) ->
      @_contentMode = newMode
      this.contentModeChanged()
      return

  @property "frame",
    set: (newFrame) ->
      @_frame = newFrame
      @renderDelegate.applyFrameForView(this)
      this.frameChanged()
      return

  frameChanged: () ->
    this.syncWithContentMode()

  contentModeChanged: () ->
    this.syncWithContentMode()

  syncWithContentMode: () ->
    return unless @image
    imageOriginalSize = @image.size
    return unless imageOriginalSize
    if @contentMode == "scale to fill"
      this.applySizeForImg(0, 0, @frame.width, @frame.height)
    else if @contentMode == "scale aspect fit"
      scaleWidth = imageOriginalSize.width / @frame.width
      scaleHeight = imageOriginalSize.height / @frame.height
      useScale = Math.max(scaleWidth, scaleHeight)
      renderingWidth  = imageOriginalSize.width / scaleWidth
      renderingHeight = imageOriginalSize.height / scaleHeight
      renderingLeft = (@frame.width - renderingWidth) / 2
      renderingTop = (@frame.height - renderingHeight) / 2
      this.applySizeForImg(renderingLeft, renderingTop, renderingWidth, renderingHeight)
    else if @contentMode == "scale aspect fill"
      scaleWidth = imageOriginalSize.width / @frame.width
      scaleHeight = imageOriginalSize.height / @frame.height
      useScale = Math.min(scaleWidth, scaleHeight)
      renderingWidth  = imageOriginalSize.width / scaleWidth
      renderingHeight = imageOriginalSize.height / scaleHeight
      renderingLeft = (@frame.width - renderingWidth) / 2
      renderingTop = (@frame.height - renderingHeight) / 2
      this.applySizeForImg(renderingLeft, renderingTop, renderingWidth, renderingHeight)
    else if @contentMode == "center"
      renderingLeft = (@frame.width - renderingWidth) / 2
      renderingTop = (@frame.height - renderingHeight) / 2
      this.applySizeForImg(renderingLeft, renderingTop, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "top"
      renderingLeft = (@frame.width - renderingWidth) / 2
      this.applySizeForImg(renderingLeft, 0, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "bottom"
      renderingLeft = (@frame.width - renderingWidth) / 2
      renderingTop = @frame.height - imageOriginalSize.height
      this.applySizeForImg(renderingLeft, renderingTop, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "left"
      renderingTop = (@frame.height - renderingHeight) / 2
      this.applySizeForImg(0, renderingTop, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "right"
      renderingLeft = @frame.width - imageOriginalSize.width
      renderingTop = (@frame.height - renderingHeight) / 2
      this.applySizeForImg(renderingLeft, renderingTop, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "top left"
      this.applySizeForImg(0, 0, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "top right"
      renderingLeft = @frame.width - imageOriginalSize.width
      this.applySizeForImg(renderingLeft, 0, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "bottom left"
      renderingTop = @frame.height - imageOriginalSize.height
      this.applySizeForImg(0, renderingLeft, imageOriginalSize.width, imageOriginalSize.height)
    else if @contentMode == "bottom right"
      renderingTop = @frame.height - imageOriginalSize.height
      renderingLeft = @frame.width - imageOriginalSize.width
      this.applySizeForImg(renderingLeft, renderingTop, imageOriginalSize.width, imageOriginalSize.height)
  applySizeForImg: (left, top, width, height) ->
    @img.width(width)
    @img.height(height)
    @img.css("left", 0)
    @img.css("top", 0)
