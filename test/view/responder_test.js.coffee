describe "CB.Responder", ->
  responder = null
  beforeEach ->
    responder = new CB.Responder
  it "next responder is always null", ->
    expect(responder.nextResponder()).toBe(null)
  it "is first responder after became first responder", ->
    expect(responder.isFirstResponder()).toBe(false)
    spyOn(responder, "canBecomeFirstResponder").and.returnValue(true)
    responder.becomeFirstResponder()
    expect(responder.isFirstResponder()).toBe(true)
  it "always cannot become first responder", ->
    expect(responder.canBecomeFirstResponder()).toBe(false)
  it "acceptsFirstResponder is actually OS X name version of canBecomeFirstResponder", ->
    expect(responder.acceptsFirstResponder()).toEqual(responder.canBecomeFirstResponder())
  it "always can resign first responder", ->
    expect(responder.canResignFirstResponder()).toBe(true)
  it "is not first responder after resign first responder", ->
    expect(responder.isFirstResponder()).toBe(false)
    spyOn(responder, "canBecomeFirstResponder").and.returnValue(true)
    responder.becomeFirstResponder()
    expect(responder.isFirstResponder()).toBe(true)
    responder.resignFirstResponder()
    expect(responder.isFirstResponder()).toBe(false)
  describe "defines method ", ->
    it "touchesBeganWithEvent", ->
      expect(typeof responder.touchesBeganWithEvent).toBe("function")
    it "touchesMovedWithEvent", ->
      expect(typeof responder.touchesMovedWithEvent).toBe("function")
    it "touchesEndedWithEvent", ->
      expect(typeof responder.touchesEndedWithEvent).toBe("function")
    it "touchesCanceledWithEvent", ->
      expect(typeof responder.touchesCanceledWithEvent).toBe("function")
    it "mouseDownWithEvent", ->
      expect(typeof responder.mouseDownWithEvent).toBe("function")
    it "mouseMovedWithEvent", ->
      expect(typeof responder.mouseMovedWithEvent).toBe("function")
    it "mouseUpWithEvent", ->
      expect(typeof responder.mouseUpWithEvent).toBe("function")
    it "mouseDraggedWithEvent", ->
      expect(typeof responder.mouseDraggedWithEvent).toBe("function")
    it "mouseEnteredWithEvent", ->
      expect(typeof responder.mouseEnteredWithEvent).toBe("function")
    it "mouseExitedWithEvent", ->
      expect(typeof responder.mouseExitedWithEvent).toBe("function")
    it "keyDownWithEvent", ->
      expect(typeof responder.keyDownWithEvent).toBe("function")
    it "keyUpWithEvent", ->
      expect(typeof responder.keyUpWithEvent).toBe("function")
