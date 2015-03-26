describe "CB.Point", ->
  aPoint = null
  beforeEach ->
    aPoint = new CB.Point(20.5, 40.5)
  it "constructs", ->
    expect(aPoint.x).toBe(20.5)
    expect(aPoint.y).toBe(40.5)
  it "can't set x", ->
    expect(-> aPoint.x = 19).toThrow()
    expect(aPoint.x).toBe(20.5)
  it "can't set y", ->
    expect(-> aPoint.y = 30).toThrow()
    expect(aPoint.y).toBe(40.5)
