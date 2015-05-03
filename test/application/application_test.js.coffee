describe "CB.Application", ->
  it "is shared", ->
    referenceOne = CB.Application.sharedApplication()
    referenceTwo = CB.Application.sharedApplication()
    expect(referenceOne).toBe(referenceTwo)
    expect(referenceOne instanceof CB.Application).toBe(true)

  it "inherits from CB.Responder", ->
    expect(CB.Application.sharedApplication() instanceof CB.Responder).toBe(true)

  it "has an readonly delegate", ->
    reference = CB.Application.sharedApplication()
    expect(reference.delegate).toBe(undefined)
    expect(-> reference.delegate = "new delegate").toThrow()
    delegate = new CB.ApplicationDelegate
    reference._delegate = delegate
    expect(reference.delegate).toBe(delegate)

  it "has a key window and on web platform, it's just CB.Window.currentWindow()", ->
    expect(CB.Application.sharedApplication().keyWindow).toBe(CB.Window.currentWindow())

  it "has windows and on web platform, it's just [CB.Window.currentWindow()]", ->
    expect(CB.Application.sharedApplication().windows).toEqual([CB.Window.currentWindow()])

  it "has web title", ->
    expect(CB.Application.sharedApplication().webTitle).toBe(document.title)
    CB.Application.sharedApplication().webTitle = "New title"
    expect(CB.Application.sharedApplication().webTitle).toBe("New title")
    expect(document.title).toBe("New title")

  it "is the last responder", ->
    expect(CB.Application.sharedApplication().nextResponder()).toBe(null)

describe "CB.ApplicationDelegate", ->
  it "is defined", ->
    expect(CB.ApplicationDelegate).not.toBeFalsy()

  it "has a method named applicationDidFinishLaunchingWithOptions", ->
    delegate = new CB.ApplicationDelegate
    expect(typeof delegate.applicationDidFinishLaunchingWithOptions).toBe("function")

describe "CB.Run", ->
  it "accept a function", ->
    pending("Don't know how to test this")
  it "accept an object", ->
    pending("Don't know how to test this")
