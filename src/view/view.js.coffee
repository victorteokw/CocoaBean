# Base class for all view.
# This view is an generic empty view. This view is suitable for a container
# or a custom drawing view.
# For text, button and other feature, use subclasses of this class instead.
#
# @example Create a view
#   view = new CB.View()
#
class CB.View extends CB.Responder

  # @param [CB.Rect] a frame.
  # @return [CB.View] newly created CB.View
  #
  constructor: (frame) ->
    @frame = frame || new CB.Rect(0, 0, 0, 0)
    @_subviews = []
    @_clipsToBounds = false
    @_userInteractionEnabled = true
    @_alpha = 1.0
    @_hidden = false
    @clipsToBounds = true
    @_cornerRadius = 0
    @_window = null
    @_contentMode = "scale to fill"

  # pragma mark - Render

  @property "readonly", "renderDelegate",
    get: () -> CB.Renderer.sharedRenderer()

  # pragma mark - Layer

  @property "readonly", "layer",
    get: ->
      if !@_layer
        @renderDelegate.loadLayerForView(this)
      return @_layer

  layerDescription: () ->
    $("<div></div>")

  # pragma mark - View hirarchy related

  @property "readonly", "subviews"

  @property "readonly", "superview"

  addSubview: (subview) ->
    this.insertSubviewAtIndex(subview, @subviews.length)

  removeFromSuperview: () ->
    return unless @superview
    @superview.willRemoveSubview(this)
    this.willMoveToSuperview(null)
    this.willMoveToWindow(null)
    @renderDelegate.viewWillRemoveFromSuperview(this)
    @superview.subviews.remove(this)
    @_superview = null
    this.didMoveToSuperview(null)
    this.didMoveToWindow(null)
    return

  bringSubviewToFront: (view) ->

  sendSubviewToBack: (view) ->

  insertSubviewAtIndex: (subview, index) ->
    if subview == this
      throw "View cannot add self as subview!"
    if subview.superview
      subview.removeFromSuperview()
    subview.willMoveToSuperview(this)
    subview.willMoveToWindow(@window)
    subview._superview = this
    Array.prototype.splice.apply(@_subviews, [index, 0, subview])
    @renderDelegate.viewDidAddSubviewAtIndex(this, subview, index)
    subview.didMoveToSuperview(this)
    subview.didMoveToWindow(@window)
    this.didAddSubview(subview)
    return

  insertSubviewAboveSubview: (newSubview, subview) ->
    index = @subviews.indexOf(subview)
    this.insertSubviewAtIndex(newSubview, index + 1)

  insertSubviewBelowSubview: (newSubview, subview) ->
    index = @subviews.indexOf(subview)
    this.insertSubviewAtIndex(newSubview, index)

  exchangeSubviewAtIndexWithSubviewAtIndex:(index1, index2) ->

  isDescendantOfView: (view) ->
    this.isDescendantOf(view)

  # pragma mark - Hooks

  didAddSubview: (view) ->
  willRemoveSubview: (view) ->
  willMoveToSuperview: (view) ->
  didMoveToSuperview: () ->
  willMoveToWindow: (window) ->
  didMoveToWindow: () ->


  # pragma mark - Layout related properties and methods

  # Rect in the view coordinate of super view.
  #
  @property "frame",
    set: (newFrame) ->
      @_frame = newFrame
      @renderDelegate.applyFrameForView(this)
      return

  # Rect in the view coordinate of this view.
  #
  @property "bounds",
    set: (newValue) ->
      @_bounds = newValue
      x = @frame.origin.x
      y = @frame.origin.y
      @frame = new CB.Rect(x, y, newValue.width, newValue.height)
      return
    get: () ->
      new CB.Rect(0, 0, @frame.width, @frame.height)

  # Center of view to the super view coordinate.
  #
  @property "center",
    set: (newValue) ->
      @_center = newValue
      [cX, cY] = [newValue.x, newValue.y]
      x = cX - @frame.size.width / 2
      y = cY - @frame.size.height / 2
      width = @frame.size.width
      height = @frame.size.height
      @frame = new CB.Rect(x, y, width, height)
      return
    get: () ->
      x = @frame.origin.x + @frame.size.width / 2
      y = @frame.origin.y + @frame.size.height / 2
      new CB.Point(x, y)

  @property "alpha",
    set: (newAlpha) ->
      @_alpha = newAlpha
      @layer.css("opacity", newAlpha)

  @property "backgroundColor",
    set: (newColor) ->
      @_backgroundColor = newColor
      if color instanceof CB.Color
        color = color.toString()
      @css("background-color", newColor)

  @property "transform" # Future implementation

  @property "hidden",
    set: (newValue) ->
      if newValue == true
        @layer.css("visibility", "hidden")
      else if newValue == false
        @layer.css("visibility", "visible")
      @_hidden = newValue

  @property "opaque" # Make sence on native platform

  @property "clipsToBounds",
    set: (newValue) ->
      if newValue == true
        @layer.css("overflow", "hidden")
      else if newValue == false
        @layer.css("overflow", "visible")
      @_clipsToBounds = newValue

  @property "cornerRadius",
    set: (newRadius) ->
      @_cornerRadius = newRadius
      @css("border-radius", newRadius)

  @property "readonly", "window",
    get: () ->
      return null if !@superview
      return @_window if @_window
      @superview.window

  css: (args...) ->
    @layer.css(args...)

  layoutSubviews: () -> return

  sizeThatFits: (size) ->
    @frame.size

  # sizeToFit
  # Note this behavior is different from Apple's UIKit
  # which does not accept a argument
  #
  sizeToFit: (size) ->
    size = this.sizeThatFits(size)
    @frame = new CB.Rect(@frame.x, @frame.y, size.width, size.height)

  setNeedsLayout: () ->
    @renderDelegate.viewNeedsLayout(this)

  layoutIfNeeded: () ->
    @renderDelegate.viewNeedsLayout(this)

  nextResponder: () ->
    return @viewController if @viewController
    return @superview if @superview
    return null

  @property "userInteractionEnabled"

  canBecomeFirstResponder: () ->
    @userInteractionEnabled && @alpha >= 0.01 && !@hidden

  ancestorSharedWithView: (view) ->
    # Implementation from
    # http://stackoverflow.com/questions/22666535/shared-ancestor-between-two-views
    return null unless view
    return this if view == this
    return this if view.superview == this
    if this.superview
      ancestor = this.superview.ancestorSharedWithView(view)
      return ancestor if ancestor
      return null
    else
      return this.ancestorSharedWithView(view.superview)

  isDescendantOf: (view) ->
    return true if view == this
    return false unless this.superview
    this.superview.isDescendantOf(view)

  convertPointToView: (point, view) ->
    p = point
    v = this
    s = this.ancestorSharedWithView(view)
    return null unless s
    while v.superview && v.superview.isDescendantOf(s) and s != v
      p = new CB.Point(p.x + v.frame.x, p.y + v.frame.y)
      v = v.superview
    p2 = new CB.Point(0, 0)
    while view.superview && view.superview.isDescendantOf(s) and s != view
      p2 = new CB.Point(p2.x + view.frame.x, p2.y + view.frame.y)
      view = view.superview
    return new CB.Point(p.x - p2.x, p.y - p2.y)

  convertPointFromView: (point, view) ->
    view.convertPointToView(point, this)

  convertRectToView: (rect, view) ->
    s = rect.size
    p = this.convertPointToView(rect.origin, view)
    return new CB.Rect(p.x, p.y, s.width, s.height)

  convertRectFromView: (rect, view) ->
    view.convertRectToView(rect, this)

  pointInsideWithEvent: (point, event) ->
    if 0 <= point.x <= @frame.width and
       0 <= point.y <= @frame.height
      return true
    return false

  hitTestWithEvent: (point, event) ->
    if this.pointInsideWithEvent(point, event)
      if this.hidden or !this.userInteractionEnabled or this.alpha < 0.01
        return null
      thatView = null
      thatPoint = null
      for subview in @subviews.reverse()
        p = this.convertPointToView(point, subview)
        if subview.pointInsideWithEvent(p, event)
          thatView = subview
          thatPoint = p
          break
      if thatView && thatPoint
        retVal = thatView.hitTestWithEvent(thatPoint, event)
        if retVal
          return retVal
        return thatView
      else return this
    else
      return null

  # Available values are
  #
  # scale to fill
  # scale aspect fit
  # scale aspect fill
  # redraw
  # center
  # top
  # bottom
  # left
  # right
  # top left
  # top right
  # bottom left
  # bottom right
  #
  @property "contentMode"
