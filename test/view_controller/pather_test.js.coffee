describe "CB.Pather", ->
  it "is shared", ->
    a = CB.Pather.sharedPather()
    b = CB.Pather.sharedPather()
    expect(a).toBe(b)
    expect(a instanceof CB.Pather).toBe(true)
  describe "returns correct current path: ", ->
    localContext =
        location:
          href: "url"
    it "for abc.com/#abcde/ddeff/aabbc, should return /abcde/ddeff/aabbc", ->
      body = (window) ->
        window.location.href = "http://abc.com/#abcde/ddeff/aabbc"
        path = CB.Pather.sharedPather().currentPath(window)
        expect(path).toBe("/abcde/ddeff/aabbc")
      body(localContext)
    it "for abc.com, should return /", ->
      body = (window) ->
        window.location.href = "http://abc.com"
        path = CB.Pather.sharedPather().currentPath(window)
        expect(path).toBe("/")
      body(localContext)
    it "for a.com/#z, should return /z", ->
      body = (window) ->
        window.location.href = "http://abc.com/#z"
        path = CB.Pather.sharedPather().currentPath(window)
        expect(path).toBe("/z")
      body(localContext)
