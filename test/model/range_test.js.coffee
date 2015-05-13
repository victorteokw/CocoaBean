describe "CB.Range", ->
  describe "constructs", ->
    it "with two numbers", ->
      a = new CB.Range(0, 2)
      expect(a.start).toEqual(0)
      expect(a.length).toEqual(2)
      expect(a.end).toEqual(2)
    it "with an array", ->
      a = new CB.Range([3, 8])
      expect(a.start).toEqual(3)
      expect(a.length).toEqual(5)
      expect(a.end).toEqual(8)

  it "equals", ->
    a = new CB.Range(1, 3)
    b = new CB.Range([1, 4])
    c = new CB.Range([2, 5])
    expect(a.equals(b)).toBe(true)
    expect(b.equals(c)).toBe(false)
