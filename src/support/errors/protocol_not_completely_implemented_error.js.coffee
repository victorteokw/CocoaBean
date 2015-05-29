class CB.ProtocolNotCompletelyImplementedError extends Error

  constructor: (args...) ->
    super(args...)
    @name = "ProtocolNotCompletelyImplementedError"
    @message ||= "Protocol is not completely implemented."
