describe "CB.Browser", ->
  `
  function setUserAgent(window, userAgent) {
    if (window.navigator.userAgent != userAgent) {
        var userAgentProp = { get: function () { return userAgent; } };
        try {
            Object.defineProperty(window.navigator, 'userAgent', userAgentProp);
        } catch (e) {
            window.navigator = Object.create(navigator, {
                userAgent: userAgentProp
            });
        }
    }
}
  `
  setSafariUserAgent = ->
    setUserAgent(window, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/600.5.17 (KHTML, like Gecko) Version/8.0.5 Safari/600.5.17")
  setChromeUserAgent = ->
    setUserAgent(window, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_10_4) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/42.0.2311.135 Safari/537.36")
  setFirefoxUserAgent = ->
    setUserAgent(window, "Mozilla/5.0 (Macintosh; Intel Mac OS X 10.10; rv:33.0) Gecko/20100101 Firefox/33.0")
  setIEUserAgent = ->
    setUserAgent(window, "Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; Win64; x64; Trident/5.0; .NET CLR 2.0.50727; SLCC2; .NET CLR 3.5.30729; .NET CLR 3.0.30729; Media Center PC 6.0; .NET4.0C; Tablet PC 2.0)")
  setMobileSafariUserAgent = ->
    setUserAgent(window, "Mozilla/5.0 (iPhone; CPU iPhone OS 8_1 like Mac OS X) AppleWebKit/600.1.4 (KHTML, like Gecko) Version/8.0 Mobile/12B410 Safari/600.1.4")
  setMobileChromeUserAgent = ->
    setUserAgent(window, "Mozilla/5.0 (Linux; Android 4.0.4; Galaxy Nexus Build/IMM76B) AppleWebKit/535.19 (KHTML, like Gecko) Chrome/18.0.1025.133 Mobile Safari/535.19")
  setMobileFirefoxUserAgent = ->
    setUserAgent(window, "Mozilla/5.0 (Android; Mobile; rv:30.0) Gecko/30.0 Firefox/30.0")
  setMobileIEUserAgent = ->
    setUserAgent(window, "Mozilla/4.0(compatible; MSIE 6.0; Windows NT 5.1;
Motorola_ES405B_19103; Windows Phone 6.5.3.5)")
  it "is shared", ->
    expect(CB.Browser.sharedBrowser()).toBe(CB.Browser.sharedBrowser())
    expect(CB.Browser.sharedBrowser() instanceof CB.Browser).toBe(true)
  describe "knows browser name", ->
    it "on Safari", ->
      setSafariUserAgent()
      expect(CB.Browser.sharedBrowser().name).toEqual("Safari")
    it "on Chrome", ->
      setChromeUserAgent()
      expect(CB.Browser.sharedBrowser().name).toEqual("Chrome")
    it "on Firefox", ->
      setFirefoxUserAgent()
      expect(CB.Browser.sharedBrowser().name).toEqual("Firefox")
    it "on IE", ->
      setIEUserAgent()
      expect(CB.Browser.sharedBrowser().name).toEqual("IE")
  describe "knows browser version", ->
    it "on Safari", ->
      setSafariUserAgent()
      expect(CB.Browser.sharedBrowser().version).toEqual("8.0.5")
    it "on Chrome", ->
      setChromeUserAgent()
      expect(CB.Browser.sharedBrowser().version).toEqual("42.0.2311.135")
    it "on Firefox", ->
      setFirefoxUserAgent()
      expect(CB.Browser.sharedBrowser().version).toEqual("33.0")
    it "on IE", ->
      setIEUserAgent()
      expect(CB.Browser.sharedBrowser().version).toEqual("9.0")
  describe "knows desktop or mobile", ->
    it "on mobile Safari", ->
      setMobileSafariUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(false)
      expect(CB.Browser.sharedBrowser().mobile).toBe(true)
    it "on mobile Chrome", ->
      setMobileChromeUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(false)
      expect(CB.Browser.sharedBrowser().mobile).toBe(true)
    it "on mobile Firefox", ->
      setMobileFirefoxUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(false)
      expect(CB.Browser.sharedBrowser().mobile).toBe(true)
    it "on mobile IE", ->
      setMobileIEUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(false)
      expect(CB.Browser.sharedBrowser().mobile).toBe(true)
    it "on desktop Safari", ->
      setSafariUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(true)
      expect(CB.Browser.sharedBrowser().mobile).toBe(false)
    it "on desktop Chrome", ->
      setChromeUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(true)
      expect(CB.Browser.sharedBrowser().mobile).toBe(false)
    it "on desktop Firefox", ->
      setFirefoxUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(true)
      expect(CB.Browser.sharedBrowser().mobile).toBe(false)
    it "on desktop IE", ->
      setIEUserAgent()
      expect(CB.Browser.sharedBrowser().desktop).toBe(true)
      expect(CB.Browser.sharedBrowser().mobile).toBe(false)
