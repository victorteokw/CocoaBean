class CB.Color
  @colorWithRGBA: (r, g, b, a) ->
    new CB.Color(r: r, g: g, b: b, a: a)
  @colorWithHSLA: (h, s, l, a) ->
    new CB.Color(h: h, s: s, l: l, a: a)
  @colorWithRGB: (r, g, b) ->
    @colorWithRGBA(r, g, b)
  @colorWithHSL: (h, s, l) ->
    @colorWithHSLA(h, s, l)
  @__rAbbr = /^#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])$/ # like #18F
  @__rHex = /^#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})$/ # like #6699BB
  @__rS = '(?:\\+|-)?' # optional sign
  @__rI = @__rS + '\\d+' # integer
  @__rF = @__rS + '\\d*\\.\\d+' # float
  @__rN = '(?:' + @__rI + ')|(?:' + @__rF + ')' # whatever number
  @__rIC = '(' + @__rI + ')' # integer captured
  @__rFC = '(' + @__rF + ')' # float captured
  @__rNC = '(' + @__rN + ')'
  @__rP = @__rN + '%' # percentage
  @__rPC = @__rNC + '%' # percentage with captured number
  @__rW = '\\s*?' # whitespace
  @__rICS = @__rW + @__rIC + @__rW
  @__rFCS = @__rW + @__rFC + @__rW
  @__rNCS = @__rW + @__rNC + @__rW
  @__rPCS = @__rW + @__rPC + @__rW
  @__rRGBA = new RegExp('^rgba?\\(' + @__rNCS + ',' + @__rNCS + ',' + @__rNCS + ',?(?:' + @__rNCS + ')?\\);*$')
  @__rHSLA = new RegExp('^hsla?\\(' + @__rNCS + ',' + @__rPCS + ',' + @__rPCS + ',?(?:' + @__rNCS + ')?\\);*$')

  constructor: (obj) ->
    if obj instanceof CB.Color then return obj
    if typeof obj == 'string'
      this.__setStringValue(obj)
    else if typeof obj == 'object'
      this.__setObjectValue(obj)

  __setStringValue: (obj) ->
    if matchData = obj.match(CB.Color.__rAbbr)
      @r = matchData[1]; @g = matchData[2]; @b = matchData[3]; @type = 'abbr'
    else if matchData = obj.match(CB.Color.__rHex)
      @r = matchData[1]; @g = matchData[2]; @b = matchData[3]; @type = 'hex'
    else if matchData = obj.match(CB.Color.__rRGBA)
      @r = matchData[1]; @g = matchData[2]; @b = matchData[3]; @type = 'rgb'
      @type += "a" if @a = matchData[4]
    else if matchData = obj.match(CB.Color.__rHSLA)
      @h = matchData[1]; @s = matchData[2]; @l = matchData[3]; @type = 'hsl'
      @type += "a" if @a = matchData[4]
    else throw "Color string is not approriate."
    this.__normalizeValues()

  __setObjectValue: (obj) ->
    if obj.hasOwnProperty('r') && obj.hasOwnProperty('g') && obj.hasOwnProperty('b')
      @r = obj['r']; @g = obj['g']; @b = obj['b']; @type = 'rgb'
      if obj.hasOwnProperty('a')
        @type += "a"; @a = obj['a']
    else if obj.hasOwnProperty('red') && obj.hasOwnProperty('green') && obj.hasOwnProperty('blue')
      @r = obj['red']; @g = obj['green']; @b = obj['blue']; @type = 'rgb'
      if obj.hasOwnProperty('alpha')
        @type += "a"; @a = obj['alpha']
    else if obj.hasOwnProperty('h') && obj.hasOwnProperty('s') && obj.hasOwnProperty('l')
      @h = obj['h']; @s = obj['s']; @l = obj['l']; @type = 'hsl'
      if obj.hasOwnProperty('a')
        @type += "a"; @a = obj['a']
    else if obj.hasOwnProperty('hue') && obj.hasOwnProperty('saturation') && obj.hasOwnProperty('lightness')
      @h = obj['hue']; @s = obj['saturation']; @l = obj['lightness']; @type = 'hsl'
      if obj.hasOwnProperty('alpha')
        @type += "a"; @a = obj['alpha']
    else throw "Color object is not approriate."
    this.__normalizeValues()

  __normalizeValues: () ->
    if (@type == 'hex') || (@type == 'abbr')
      @r = this.__convert(@r, @type, "number")
      @g = this.__convert(@g, @type, "number")
      @b = this.__convert(@b, @type, "number")
    else
      @r = this.__convert(@r, "rgb", "number") if @r
      @g = this.__convert(@g, "rgb", "number") if @g
      @b = this.__convert(@b, "rgb", "number") if @b
      @a = this.__convert(@a, "rgb", "number") if @a
      @h = this.__convert(@h, "rgb", "number") if @h
      @s = this.__convert(@s, "hsl", "number") if @s
      @l = this.__convert(@l, "hsl", "number") if @l

  __convertHash:
    hex:
      number: (value) ->
        parseInt(value, 16)
    abbr:
      number: (value) ->
        parseInt(value + value, 16)
    rgb:
      number: (value) ->
        return value if typeof value is 'number'
        parseFloat(value)
    hsl:
      number: (value) ->
        return value if typeof value is 'number'
        parseFloat(value) / 100.0
    number:
      hex: (value) ->
        retVal = value.toString(16).toUpperCase()
        return "0" + retVal if retVal.length < 2
        return retVal
      abbr: (value) ->
        return "0" # TODO: ROUND
      rgb: (value) ->
        value + ''
      hsl: (value) ->
        (value * 100.0) + '%'

  __convert: (value, from_type, to_type) ->
    this.__convertHash[from_type][to_type](value)

  # Algorithm from https://github.com/harthur/color-convert/blob/master/conversions.js#L198
  `Color.prototype.__calculateRGB = function(){
    var h, s, l, t1, t2, t3, rgb;
    h = this.h / 360.0;
    s = this.s;
    l = this.l;
    if (s == 0) {
      val = l * 255;
      this.r = this.g = this.b = val;
      return;
    }
    if (l < 0.5) {
      t2 = l * (1 + s);
    } else {
      t2 = l + s - l * s;
    }
    t1 = 2 * l - t2;
    rgb = [0, 0, 0];
    for (var i = 0; i < 3; i++) {
      t3 = h + 1 / 3 * - (i - 1);
      t3 < 0 && t3++;
      t3 > 1 && t3--;

      if (6 * t3 < 1)
        val = t1 + (t2 - t1) * 6 * t3;
      else if (2 * t3 < 1)
        val = t2;
      else if (3 * t3 < 2)
        val = t1 + (t2 - t1) * (2 / 3 - t3) * 6;
      else
        val = t1;

      rgb[i] = val * 255;
    }
    this.r = Math.round(rgb[0]);
    this.g = Math.round(rgb[1]);
    this.b = Math.round(rgb[2]);
  }`

  # Algorithm from https://github.com/harthur/color-convert/blob/master/conversions.js#L59
  __calculateHSL: () ->
    [r, g, b] = [@r / 255.0, @g / 255.0, @b / 255.0]
    min = Math.min(r, g, b)
    max = Math.max(r, g, b)
    delta = max - min
    if max == min
      h = 0
    else if r == max
      h = (g - b) / delta
    else if g == max
      h = 2 + (b - r) / delta
    else if b == max
      h = 4 + (r - g)/ delta
    h = Math.min(h * 60, 360)
    h += 360 if h < 0
    l = (min + max) / 2
    if max == min
      s = 0
    else if l <= 0.5
      s = delta / (max + min)
    else
      s = delta / (2 - max - min)
    @h = Math.round(h)
    @s = Math.round(s * 100.0) / 100.0
    @l = Math.round(l * 100.0) / 100.0

  __calculateAlpha: () ->
    if !this.hasOwnProperty('a')
      @a = 1

  red: (presentationOrValue = null) ->
    @__calculateRGB() if !this.hasOwnProperty('r')
    if !presentationOrValue
      return @r
    if presentationOrValue == "string"
      return @r + ""
    if presentationOrValue == "number"
      return @r
    @r = parseInt(presentationOrValue)
    @__calculateHSL() if this.hasOwnProperty('h')
  green: (presentationOrValue = null) ->
    @__calculateRGB() if !this.hasOwnProperty('g')
    if !presentationOrValue
      return @g
    if presentationOrValue == "string"
      return @g + ""
    if presentationOrValue == "number"
      return @g
    @g = parseInt(presentationOrValue)
    @__calculateHSL() if this.hasOwnProperty('h')
  blue: (presentationOrValue = null) ->
    @__calculateRGB() if !this.hasOwnProperty('b')
    if !presentationOrValue
      return @b
    if presentationOrValue == "string"
      return @b + ""
    if presentationOrValue == "number"
      return @b
    @b = parseInt(presentationOrValue)
    @__calculateHSL() if this.hasOwnProperty('h')
  hue: (presentationOrValue = null) ->
    @__calculateHSL() if !this.hasOwnProperty('h')
    if !presentationOrValue
      return @h
    if presentationOrValue == "string"
      return @h + ""
    if presentationOrValue == "number"
      return @h
    @h = parseInt(presentationOrValue)
    @__calculateRGB() if this.hasOwnProperty('r')
  saturation: (presentationOrValue = null) ->
    @__calculateHSL() if !this.hasOwnProperty('s')
    if !presentationOrValue
      return @s
    if presentationOrValue == "number"
      return @s
    if presentationOrValue == "string"
      return @s * 100 + '%'
    if typeof presentationOrValue == 'number'
      @s = presentationOrValue
      @__calculateRGB() if this.hasOwnProperty('r')
      return
    if presentationOrValue.match(CB.Color.__rF)
      @s = parseFloat(presentationOrValue)
      @__calculateRGB() if this.hasOwnProperty('r')
      return
    if presentationOrValue.match(CB.Color.__rI)
      @s = parseInt(presentationOrValue) / 100.0
      @__calculateRGB() if this.hasOwnProperty('r')
      return
    if presentationOrValue.match(CB.Color.__rP)
      @s = parseInt(presentationOrValue) / 100.0
      @__calculateRGB() if this.hasOwnProperty('r')
      return
  lightness: (presentationOrValue = null) ->
    @__calculateHSL() if !this.hasOwnProperty('l')
    if !presentationOrValue
      return @l
    if presentationOrValue == "number"
      return @l
    if presentationOrValue == "string"
      return @l * 100 + '%'
    if typeof presentationOrValue == 'number'
      @l = presentationOrValue
      @__calculateRGB() if this.hasOwnProperty('r')
      return
    if presentationOrValue.match(CB.Color.__rF)
      @l = parseFloat(presentationOrValue)
      @__calculateRGB() if this.hasOwnProperty('r')
      return
    if presentationOrValue.match(CB.Color.__rI)
      @l = parseInt(presentationOrValue) / 100.0
      @__calculateRGB() if this.hasOwnProperty('r')
      return
    if presentationOrValue.match(CB.Color.__rP)
      @l = parseInt(presentationOrValue) / 100.0
      @__calculateRGB() if this.hasOwnProperty('r')
      return
  alpha: (presentationOrValue = null) ->
    @__calculateAlpha() if !this.hasOwnProperty('a')
    if !presentationOrValue
      return @a
    if presentationOrValue == "string"
      return @a + ''
    if presentationOrValue == "number"
      return @a
    @a = parseFloat(presentationOrValue)

  # TODO: Add more manipulation methods

  toString: () ->
    switch @type
      when "hex"
        this.toHexString()
      when "abbr"
        this.toHexString()
      when "hsl"
        this.toHSLString()
      when "hsla"
        this.toHSLAString()
      when "rgb"
        this.toRGBString()
      when "rgba"
        this.toRGBAString()

  toHSLAString: (useHSLIfPossible = false) ->
    this.__calculateHSL() if !this.hasOwnProperty('h')
    if useHSLIfPossible && (!@a || @a >= 1.0) # BUG
      return "hsl(" + @__convert(@h, "number", "rgb") + ", " + @__convert(@s, "number", "hsl") + ", " + @__convert(@l, "number", "hsl") + ")"
    if @a # BUG
      a = @a
    else
      a = 1
    return "hsla(" + @__convert(@h, "number", "rgb") + ", " + @__convert(@s, "number", "hsl") + ", " + @__convert(@l, "number", "hsl") + ", " + a + ")"

  toRGBAString: (useRGBIfPossible = false) ->
    this.__calculateRGB() if !this.hasOwnProperty('r')
    if useRGBIfPossible && (!@a || @a >= 1.0) # BUG
      return "rgb(" + @__convert(@r, "number", "rgb") + ", " + @__convert(@g, "number", "rgb") + ", " + @__convert(@b, "number", "rgb") + ")"
    if @a
      a = @a
    else
      a = 1
    return "rgba(" + @__convert(@r, "number", "rgb") + ", " + @__convert(@g, "number", "rgb") + ", " + @__convert(@b, "number", "rgb") + ", " + a + ")"

  toHSLString: () ->
    this.toHSLAString(true)

  toRGBString: () ->
    this.toRGBAString(true)

  toHexString: (neverFallBackIfHasAlpha = false) ->
    if (!neverFallBackIfHasAlpha) && @a && (@a < 1.0) # BUG
      if this.hasOwnProperty('r')
        return this.toRGBAString()
      else if this.hasOwnProperty('h')
        return this.toHSLAString()
    this.__calculateRGB() if !@r
    "#" + @__convert(@r, "number", "hex") + @__convert(@g, "number", "hex") + @__convert(@b, "number", "hex")
