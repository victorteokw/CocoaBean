describe "CB.Size", ->
  aSize = null
  beforeEach ->
    aSize = new CB.Size(20.5, 40.5)
  it "constructs", ->
    expect(aSize.width).toBe(20.5)
    expect(aSize.height).toBe(40.5)
  it "can't set width", ->
    expect(-> aSize.width = 19).toThrow()
    expect(aSize.width).toBe(20.5)
  it "can't set height", ->
    expect(-> aSize.height = 30).toThrow()
    expect(aSize.height).toBe(40.5)
