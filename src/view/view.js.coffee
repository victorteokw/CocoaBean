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
    @unsyncedStyles = {}
    @eventDelegate = null
    @__events = []
    @_subviews = []
    @_clipsToBounds = true
    @_userInteractionEnabled = true
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
    subview.willMoveToSuperview(this)
    subview.willMoveToWindow(@window)
    subview._superview = this
    Array.prototype.push.apply(@_subviews, [subview])
    @renderDelegate.viewDidAddSubview(this, subview)
    subview.didMoveToSuperview(this)
    subview.didMoveToWindow(@window)
    this.didAddSubview(subview)
    return

  removeFromSuperview: () ->
    @superview.willRemoveSubview(this)
    @renderDelegate.viewWillRemoveFromSuperview(this)
    index = @superview.subviews.indexOf(this)
    index > -1 && @superview.subviews.splice(index, 1)
    @superview = null
    return

  bringSubviewToFront: (view) ->

  sendSubviewToBack: (view) ->

  insertSubviewAtIndex: (view, index) ->

  insertSubviewAboveSubview: (newSubview, subview) ->

  insertSubviewBelowSubview: (newSubview, subview) ->

  exchangeSubviewAtIndexWithSubviewAtIndex:(index1, index2) ->

  isDescendantOfView: (view) ->

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
    set: (newValue) ->
      @_frame = newValue
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
      @css("opacity", newAlpha)

  @property "backgroundColor",
    set: (newColor) ->
      @_backgroundColor = newColor
      if color instanceof CB.Color
        color = color.toString()
      @css("background-color", color)

  @property "transform" # Future implementation

  @property "hidden",
    set: (newValue) ->
      if newValue == true
        @css("visibility", "hidden")
      else if newValue == false
        @css("visibility", "visible")
      @_hidden = newValue

  @property "opaque" # Make sence on native platform

  @property "clipsToBounds",
    set: (newValue) ->
      if newValue == true
        @css("overflow", "hidden")
      else if newValue == false
        @css("overflow", "visible")
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

  # Old gesture implementation, need to delete

  __loadGestures: () ->
    @layer.on "click", =>
      this.__sendActions("click")
    # events = ["click", "mouseenter", "mouseleave", "focus", "blur", \
    #   "touchstart"]
    # for event in events
    #   @layer.on event, =>
    #     this.__sendActions(event)
  __unloadGestures: () ->
    events = ["click", "mouseenter", "mouseleave", "focus", "blur", \
      "touchstart"]
    for event in events
      @layer.off event

  # user event
  __sendActions: (event) ->
    if @eventDelegate
      return @eventDelegate.__sendActions(event)
    this.sendActionsForUserEvent(event)

  queryTargetActionEvent: (target, action, event) ->
    @__events.filter (obj) ->
      (if target then obj.target == target else true) &&
      (if action then obj.action == action else true) &&
      (if event then obj.event == event else true)

  # TODO: lint event
  # target is an object, action is string of method name,
  # event is "tap" or "click"
  addTargetForUserEvent: (target, action, event) ->
    @__events.push(target: target, action: action, event: event)

  removeTargetForUserEvent: (target, action, event) ->
    @__events = @__events.filter (obj) ->
      !this.queryTargetActionEvent(target, action, event)

  sendActionsForUserEvent: (event) ->
    this.queryTargetActionEvent(null, null, event)
    .forEach (object) =>
      object.target[object.action](this)

  sizeThatFits: (size) ->
    @frame.size

  sizeToFit: () ->
    @frame = this.sizeThatFits(size)

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
    @userInteractionEnabled
