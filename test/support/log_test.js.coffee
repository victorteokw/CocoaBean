describe "CB.Log", ->
  it "calls console.log with the same argument", ->
    spyOn(console, 'log')
    CB.Log("I love test.")
    expect(console.log).toHaveBeenCalledWith("I love test.")

describe "CB.DebugLog", ->
  it "calls CB.Log when debug token is on", ->
    CB.__DebugToken = true
    spyOn(CB, 'Log')
    CB.DebugLog("We're debugging!")
    expect(CB.Log).toHaveBeenCalledWith("DEBUG: " + "We're debugging!")
  it "doesn't call CB.Log when debug token is off", ->
    CB.__DebugToken = false
    spyOn(CB, 'Log')
    CB.DebugLog("We are not debugging!")
    expect(CB.Log).not.toHaveBeenCalled()
