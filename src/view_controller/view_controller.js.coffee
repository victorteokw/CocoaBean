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
class CB.ViewController
  # Construct a new controller.
  # This method does not take any parameters.
  #
  constructor: () ->

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
    @childViewControllers.push(child)
    return

  removeFromParentViewController: () ->
    index = @parentViewController.childViewControllers.indexOf(this)
    index > -1 && @parentViewController.childViewControllers.splice(index, 1)
    @parentViewController = null
    return

  willMoveToParentViewController: (parent) ->

  didMoveToParentViewController: (parent) ->
