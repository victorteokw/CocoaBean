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

  mousedown: (e) ->
    layer = $(e.target)
    view = layer.data("view")
    while !view
      break if layer.is($(document))
      layer = layer.parent()
      view = layer.data("view")
    responder = view
    while responder && !responder.canBecomeFirstResponder()
      responder = responder.nextResponder()
    if responder
      event = new CB.Event
      event._timestamp = "ok"
      event._locationInWindow = new CB.Point(e.clientX, e.clientY)
      event._type = "mouse"
      event._view = view
      event._window = view.window
      responder.mouseDownWithEvent(event)

  mouseup: (e) ->



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
    view._layer = view.layerDescription()
    view._layer.data("view", view)
    view._layer.css("position", "absolute")

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


  viewDidAddSubview: (superview, subview) ->
    superview.layer.append(subview.layer)

  applyFrameForView: (view) ->
    view.layer.css("left", view.frame.origin.x)
    view.layer.css("top", view.frame.origin.y)
    view.layer.width(view.frame.size.width)
    view.layer.height(view.frame.size.height)

  viewNeedsLayout: (view) ->
    if view.window
      this.layoutEntireHirarchyForWindow()
