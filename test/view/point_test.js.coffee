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

# Here lacks four specs, somebody want to do it?
