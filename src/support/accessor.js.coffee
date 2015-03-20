# Use accessors inside a class.
#
# @example
#   class MyClass extends SuperClass
#     @property 'myProperty',
#       get: -> @_myProperty
#       set: (newValue) -> @_myProperty = newValue
#
# @example
#   @property 'readonly', 'name',
#     get: -> return "Smith"
#
Function::property = (accessibility, property, description) ->
  if !description and !accessibility.match(/(?:readonly|readwrite|writeonly)/)
    description = property
    property = accessibility
    accessibility = 'readwrite'
  if !description
    description = {}
  if !description.set and accessibility.match(/write/)
    description.set = (newValue) -> this["_" + property] = newValue
  if !description.get and accessibility.match(/read/)
    description.get = -> this["_" + property]
  if accessibility.match(/only/)
    if accessibility.match(/read/)
      description.set = -> throw "Property permission denied."
    else if accessibility.match(/write/)
      description.get = -> throw "Property permission denied."
  Object.defineProperty @prototype, property, description
