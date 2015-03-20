# Base class for all view.
# This view is an generic empty view. This view is suitable for a container.
# For text, button and other feature, use subclasses of this class instead.
#
class CB.View
  # initializer
  constructor: () ->
    @subviews = [] # view hirarchy

    @layer = null # DOM and jQuery backed layer

    @unsyncedStyles = {} # for css

    @eventDelegate = null # for user event
    @__events = [] # for user event

    @delegate = CB.Renderer.sharedRenderer()

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

  layerDescription: () ->
    $("<div></div>")

  # layout
  @property "frame"
  @property "bounds"
  @property "center"
  # @property "transform" # Future implementation
  @property "alpha"
  @property "backgroundColor"

  layoutSubviews: () ->
    @layer.css("top", @frame.origin.x)
    @layer.css("left", @frame.origin.y)
    @layer.width(@frame.size.width)
    @layer.height(@frame.size.height)
    for subview in @subviews
      subview.layoutSubviews()

  # Old layout implementation
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

  layout: () ->
    unless CB.Window.currentWindow().keyView == this
      @layer.css("top", this.__top())
      @layer.css("left", this.__left())
      @layer.width(this.__width())
      @layer.height(this.__height())
    for subview in @subviews
      subview.layout()

  # subviews
  addSubview: (views...) ->
    for view in views
      view.superview = this # TODO:
      view.__loadLayer() # Move this line to if block result in test failure. Why?
      if @show
        @layer.append(view.layer)
    Array.prototype.push.apply(@subviews, views);
    return

  addSubviews: (subviews...) ->
    this.addSubview(subviews...)

  removeFromSuperview: () ->
    index = @superview.subviews.indexOf(this)
    index > -1 && @superview.subviews.splice(index, 1)
    @superview = null
    @layer && @layer.remove()
    return

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
