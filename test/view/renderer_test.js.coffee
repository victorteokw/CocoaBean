describe "CB.Renderer", ->
  it "is shared", ->
    rendererA = CB.Renderer.sharedRenderer()
    rendererB = CB.Renderer.sharedRenderer()
    expect(rendererA).toBe(rendererB)
    expect(rendererA instanceof CB.Renderer).toBe(true)
