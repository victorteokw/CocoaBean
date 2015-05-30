describe "CB.Color", ->

  beforeAll ->
    jasmine.addMatchers
      toBeWithinDelta: ->
        compare: (n, d) ->
          pass = (n <= n + d) && (n >= n - d)
          if pass
            pass: true,
            message: "Passed."
          else
            pass: false,
            message: "#{n} is not within #{n - d} and #{n + d}."

  describe "constructs", ->

    expectations = (color) ->
      expect(color.red).toBe 255
      expect(color.green).toBe 0
      expect(color.blue).toBeWithinDelta 122, 1
      expect(color.hslHue).toBe 331
      expect(color.hslSaturation).toBe 1
      expect(color.hslLightness).toBe 0.5
      expect(color.hsbHue).toBe 331
      expect(color.hsbSaturation).toBe 1
      expect(color.hsbBrightness).toBe 1

    it "with an object with key red, green and blue", ->
      color = new CB.Color(red: 255, green: 0, blue: 122)
      expectations(color)

    it "with an object with key red, green, blue and alpha", ->
      color = new CB.Color(red: 255, green: 0, blue: 122, alpha: 1.0)
      expectations(color)

    it "with an object with key hue, saturation and lightness", ->
      color = new CB.Color(hue: 331, saturation: 1.0, lightness: 0.5)
      expectations(color)

    it "with an object with key hue, saturation, lightness and alpha", ->
      color = new CB.Color hue: 331, saturation: 1.0, lightness: 0.5, alpha: 1.0
      expectations(color)

    it "with an object with key hue, saturation and brightness", ->
      color = new CB.Color(hue: 331, saturation: 1.0, brightness: 1.0)
      expectations(color)

    it "with an object with key hue, saturation, brightness and alpha", ->
      color = new CB.Color hue: 331,saturation: 1.0, brightness: 1.0, alpha: 1.0
      expectations(color)

    xit "with an object with key cyan, magenta, yellow and key", ->
      color = new CB.Color cyan: 0, magenta: 100, yellow: 52, key: 0
      expectations(color)

    it "with an object with key hex", ->
      color = new CB.Color(hex: "#FF007A")
      expectations(color)

    it "with an object with key hex and alpha", ->
      color = new CB.Color(hex: "#FF007A", alpha: 1.0)
      expectations(color)

  describe "converts:", ->

    beforeEach -> @color = new CB.Color(red: 255, green: 0, blue: 122)

    it "to css hex string", ->
      expect(@color.toCss('hex')).toBe "#FF007A"

    it "to css rgba string", ->
      expect(@color.toCss('rgba')).toBe "rgba(255, 0, 122, 1);"

    it "to css hsla string", ->
      expect(@color.toCss('hsla')).toBe "hsla(331, 100%, 50%, 1);"
