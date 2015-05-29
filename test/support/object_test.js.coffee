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

  describe "copy", ->

    # Sorry for my English ;)
    it "returns a very similar object", ->
      obj1 = key1: "value1", key2: "value2"
      obj2 = obj1.copy()
      expect(obj1).not.toBe obj2
      expect(obj1).toEqual obj2

    it "works for complex object, too", ->
      obj1 = new CB.View
      obj1.cornerRadius = 10.0
      obj2 = obj1.copy()
      expect(obj2.class).toBe CB.View
      expect(obj2).not.toBe obj1
      expect(obj2).toEqual obj1
      expect(obj2.cornerRadius).toEqual 10

      obj1 = new CB.View(new CB.Rect(1, 2, 3, 4))
      obj2 = obj1.copy()
      expect(obj2.class).toBe CB.View
      expect(obj2).not.toBe obj1
      expect(obj2).toEqual obj1
      expect(obj2.frame).toEqual new CB.Rect(1, 2, 3, 4)
