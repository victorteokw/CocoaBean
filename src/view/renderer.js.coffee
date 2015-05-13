# The view renderer.
# It's responsible for view rendering.
# It's a web only class.
#
class CB.Renderer
  # the renderer singleton
  #
  # @return [CB.Renderer] the renderer singleton
  #
  @sharedRenderer: () ->
    @__shared ||= new CB.Renderer
    return @__shared

  constructor: () ->
    CB.DispatchOnce "CB.Renderer.setRootViewController", =>
      this.setup()

  @property "readonly", "currentRootView",
    get: ->
      return null if !@currentRootViewController
      return @currentRootViewController.view

  @property "currentRootViewController"

  @property "lastEventDispatched"

  # pragma mark - Setup

  setup: () ->
    this.clearDOMBody()
    this.setupBodyCSS()
    this.setupResize()
    this.setupEventDispatcher()

  setupBodyCSS: () ->
    body = $("body")
    body.css("position", "relative")
    body.css("margin", "0px")
    # body.width('100%') body.height('100%')

  setupResize: () ->
    $(window).off("resize")
    _this = this
    $(window).resize ->
      _this.layoutEntireHirarchyForWindow()

  setupEventDispatcher: () ->
    $body = $("body")
    events = ["touchstart", "touchmove", "touchend", "touchcancel",
      "mousemove", "mousedown", "mouseup"]
    for event in events
      block = (event) =>
        $body.on event, (e) =>
          this[event](e)
      block(event)

  clearDOMBody: () ->
    if $("body").length
      $("body").empty()

  # pragma mark - event handling

  touchstart: (e) ->
    view = this.__getEventViewFromEvent(e)
    return unless view
    responder = this.__findResponderForEventView(view)
    return unless responder
    event = this.__buildEvent(e, view, "touch.start")
    responder.touchesBeganWithEvent(event)
    CB.Responder.currentFirstResponder = responder
    @lastEventDispatched = event
    return

  touchmove: (e) ->
    return unless CB.Responder.currentFirstResponder
    view = this.__getEventViewFromEvent(e)
    return unless view
    event = this.__buildEvent(e, view, "touch.move", true)
    CB.Responder.currentFirstResponder.touchesMovedWithEvent(event)
    @lastEventDispatched = event
    return

  touchend: (e) ->
    return unless CB.Responder.currentFirstResponder
    view = this.__getEventViewFromEvent(e)
    return unless view
    event = this.__buildEvent(e, view, "touch.end", true)
    CB.Responder.currentFirstResponder.touchesEndedWithEvent(event)
    @lastEventDispatched = null
    CB.Responder.currentFirstResponder = null

  touchcancel: (e) ->
    return unless CB.Responder.currentFirstResponder
    view = this.__getEventViewFromEvent(e)
    return unless view
    event = this.__buildEvent(e, view "touch.end", true)
    CB.Responder.currentFirstResponder.touchesEndedWithEvent(event)
    @lastEventDispatched = null
    CB.Responder.currentFirstResponder = null

  mousemove: (e) ->
    # Handle drag
    view = this.__getEventViewFromEvent(e)
    if @mouseDownOn
      event = this.__buildEvent(e, view, "mouse.drag", true)
      @mouseDownOn.mouseDraggedWithEvent(event)
      @lastEventDispatched = event
      true
    else
      # return unless view
      # responder = this.__findResponderForEventView(view)
      # return unless responder
      # # Dispatch for old responder
      # event = this.__buildEvent(e, view, "mouse.exit", true)
      # # Dispatch for new responder
      # event = this.__buildEvent(e, view, "mouse.enter", true)
      # responder.mouseEnterWithEvent(event)
      # @lastEventDispatched = event

  mousedown: (e) ->
    view = this.__getEventViewFromEvent(e)
    return unless view
    responder = this.__findResponderForEventView(view)
    return unless responder
    event = this.__buildEvent(e, view, "mouse.down")
    responder.mouseDownWithEvent(event)
    CB.Responder.currentFirstResponder = responder
    @mouseDownOn = responder
    @lastEventDispatched = event
    return

  mouseup: (e) ->
    return unless @mouseDownOn
    view = this.__getEventViewFromEvent(e)
    event = this.__buildEvent(e, view, "mouse.up", true)
    @mouseDownOn.mouseUpWithEvent(event)
    return
    @lastEventDispatched = null
    @mouseDownOn = null

  __getEventViewFromEvent: (e) ->
    layer = $(e.target)
    view = layer.data("view")
    while !view
      break if layer.is($(document))
      layer = layer.parent()
      view = layer.data("view")
    return view

  __findResponderForEventView: (view) ->
    responder = view
    while responder && !responder.canBecomeFirstResponder()
      responder = responder.nextResponder()
    return responder

  __buildEvent: (e, view, type, usePrevious) ->
    event = new CB.Event
    event._timestamp = new Date
    if type.match /touch/
      touches = []
      for t in e.originalEvent.touches
        touch = new CB.Touch
        touch._timestamp = new Date
        touch._locationInWindow = new CB.Point(t.clientX, t.clientY)
        touch._view = view
        touch._window = view.window
        touches.push(touch)
      event._allTouches = touches
      if type.match /end/
        touch = new CB.Touch
        touch._timestamp = new Date
        touch._locationInWindow = new CB.Point(e.originalEvent.pageX, e.originalEvent.pageY)
        touch._view = view
        touch._window = view.window
        event._allTouches = [touch]
    else
      event._locationInWindow = new CB.Point(e.clientX, e.clientY)
      event._view = view
      event._window = view.window
      if usePrevious && @lastEventDispatched
        event._previousLocationInWindow = @lastEventDispatched.locationInWindow
    event._type = type
    return event

  # pragma mark - layout

  layoutEntireHirarchyForWindow: () ->
    this.layoutEntireHirarchyForView(CB.Window.currentWindow())

  layoutEntireHirarchyForView: (view) ->
    if view.viewController
      view.viewController.viewWillLayoutSubviews()
    view.__isLayoutSubviews = true
    view.layoutSubviews()
    for subview in view.subviews
      this.layoutEntireHirarchyForView(subview)
    view.__isLayoutSubviews = false
    if view.viewController
      view.viewController.viewDidLayoutSubviews()

  # pragma mark - Interacting with view controller

  loadViewForViewController: (viewController) ->
    return if viewController._view
    viewController.loadView()
    if !viewController._view
      throw "You should set a view in your view controller's loadView."
    viewController._view.viewController = viewController
    viewController.viewDidLoad()

  # pragma mark - Interacting with window

  setRootViewController: (viewController) ->
    if @currentRootViewController
      @currentRootViewController.view.removeFromSuperview()
    @currentRootViewController = viewController
    CB.Window.currentWindow().addSubview(@currentRootView)
    CB.Window.currentWindow()._rootView = @currentRootView
    CB.Window.currentWindow()._rootView._window = CB.Window.currentWindow()
    this.layoutEntireHirarchyForWindow()

  # pragma mark - Interacting with view

  normalizeLayer: (layer) ->
    layer.css("position", "absolute")
    layer.css("-webkit-touch-callout", "none")
    layer.css("-webkit-user-select", "none")
    layer.css("-moz-user-select", "-moz-none")
    layer.css("-ms-user-select", "none")
    layer.css("user-select", "none")
    layer.css("overflow", "hidden")

  loadLayerForView: (view) ->
    return if view._layer
    if view instanceof CB.ScrollView
      view._layer = $("<div></div>")
      view._contentLayer = $("<div></div>")
      this.normalizeLayer(view._contentLayer)
      view._layer.append(view._contentLayer)
    else
      view._layer = view.layerDescription()
    view._layer.data("view", view)
    this.normalizeLayer(view._layer)
    return

  viewForLayer: (layer) ->
    layer.data("view")

  # loadLayerHirarchyForView: (view) ->
  #   view.layer.appendTo(view.superview.layer)
  #   for subview in view.subviews
  #     subview.layer.appendTo(view.layer)

  updateCSSForView: (view) ->

  updateGestureForView: (view) ->

  unloadLayerForView: (view) ->
    view.layer.empty()
    view.layer = null
    force = null
    if force
      for subview in view.subviews
        subview.layer = null

  layoutAndRenderSubviewsForView: (view) ->
    view.layoutSubviews()
    for subview in view.subviews
      this.layoutSubviewsForView(subview)

  viewWillRemoveFromSuperview: (view) ->
    view.layer.remove()

  syncSubviewLayerRelationship: (view) ->
    unless view.layer.data("view")
      view.layer.data("view", view)
    for v in view.subviews
      this.syncSubviewLayerRelationship(v)

  viewDidAddSubviewAtIndex: (superview, subview, index) ->
    this.syncSubviewLayerRelationship(subview)
    layerToAddTo = if superview instanceof CB.ScrollView
                     superview.contentLayer
                   else
                     superview.layer
    if index == superview.subviews.length
      layerToAddTo.append(subview.layer)
    else if index == 0
      layerToAddTo.prepend(subview.layer)
    else
      l = superview.subviews[index - 1].layer
      l.after(subview.layer)
    return

  applyFrameForView: (view) ->
    view.layer.css("left", view.frame.origin.x)
    view.layer.css("top", view.frame.origin.y)
    view.layer.width(view.frame.size.width)
    view.layer.height(view.frame.size.height)
    # if (view._subviews && view._subviews.length > 0) || (view instanceof CB.ScrollView)
    if view._subviews && view._subviews.length > 0
      this.layoutEntireHirarchyForView(view) unless view.__isLayoutSubviews

  viewNeedsLayout: (view) ->
    if view.window
      this.layoutEntireHirarchyForWindow()
