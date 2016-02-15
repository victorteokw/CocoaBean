class CB.LabelView extends CB.View

  constructor: (frame) ->
    super(frame)
    @_userInteractionEnabled = false

  # Implementation from here
  # https://github.com/cheunghy/jquery.colorfy/blob/master/jquery.colorfy.coffee
  __htmlfyText: (dataText) ->
    dataText = dataText.replace(/&/g, '&amp;')    # & -> &amp;
    dataText = dataText.replace(/</g, '&lt;')     # < -> &lt;
    dataText = dataText.replace(/>/g, '&gt;')     # > -> &gt;
    dataText = dataText.replace(/"/g, '&quot;')   # " -> &quot;
    dataText = dataText.replace(/'/g, '&apos;')   # ' -> &apos;
    dataText = dataText.replace(/\//g, '&#x2F;')  # / -> &#x2F;
    dataText = dataText.replace(/\n/g, '<br>')    # \n -> <br>
    # Coffee cannot compile if use literal '/ /g'
    dataText = dataText.replace(new RegExp(' ', 'g'), '&nbsp;')   # ' ' -> &nbsp;
    return dataText

  @property "text",
    set: (newText) ->
      @_text = newText
      if newText
        @layer.html(this.__htmlfyText(newText))
      else
        @layer.html(this.__htmlfyText(""))
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
      if newTextColor.class == CB.Color
        @css("color", newTextColor.toCss('rgba'))
      else
        @css("color", newTextColor)

  @property "textAlignment",
    set: (newValue) ->
      @_textAlignment = newValue
      @css("text-align", newValue)

  @property "lineBreakMode"

  @property "adjustsFontSizeToFitWidth"

  @property "baselineAdjustment"

  @property "numberOfLines"

  @property "maxWidth"

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
      if @maxWidth
        @_sizeTestingLayer.css("max-width", @maxWidth)
      @_sizeTestingLayer.css("white-space", "nowrap")
    @_sizeTestingLayer.css("font-family", @font)
    @_sizeTestingLayer.css("font-size", @fontSize)
    if @text
      @_sizeTestingLayer.html(this.__htmlfyText(@text))
    $("body").append(@_sizeTestingLayer)
    h = @_sizeTestingLayer[0].clientHeight + 1
    w = @_sizeTestingLayer[0].clientWidth + 1
    @_sizeTestingLayer.remove()
    new CB.Size(w, h)
