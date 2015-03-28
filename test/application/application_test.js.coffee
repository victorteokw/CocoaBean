describe "CB.Application", ->
  it "is shared", ->
    referenceOne = CB.Application.sharedApplication()
    referenceTwo = CB.Application.sharedApplication()
    expect(referenceOne).toBe(referenceTwo)
    expect(referenceOne instanceof CB.Application).toBe(true)

describe "CB.ApplicationDelegate", ->
  it "is defined", ->
    expect(CB.ApplicationDelegate).not.toBeFalsy()

describe "CB.Run", ->
  it "accept a function", ->
    pending()
  it "accept an object", ->
    pending()
