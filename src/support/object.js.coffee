Object::equals = (rhs) ->
  this == rhs

Object.property "readonly", "class",
  get: () ->
    this.constructor

Object.property "readonly", "superclass",
  get: () ->
    if this.constructor.prototype.__proto__
      return this.constructor.prototype.__proto__.constructor
    return undefined

Object::instanceOf = (cls) ->
  this instanceof cls

Object::copy = () ->
    # How to do this?

Object::deepCopy = () ->

Object::respondsTo = (methodName) ->
  value = this[methodName]
  if typeof value == "function"
    return true
  else return false
