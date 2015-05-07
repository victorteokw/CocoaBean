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
