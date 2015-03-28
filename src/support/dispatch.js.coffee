CB.__DispatchOnceTokenTable ||= {}
CB.DispatchOnce ||= (token, code) ->
  if !CB.__DispatchOnceTokenTable[token]
    code()
    CB.__DispatchOnceTokenTable[token] = true

CB.DispatchAfter ||= (func, timeInMillisecond) ->
  setTimeout(func, timeInMillisecond);

CB.DispatchAsync ||= (func) ->
  setTimeout(func, 0)

CB.__DebugToken = true
CB.DispatchDebug ||= (func) ->
  if CB.__DebugToken
    func()
