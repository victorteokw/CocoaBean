describe "CB.ViewController", ->
  controller = null
  beforeEach(-> controller = new CB.ViewController)

  it "inherits from CB.Responder", ->
    expect(controller instanceof CB.Responder).toBe(true)

  it "doesn't have a view at first", ->
    expect(controller._view).toBe(undefined)
    expect(controller.isViewLoaded()).toBe(false)

  it "has an auto loading view", ->
    expect(controller.view).not.toBe(undefined)
    expect(controller.isViewLoaded()).toBe(true)

  it "has a view if manually called loadView", ->
    expect(controller._view).toBe(undefined)
    controller.loadView()
    expect(controller._view instanceof CB.View).toBe(true)

  it "doesn't have next responder if view is not loaded", ->
    expect(controller.nextResponder()).toBe(null)
    controller.loadView()
    expect(controller.nextResponder()).toBe(controller.view.superview)

  it "doesn't has any child view controllers at first", ->
    expect(controller.childViewControllers).toEqual([])

  it "doesn't has any parent view controller at first", ->
    expect(controller.parentViewController).toBeFalsy()

  it "adds and removes child view controller", ->
    child = new CB.ViewController
    controller.addChildViewController(child)
    expect(controller.childViewControllers).toEqual([child])
    expect(child.parentViewController).toBe(controller)
    child2 = new CB.ViewController
    controller.addChildViewController(child2)
    expect(controller.childViewControllers).toEqual([child, child2])
    expect(child2.parentViewController).toBe(controller)
    expect(child.parentViewController).toBe(controller)
    child.removeFromParentViewController()
    expect(controller.childViewControllers).toEqual([child2])
    expect(child.parentViewController).toBeFalsy()
    expect(child2.parentViewController).toBe(controller)

  it "removes child view controller from other container if it's already its child", ->
    container = new CB.ViewController
    child = new CB.ViewController
    container.addChildViewController(child)
    controller.addChildViewController(child)
    expect(container.childViewControllers).toEqual([])
    expect(child.parentViewController).toBe(controller)
    expect(controller.childViewControllers).toEqual([child])

  it "automatically calls child's will but not did when adding", ->
    child = new CB.ViewController
    spyOn(child, 'willMoveToParentViewController')
    spyOn(child, 'didMoveToParentViewController')
    controller.addChildViewController(child)
    expect(child.willMoveToParentViewController).toHaveBeenCalledWith(controller)
    expect(child.didMoveToParentViewController).not.toHaveBeenCalled()

  it "automatically calls child's did but not will when removing", ->
    child = new CB.ViewController
    controller.addChildViewController(child)
    spyOn(child, 'willMoveToParentViewController')
    spyOn(child, 'didMoveToParentViewController')
    child.removeFromParentViewController()
    expect(child.willMoveToParentViewController).not.toHaveBeenCalled()
    expect(child.didMoveToParentViewController).toHaveBeenCalledWith(null)
