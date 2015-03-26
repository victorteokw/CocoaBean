describe "CB.Rect", ->
  aRect = null
  beforeEach ->
    aRect = new CB.Rect(10, 20, 30, 40)
  it "constructs", ->
    expect(aRect.origin.x).toBe(10)
    expect(aRect.x).toBe(aRect.origin.x)
    expect(aRect.origin.y).toBe(20)
    expect(aRect.y).toBe(aRect.origin.y)
    expect(aRect.size.width).toBe(30)
    expect(aRect.width).toBe(aRect.size.width)
    expect(aRect.size.height).toBe(40)
    expect(aRect.height).toBe(aRect.size.height)

  it "can't set width", ->
    expect(-> aRect.width = 19).toThrow()
    expect(aRect.width).toBe(30)
  it "can't set height", ->
    expect(-> aRect.height = 30).toThrow()
    expect(aRect.height).toBe(40)
  it "can't set x", ->
    expect(-> aRect.x = 30).toThrow()
    expect(aRect.x).toBe(10)
  it "can't set y", ->
    expect(-> aRect.y = 40).toThrow()
    expect(aRect.y).toBe(20)
  it "can't set origin", ->
    expect(-> aRect.origin = new CB.Point(1,2)).toThrow()
  it "can't set size", ->
    expect(-> aRect.size = new CB.Size(1,2)).toThrow()
