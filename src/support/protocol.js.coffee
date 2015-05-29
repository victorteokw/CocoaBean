# Declare a protocol like this:
# @example
#   protocol "Copyable", "copy"
#
# Provide a protocol like this:
#
# @example
#   class MyClass extends MySuperClass
#
#     copy: () ->
#       return this
#
#     @provided Copyable
#

root = exports ? this

# @nodoc
# name: protocol name
# methods: array of methods
# sps: super protocols
#
root.protocol = (name) ->
  if root[name]
    throw new CB.ProtocolRedefinedError("Protocol #{name} is defined.")
  root[name] = new Protocol(arguments...)

Function.property "readonly", "copy", "implementedProtocols",
  get: ->
    @_implementedProtocols ||= []
    return @_implementedProtocols.copy()

Function::provides = (protocol) ->
  @_implementedProtocols ||= []
  @implementedProtocols.indexOf(protocol) > -1

Function::provided = ->
  args = Array.prototype.slice.call(arguments)
  for protocol in args
    protocol.examineClass(this)
  return

class Protocol

  constructor: () ->
    args = Array.prototype.slice.call(arguments)
    unless args.length >= 2
      this.throwArgumentError "You should declare protocol with at least \
        2 arguments"
    @_name = args.shift()
    @_methods = []
    @_parents = []
    for arg in args
      if typeof arg == 'string'
        @_methods.push arg
      else if typeof arg == 'object' && arg.class == Protocol
        @_parents.push arg
      else
        this.throwArgumentError()

  throwArgumentError: (message) ->
    throw new CB.ArgumentError(message ||
      "Please check the declaration of protocol: #{@name}")

  @property "readonly", "name"

  @property "readonly", "copy", "methods"

  @property "readonly", "copy", "parents"

  examineClass: (krass) ->
    for method in @_methods
      imp = krass.prototype[method]
      unless imp && typeof imp == 'function'
        throw new CB.ProtocolNotCompletelyImplementedError("Method #{method}\
         of protocol: #{protocol.name} is unimplemented.")
    krass._implementedProtocols ||= []
    krass._implementedProtocols.push(this)
    for parent in @_parents
      parent.examineClass(krass)

root.Protocol = Protocol
