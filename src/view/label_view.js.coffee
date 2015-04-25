class CB.LabelView extends CB.View

  @property "text",
    set: (newText) ->
      @_text = newText
      @layer.text(newText)

  @property "font",
    set: (newFont) ->
      @_font = newFont
      @css("font-family", newFont)

  @property "fontSize",
    set: (newValue) ->
      @_fontSize = newValue
      @css("font-size", newValue)

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

  updateDisplayingText: () ->


  sizeThatFits: (size) ->
