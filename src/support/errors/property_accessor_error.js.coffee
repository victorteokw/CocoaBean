class CB.PropertyAccessorError extends Error

  constructor: (args...) ->
    super(args...)
    @name = "CB.PropertyAccessorError"
    @message ||= "Property cannot be accessed."
