class CB.Browser
  @sharedBrowser: () ->
    @__shared ||= new CB.Browser
    return @__shared

  @property "readonly", "name",
    get: () ->
      ua = window.navigator.userAgent
      if ua.match(/Android/)
        return "Android"
      else if ua.match(/Chrome/)
        return "Chrome"
      else if ua.match(/Safari/)
        return "Safari"
      else if ua.match(/Firefox/)
        return "Firefox"
      else if ua.match(/MSIE/)
        return "IE"
      else
        return "Unknown"

  @property "readonly", "version",
    get: () ->
      ua = window.navigator.userAgent
      if md = ua.match(/Chrome\/([0-9.]+)/)
        return md[1]
      else if ua.match(/Safari/)
        md = ua.match(/Version\/([0-9.]+)/)
        return md[1]
      else if md = ua.match(/Firefox\/([0-9.]+)/)
        return md[1]
      else if md = ua.match(/MSIE ([0-9.]+);/)
        return md[1]

  @property "readonly", "desktop",
    get: () ->
      return !@mobile

  @property "readonly", "mobile",
    get: () ->
      ua = window.navigator.userAgent.toLowerCase()
      if ua.indexOf("android") > -1
        return true
      else if ua.indexOf("iphone") > -1
        return true
      else if ua.indexOf("ipad") > -1
        return true
      else if ua.indexOf("ipod") > -1
        return true
      else if ua.indexOf("windows phone") > -1
        return true
      else return false
