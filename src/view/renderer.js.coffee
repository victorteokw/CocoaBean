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
    @__shared ||= new CHESS.VIEW.Renderer
    return @__shared

  @property "currentRootView"

  constructor: () ->
    this.setupDOMBody()

  setupDOMBody: () ->
    CB.DispatchOnce "CB.Renderer.setupDOMBody", ->
      body = $("body")
      body.css("position", "relative")
      body.css("margin", "0px")
#      body.width('100%') may not needed
#      body.height('100%') may not needed
      $(window).off("resize")
      $(window).resize ->
        CB.Window.currentWindow().layoutSubviews()

  clearBody: () ->
    CB.DispatchOnce "CB.Renderer.clearBody", ->
      if $("body").length
        $("body").empty()
    if @currentRootView
      @currentRootView.removeFromSuperview()
      @currentRootView = null

  setRootViewForWindow: (view, window) ->
    if view.superview
      view.removeFromSuperview()
    CB.Window.currentWindow().addSubview(view)
    @currentRootView = view

  renderRootViewForWindow: (view, window) ->
    this.clearBody()
    this.loadLayerForView(view)
    this.setRootViewForWindow(view, window)
    CB.Window.currentWindow().layoutSubviews()

  loadLayerForView: (view) ->
    if !view.layer
      view.layer = view.layerDescription()
      view.layer.css("position", "absolute")
    if force
      for subview in view.subviews
        this.loadLayerForView(subview)

  loadLayerHirarchyForView: (view) ->
    view.layer.appendTo(view.superview.layer)
    for subview in view.subviews
      subview.layer.appendTo(view.layer)

  updateCSSForView: (view) ->

  updateGestureForView: (view) ->

  unloadLayerForView: (view) ->
    view.layer.empty()
    view.layer = null
    if force
      for subview in view.subviews
        subview.layer = null

  # pragma mark -
  bringViewToScreen: (view) ->
