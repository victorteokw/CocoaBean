describe "CB.View", ->

  view = null

  beforeEach -> view = new CB.View

  describe "is defined:", ->

    it "it inherits from CB.Responder", ->
      expect(view instanceof CB.Responder).toBe(true)

  describe "initializes", ->

    it "without a frame", ->
      expect(view.class).toBe(CB.View)

    it "with a frame, and its frame should be the one passed to constructor", ->
      view = new CB.View(new CB.Rect(10, 10, 20, 20))
      expect(view.class).toBe CB.View
      expect(view.frame).toEqual new CB.Rect(10, 10, 20, 20)

  describe "has default property values", ->

    it "frame defaults to CB.Rect(0, 0, 0, 0)", ->
      expect(view.frame).toEqual new CB.Rect(0, 0, 0, 0)

    it "bounds defaults to CB.Rect(0, 0, 0, 0)", ->
      expect(view.bounds).toEqual new CB.Rect(0, 0, 0, 0)

    it "center defaults to CB.Point(0, 0)", ->
      expect(view.center).toEqual new CB.Point(0, 0)

    it "alpha defaults to 1.0", ->
      expect(view.alpha).toEqual 1.0

    it "backgroundColor defaults to clear color", ->
      pending()

    it "transform defaults to identity transform", ->
      pending()

    it "hidden defaults to false", ->
      expect(view.hidden).toBe false

    it "cornerRadius defaults to 0", ->
      expect(view.cornerRadius).toBe 0

    it "clipsToBounds defaults to true", ->
      expect(view.clipsToBounds).toBe true

    it "window defaults to null", ->
      expect(view.window).toBe null

  describe "has these features:", ->

    describe "addSubview(subview):", ->

      subview = null

      beforeEach ->
        subview = new CB.View
        view.addSubview(subview)

      it "add subview into superview's @subviews", ->
        expect(view.subviews).toEqual [subview]

      it "set subview's superview to superview", ->
        expect(subview.superview).toBe view

      it "if subview has superview, remove subview from it and add", ->
        superview2 = new CB.View
        superview2.addSubview(subview)
        expect(view.subviews).toEqual []
        expect(superview2.subviews).toEqual [subview]
        expect(subview.superview).toBe superview2

      it "newer subview comes after older subviews", ->
        subview2 = new CB.View
        view.addSubview(subview2)
        expect(view.subviews).toEqual [subview, subview2]

    describe "inspects hirarchy: ", ->

      left1 = null
      left2 = null
      right1 = null
      windol = null

      beforeEach ->
        left1 = new CB.View
        left2 = new CB.View
        right1 = new CB.View
        view.addSubview(left1)
        left1.addSubview(left2)
        view.addSubview(right1)
        windol = new CB.Window
        windol.addSubview(view)

      describe "isDescendantOfView(aView):", ->

        it "returns true if aView is itself", ->
          expect(view.isDescendantOfView(view)).toBe true
          expect(view.isDescendantOf(view)).toBe true

        it "returns true if aView is superview of view", ->
          expect(left1.isDescendantOfView(view)).toBe true
          expect(left1.isDescendantOf(view)).toBe true

        it "returns true if aView is way far up the hirarchy", ->
          expect(left2.isDescendantOfView(view)).toBe true
          expect(left2.isDescendantOf(view)).toBe true

        it "returns true if aView is view's window", ->
          expect(left2.isDescendantOfView(windol)).toBe true
          expect(left2.isDescendantOf(windol)).toBe true

        it "returns false if aView is not in the same hirarchy with view", ->
          remoteView = new CB.View
          remoteRightView = new CB.View
          remoteView.addSubview(remoteRightView)
          expect(left2.isDescendantOfView(remoteRightView)).toBe false
          expect(left2.isDescendantOf(remoteRightView)).toBe false

        it "returns false if aView is not way up the hirarchy", ->
          expect(left2.isDescendantOfView(right1)).toBe false
          expect(left2.isDescendantOf(right1)).toBe false

      describe "ancestorSharedWithView(viewB):", ->

        it "returns viewA if viewA is viewB's superview", ->
          expect(left1.ancestorSharedWithView(left2)).toBe left1

        it "returns viewB if viewB is viewA's superview", ->
          expect(left2.ancestorSharedWithView(left1)).toBe left1

        it "returns common superview is viewA and viewB \
        are in the same hirarchy", ->
          expect(left1.ancestorSharedWithView(right1)).toBe view
          expect(left2.ancestorSharedWithView(right1)).toBe view

        it "returns viewA if viewA is viewB's window", ->
          expect(windol.ancestorSharedWithView(right1)).toBe windol

        it "returns viewB if viewB is viewA's window", ->
          expect(right1.ancestorSharedWithView(windol)).toBe windol

        it "returns null if any of the views doesn't have a superview", ->
          lonelyView = new CB.View
          expect(lonelyView.ancestorSharedWithView(right1)).toBe null
          expect(right1.ancestorSharedWithView(lonelyView)).toBe null

        it "returns null if views are not in the same hirarchy", ->
          ancientView = new CB.View
          ancientSon = new CB.View
          expect(view.ancestorSharedWithView(ancientSon)).toBe null
          expect(ancientSon.ancestorSharedWithView(view)).toBe null

    describe "converts metrics: ", -> # TODO: test more precisely

      view2 = null
      superview = null

      beforeEach ->
        view2 = new CB.View
        superview = new CB.View
        superview.addSubview(view)
        superview.addSubview(view2)
        superview.frame = new CB.Rect(10, 10, 50, 50)
        view.frame = new CB.Rect(5, 5, 20, 20)
        view2.frame = new CB.Rect(7, 7, 30, 30)

      describe "point ", ->

        it "to view", ->
          expect(view.convertPointToView(new CB.Point(3, 3), view2))
            .toEqual(new CB.Point(1, 1))

        it "from view", ->
          expect(view.convertPointFromView(new CB.Point(3, 3), view2))
            .toEqual(new CB.Point(5, 5))

      describe "rect ", ->

        it "to view", ->
          expect(view.convertRectToView(new CB.Rect(3, 3, 2, 2), view2))
            .toEqual(new CB.Rect(1, 1, 2, 2))

        it "from view", ->
          expect(view.convertRectFromView(new CB.Rect(3, 3, 2, 2), view2))
            .toEqual(new CB.Rect(5, 5, 2, 2))

    describe "triggers hook:", ->

      subview = null
      windol = null

      spyForTriggers = ->
        spyOn view, "didAddSubview"
        spyOn view, "willRemoveSubview"
        spyOn subview, "willMoveToSuperview"
        spyOn subview, "didMoveToSuperview"
        spyOn subview, "willMoveToWindow"
        spyOn subview, "didMoveToWindow"

      beforeEach ->
        windol = new CB.Window
        windol.addSubview(view)

      describe "on adding subview", ->

        beforeEach ->
          subview = new CB.View
          spyForTriggers()
          view.addSubview(subview)

        it "didAddSubview on superview once with subview", ->
          expect(view.didAddSubview).toHaveBeenCalledWith subview
          expect(view.didAddSubview.calls.count()).toBe 1

        it "willMoveToSuperview on subview once with superview", ->
          expect(subview.willMoveToSuperview).toHaveBeenCalledWith view
          expect(subview.willMoveToSuperview.calls.count()).toBe 1

        it "didMoveToSuperview on subview once with superview", ->
          expect(subview.didMoveToSuperview).toHaveBeenCalledWith view
          expect(subview.didMoveToSuperview.calls.count()).toBe 1

        it "willMoveToWindow on subview once with superview's window", ->
          expect(subview.willMoveToWindow).toHaveBeenCalledWith windol
          expect(subview.willMoveToWindow.calls.count()).toBe 1

        it "didMoveToWindow on subview once with superview's window", ->
          expect(subview.didMoveToWindow).toHaveBeenCalledWith windol
          expect(subview.didMoveToWindow.calls.count()).toBe 1

      describe "on removing subview", ->

        beforeEach ->
          subview = new CB.View
          view.addSubview(subview)
          spyForTriggers()
          subview.removeFromSuperview()

        it "willRemoveSubview on superview once with subview", ->
          expect(view.willRemoveSubview).toHaveBeenCalledWith subview
          expect(view.willRemoveSubview.calls.count()).toBe 1

        it "willMoveToSuperview on subview once with null", ->
          expect(subview.willMoveToSuperview).toHaveBeenCalledWith null
          expect(subview.willMoveToSuperview.calls.count()).toBe 1

        it "didMoveToSuperview on subview once with null", ->
          expect(subview.didMoveToSuperview).toHaveBeenCalledWith null
          expect(subview.didMoveToSuperview.calls.count()).toBe 1

        it "willMoveToWindow on subview once with null", ->
          expect(subview.willMoveToWindow).toHaveBeenCalledWith null
          expect(subview.willMoveToWindow.calls.count()).toBe 1

        it "didMoveToWindow on subview once with null", ->
          expect(subview.didMoveToWindow).toHaveBeenCalledWith null
          expect(subview.didMoveToWindow.calls.count()).toBe 1

    describe "hit tests:", ->

      describe "pointInsideWithEvent(point, eventOrNull)", ->

        beforeEach -> view.frame = new CB.Rect(123, 123, 30, 30)

        it "pointInside if point is inside the frame rect", ->
          expect(view.pointInsideWithEvent(new CB.Point(0, 0))).toBe(true)
          expect(view.pointInsideWithEvent(new CB.Point(15, 15))).toBe(true)
          expect(view.pointInsideWithEvent(new CB.Point(30, 30))).toBe(true)

        it "point not inside if point is not inside frame rect", ->
          expect(view.pointInsideWithEvent(new CB.Point(16, 31))).toBe(false)
          expect(view.pointInsideWithEvent(new CB.Point(31, 31))).toBe(false)

        it "event parameter", ->
          pending() # TODO: check Apple's documentation for how this api works

      # TODO: need improve the testing below hitTestWithEvent
      describe "hitTestWithEvent(point, eventOrNull)", ->
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
          it "event parameter", ->
            pending()
            # TODO: same reason with above

    describe "lazy loading layer", ->

      it "pending", ->
        pending() # TODO: implement it in the future as optimization
        expect(view._layer).toBe(undefined)
        a = view.layer
        expect(view._layer).toBe(a)
        expect(view.layer).toBe(view._layer)

    describe "layouting:", ->

      describe "layoutSubviews()", ->

        it "is defined", ->
          expect(typeof view.layoutSubviews).toBe "function"

      describe "sizeThatFits(sizeOrNull)", ->

        it "just returns it's frame when parameter is null", ->
          expect(view.sizeThatFits()).toEqual view.frame.size

        it "just returns it's frame when parameter is of CB.Size", ->
          size = new CB.Size(10, 20)
          expect(view.sizeThatFits(size)).toEqual view.frame.size

      describe "sizeToFit(sizeOrNull)", ->

        beforeEach ->
          @size = new CB.Size(20, 20)
          spyOn(view, "sizeThatFits").and.returnValue @size
          view.sizeToFit(@size)

        it "resizes frame of view", ->
          expect(view.frame).toEqual new CB.Rect(0, 0, 20, 20)

        it "calls sizeThatFits() with the same argument", ->
          expect(view.sizeThatFits).toHaveBeenCalledWith @size

      xdescribe "setNeedsLayout()", ->

      xdescribe "layoutIfNeeded", ->

    describe "behave as responder:", ->

      describe "nextResponder()", ->

        beforeEach ->
          @viewController = new CB.ViewController
          @superview = new CB.View
          @subview = new CB.View
          @superview.addSubview(@viewController.view)
          @viewController.view.addSubview(@subview)

        it "returns view controller if it has", ->
          expect(@viewController.view.nextResponder()).toBe @viewController

        it "returns its superview if it has", ->
          expect(@subview.nextResponder()).toBe @viewController.view

        it "returns null if it doesn't have superview nor view controller", ->
          expect(@superview.nextResponder()).toBe null

        it "returns view controller if it has both vc and superview", ->
          expect(@viewController.view.nextResponder()).toBe @viewController

      describe "userInteractionEnabled", ->

        it "defaults to true", ->
          expect(view.userInteractionEnabled).toBe true

      describe "canBecomeFirstResponder()", ->

        it "return true by default", ->
          expect(view.canBecomeFirstResponder()).toBe true

        it "returns false if user interaction is not enabled", ->
          view.userInteractionEnabled = false
          expect(view.canBecomeFirstResponder()).toBe false

        it "returns false if alpha is less than 0.01", ->
          view.alpha = 0.0
          expect(view.canBecomeFirstResponder()).toBe false

        it "returns false if it's hidden", ->
          view.hidden = true
          expect(view.canBecomeFirstResponder()).toBe false

  describe "defines these methods:", ->

    describe "layerDescription()", ->

      it "default to an DOM div", ->
        expect(view.layerDescription()).toEqual $("<div></div>")

    # TODO implement these
    xdescribe "insertSubviewAtIndex", ->
      pending()
    xdescribe "insertSubviewAboveSubview", ->
      pending()
    xdescribe "insertSubviewBelowSubview", ->
      pending()
    xdescribe "exchangeSubviewAtIndexWithSubviewAtIndex", ->
      pending()
    xdescribe "bringSubviewToFront", ->
      pending()
    xdescribe "sendSubviewToBack", ->
      pending()

  describe "defines these properties:", ->

    describe "subviews", ->

      it "is an empty array on create", ->
        expect(view.subviews).toEqual []

      it "is readonly", ->
        expect( ->
          view.subviews = []
          ).toThrow()

      xit "is copied property", ->


    describe "bounds", ->

      it "is defined by frame", ->
        expect(view.bounds).toEqual new CB.Rect(0, 0, 0, 0)
        view.frame = new CB.Rect(50, 50, 100, 100)
        expect(view.bounds).toEqual new CB.Rect(0, 0, 100, 100)

      it "affects frame's width and height value when sets", ->
        view.frame = new CB.Rect(10, 10, 0, 0)
        view.bounds = new CB.Rect(0, 0, 100, 100)
        expect(view.frame).toEqual new CB.Rect(10, 10, 100, 100)

      it "affects view's center property when sets", ->
        view.frame = new CB.Rect(10, 10, 0, 0)
        view.bounds = new CB.Rect(0, 0, 100, 100)
        expect(view.center).toEqual new CB.Point(60, 60)

    describe "center", ->

      it "is calculated from frame", ->
        expect(view.center).toEqual new CB.Point(0, 0)
        view.frame = new CB.Rect(10, 20, 30, 40)
        expect(view.center).toEqual new CB.Point(25, 40)

      it "affects frame's x and y value when sets", ->
        view.frame = new CB.Rect(10, 20, 30, 40)
        view.center = new CB.Point(50, 50)
        expect(view.frame).toEqual new CB.Rect(35, 30, 30, 40)

    describe "frame", ->

      it "affects bounds when sets", ->
        view.frame = new CB.Rect(1, 2, 3, 4)
        expect(view.bounds).toEqual new CB.Rect(0, 0, 3, 4)

      it "affects center when sets", ->
        view.frame = new CB.Rect(10, 10, 30, 30)
        expect(view.center).toEqual new CB.Point(25, 25)

    describe "window", ->

      beforeEach -> @windol = new CB.Window

      it "has a window when it's the direct subview of the window", ->
        @windol.addSubview(view)
        expect(view.window).toBe @windol

      it "doesn't have a window when it's not in the hirarchy", ->
        expect(view.window).toBe null

      it "has a window when it's in the view hirarchy of window", ->
        subview = new CB.View
        view.addSubview(subview)
        @windol.addSubview(view)
        expect(subview.window).toBe @windol
