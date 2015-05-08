describe "Number core extension", ->
  describe "copy:", ->
    a = null; b = null
    beforeEach ->
      a = 1
      b = a.copy()
    it "copied number has same value", ->
      expect(b).toEqual(1)
    it "won't mutate the original one", ->
      expect(a).toEqual(1)
    it "mutate copied one won't affect original one", ->
      b += 2
      expect(a).toEqual(1)
      expect(b).toEqual(3)
    it "mutate original one won't affect copied one", ->
      a += 2
      expect(b).toEqual(1)
      expect(a).toEqual(3)
