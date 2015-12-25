describe "CB.Image", ->

  loadMetadataFixture = ->
    CB.ImageMetadata.load
      "logo.png":
        width: 50
        height: 50
        "@1x": true
        "@2x": true
        "@3x": true
      "arrow_right.png":
        width: 40
        height: 40
        "@2x": true
      "arrow_left.png":
        width: 40
        height: 40
        "@1x": true
      "arrow_top.png":
        width: 40
        height: 40
        "@3x": true
      "app_icon.png":
        width: 120
        height: 120
        "@2x": true
        "@1x": true
      "sea.jpg":
        width: 800
        height: 800
        "@1x": true
      "abstract.svg":
        width: 30
        height: 30
        "@1x": true
      "old_image.bmp":
        width: 1024
        height: 768
        "@1x": true

  beforeAll -> loadMetadataFixture()

  describe "constructs to be a", ->

    it "local image", ->
      image = new CB.Image("logo")
      expect(image.local).toBe true

    it "web image", ->
      image = new CB.Image("http://not.exist.com/image.png")
      expect(image.local).toBe false

  describe "local image:", ->

    beforeAll -> @image = new CB.Image("logo")

    it "it's name is part of its file name", ->
      expect(@image.name).toBe "logo"

    it "it's size is precalculated", ->
      expect(@image.size).toEqual new CB.Size(50, 50)

    it "it's scale is depending on the screen pixel ratio", ->
      expect(@image.scale).toBe window.devicePixelRatio

    it "it's path is under assets directory", ->
      expect(@image.path).toMatch /assets\//

  describe "web image:", ->

    beforeAll -> @image = new CB.Image('http://i.ly/a.svg')

    it "it's name is random but contains web image", ->
      expect(@image.name).toMatch /web image/

    it "it's size is unknown", ->
      expect(@image.size).toBeFalsy()

    it "it's scale is always 1", ->
      expect(@image.scale).toBe 1

    it "it's path is it's url", ->
      expect(@image.path).toBe 'http://i.ly/a.svg'
