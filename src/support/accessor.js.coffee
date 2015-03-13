# Use accessors.
#
# @example
#   class MyClass extends SuperClass
#     @property 'myProperty',
#       get: -> @_myProperty
#       set: (newValue) -> @_myProperty = newValue
#
Function::property = (prop, desc) ->
  if !desc
    desc = {}
  if !desc.set
    desc.set = (newValue) -> this["_" + prop] = newValue
  if !desc.get
    desc.get = -> this["_" + prop]
  Object.defineProperty @prototype, prop, desc
