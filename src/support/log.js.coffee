CB.Log ||= (string) ->
  console.log(string)

CB.DebugLog ||= (string) ->
  CB.DispatchDebug(-> CB.Log("DEBUG: " + string))
