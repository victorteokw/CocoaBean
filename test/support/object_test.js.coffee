describe "Object core extension", ->
  describe "class:", ->
    it "returns correct constructor function", ->
      a = new CB.View
      expect(a.class).toBe(CB.View)
  describe "superclass:", ->
    it "returns correct constructor function", ->
      a = new CB.View
      expect(a.superclass).toBe(CB.Responder)
  describe "instanceOf:", ->
    it "returns true if obj is direct instance of a class", ->
      a = new CB.View
      expect(a.instanceOf(CB.View)).toBe(true)
    it "returns true if obj is indirect instance of a class", ->
      a = new CB.View
      expect(a.instanceOf(Object)).toBe(true)
    it "returns false if obj is not instance of a class", ->
      a = new CB.View
      expect(a.instanceOf(CB.Window)).toBe(false)
  describe "respondsTo:", ->
    it "returns true if obj has the method", ->
      a = new CB.View
      expect(a.respondsTo("addSubview")).toBe(true)
    it "returns false if obj doesn't has the method", ->
      a = new CB.View
      expect(a.respondsTo("slice")).toBe(false)
