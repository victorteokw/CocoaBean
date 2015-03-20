CB.__DispatchOnceTokenTable ||= {}
CB.DispatchOnce ||= (token, code) ->
  if !CB.__DispatchOnceTokenTable[token]
    code()
    CB.__DispatchOnceTokenTable[token] = true

CB.DispatchAfter ||= (func, time) ->
  setTimeout(func, time);

CB.DispatchAsync ||= (func) ->
  setTimeout(func, 0)
