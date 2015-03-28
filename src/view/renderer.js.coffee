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

  # pragma mark - DOM Setup

  setupDOMBody: () ->
    body = $("body")
    body.css("position", "relative")
    body.css("margin", "0px")
    # body.width('100%') may not needed
    # body.height('100%') may not needed
    $(window).off("resize")
    $(window).resize ->
      CB.Window.currentWindow().layoutSubviews()

  clearDOMBody: () ->
    if $("body").length
      $("body").empty()

  # pragma mark - Interacting with view controller

  loadViewForViewController: (viewController) ->
    return if viewController._view
    viewController.loadView()
    if !viewController._view
      throw "You should set a view in your view controller's loadView."
    viewController.viewDidLoad()

  # pragma mark - Interacting with window

  setRootViewController: (viewController) ->
    if @currentRootViewController
      @currentRootViewController.view.removeFromSuperview()
    CB.DispatchOnce "CB.Renderer.setRootViewController", ->
      this.setupDOMBody()
      this.clearDOMBody()
    @currentRootViewController = viewController
    CB.Window.currentWindow().addSubview(@currentRootView)
    CB.Window.currentWindow().layoutSubviews()

  # pragma mark - Interacting with view

  loadLayerForView: (view) ->
    return if view._layer
    view._layer = view.layerDescription()
    view._layer.css("position", "absolute")

  # layoutView: (view) ->
  #   view.layer.css("top", view.frame.origin.x)
  #   view.layer.css("left", view.frame.origin.y)
  #   view.layer.width(view.frame.size.width)
  #   view.layer.height(view.frame.size.height)

  # loadLayerHirarchyForView: (view) ->
  #   view.layer.appendTo(view.superview.layer)
  #   for subview in view.subviews
  #     subview.layer.appendTo(view.layer)

  updateCSSForView: (view) ->

  updateGestureForView: (view) ->

  unloadLayerForView: (view) ->
    view.layer.empty()
    view.layer = null
    if force
      for subview in view.subviews
        subview.layer = null

  # pragma mark -
#  bringViewToScreen: (view) ->
  #

  layoutAndRenderSubviewsForView: (view) ->

    view.layoutSubviews()
    for subview in view.subviews
      this.layoutSubviewsForView(subview)


  viewWillRemoveFromSuperview: (view) ->


  viewDidAddSubview: (view) ->
