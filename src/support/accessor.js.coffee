# Use accessors when declaring a class.
#
# The simplest usage is like this:
#
# @example
#   class MyClass extends SuperClass
#     @property 'myProperty'
#
# An optional object may be appended to alter the default getter and setter
# The simplest usage above works like this:
#
# @example
#   class MyClass extends SuperClass
#     @property 'myProperty',
#       get: -> @_myProperty
#       set: (newValue) -> @_myProperty = newValue
#
# An optional accessibility can be specified like this:
#
# @example
#   class MyClass extends SuperClass
#     @property 'readonly', 'myProperty'
#
# Therefore, if you try to assign a new value for the property,
# you get an error.
#
# An optional referencing can be specified like this:
#
# @example
#   class Person
#     @property 'readonly', 'copy', 'familyMembers',
#       get: -> return ['mom', 'dad', 'sister', 'brother']
#
# In this case, the value is copied through copy() method defined on
# the object.
#
# @param [String] accessibility the accessibility level of the property.
# available values are 'readwrite', 'readonly', 'writeonly'
# 'readwrite' is the default value.
# This parameter is optional.
#
# @param [String] referencing the referencing level of the property.
# available values are 'strong', 'week', 'copy'.
# 'week' is unused and 'strong' is the default value.
# This parameter is optional.
#
# @param [String] property the name of the property.
# This parameter is required.
#
# @param [Object] description the accessor description.
# @option description [Function] set the setter
# @option description [Function] get the getter
#
# @return [Undefined] returns nothing
#
Function::property = ->

  args = Array.prototype.slice.call(arguments)
  unless args.length >= 1
    throw new CB.PropertyDeclarationError("you should provide at \
      least one argument.")

  maybeDescription = args[args.length - 1]
  if typeof maybeDescription == 'object'
    description = args.pop()

  property = args.pop()

  unless args.length == 0
    firstArgument = args[0]
    if firstArgument.match /(?:readonly|readwrite|writeonly)/
      accessibility = firstArgument
      if args[1] and args[1].match /(?:copy|week|strong)/
        referencing = args[1]
    else if firstArgument.match /(?:copy|week|strong)/
      referencing = firstArgument

  referencing ||= 'strong'
  accessibility ||= 'readwrite'
  description ||= {}

  if accessibility.match /readonly/
    description.set = ->
      throw new CB.PropertyAccessorError "Property is readonly."
  else if accessibility.match /writeonly/
    description.get = ->
      throw new CB.PropertyAccessorError "Property is writeonly."

  if !description.set
    description.set = (newValue) -> this["_" + property] = newValue
  if !description.get
    if referencing == "copy"
      description.get = ->
        pn = ["_" + property]
        if typeof this[pn] == 'undefined'
          return undefined
        else if typeof this[pn] == 'object'
          return this[pn].copy()
        else return this[pn]
    else
      description.get = -> this["_" + property]

  Object.defineProperty @prototype, property, description

  return
