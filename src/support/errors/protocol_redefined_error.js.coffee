class CB.ProtocolRedefinedError extends Error

  constructor: (args...) ->
    super(args...)
    @name = "CB.ProtocolRedefinedError"
    @message ||= "Protocol shouldn't be redefined."
