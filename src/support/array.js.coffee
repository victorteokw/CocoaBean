Array::each = (iteratee) ->
  i = 0; len = this.length
  while i < len
    iteratee(this[i]); i++
  return this

Array::remove = (object) ->
  retVal = null
  while (index = this.indexOf(object)) > -1
    this.splice(index, 1) && retVal = object
  return retVal

Array::delete = Array::remove

Array::insert = (index, objects...) ->
  for object in objects
    this.splice(index, 0, object)
    index++
  return this

Array::first = (n) ->
  if n == undefined
    return this[0]
  else
    this.slice(0, n)

Array::last = (n) ->
  if n == undefined
    return this[this.length - 1]
  else
    this.slice(this.length - n, this.length)

Array::collect = (args...) ->
  return this.map(args...)

Array::count = () ->
  this.length

Array::size = () ->
  this.length

Array::reduce = (initial, iteratee) ->
  if !iteratee
    iteratee = initial
    initial = undefined
  i = 0; len = this.length
  if typeof initial == "undefined"
    memo = this[i]
    i++
  else
    memo = initial
  if typeof iteratee == "string"
    while i < len
      memo = memo[iteratee](this[i])
      i++
  else if typeof iteratee == "function"
    while i < len
      memo = iteratee(memo, this[i])
      i++
  return memo

Array::inject = Array::reduce

Array::reject = (iteratee) ->
  collection = []
  for obj in this
    collection.push(obj) if !iteratee(obj)
  return collection

Array::select = (iteratee) ->
  collection = []
  for obj in this
    collection.push(obj) if iteratee(obj)
  return collection

Array::findAll = Array::select

Array::contains = (value) ->
  this.indexOf(value) > -1

Array::includes = Array::contains

Array::uniq = (iteratee) ->
  result = []
  seen = []
  i = 0; len = this.length
  while i < len
    value = this[i]
    computed = if iteratee then iteratee(value) else value
    if iteratee
      if !seen.contains(computed)
        result.push(value)
        seen.push(computed)
      i++
    else
      if !result.contains(value)
        result.push(value)
      i++
  return result

Array::find = (ifnone, iteratee) ->
  if !iteratee and typeof ifnone == "function"
    iteratee = ifnone
    ifnone = null
  i = 0; len = this.length
  while i < len
    if iteratee(this[i])
      ifnone = this[i]
      break
    i++
  return ifnone

Array::detect = Array::find

Array::withoutLast = (n) ->
  if typeof n == "undefined"
    n = 1
  this.slice(0, Math.max(0, this.length - n))

Array::withoutFirst = (n) ->
  if typeof n == "undefined"
    n = 1
  this.slice(n, this.length)
