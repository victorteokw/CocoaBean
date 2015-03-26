# Base class for all view.
# This view is an generic empty view. This view is suitable for a container
# or a custom drawing view.
# For text, button and other feature, use subclasses of this class instead.
#
# @example Create a view
#   view = new CB.View()
#
class CB.View

  # @param [CB.Frame] a frame.
  # @return [CB.View] newly created CB.View
  #
  constructor: (@frame) ->
    @unsyncedStyles = {}
    @eventDelegate = null
    @__events = []

  # pragma mark - Render

  @property "readonly", "renderDelegate",
    get: () -> CB.Renderer.sharedRenderer()

  # pragma mark - Layer

  @property "readonly", "layer"

  layerDescription: () ->
    $("<div></div>")

  # pragma mark - View hirarchy related

  @property "readonly", "subviews"

  @property "readonly", "superview"

  addSubview: (subview) ->
    subview.willMoveToSuperview(this)
    subview.willMoveToWindow(@window)
    subview.superview = this
    Array.prototype.push.apply(@_subviews, subview)
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
      @renderDelegate.layoutView(this)
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


  @property "alpha" # css related?

  @property "backgroundColor" # css related?

  @property "transform" # Future implementation

  @property "hidden"

  @property "opaque" # Make sence on native platform

  @property "clipsToBounds"

  @property "readonly", "window"



  layoutSubviews: () -> return

  # Old layout implementation

  # @todo Bugs exist.
  # Need to modify.
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

  __calculateOffset: (offset, functionName, relativeFName) -> # Need more test
    if @useBodyAsLayer
      return '0px'
    switch typeof offset
      when 'number'
        return offset
        return CB.Metrics.add @superview[functionName](), offset
      when 'string'
        if offset.match(/px$/)
          return offset
          return CB.Metrics.add @superview[functionName](), offset
        else if offset.match(/%$/)
          return CB.Metrics.multiply @superview[relativeFName](), offset
        else
          return '0px'
      when 'function'
        return offset()

  __calculateLength: (length, functionName) ->
    if @useBodyAsLayer
      return '100%'
    switch typeof length
      when 'number'
        return length + 'px'
      when 'string'
        if length.match(/px$/)
          return length
        else if length.match(/%$/)
          return CB.Metrics.multiply @superview[functionName](), length
        else
          return '0px'
      when 'function'
        return length()

  __top: () -> this.__calculateOffset(@top, "__top", "__height")
  __left: () -> this.__calculateOffset(@left, "__left", "__width")
  __width: () -> this.__calculateLength(@width, "__width")
  __height: () -> this.__calculateLength(@height, "__height")

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

  # CSS and style
  __syncCSS: () ->
    for k, v in @__css
      @layer.css(k, v)
  css: (args...) ->
    @__css[args[0]] = @__css[args[1]]
    if @layer
      @layer.css(args...)
  cornerRadius: (radius) ->
    this.css("border-radius", radius)
  backgroundColor: (color) ->
    if color instanceof CB.Color
      color = color.toString()
    this.css("background-color", color)
