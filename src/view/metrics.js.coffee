class CB.Metrics # Deprecated
  @add: (a, b) ->
    if typeof a == 'number'
      a = a + 'px'
    if typeof b == 'number'
      b = b + 'px'
    if a.match(/%$/) and b.match(/%$/)
      [ra, rb] = [parseFloat(a), parseFloat(b)]
      return (ra + rb).toString() + "%"
    if a.match(/px$/) and b.match(/px$/)
      [ra, rb] = [parseFloat(a), parseFloat(b)]
      return (ra + rb).toString() + "px"
    throw "CB.Metrics: Add error." # TODO: Better error.
  @multiply: (a, b) ->
    if typeof a == 'number'
      a = a + 'px'
    if typeof b == 'number'
      b = b + 'px'
    for value in [a, b]
      if typeof value == 'number'
        value = value + 'px'
    if a.match(/%$/) and b.match(/px$/)
      [a, b] = [b, a]
    if a.match(/px$/) and b.match(/%$/)
      [ra, rb] = [parseFloat(a), parseFloat(b)]
      return (ra * rb / 100.0).toString() + "px"
    throw "CB.Metrics: Multiply error." # TODO: Better error.
