describe "CB.Rect", ->

  beforeEach -> @rect = new CB.Rect(10, 20, 30, 40)

  it "constructs", ->
    expect(@rect.origin.x).toBe(10)
    expect(@rect.x).toBe(@rect.origin.x)
    expect(@rect.origin.y).toBe(20)
    expect(@rect.y).toBe(@rect.origin.y)
    expect(@rect.size.width).toBe(30)
    expect(@rect.width).toBe(@rect.size.width)
    expect(@rect.size.height).toBe(40)
    expect(@rect.height).toBe(@rect.size.height)

  it "can't set width", ->
    expect(-> @rect.width = 19).toThrow()
    expect(@rect.width).toBe(30)

  it "can't set height", ->
    expect(-> @rect.height = 30).toThrow()
    expect(@rect.height).toBe(40)

  it "can't set x", ->
    expect(-> @rect.x = 30).toThrow()
    expect(@rect.x).toBe(10)

  it "can't set y", ->
    expect(-> @rect.y = 40).toThrow()
    expect(@rect.y).toBe(20)

  it "can't set origin", ->
    expect(-> @rect.origin = new CB.Point(1,2)).toThrow()

  it "can't set size", ->
    expect(-> @rect.size = new CB.Size(1,2)).toThrow()

  it "copies", ->
    newRect = @rect.copy()
    expect(newRect).toEqual @rect

  it "equals", ->
    newRect = new CB.Rect(10, 20, 30, 40)
    expect(newRect.equals(@rect)).toBe true
    newRect = new CB.Rect(10, 20, 30, 41)
    expect(newRect.equals(@rect)).toBe false

  it "provided Equalable", ->
    expect(CB.Rect.provides(Equalable)).toBe true

  it "provided Copyable", ->
    expect(CB.Rect.provides(Copyable)).toBe true
