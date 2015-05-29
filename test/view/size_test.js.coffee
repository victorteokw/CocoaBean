describe "CB.Size", ->

  beforeEach -> @size = new CB.Size(20.5, 40.5)

  it "constructs", ->
    expect(@size.width).toBe(20.5)
    expect(@size.height).toBe(40.5)

  it "can't set width", ->
    expect(-> @size.width = 19).toThrow()
    expect(@size.width).toBe(20.5)

  it "can't set height", ->
    expect(-> @size.height = 30).toThrow()
    expect(@size.height).toBe(40.5)

  it "copies", ->
    newSize = @size.copy()
    expect(newSize).toEqual @size

  it "equals", ->
    newSize = new CB.Size(20.5, 40.5)
    expect(newSize.equals(@size)).toBe true
    newSize = new CB.Size(10, 20)
    expect(newSize.equals(@size)).toBe false


  it "provided Equalable", ->
    expect(CB.Size.provides(Equalable)).toBe true

  it "provided Copyable", ->
    expect(CB.Size.provides(Copyable)).toBe true
