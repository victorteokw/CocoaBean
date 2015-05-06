Array::each = (iteratee) ->
  i = 0; len = this.length
  while i < len
    iteratee(this[i]); i++
  return this
