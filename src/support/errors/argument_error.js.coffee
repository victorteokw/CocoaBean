class CB.ArgumentError extends Error

  constructor: (args...) ->
    super(args...)
    @name = "CB.ArgumentError"
    @message ||= "Unexpected arguments."
