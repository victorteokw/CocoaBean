class CB.LabelView extends CB.View

  constructor: (frame) ->
    super(frame)
    @_userInteractionEnabled = false

  @property "text",
    set: (newText) ->
      @_text = newText
      @layer.text(newText)
      this.setNeedsLayout()

  @property "font",
    set: (newFont) ->
      @_font = newFont
      @css("font-family", newFont)
      this.setNeedsLayout()

  @property "fontSize",
    set: (newValue) ->
      @_fontSize = newValue
      @css("font-size", newValue)
      this.setNeedsLayout()

  @property "textColor",
    set: (newTextColor) ->
      @_textColor = newTextColor
      @css("color", newTextColor)

  @property "textAlignment",
    set: (newValue) ->
      @_textAlignment = newValue
      @css("text-align", newValue)

  @property "lineBreakMode"

  @property "adjustsFontSizeToFitWidth"

  @property "baselineAdjustment"

  @property "numberOfLines"

  layerDescription: () ->
    $("<div></div>")

  sizeThatFits: (size) ->
    # DOM implementation
    # there is better canvas implementation
    # see: https://stackoverflow.com/questions/118241/calculate-text-width-with-javascript/21015393#21015393
    if !@_sizeTestingLayer
      @_sizeTestingLayer = $("<div></div>")
      @_sizeTestingLayer.css("position", "absolute")
      @_sizeTestingLayer.css("visibility", "hidden")
      @_sizeTestingLayer.css("height", "auto")
      @_sizeTestingLayer.css("width", "auto")
      @_sizeTestingLayer.css("white-space", "nowrap")
    @_sizeTestingLayer.css("font-family", @font)
    @_sizeTestingLayer.css("font-size", @fontSize)
    @_sizeTestingLayer.text(@text)
    $("body").append(@_sizeTestingLayer)
    h = @_sizeTestingLayer[0].clientHeight + 1
    w = @_sizeTestingLayer[0].clientWidth + 1
    @_sizeTestingLayer.remove()
    CB.Log("Height " + h + " Width " + w)
    new CB.Size(w, h)
