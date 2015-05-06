# Scroll View similar to UIScrollView in Cocoa
#
class CB.ScrollView extends CB.View

  @property "contentSize", ->
    set: (newValue) ->
      @_contentSize = newValue
      @contentLayer.width = newValue.width
      @contentLayer.height = newValue.height

  @property "contentOffset", ->
    set: (newValue) ->
      @contentLayer.scrollLeft = newValue.width
      @contentLayer.scrollTop = newValue.height
    get: () ->
      new CB.Size(@contentLayer.scrollLeft, @contentLayer.scrollTop)

  @property "bounds", ->
    set: (newValue) ->
      @contentOffset = new CB.Size(newValue.x, newValue.y)
      x = @frame.origin.x
      y = @frame.origin.y
      @frame = new CB.Rect(x, y, newValue.width, newValue.height)
    get: () ->
      new CB.Rect(@contentOffset.width, @contentOffset.height, @frame.width, @frame.height)

  @property "scrollEnabled", ->
    set: (newValue) ->
      @_scrollEnabled = newValue
      if newValue == false
        @css("overflow", "hidden")
      else
        @css("overflow", "scroll")

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

  layerDescription: () ->
    parent = $("<div></div>")
    child = $("<div></div>")
    parent.append(child)
    @contentLayer = child
    return parent
