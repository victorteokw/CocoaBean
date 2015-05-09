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
    # this.setupDOMBody()

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
  touchmove: (e) ->
  touchend: (e) ->
  touchcancel: (e) ->

  mousemove: (e) ->
    view = this.__getEventViewFromEvent(e)
    responder = view
    return unless responder
    while responder && !responder.canBecomeFirstResponder()
      responder = responder.nextResponder()
    if responder
      if responder == CB.Responder.currentFirstResponder
        event = new CB.Event
        if @lastEventDispatched
          event._previousLocationInWindow = @lastEventDispatched.locationInWindow
        event._timestamp = new Date
        event._locationInWindow = new CB.Point(e.clientX, e.clientY)
        event._view = view
        event._window = view.window
        event._type = "mouse.move"
        responder.mouseMovedWithEvent(event)
      else
        event = new CB.Event
        if @lastEventDispatched
          event._previousLocationInWindow = @lastEventDispatched.locationInWindow
        event._timestamp = new Date
        event._locationInWindow = new CB.Point(e.clientX, e.clientY)
        event._view = view
        event._window = view.window
        event._type = "mouse.exit"
        responder.mouseExitedWithEvent(event)
        # @lastEventDispatched = null
        # CB.Responder.currentFirstResponder = null

  mousedown: (e) ->
    view = this.__getEventViewFromEvent(e)
    responder = view
    return unless responder
    while responder && !responder.canBecomeFirstResponder()
      responder = responder.nextResponder()
    if responder
      CB.Responder.currentFirstResponder = responder
      event = new CB.Event
      event._timestamp = new Date
      event._locationInWindow = new CB.Point(e.clientX, e.clientY)
      event._view = view
      event._window = view.window
      event._type = "mouse.down"
      responder.mouseDownWithEvent(event)
      @lastEventDispatched = event

  mouseup: (e) ->
    return unless CB.Responder.currentFirstResponder
    view = this.__getEventViewFromEvent(e)
    responder = view
    while responder && !responder.canBecomeFirstResponder()
      responder = responder.nextResponder()
    if responder
      CB.Responder.currentFirstResponder == responder
      event = new CB.Event
      if @lastEventDispatched
        event._previousLocationInWindow = @lastEventDispatched.locationInWindow
      event._timestamp = new Date
      event._locationInWindow = new CB.Point(e.clientX, e.clientY)
      event._view = view
      event._window = view.window
      event._type = "mouse.up"
      responder.mouseUpWithEvent(event)
    CB.Responder.currentFirstResponder = null
    @lastEventDispatched = null

  __getEventViewFromEvent: (e) ->
    layer = $(e.target)
    view = layer.data("view")
    while !view
      break if layer.is($(document))
      layer = layer.parent()
      view = layer.data("view")
    return view

  # pragma mark - layout

  layoutEntireHirarchyForWindow: () ->
    this.layoutEntireHirarchyForView(CB.Window.currentWindow())

  layoutEntireHirarchyForView: (view) ->
    if view.viewController
      view.viewController.viewWillLayoutSubviews()
    view.layoutSubviews()
    if view.viewController
      view.viewController.viewDidLayoutSubviews()
    for subview in view.subviews
      this.layoutEntireHirarchyForView(subview)

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
    CB.DispatchOnce "CB.Renderer.setRootViewController", =>
      this.setup()
    @currentRootViewController = viewController
    CB.Window.currentWindow().addSubview(@currentRootView)
    CB.Window.currentWindow()._rootView = @currentRootView
    CB.Window.currentWindow()._rootView._window = CB.Window.currentWindow()
    this.layoutEntireHirarchyForWindow()

  # pragma mark - Interacting with view

  loadLayerForView: (view) ->
    return if view._layer
    if view instanceof CB.ScrollView
      view._layer = $("<div></div>")
      view._contentLayer = $("<div></div>")
      view._contentLayer.css("position", "absolute")
      view._contentLayer.css("-webkit-touch-callout", "none")
      view._contentLayer.css("-webkit-user-select", "none")
      view._contentLayer.css("-moz-user-select", "-moz-none")
      view._contentLayer.css("-ms-user-select", "none")
      view._contentLayer.css("user-select", "none")
      view._contentLayer.css("overflow", "hidden")
      view._layer.append(view._contentLayer)
    else
      view._layer = view.layerDescription()
    view._layer.data("view", view)
    view._layer.css("position", "absolute")
    view._layer.css("-webkit-touch-callout", "none")
    view._layer.css("-webkit-user-select", "none")
    view._layer.css("-moz-user-select", "-moz-none")
    view._layer.css("-ms-user-select", "none")
    view._layer.css("user-select", "none")
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
      view.layoutSubviews()

  viewNeedsLayout: (view) ->
    if view.window
      this.layoutEntireHirarchyForWindow()
