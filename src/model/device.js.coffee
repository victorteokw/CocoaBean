class CB.Device
  @currentDevice: () ->
    @__current ||= new CB.Device
    return @__current

  @property "readonly", "type"

  @property "readonly", "name"

  @property "readonly", "os"

  @property "readonly", "osVersion"
