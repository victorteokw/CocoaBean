# Base class for all view controllers.
#
# @example How to subclass a controller
#   class MyController extends CB.ViewController
#     constructor: () ->
#     loadView: () ->
#       @view = new YourOwnView()
#
# @example To load a controller into window:
#   $(document).ready ->
#     controller = new MyController()
#     CB.Window.currentWindow().setRootViewController(controller)
#
class CB.ViewController extends CB.Responder
  # Construct a new controller.
  # This method does not take any parameters.
  #
  constructor: () ->
    super()

  @property "readonly", "renderDelegate",
    get: () -> CB.Renderer.sharedRenderer()

  @property "readonly", "view",
    get: ->
      if !@_view
        @renderDelegate.loadViewForViewController(this)
      return @_view

  @property "title"

  isViewLoaded: () ->
    return !!@_view

  loadView: () ->
    @_view = new CB.View
    return

  viewDidLoad: () ->

  viewWillAppear: () ->

  viewDidAppear: () ->

  viewWillDisappear: () ->

  viewDidDisappear: () ->

  viewWillLayoutSubviews: () ->

  viewDidLayoutSubviews: () ->

  @property "childViewControllers",
    get: ->
      @_childViewControllers ||= []
      @_childViewControllers

  @property "parentViewController"

  addChildViewController: (child) ->
    if child.parentViewController
      child.removeFromParentViewController()
    child.willMoveToParentViewController(this)
    @childViewControllers.push(child)
    child.parentViewController = this
    return

  removeFromParentViewController: () ->
    return unless @parentViewController
    @parentViewController.childViewControllers.remove(this)
    @parentViewController = null
    this.didMoveToParentViewController(null)
    return

  willMoveToParentViewController: (parent) ->

  didMoveToParentViewController: (parent) ->

  nextResponder: () ->
    return null unless @_view
    @view.superview
