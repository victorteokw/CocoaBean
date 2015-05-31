describe "CB.Point", ->

  beforeEach -> @point = new CB.Point(20.5, 40.5)

  it "constructs", ->
    expect(@point.x).toBe(20.5)
    expect(@point.y).toBe(40.5)

  it "can't set x", ->
    expect(-> @point.x = 19).toThrow()
    expect(@point.x).toBe(20.5)

  it "can't set y", ->
    expect(-> @point.y = 30).toThrow()
    expect(@point.y).toBe(40.5)

  it "copies", ->
    newPoint = @point.copy()
    expect(newPoint).toEqual @point

  it "equals", ->
    newPoint = new CB.Point(10, 20, 30, 40)
    expect(newPoint.equals(@point)).toBe true
    newPoint = new CB.Point(10, 20, 30, 41)
    expect(newPoint.equals(@point)).toBe false

  it "provided Equalable", ->
    expect(CB.Point.provides(Equalable)).toBe true

  it "provided Copyable", ->
    expect(CB.Point.provides(Copyable)).toBe true
