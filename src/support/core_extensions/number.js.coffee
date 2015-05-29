# This method should be provided to provide consistent behavior
Number::copy = ->
  return this

Number.provided Copyable
