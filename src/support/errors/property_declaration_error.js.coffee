class CB.PropertyDeclarationError extends Error
  constructor: (args...) ->
    super(args...)
    @name = CB.PropertyDeclarationError
    @message ||= "Property declaration is incorrect."
