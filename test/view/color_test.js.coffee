describe "CB.Color", ->
  describe "constructs", ->
    it "with hex string", ->
      color = new CB.Color("#123AEE")
      expect(color.r).toBe(0x12)
      expect(color.g).toBe(0x3A)
      expect(color.b).toBe(0xEE)
      expect(color.type).toBe('hex')
    it "with abbr string", ->
      color = new CB.Color("#19A")
      expect(color.r).toBe(0x11)
      expect(color.g).toBe(0x99)
      expect(color.b).toBe(0xAA)
      expect(color.type).toBe('abbr')
    it "with rgb string", ->
      color = new CB.Color("rgb(0, 122, 255);")
      expect(color.r).toBe(0)
      expect(color.g).toBe(122)
      expect(color.b).toBe(255)
      expect(color.type).toBe('rgb')
    it "with rgba string", ->
      color = new CB.Color("rgba(0, 122, 255, 0.8);")
      expect(color.r).toBe(0)
      expect(color.g).toBe(122)
      expect(color.b).toBe(255)
      expect(color.a).toBe(0.8)
      expect(color.type).toBe('rgba')
    it "with hsl string", ->
      color = new CB.Color("hsl(155, 50%, 60%);")
      expect(color.h).toBe(155)
      expect(color.s).toBe(0.5)
      expect(color.l).toBe(0.6)
      expect(color.type).toBe('hsl')
    it "with hsla string", ->
      color = new CB.Color("hsla(155, 50%, 60%, 0.2);")
      expect(color.h).toBe(155)
      expect(color.s).toBe(0.5)
      expect(color.l).toBe(0.6)
      expect(color.a).toBe(0.2)
      expect(color.type).toBe('hsla')
    it "with rgb object", ->
      color = new CB.Color(r:'20', g:3, b:5)
      expect(color.r).toBe(20)
      expect(color.g).toBe(3)
      expect(color.b).toBe(5)
      expect(color.type).toBe('rgb')
    it "with rgba object", ->
      color = new CB.Color(r:'20', g:3, b:5, a: 0.2)
      expect(color.r).toBe(20)
      expect(color.g).toBe(3)
      expect(color.b).toBe(5)
      expect(color.a).toBe(0.2)
      expect(color.type).toBe('rgba')
    it "with hsl object", ->
      color = new CB.Color(h: 155, s: "20%", l: 0.4)
      expect(color.h).toBe(155)
      expect(color.s).toBe(0.2)
      expect(color.l).toBe(0.4)
      expect(color.type).toBe('hsl')
    it "with hsla object", ->
      color = new CB.Color(h: 155, s: "20%", l: 0.4, a: '0.9')
      expect(color.h).toBe(155)
      expect(color.s).toBe(0.2)
      expect(color.l).toBe(0.4)
      expect(color.a).toBe(0.9)
      expect(color.type).toBe('hsla')
  describe "converts", ->
    it "default to its type", ->
      hex = new CB.Color("#800080")
      expect(hex.toString()).toBe("#800080")
      rgb = new CB.Color("rgb(128, 0, 128)")
      expect(rgb.toString()).toBe("rgb(128, 0, 128)")
      rgba = new CB.Color("rgba(128, 0, 128, 0.532)")
      expect(rgba.toString()).toBe("rgba(128, 0, 128, 0.532)")
      hsl = new CB.Color("hsl(300, 100%, 25%);")
      expect(hsl.toString()).toBe("hsl(300, 100%, 25%)")
      hsla = new CB.Color("hsla(300, 100%, 25%, 1)")
      expect(hsla.toString()).toBe("hsla(300, 100%, 25%, 1)")
    describe "from hex", ->
      it "to rgb", ->
        color = new CB.Color("#010203")
        expect(color.toRGBString()).toBe("rgb(1, 2, 3)")
      it "to hsl", ->
        color = new CB.Color("#FF0000")
        expect(color.toHSLString()).toBe("hsl(0, 100%, 50%)")
    describe "from rgb", ->
      it "to hex", ->
        color = new CB.Color("rgb(1,2,3)")
        expect(color.toHexString()).toBe("#010203")
      it "to hsl", ->
        color = new CB.Color("rgb(0, 122, 255);")
        expect(color.toHSLString()).toBe("hsl(211, 100%, 50%)")
    describe "from hsl", ->
      it "to hex", ->
        color = new CB.Color("hsl(211, 100%, 50%)")
        expect(color.toHexString()).toBe('#007BFF')
      it "to rgb", ->
        color = new CB.Color("hsl(211, 100%, 50%)")
        expect(color.toRGBString()).toBe("rgb(0, 123, 255)")
    describe "from rgba", ->
      describe "to hex", ->
        it "with force losing alpha", ->
          color = new CB.Color(r: 255, g: 255, b: 0, a: 0.4)
          expect(color.toHexString(true)).toBe("#FFFF00")
        it "and fallbacks to rgba", ->
          color = new CB.Color(red: 255, green: 255, blue: 0, alpha: 0.5)
          expect(color.toHexString()).toBe("rgba(255, 255, 0, 0.5)")
      it "to hsla", ->
        color = new CB.Color(r: 192, g: 192, b: 192, a: 0.75)
        expect(color.toHSLAString()).toBe("hsla(0, 0%, 75%, 0.75)")
    describe "from hsla", ->
      describe "to hex", ->
        it "with force losing alpha", ->
          color = new CB.Color(h: 180, s: '100%', l: '50%', a: 0.3)
          expect(color.toHexString(true)).toBe("#00FFFF")
        it "and fallbacks to rgba", ->
          color = new CB.Color(h: 180, s: '100%', l: '50%', a: '0.3')
          expect(color.toHexString()).toBe("hsla(180, 100%, 50%, 0.3)")
      it "to rgba", ->
        color = new CB.Color(h: 180, s: 1, l: 0.5, a: 0.2)
        expect(color.toRGBString()).toBe("rgba(0, 255, 255, 0.2)")
  describe "sets", ->
    describe "red", ->
      it "with a number", ->
        color = new CB.Color(r:0,g:0,b:0)
        color.red(color.red() + 255)
        expect(color.toHexString()).toBe('#FF0000')
      it "with a string", ->
        color = new CB.Color(r:0,g:0xCE,b:0xAB)
        color.red("254")
        expect(color.toHexString()).toBe('#FECEAB')
    describe "green", ->
      it "with a number", ->
        color = new CB.Color('#AAA')
        color.green(0xBB)
        expect(color.toHexString()).toBe('#AABBAA')
      it "with a string", ->
        color = new CB.Color('#AAA')
        color.green('0xBB')
        expect(color.toHexString()).toBe('#AABBAA')
    describe "blue", ->
      it "with a number", ->
        color = new CB.Color('hsla(0, 100%, 50%, 0.5);')
        color.blue(255)
        expect(color.toHSLString(true)).toBe('hsla(300, 100%, 50%, 0.5)')
      it "with a string", ->
        color = new CB.Color('hsla(240, 100%, 50%, 0.1)')
        color.blue('0')
        expect(color.toHexString(true)).toBe('#000000')
    describe "hue", ->
      it "with a number", ->
        color = new CB.Color('rgb(255,0,0)')
        color.hue(120)
        expect(color.toHexString()).toBe('#00FF00')
      it "with a string", ->
        color = new CB.Color('rgba(255, 0, 0, 0.8)')
        color.hue('120')
        expect(color.toHexString()).toBe('rgba(0, 255, 0, 0.8)')
    describe "saturation", ->
      it "with a number", ->
        color = new CB.Color('hsl(240, 100%, 50%)')
        color.saturation(0.4)
        expect(color.toHSLString()).toBe('hsl(240, 40%, 50%)')
      it "with an integer string", ->
        color = new CB.Color('hsl(240, 100%, 50%)')
        color.saturation('40')
        expect(color.toHSLString()).toBe('hsl(240, 40%, 50%)')
      it "with a float string", ->
        color = new CB.Color('hsl(240, 100%, 50%)')
        color.saturation('0.4')
        expect(color.toHSLString()).toBe('hsl(240, 40%, 50%)')
      it "with a percentage string", ->
        color = new CB.Color('hsl(240, 100%, 50%)')
        color.saturation('40%')
        expect(color.toHSLString()).toBe('hsl(240, 40%, 50%)')
    describe "lightness", ->
      it "with a number", ->
        color = new CB.Color('hsl(100,20%,30%)')
        color.lightness(0.9)
        expect(color.toHSLString()).toBe("hsl(100, 20%, 90%)")
      it "with an integer string", ->
        color = new CB.Color('hsl(100,20%,30%)')
        color.lightness('90')
        expect(color.toHSLString()).toBe("hsl(100, 20%, 90%)")
      it "with a float string", ->
        color = new CB.Color('hsl(100,20%,30%)')
        color.lightness('0.9')
        expect(color.toHSLString()).toBe("hsl(100, 20%, 90%)")
      it "with a percentage string", ->
        color = new CB.Color('hsl(100,20%,30%)')
        color.lightness('90%')
        expect(color.toHSLString()).toBe("hsl(100, 20%, 90%)")
    describe "alpha", ->
      it "with a number", ->
        color = new CB.Color(r:1,g:2,b:3,a:0.5)
        color.alpha(+0.4)
        expect(color.toRGBString()).toBe('rgba(1, 2, 3, 0.4)')
      it "with a string", ->
        color = new CB.Color(r:1,g:2,b:3,a:0.5)
        color.alpha('+0.4')
        expect(color.toRGBString()).toBe('rgba(1, 2, 3, 0.4)')
  describe "gets", ->
    color = {}
    beforeEach(-> color = new CB.Color("#FF0000"))
    describe "string value", ->
      it "of red", ->
        expect(color.red("string")).toBe('255')
      it "of green", ->
        expect(color.green("string")).toBe('0')
      it "of blue", ->
        expect(color.blue("string")).toBe('0')
      it "of hue", ->
        expect(color.hue("string")).toBe('0')
      it "of saturation", ->
        expect(color.saturation("string")).toBe('100%')
      it "of lightness", ->
        expect(color.lightness("string")).toBe('50%')
      it "of alpha", ->
        expect(color.alpha("string")).toBe('1')
    describe "number value", ->
      it "of red", ->
        expect(color.red("number")).toBe(255)
        expect(color.red()).toBe(255)
      it "of green", ->
        expect(color.green("number")).toBe(0)
        expect(color.green()).toBe(0)
      it "of blue", ->
        expect(color.blue("number")).toBe(0)
        expect(color.blue()).toBe(0)
      it "of hue", ->
        expect(color.hue()).toBe(0)
        expect(color.hue("number")).toBe(0)
      it "of saturation", ->
        expect(color.saturation()).toBe(1)
        expect(color.saturation("number")).toBe(1)
      it "of lightness", ->
        expect(color.lightness()).toBe(0.5)
        expect(color.lightness("number")).toBe(0.5)
      it "of alpha", ->
        expect(color.alpha()).toBe(1)
        expect(color.alpha("number")).toBe(1)
