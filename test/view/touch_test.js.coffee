describe "CB.Touch", ->
  touch = null
  beforeEach ->
    touch = new CB.Touch
  describe "has readonly property: ", ->
    it "locationInWindow", ->
      expect(-> touch.locationInWindow = "abc").toThrow()
      touch._locationInWindow = "abc"
      expect(touch.locationInWindow).toEqual("abc")
    it "previousLocationInWindow", ->
      expect(-> touch.previousLocationInWindow = "abc").toThrow()
      touch._previousLocationInWindow = "abc"
      expect(touch.previousLocationInWindow).toEqual("abc")
    it "view", ->
      expect(-> touch.view = "abc").toThrow()
      touch._view = "abc"
      expect(touch.view).toEqual("abc")
    it "window", ->
      expect(-> touch.window = "abc").toThrow()
      touch._window = "abc"
      expect(touch.window).toEqual("abc")
    it "timestamp", ->
      expect(-> touch.timestamp = "abc").toThrow()
      touch._timestamp = "abc"
      expect(touch.timestamp).toEqual("abc")
