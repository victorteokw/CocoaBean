describe "String core extension:", ->
  describe "capitalize:", ->
    it "uppercasefy first char and lowercasefy others", ->
      a = "aBCDE"
      b = a.capitalize()
      expect(b).toEqual("Abcde")
    it "return empty string for empty string", ->
      a = ""
      expect(a.capitalize()).toBe("")
    it "just capitalize first char if length is 1", ->
      a = "a"
      expect(a.capitalize()).toBe("A")
  describe "copy:", ->
    a = null; b = null
    beforeEach ->
      a = "Abcde"
      b = a.copy()
    it "copied string has the same structure", ->
      expect(b).toEqual("Abcde")
    it "won't mutate the original one", ->
      expect(a).toEqual("Abcde")
    it "mutate copied one won't affect original one", ->
      b += "a"
      expect(a).toEqual("Abcde")
      expect(b).toEqual("Abcdea")
    it "mutate original one won't affect copied one", ->
      a += "a"
      expect(b).toEqual("Abcde")
      expect(a).toEqual("Abcdea")
