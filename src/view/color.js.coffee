class CB.Color

  copy: () ->
    return new CB.Color(@__obj)

  constructor: (obj) ->
    @__obj = obj
    @__type = this.__figureOutType(obj)

  __figureOutType: (obj) ->
    if obj['lightness'] != undefined
      return 'hsl'
    else if obj['brightness'] != undefined
      return 'hsb'
    else if obj['red'] != undefined
      return 'rgb'
    else if obj['cyan'] != undefined
      return 'cmyk'
    else if obj['hex'] != undefined
      this.__parseHex()
      return 'rgb'
    else
      throw new CB.ArgumentError "Wrong arguments passed to CB.Color \
       constructor."

  __parseHex: () ->
    hexString = @__obj['hex']
    newObj = {}
    newObj.alpha = @alpha
    mat = hexString.match(/([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})([0-9A-Fa-f]{2})/)
    r = mat[1]; g = mat[2]; b = mat[3]
    r = parseInt(r, 16); g = parseInt(g, 16); b = parseInt(b, 16)
    newObj['red'] = r
    newObj['green'] = g
    newObj['blue'] = b
    @__obj = newObj
    return

  @property "alpha",
    get: ->
      if @_alpha
        @_alpha
      else
        @__obj.alpha ? 1.0

  @property "readonly", "red",
    get: -> this.__rgb('red')

  @property "readonly", "green",
    get: -> this.__rgb('green')

  @property "readonly", "blue",
    get: -> this.__rgb('blue')

  @property "readonly", "hslHue",
    get: -> this.__hsl('hue')

  @property "readonly", "hslSaturation",
    get: -> this.__hsl('saturation')

  @property "readonly", "hslLightness",
    get: -> this.__hsl('lightness')

  @property "readonly", "hsbHue",
    get: -> this.__hsb('hue')

  @property "readonly", "hsbSaturation",
    get: -> this.__hsb('saturation')

  @property "readonly", "hsbBrightness",
    get: -> this.__hsb('brightness')

  @property "readonly", "cyan",
    get: -> this.__cmyk('cyan')

  @property "readonly", "magenta",
    get: -> this.__cmyk('magenta')

  @property "readonly", "yellow",
    get: -> this.__cmyk('yellow')

  @property "readonly", "key",
    get: -> this.__cmyk('key')

  __rgb: (component) ->
    if @__type == 'rgb'
      return @__obj[component]
    return this['__' + @__type + 'to' + 'rgb']()[component]

  __hsl: (component) ->
    if @__type == 'hsl'
      return @__obj[component]
    return this['__' + @__type + 'to' + 'hsl']()[component]

  __hsb: (component) ->
    if @__type == 'hsb'
      return @__obj[component]
    return this['__' + @__type + 'to' + 'hsb']()[component]

  __cmyk: (component) ->
    if @__type == 'cmyk'
      return @__obj[component]
    return this['__' + @__type + 'to' + 'cmyk']()[component]

  toCss: (format) ->
    switch format
      when 'hex'
        return this.__rgbtohex()
      when 'rgba'
        return this.__cssrgba()
      when 'hsla'
        return this.__csshsla()

  # Algorithm from https://gist.github.com/abachman/3716319
  __rgbtohsl: ->
    [r, g, b] = @__obj.valuesAt('red', 'green', 'blue').map (v) -> v /= 255.0

    max = Math.max(r, g, b)
    min = Math.min(r, g, b)

    l = (max + min) / 2

    if max == min
      h = s = 0
    else
      d = max - min
      s = if l > 0.5 then d / (2 - max - min) else d / (max + min)

      switch max
        when r
          h = (g - b) / d + (if g < b then 6 else 0)
        when g
          h = (b - r) / d + 2
        when b
          h = (r - g) / d + 4

      h /= 6

    hue: Math.floor(h * 360), saturation: s, lightness: l

  __hsltorgb: ->
    [h, s, l] = @__obj.valuesAt('hue', 'saturation', 'lightness')
    h /= 360

    if s == 0
      r = g = b = l
    else
      hue2rgb = (p, q, t) ->
        if t < 0 then t += 1
        if t > 1 then t -= 1
        if t < 1/6 then return p + (q - p) * 6 * t
        if t < 1/2 then return q
        if t < 2/3 then return p + (q - p) * (2/3 - t) * 6
        return p

      q = if l < 0.5 then l * (1 + s) else l + s - l * s
      p = 2 * l - q
      r = hue2rgb(p, q, h + 1/3)
      g = hue2rgb(p, q, h)
      b = hue2rgb(p, q, h - 1/3)

      r = Math.floor(r * 255)
      g = Math.floor(g * 255)
      b = Math.floor(b * 255)
    red: r, green: g, blue: b

  __hsltohsb: ->
    [h, s, l] = @__obj.valuesAt('hue', 'saturation', 'lightness')
    s *= 100
    l *= 100

    t = s * (if l < 50 then l else 100 - l) / 100
    H = h
    S = 200 * t / (l + t)
    V = t + l

    S = 0 if isNaN(S)

    S /= 100
    V /= 100

    hue: H, saturation: S, brightness: V

  __hsbtohsl: ->
    [h, s, v] = @__obj.valuesAt('hue', 'saturation', 'brightness')
    s *= 100
    v *= 100

    l = (2 - s / 100) * v / 2

    H = h
    S = s * v / (if l < 50 then l * 2 else 200 - l * 2)
    L = l

    S = 0 if isNaN(s)

    S /= 100
    L /= 100

    hue: H, saturation: S, lightness: L

  __rgbtohsb: ->
    [r, g, b] = @__obj.valuesAt('red', 'green', 'blue').map (i) -> i /= 255.0
    max = Math.max(r, g, b)
    min = Math.min(r, g, b)

    h = s = v = max
    d = max - min
    s = if max == 0 then 0 else d / max

    if max == min
      h = 0
    else
      switch max
        when r
          h = (g - b) / d + (if g < b then 6 else 0)
        when g
          h = (b - r) / d + 2
        when b
          h = (r - g) / d + 4

      h /= 6

    hue: Math.floor(h * 360), saturation: s, brightness: v

  __hsbtorgb: ->
    [h, s, v] = @__obj.valuesAt('hue', 'saturation', 'brightness')
    h = h / 360 * 6

    i = Math.floor(h)
    f = h - i
    p = v * (1 - s)
    q = v * (1 - f * s)
    t = v * (1 - (1 - f) * s)
    mod = i % 6
    r = [v, q, p, p, t, v][mod]
    g = [t, v, v, q, p, p][mod]
    b = [p, p, t, v, v, q][mod]

    r = Math.floor(r * 255)
    g = Math.floor(g * 255)
    b = Math.floor(b * 255)

    red: r, green: g, blue: b

  __rgbtocmyk: ->
  __cmyktorgb: ->

  __hsltocmyk: ->
  __cmyktohsl: ->

  __hsbtocmyk: ->
  __cmyktohsb: ->

  __rgbtohex: ->
    ret = '#'
    ret += this.__fixformat Math.floor(@red).toString(16)
    ret += this.__fixformat Math.floor(@green).toString(16)
    ret += this.__fixformat Math.floor(@blue).toString(16)
    ret

  __fixformat: (s) ->
    if s.length == 1
      s = '0' + s
    return s.toUpperCase()

  __cssrgba: ->
    "rgba(#{@red}, #{@green}, #{@blue}, #{@alpha})"

  __csshsla: ->
    "hsla(#{@hslHue}, #{@hslSaturation * 100}%, #{@hslLightness * 100}%, \
     #{@alpha})"
