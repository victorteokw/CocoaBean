# Scroll View similar to UIScrollView in Cocoa
#
class CB.ScrollView extends CB.View

  constructor: (frame) ->
    super(frame)
    @layer.css("overflow", "scroll")
    @_scrollEnabled = true
    @_contentSize = new CB.Size(0, 0)

  @property "readonly", "contentLayer",
    get: ->
      if !@_contentLayer
        @renderDelegate.loadLayerForView(this)
      return @_contentLayer

  @property "contentSize",
    set: (newValue) ->
      @_contentSize = newValue
      @contentLayer.width(newValue.width)
      @contentLayer.height(newValue.height)

  @property "contentOffset",
    set: (newValue) ->
      @contentLayer.scrollLeft = newValue.width
      @contentLayer.scrollTop = newValue.height
    get: () ->
      new CB.Size(@contentLayer.scrollLeft, @contentLayer.scrollTop)

  @property "bounds",
    set: (newValue) ->
      @contentOffset = new CB.Size(newValue.x, newValue.y)
      x = @frame.origin.x
      y = @frame.origin.y
      @frame = new CB.Rect(x, y, newValue.width, newValue.height)
    get: () ->
      new CB.Rect(@contentOffset.width, @contentOffset.height, @frame.width, @frame.height)

  @property "scrollEnabled",
    set: (newValue) ->
      @_scrollEnabled = newValue
      if newValue == false
        @layer.css("overflow", "hidden")
      else
        @layer.css("overflow", "scroll")
        @layer.css("-webkit-overflow-scrolling", "touch")

  @property "directionalLockEnabled"

  @property "scrollsToTop" # make sence on iOS only

  @property "pagingEnabled"

  @property "bounces"

  @property "alwaysBounceVertical"

  @property "alwaysBounceHorizontal"

  @property "dragging"

  @property "tracking"

  @property "decelerating"

  @property "showsHorizontalScrollIndicator"

  @property "showsVerticalScrollIndicator"

  @property "scrollIndicatorInsets"

  flashScrollIndicators: () ->

  css: (args...) ->
    @contentLayer.css(args...)
