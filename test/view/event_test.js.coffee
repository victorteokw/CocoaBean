describe "CB.Event", ->
  event = null
  beforeEach ->
    event = new CB.Event
  describe "has readonly property: ", ->
    it "locationInWindow", ->
      expect(-> event.locationInWindow = "abc").toThrow()
      event._locationInWindow = "abc"
      expect(event.locationInWindow).toEqual("abc")
    it "previousLocationInWindow", ->
      expect(-> event.previousLocationInWindow = "abc").toThrow()
      event._previousLocationInWindow = "abc"
      expect(event.previousLocationInWindow).toEqual("abc")
    it "view", ->
      expect(-> event.view = "abc").toThrow()
      event._view = "abc"
      expect(event.view).toEqual("abc")
    it "window", ->
      expect(-> event.window = "abc").toThrow()
      event._window = "abc"
      expect(event.window).toEqual("abc")
    it "timestamp", ->
      expect(-> event.timestamp = "abc").toThrow()
      event._timestamp = "abc"
      expect(event.timestamp).toEqual("abc")
    it "allTouches", ->
      expect(-> event.allTouches = "abc").toThrow()
      event._allTouches = "abc"
      expect(event.allTouches).toEqual("abc")
    it "type", ->
      expect(-> event.type = "abc").toThrow()
      event._type = "abc"
      expect(event.type).toEqual("abc")
