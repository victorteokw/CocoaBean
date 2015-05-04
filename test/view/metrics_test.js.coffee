describe "CB.Metrics", ->
  describe "@add", ->
    it "should work for %", ->
      a = '20%'; b = '2%'
      expect(CB.Metrics.add(a, b)).toEqual('22%')
    it "should work for px", ->
      a = '35.2px'; b = '45px'
      expect(CB.Metrics.add(a, b)).toEqual('80.2px')
    it "should work for number", ->
      a = 20; b = 40
      expect(CB.Metrics.add(a, b)).toEqual('60px')
    it "should work for number and px", ->
      a = 35.2; b = '45px'
      expect(CB.Metrics.add(a, b)).toEqual('80.2px')
    it "should raise error if % + px", ->
      expect(-> CB.Metrics.add('1%', '2px')).toThrow()
    it "should raise error if bad input", ->
      expect(-> CB.Metrics.add('2', 'z')).toThrow()
  describe "@multiply", ->
    it "should work for % px", ->
      a = '10%'; b = '50px'
      expect(CB.Metrics.multiply(a, b)).toEqual('5px')
    it "should work for px %", ->
      a = '73px'; b = '50%'
      expect(CB.Metrics.multiply(a, b)).toEqual('36.5px')
