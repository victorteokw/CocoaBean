describe "CB.Window", ->
  window = CB.Window.currentWindow()
  it "should be subclass of CB.View", ->
    expect(window instanceof CB.Window).toBe(true)
    expect(window instanceof CB.View).toBe(true)
    expect(window instanceof CB.Responder).toBe(true)
  it "is shared", ->
    expect(CB.Window.currentWindow()).toBe(CB.Window.currentWindow())
  it "represents DOM body", ->
    expect(window.layerDescription()[0]).toEqual(document.body)
  it "sets window after view added to it", ->
    view = new CB.View
    expect(view.window).toBeFalsy()
    window.addSubview(view)
    expect(view.window).toBe(window)
  it "unsets window after view removed from it", ->
    view = new CB.View
    expect(view.window).toBeFalsy()
    window.addSubview(view)
    expect(view.window).toBe(window)
    view.removeFromSuperview()
    expect(view.window).toBe(null)
  it "next responder is application object", ->
    expect(window.nextResponder()).toBe(CB.Application.sharedApplication())
  describe "layoutSubviews", ->
    it "set subview frame to equal window", ->
      view = new CB.View
      window._rootView = view
      window.layoutSubviews()
      expect(view.frame).toEqual(window.frame)
