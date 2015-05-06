describe "CB.View", ->
  view = null
  beforeEach(-> view = new CB.View)

  it "inherits from CB.Responder", ->
    expect(view instanceof CB.Responder).toBe(true)

  it "has a default layer description and it's default to normal div", ->
    expect(view.layerDescription()).toEqual($("<div></div>"))

  it "has a lazy loading layer", ->
    pending("Currently, layer is loaded on constructing, it's not good")
    expect(view._layer).toBe(undefined)
    a = view.layer
    expect(view._layer).toBe(a)
    expect(view.layer).toBe(view._layer)

  it "adds subview and removes from superview", ->
    subview = new CB.View
    view.addSubview(subview)
    expect(view.subviews).toEqual([subview])
    expect(subview.superview).toBe(view)
    subview2 = new CB.View
    view.addSubview(subview2)
    expect(subview2.superview).toBe(view)
    expect(view.subviews).toEqual([subview, subview2])
    subview.removeFromSuperview()
    expect(subview.superview).toBeFalsy()
    expect(subview2.superview).toBe(view)
    expect(view.subviews).toEqual([subview2])

  it "adds subview and removes subview from its previous superview", ->
    subview = new CB.View
    previous = new CB.View
    previous.addSubview(subview)
    view.addSubview(subview)
    expect(view.subviews).toEqual([subview])
    expect(subview.superview).toBe(view)
    expect(previous.subviews).toEqual([])

  it "triggers didAddSubview after a view is added", ->
    subview = new CB.View
    spyOn(view, "didAddSubview")
    view.addSubview(subview)
    expect(view.didAddSubview).toHaveBeenCalledWith(subview)
    expect(view.didAddSubview.calls.count()).toBe(1)

  it "triggers willRemoveSubview before a subview is to be removed", ->
    subview = new CB.View
    view.addSubview(subview)
    spyOn(view, "willRemoveSubview")
    subview.removeFromSuperview()
    expect(view.willRemoveSubview).toHaveBeenCalledWith(subview)
    expect(view.willRemoveSubview.calls.count()).toBe(1)

  it "triggers willMoveToSuperview and didMoveToSuperview when adds", ->
    subview = new CB.View
    spyOn(subview, "willMoveToSuperview")
    spyOn(subview, "didMoveToSuperview")
    view.addSubview(subview)
    expect(subview.willMoveToSuperview).toHaveBeenCalledWith(view)
    expect(subview.willMoveToSuperview.calls.count()).toBe(1)
    expect(subview.didMoveToSuperview).toHaveBeenCalled()
    expect(subview.didMoveToSuperview.calls.count()).toBe(1)

  it "triggers willMoveToSuperview and didMoveToSuperview when removes", ->
    subview = new CB.View
    view.addSubview(subview)
    spyOn(subview, "willMoveToSuperview")
    spyOn(subview, "didMoveToSuperview")
    subview.removeFromSuperview()
    expect(subview.willMoveToSuperview).toHaveBeenCalledWith(null)
    expect(subview.willMoveToSuperview.calls.count()).toBe(1)
    expect(subview.didMoveToSuperview).toHaveBeenCalled()
    expect(subview.didMoveToSuperview.calls.count()).toBe(1)

  it "triggers willMoveToWindow and didMoveToWindow when adds", ->
    subview = new CB.View
    spyOn(subview, "willMoveToWindow")
    spyOn(subview, "didMoveToWindow")
    view.addSubview(subview)
    expect(subview.willMoveToWindow).toHaveBeenCalledWith(view.window)
    expect(subview.willMoveToWindow.calls.count()).toBe(1)
    expect(subview.didMoveToWindow).toHaveBeenCalled()
    expect(subview.didMoveToWindow.calls.count()).toBe(1)

  it "triggers willMoveToWindow and didMoveToWindow when removes", ->
    subview = new CB.View
    view.addSubview(subview)
    spyOn(subview, "willMoveToWindow")
    spyOn(subview, "didMoveToWindow")
    subview.removeFromSuperview()
    expect(subview.willMoveToWindow).toHaveBeenCalledWith(null)
    expect(subview.willMoveToWindow.calls.count()).toBe(1)
    expect(subview.didMoveToWindow).toHaveBeenCalled()
    expect(subview.didMoveToWindow.calls.count()).toBe(1)

  it "insertSubviewAtIndex", ->
    pending()
  it "insertSubviewAboveSubview", ->
    pending()
  it "insertSubviewBelowSubview", ->
    pending()
  it "exchangeSubviewAtIndexWithSubviewAtIndex", ->
    pending()
  it "bringSubviewToFront", ->
    pending()
  it "sendSubviewToBack", ->
    pending()

  it "knows if it's a descendant of view or not", ->
    subview = new CB.View
    view.addSubview(subview)
    expect(subview.isDescendantOfView(view)).toBe(true)
    expect(subview.isDescendantOf(view)).toBe(true)

  it "is descendant of itself", ->
    expect(view.isDescendantOfView(view)).toBe(true)
    expect(view.isDescendantOf(view)).toBe(true)

  it "has a frame and default to 0,0,0,0", ->
    expect(view.frame).toEqual(new CB.Rect(0, 0, 0, 0))

  it "creates with a frame", ->
    view = new CB.View(new CB.Rect(10, 10, 20, 20))
    expect(view.frame).toEqual(new CB.Rect(10, 10, 20, 20))

  it "has its own coordinates aka bounds", ->
    view.frame = new CB.Rect(10, 10, 30, 45)
    expect(view.bounds).toEqual(new CB.Rect(0, 0, 30, 45))

  it "sets bounds changes frame", ->
    view.frame = new CB.Rect(10, 10, 20, 20)
    view.bounds = new CB.Rect(0, 0, 50, 50)
    expect(view.frame).toEqual(new CB.Rect(10, 10, 50, 50))

  it "has a center and center can be calculated from frame", ->
    view.frame = new CB.Rect(10, 20, 30, 40)
    expect(view.center).toEqual(new CB.Point(25, 40))

  it "sets a center changes frame", ->
    view.frame = new CB.Rect(10, 20, 30, 40)
    view.center = new CB.Point(50, 50)
    expect(view.frame).toEqual(new CB.Rect(35, 30, 30, 40))

  it "has a alpha and its default value is 1.0", ->
    expect(view.alpha).toEqual(1.0)

  it "has a background color and it's default value is clear", ->
    pending("Need to implement an clear color")

  it "has a transform", ->
    pending("Implement in the future")

  it "has a hidden and its default value is false", ->
    expect(view.hidden).toBe(false)

  it "has a cornerRadius and its default value is 0", ->
    expect(view.cornerRadius).toBe(0)

  it "has a clipsToBounds and its default value is true", ->
    expect(view.clipsToBounds).toBe(true)

  it "has a window and when it's in it and it's null when it's not in it", ->
    expect(view.window).toBe(null)
    CB.Window.currentWindow().addSubview(view)
    expect(view.window).toBe(CB.Window.currentWindow())
    view.removeFromSuperview()
    expect(view.window).toBe(null)

  it "has a window and it's can be get from superview", ->
    subview = new CB.View
    view.addSubview(subview)
    expect(subview.window).toBe(null)
    CB.Window.currentWindow().addSubview(view)
    expect(subview.window).toBe(CB.Window.currentWindow())
    view.removeFromSuperview()
    expect(subview.window).toBe(null)

  it "layout subviews and it actually does nothing", ->
    expect(typeof view.layoutSubviews).toBe("function")

  it "next responder is view controller else superview else null", ->
    pending("Don't know how to test yet")

  it "has a userInteractionEnabled and it's default to true", ->
    expect(view.userInteractionEnabled).toBe(true)

  it "sizeThatFits is just it's frame.size", ->
    expect(view.sizeThatFits()).toEqual(view.frame.size)

  it "sizeToFit to resize", ->
    spyOn(view, "sizeThatFits").and.returnValue(new CB.Size(12, 14))
    view.sizeToFit()
    expect(view.frame).toEqual(new CB.Rect(0, 0, 12, 14))

  it "setNeedsLayout to trigger layout", ->
    pending("Don't know how to implement and test yet")

  it "layoutIfNeeded", ->
    pending("Don't know how to implement and test yet")

  it "can become first responder by default", ->
    expect(view.canBecomeFirstResponder()).toBe(true)
  describe "cannot become first responder", ->
    it "if user interaction is not enabled", ->
      view.userInteractionEnabled = false
      expect(view.canBecomeFirstResponder()).toBe(false)
    it "if alpha is less than 0.01", ->
      view.alpha = 0.0
      expect(view.canBecomeFirstResponder()).toBe(false)
    it "if view is hidden", ->
      view.hidden = true
      expect(view.canBecomeFirstResponder()).toBe(false)

  describe "knows ancestor shared with another view, ", ->
    anotherView = null
    beforeEach ->
      anotherView = new CB.View
    it "if not in same hirarchy, the value is null", ->
      ancestor = view.ancestorSharedWithView(anotherView)
      expect(ancestor).toBe(null)
    it "if a is b's superview, the value is a", ->
      view.addSubview(anotherView)
      ancestor = view.ancestorSharedWithView(anotherView)
      expect(ancestor).toBe(view)
    it "if b is a's superview, the value is b", ->
      anotherView.addSubview(view)
      ancestor = view.ancestorSharedWithView(anotherView)
      expect(ancestor).toBe(anotherView)
    it "if in the same simple hirarchy, the value is the nearest common superview", ->
      superview = new CB.View
      superview.addSubview(view)
      superview.addSubview(anotherView)
      ancestor = view.ancestorSharedWithView(anotherView)
      expect(ancestor).toBe(superview)
    it "if in the same complex hirarchy, the value is the nearest common superview", ->
      superview = new CB.View
      CB.Window.currentWindow().addSubview(view)
      CB.Window.currentWindow().addSubview(superview)
      superview.addSubview(anotherView)
      ancestor = view.ancestorSharedWithView(anotherView)
      expect(ancestor).toBe(CB.Window.currentWindow())
    it "if in the same hirarchy, the value is the nearest common superview", ->
      superview = new CB.View
      CB.Window.currentWindow().addSubview(superview)
      superview.addSubview(view)
      superview.addSubview(anotherView)
      ancestor = view.ancestorSharedWithView(anotherView)
      expect(ancestor).toBe(superview)

  describe "converts ", ->
    view2 = null
    superview = null
    beforeEach ->
      view2 = new CB.View
      superview = new CB.View
      superview.addSubview(view)
      superview.addSubview(view2)
      CB.Window.currentWindow().addSubview(superview)
      superview.frame = new CB.Rect(10, 10, 50, 50)
      view.frame = new CB.Rect(5, 5, 20, 20)
      view2.frame = new CB.Rect(7, 7, 30, 30)
    afterEach ->
      superview.removeFromSuperview()
    describe "point ", ->
      it "to view", ->
        expect(view.convertPointToView(new CB.Point(3, 3), view2)).toEqual(new CB.Point(1, 1))
      it "from view", ->
        expect(view.convertPointFromView(new CB.Point(3, 3), view2)).toEqual(new CB.Point(5, 5))
    describe "rect ", ->
      it "to view", ->
        expect(view.convertRectToView(new CB.Rect(3, 3, 2, 2), view2)).toEqual(new CB.Rect(1, 1, 2, 2))
      it "from view", ->
        expect(view.convertRectFromView(new CB.Rect(3, 3, 2, 2), view2)).toEqual(new CB.Rect(5, 5, 2, 2))

  describe "point inside", ->
    it "if rect contains", ->
      view.frame = new CB.Rect(123, 123, 30, 30)
      expect(view.pointInsideWithEvent(new CB.Point(0, 0))).toBe(true)
      expect(view.pointInsideWithEvent(new CB.Point(15, 15))).toBe(true)
      expect(view.pointInsideWithEvent(new CB.Point(30, 30))).toBe(true)
      expect(view.pointInsideWithEvent(new CB.Point(16, 31))).toBe(false)
      expect(view.pointInsideWithEvent(new CB.Point(31, 31))).toBe(false)
  describe "hit test", ->
    describe "will return null ", ->
      it "if view is hidden", ->
        view.hidden = true
        expect(view.hitTestWithEvent(new CB.Point(0, 0))).toBe(null)
      it "if user interaction is disabled", ->
        view.userInteractionEnabled = false
        expect(view.hitTestWithEvent(new CB.Point(0, 0))).toBe(null)
      it "view has a low alpha less than 0.01", ->
        view.alpha = '0.005'
        expect(view.hitTestWithEvent(new CB.Point(0, 0))).toBe(null)
    describe "will return top most view: ", ->
      it "case 1", ->
        view2 = new CB.View(new CB.Rect(5, 5, 10, 10))
        view3 = new CB.View(new CB.Rect(5, 5, 5, 5))
        view4 = new CB.View(new CB.Rect(0, 0, 4, 4))
        view.frame = new CB.Rect(0, 0, 100, 100)
        view.addSubview(view2)
        view.addSubview(view3)
        view3.addSubview(view4)
        retView = view.hitTestWithEvent(new CB.Point(6, 6))
        expect(retView).toBe(view4)
      it "case 2", ->
        view2 = new CB.View(new CB.Rect(5, 5, 10, 10))
        view3 = new CB.View(new CB.Rect(10, 10, 5, 5))
        view4 = new CB.View(new CB.Rect(0, 0, 4, 4))
        view.frame = new CB.Rect(0, 0, 100, 100)
        view.addSubview(view2)
        view.addSubview(view3)
        view3.addSubview(view4)
        retView = view.hitTestWithEvent(new CB.Point(6, 6))
        expect(retView).toBe(view2)
      it "case 3", ->
        view2 = new CB.View(new CB.Rect(5, 5, 10, 10))
        view3 = new CB.View(new CB.Rect(10, 10, 5, 5))
        view4 = new CB.View(new CB.Rect(0, 0, 4, 4))
        view.frame = new CB.Rect(0, 0, 100, 100)
        view.addSubview(view2)
        view.addSubview(view3)
        view3.addSubview(view4)
        retView = view.hitTestWithEvent(new CB.Point(1, 1))
        expect(retView).toBe(view)
