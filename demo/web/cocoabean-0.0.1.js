(function() {
  var root;

  root = typeof exports !== "undefined" && exports !== null ? exports : this;

  if (!root.CB) {
    root.CB = {};
  }

}).call(this);
(function() {
  Function.prototype.property = function(prop, desc) {
    if (!desc) {
      desc = {};
    }
    if (!desc.set) {
      desc.set = function(newValue) {
        return this["_" + prop] = newValue;
      };
    }
    if (!desc.get) {
      desc.get = function() {
        return this["_" + prop];
      };
    }
    return Object.defineProperty(this.prototype, prop, desc);
  };

}).call(this);
(function() {
  CB.Color = (function() {
    Color.colorWithRGBA = function(r, g, b, a) {
      return new CB.Color({
        r: r,
        g: g,
        b: b,
        a: a
      });
    };

    Color.colorWithHSLA = function(h, s, l, a) {
      return new CB.Color({
        h: h,
        s: s,
        l: l,
        a: a
      });
    };

    Color.colorWithRGB = function(r, g, b) {
      return this.colorWithRGBA(r, g, b);
    };

    Color.colorWithHSL = function(h, s, l) {
      return this.colorWithHSLA(h, s, l);
    };

    Color.__rAbbr = /^#([a-fA-F0-9])([a-fA-F0-9])([a-fA-F0-9])$/;

    Color.__rHex = /^#([a-fA-F0-9]{2})([a-fA-F0-9]{2})([a-fA-F0-9]{2})$/;

    Color.__rS = '(?:\\+|-)?';

    Color.__rI = Color.__rS + '\\d+';

    Color.__rF = Color.__rS + '\\d*\\.\\d+';

    Color.__rN = '(?:' + Color.__rI + ')|(?:' + Color.__rF + ')';

    Color.__rIC = '(' + Color.__rI + ')';

    Color.__rFC = '(' + Color.__rF + ')';

    Color.__rNC = '(' + Color.__rN + ')';

    Color.__rP = Color.__rN + '%';

    Color.__rPC = Color.__rNC + '%';

    Color.__rW = '\\s*?';

    Color.__rICS = Color.__rW + Color.__rIC + Color.__rW;

    Color.__rFCS = Color.__rW + Color.__rFC + Color.__rW;

    Color.__rNCS = Color.__rW + Color.__rNC + Color.__rW;

    Color.__rPCS = Color.__rW + Color.__rPC + Color.__rW;

    Color.__rRGBA = new RegExp('^rgba?\\(' + Color.__rNCS + ',' + Color.__rNCS + ',' + Color.__rNCS + ',?(?:' + Color.__rNCS + ')?\\);*$');

    Color.__rHSLA = new RegExp('^hsla?\\(' + Color.__rNCS + ',' + Color.__rPCS + ',' + Color.__rPCS + ',?(?:' + Color.__rNCS + ')?\\);*$');

    function Color(obj) {
      if (obj instanceof CB.Color) {
        return obj;
      }
      if (typeof obj === 'string') {
        this.__setStringValue(obj);
      } else if (typeof obj === 'object') {
        this.__setObjectValue(obj);
      }
    }

    Color.prototype.__setStringValue = function(obj) {
      var matchData;
      if (matchData = obj.match(CB.Color.__rAbbr)) {
        this.r = matchData[1];
        this.g = matchData[2];
        this.b = matchData[3];
        this.type = 'abbr';
      } else if (matchData = obj.match(CB.Color.__rHex)) {
        this.r = matchData[1];
        this.g = matchData[2];
        this.b = matchData[3];
        this.type = 'hex';
      } else if (matchData = obj.match(CB.Color.__rRGBA)) {
        this.r = matchData[1];
        this.g = matchData[2];
        this.b = matchData[3];
        this.type = 'rgb';
        if (this.a = matchData[4]) {
          this.type += "a";
        }
      } else if (matchData = obj.match(CB.Color.__rHSLA)) {
        this.h = matchData[1];
        this.s = matchData[2];
        this.l = matchData[3];
        this.type = 'hsl';
        if (this.a = matchData[4]) {
          this.type += "a";
        }
      } else {
        throw "Color string is not approriate.";
      }
      return this.__normalizeValues();
    };

    Color.prototype.__setObjectValue = function(obj) {
      if (obj.hasOwnProperty('r') && obj.hasOwnProperty('g') && obj.hasOwnProperty('b')) {
        this.r = obj['r'];
        this.g = obj['g'];
        this.b = obj['b'];
        this.type = 'rgb';
        if (obj.hasOwnProperty('a')) {
          this.type += "a";
          this.a = obj['a'];
        }
      } else if (obj.hasOwnProperty('red') && obj.hasOwnProperty('green') && obj.hasOwnProperty('blue')) {
        this.r = obj['red'];
        this.g = obj['green'];
        this.b = obj['blue'];
        this.type = 'rgb';
        if (obj.hasOwnProperty('alpha')) {
          this.type += "a";
          this.a = obj['alpha'];
        }
      } else if (obj.hasOwnProperty('h') && obj.hasOwnProperty('s') && obj.hasOwnProperty('l')) {
        this.h = obj['h'];
        this.s = obj['s'];
        this.l = obj['l'];
        this.type = 'hsl';
        if (obj.hasOwnProperty('a')) {
          this.type += "a";
          this.a = obj['a'];
        }
      } else if (obj.hasOwnProperty('hue') && obj.hasOwnProperty('saturation') && obj.hasOwnProperty('lightness')) {
        this.h = obj['hue'];
        this.s = obj['saturation'];
        this.l = obj['lightness'];
        this.type = 'hsl';
        if (obj.hasOwnProperty('alpha')) {
          this.type += "a";
          this.a = obj['alpha'];
        }
      } else {
        throw "Color object is not approriate.";
      }
      return this.__normalizeValues();
    };

    Color.prototype.__normalizeValues = function() {
      if ((this.type === 'hex') || (this.type === 'abbr')) {
        this.r = this.__convert(this.r, this.type, "number");
        this.g = this.__convert(this.g, this.type, "number");
        return this.b = this.__convert(this.b, this.type, "number");
      } else {
        if (this.r) {
          this.r = this.__convert(this.r, "rgb", "number");
        }
        if (this.g) {
          this.g = this.__convert(this.g, "rgb", "number");
        }
        if (this.b) {
          this.b = this.__convert(this.b, "rgb", "number");
        }
        if (this.a) {
          this.a = this.__convert(this.a, "rgb", "number");
        }
        if (this.h) {
          this.h = this.__convert(this.h, "rgb", "number");
        }
        if (this.s) {
          this.s = this.__convert(this.s, "hsl", "number");
        }
        if (this.l) {
          return this.l = this.__convert(this.l, "hsl", "number");
        }
      }
    };

    Color.prototype.__convertHash = {
      hex: {
        number: function(value) {
          return parseInt(value, 16);
        }
      },
      abbr: {
        number: function(value) {
          return parseInt(value + value, 16);
        }
      },
      rgb: {
        number: function(value) {
          if (typeof value === 'number') {
            return value;
          }
          return parseFloat(value);
        }
      },
      hsl: {
        number: function(value) {
          if (typeof value === 'number') {
            return value;
          }
          return parseFloat(value) / 100.0;
        }
      },
      number: {
        hex: function(value) {
          var retVal;
          retVal = value.toString(16).toUpperCase();
          if (retVal.length < 2) {
            return "0" + retVal;
          }
          return retVal;
        },
        abbr: function(value) {
          return "0";
        },
        rgb: function(value) {
          return value + '';
        },
        hsl: function(value) {
          return (value * 100.0) + '%';
        }
      }
    };

    Color.prototype.__convert = function(value, from_type, to_type) {
      return this.__convertHash[from_type][to_type](value);
    };

    Color.prototype.__calculateRGB = function(){
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
  };

    Color.prototype.__calculateHSL = function() {
      var b, delta, g, h, l, max, min, r, s, _ref;
      _ref = [this.r / 255.0, this.g / 255.0, this.b / 255.0], r = _ref[0], g = _ref[1], b = _ref[2];
      min = Math.min(r, g, b);
      max = Math.max(r, g, b);
      delta = max - min;
      if (max === min) {
        h = 0;
      } else if (r === max) {
        h = (g - b) / delta;
      } else if (g === max) {
        h = 2 + (b - r) / delta;
      } else if (b === max) {
        h = 4 + (r - g) / delta;
      }
      h = Math.min(h * 60, 360);
      if (h < 0) {
        h += 360;
      }
      l = (min + max) / 2;
      if (max === min) {
        s = 0;
      } else if (l <= 0.5) {
        s = delta / (max + min);
      } else {
        s = delta / (2 - max - min);
      }
      this.h = Math.round(h);
      this.s = Math.round(s * 100.0) / 100.0;
      return this.l = Math.round(l * 100.0) / 100.0;
    };

    Color.prototype.__calculateAlpha = function() {
      if (!this.hasOwnProperty('a')) {
        return this.a = 1;
      }
    };

    Color.prototype.red = function(presentationOrValue) {
      if (presentationOrValue == null) {
        presentationOrValue = null;
      }
      if (!this.hasOwnProperty('r')) {
        this.__calculateRGB();
      }
      if (!presentationOrValue) {
        return this.r;
      }
      if (presentationOrValue === "string") {
        return this.r + "";
      }
      if (presentationOrValue === "number") {
        return this.r;
      }
      this.r = parseInt(presentationOrValue);
      if (this.hasOwnProperty('h')) {
        return this.__calculateHSL();
      }
    };

    Color.prototype.green = function(presentationOrValue) {
      if (presentationOrValue == null) {
        presentationOrValue = null;
      }
      if (!this.hasOwnProperty('g')) {
        this.__calculateRGB();
      }
      if (!presentationOrValue) {
        return this.g;
      }
      if (presentationOrValue === "string") {
        return this.g + "";
      }
      if (presentationOrValue === "number") {
        return this.g;
      }
      this.g = parseInt(presentationOrValue);
      if (this.hasOwnProperty('h')) {
        return this.__calculateHSL();
      }
    };

    Color.prototype.blue = function(presentationOrValue) {
      if (presentationOrValue == null) {
        presentationOrValue = null;
      }
      if (!this.hasOwnProperty('b')) {
        this.__calculateRGB();
      }
      if (!presentationOrValue) {
        return this.b;
      }
      if (presentationOrValue === "string") {
        return this.b + "";
      }
      if (presentationOrValue === "number") {
        return this.b;
      }
      this.b = parseInt(presentationOrValue);
      if (this.hasOwnProperty('h')) {
        return this.__calculateHSL();
      }
    };

    Color.prototype.hue = function(presentationOrValue) {
      if (presentationOrValue == null) {
        presentationOrValue = null;
      }
      if (!this.hasOwnProperty('h')) {
        this.__calculateHSL();
      }
      if (!presentationOrValue) {
        return this.h;
      }
      if (presentationOrValue === "string") {
        return this.h + "";
      }
      if (presentationOrValue === "number") {
        return this.h;
      }
      this.h = parseInt(presentationOrValue);
      if (this.hasOwnProperty('r')) {
        return this.__calculateRGB();
      }
    };

    Color.prototype.saturation = function(presentationOrValue) {
      if (presentationOrValue == null) {
        presentationOrValue = null;
      }
      if (!this.hasOwnProperty('s')) {
        this.__calculateHSL();
      }
      if (!presentationOrValue) {
        return this.s;
      }
      if (presentationOrValue === "number") {
        return this.s;
      }
      if (presentationOrValue === "string") {
        return this.s * 100 + '%';
      }
      if (typeof presentationOrValue === 'number') {
        this.s = presentationOrValue;
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
        return;
      }
      if (presentationOrValue.match(CB.Color.__rF)) {
        this.s = parseFloat(presentationOrValue);
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
        return;
      }
      if (presentationOrValue.match(CB.Color.__rI)) {
        this.s = parseInt(presentationOrValue) / 100.0;
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
        return;
      }
      if (presentationOrValue.match(CB.Color.__rP)) {
        this.s = parseInt(presentationOrValue) / 100.0;
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
      }
    };

    Color.prototype.lightness = function(presentationOrValue) {
      if (presentationOrValue == null) {
        presentationOrValue = null;
      }
      if (!this.hasOwnProperty('l')) {
        this.__calculateHSL();
      }
      if (!presentationOrValue) {
        return this.l;
      }
      if (presentationOrValue === "number") {
        return this.l;
      }
      if (presentationOrValue === "string") {
        return this.l * 100 + '%';
      }
      if (typeof presentationOrValue === 'number') {
        this.l = presentationOrValue;
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
        return;
      }
      if (presentationOrValue.match(CB.Color.__rF)) {
        this.l = parseFloat(presentationOrValue);
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
        return;
      }
      if (presentationOrValue.match(CB.Color.__rI)) {
        this.l = parseInt(presentationOrValue) / 100.0;
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
        return;
      }
      if (presentationOrValue.match(CB.Color.__rP)) {
        this.l = parseInt(presentationOrValue) / 100.0;
        if (this.hasOwnProperty('r')) {
          this.__calculateRGB();
        }
      }
    };

    Color.prototype.alpha = function(presentationOrValue) {
      if (presentationOrValue == null) {
        presentationOrValue = null;
      }
      if (!this.hasOwnProperty('a')) {
        this.__calculateAlpha();
      }
      if (!presentationOrValue) {
        return this.a;
      }
      if (presentationOrValue === "string") {
        return this.a + '';
      }
      if (presentationOrValue === "number") {
        return this.a;
      }
      return this.a = parseFloat(presentationOrValue);
    };

    Color.prototype.toString = function() {
      switch (this.type) {
        case "hex":
          return this.toHexString();
        case "abbr":
          return this.toHexString();
        case "hsl":
          return this.toHSLString();
        case "hsla":
          return this.toHSLAString();
        case "rgb":
          return this.toRGBString();
        case "rgba":
          return this.toRGBAString();
      }
    };

    Color.prototype.toHSLAString = function(useHSLIfPossible) {
      var a;
      if (useHSLIfPossible == null) {
        useHSLIfPossible = false;
      }
      if (!this.hasOwnProperty('h')) {
        this.__calculateHSL();
      }
      if (useHSLIfPossible && (!this.a || this.a >= 1.0)) {
        return "hsl(" + this.__convert(this.h, "number", "rgb") + ", " + this.__convert(this.s, "number", "hsl") + ", " + this.__convert(this.l, "number", "hsl") + ")";
      }
      if (this.a) {
        a = this.a;
      } else {
        a = 1;
      }
      return "hsla(" + this.__convert(this.h, "number", "rgb") + ", " + this.__convert(this.s, "number", "hsl") + ", " + this.__convert(this.l, "number", "hsl") + ", " + a + ")";
    };

    Color.prototype.toRGBAString = function(useRGBIfPossible) {
      var a;
      if (useRGBIfPossible == null) {
        useRGBIfPossible = false;
      }
      if (!this.hasOwnProperty('r')) {
        this.__calculateRGB();
      }
      if (useRGBIfPossible && (!this.a || this.a >= 1.0)) {
        return "rgb(" + this.__convert(this.r, "number", "rgb") + ", " + this.__convert(this.g, "number", "rgb") + ", " + this.__convert(this.b, "number", "rgb") + ")";
      }
      if (this.a) {
        a = this.a;
      } else {
        a = 1;
      }
      return "rgba(" + this.__convert(this.r, "number", "rgb") + ", " + this.__convert(this.g, "number", "rgb") + ", " + this.__convert(this.b, "number", "rgb") + ", " + a + ")";
    };

    Color.prototype.toHSLString = function() {
      return this.toHSLAString(true);
    };

    Color.prototype.toRGBString = function() {
      return this.toRGBAString(true);
    };

    Color.prototype.toHexString = function(neverFallBackIfHasAlpha) {
      if (neverFallBackIfHasAlpha == null) {
        neverFallBackIfHasAlpha = false;
      }
      if ((!neverFallBackIfHasAlpha) && this.a && (this.a < 1.0)) {
        if (this.hasOwnProperty('r')) {
          return this.toRGBAString();
        } else if (this.hasOwnProperty('h')) {
          return this.toHSLAString();
        }
      }
      if (!this.r) {
        this.__calculateRGB();
      }
      return "#" + this.__convert(this.r, "number", "hex") + this.__convert(this.g, "number", "hex") + this.__convert(this.b, "number", "hex");
    };

    return Color;

  })();

}).call(this);
(function() {
  CB.Metrics = (function() {
    function Metrics() {}

    Metrics.add = function(a, b) {
      var ra, rb, _ref, _ref1;
      if (typeof a === 'number') {
        a = a + 'px';
      }
      if (typeof b === 'number') {
        b = b + 'px';
      }
      if (a.match(/%$/) && b.match(/%$/)) {
        _ref = [parseFloat(a), parseFloat(b)], ra = _ref[0], rb = _ref[1];
        return (ra + rb).toString() + "%";
      }
      if (a.match(/px$/) && b.match(/px$/)) {
        _ref1 = [parseFloat(a), parseFloat(b)], ra = _ref1[0], rb = _ref1[1];
        return (ra + rb).toString() + "px";
      }
      throw "CB.Metrics: Add error.";
    };

    Metrics.multiply = function(a, b) {
      var ra, rb, value, _i, _len, _ref, _ref1, _ref2;
      if (typeof a === 'number') {
        a = a + 'px';
      }
      if (typeof b === 'number') {
        b = b + 'px';
      }
      _ref = [a, b];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        value = _ref[_i];
        if (typeof value === 'number') {
          value = value + 'px';
        }
      }
      if (a.match(/%$/) && b.match(/px$/)) {
        _ref1 = [b, a], a = _ref1[0], b = _ref1[1];
      }
      if (a.match(/px$/) && b.match(/%$/)) {
        _ref2 = [parseFloat(a), parseFloat(b)], ra = _ref2[0], rb = _ref2[1];
        return (ra * rb / 100.0).toString() + "px";
      }
      throw "CB.Metrics: Multiply error.";
    };

    return Metrics;

  })();

}).call(this);
(function() {
  CB.Window = (function() {
    function Window() {}

    Window.currentWindow = function() {
      this.__current || (this.__current = new CB.Window);
      return this.__current;
    };

    Window.property("height", {
      get: function() {
        return $(window).height();
      }
    });

    Window.property("width", {
      get: function() {
        return $(window).width();
      }
    });

    Window.property("rootViewController", {
      get: function() {
        return this._keyViewController;
      },
      set: function(vc) {
        this._keyViewController = vc;
        return this.__setKeyView(vc.view);
      }
    });

    Window.prototype.isLong = function() {
      return this.width <= this.height;
    };

    Window.prototype.isWide = function() {
      return !this.isLong();
    };

    Window.prototype.__setKeyView = function(view) {
      if ($("body").length) {
        $("body").empty();
      }
      view.__loadLayer();
      view.__syncView();
      view.layout();
      view.show = true;
      this._keyView = view;
      $(window).off("resize");
      return $(window).resize(function() {
        return view.layout();
      });
    };

    return Window;

  })();

}).call(this);
(function() {
  var __slice = [].slice;

  CB.View = (function() {
    function View() {
      this.subviews = [];
      this.layer = null;
      this.useBodyAsLayer = false;
      this.eventDelegate = null;
      this.__events = [];
      this.__css = {};
    }

    View.prototype.__loadLayer = function() {
      var view, _i, _len, _ref, _results;
      if (this.useBodyAsLayer) {
        this.layer = $("body");
        this.layer.css("position", "relative");
        this.layer.css("margin", "0px");
      } else {
        this.layer = this.__layer();
        this.layer.css("position", "absolute");
      }
      this.__syncCSS();
      this.__loadGestures();
      _ref = this.subviews;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        view = _ref[_i];
        _results.push(view.__loadLayer());
      }
      return _results;
    };

    View.prototype.__unloadLayer = function() {
      var view, _i, _len, _ref, _results;
      this.__unloadGestures();
      this.layer.empty();
      this.layer = null;
      _ref = this.subviews;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        view = _ref[_i];
        _results.push(view.layer = null);
      }
      return _results;
    };

    View.prototype.__syncView = function() {
      var view, _i, _len, _ref, _results;
      if (CB.Window.currentWindow().keyView === this && !this.useBodyAsLayer) {
        $("body").append(this.layer);
      }
      _ref = this.subviews;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        view = _ref[_i];
        view.layer.appendTo(this.layer);
        view.show = true;
        _results.push(view.__syncView());
      }
      return _results;
    };

    View.prototype.__loadGestures = function() {
      return this.layer.on("click", (function(_this) {
        return function() {
          return _this.__sendActions("click");
        };
      })(this));
    };

    View.prototype.__unloadGestures = function() {
      var event, events, _i, _len, _results;
      events = ["click", "mouseenter", "mouseleave", "focus", "blur", "touchstart"];
      _results = [];
      for (_i = 0, _len = events.length; _i < _len; _i++) {
        event = events[_i];
        _results.push(this.layer.off(event));
      }
      return _results;
    };

    View.prototype.__layer = function() {
      return $("<div></div>");
    };

    View.prototype.__calculateOffset = function(offset, functionName, relativeFName) {
      if (this.useBodyAsLayer) {
        return '0px';
      }
      switch (typeof offset) {
        case 'number':
          return offset;
          return CB.Metrics.add(this.superview[functionName](), offset);
        case 'string':
          if (offset.match(/px$/)) {
            return offset;
            return CB.Metrics.add(this.superview[functionName](), offset);
          } else if (offset.match(/%$/)) {
            return CB.Metrics.multiply(this.superview[relativeFName](), offset);
          } else {
            return '0px';
          }
          break;
        case 'function':
          return offset();
      }
    };

    View.prototype.__calculateLength = function(length, functionName) {
      if (this.useBodyAsLayer) {
        return '100%';
      }
      switch (typeof length) {
        case 'number':
          return length + 'px';
        case 'string':
          if (length.match(/px$/)) {
            return length;
          } else if (length.match(/%$/)) {
            return CB.Metrics.multiply(this.superview[functionName](), length);
          } else {
            return '0px';
          }
          break;
        case 'function':
          return length();
      }
    };

    View.prototype.__top = function() {
      return this.__calculateOffset(this.top, "__top", "__height");
    };

    View.prototype.__left = function() {
      return this.__calculateOffset(this.left, "__left", "__width");
    };

    View.prototype.__width = function() {
      return this.__calculateLength(this.width, "__width");
    };

    View.prototype.__height = function() {
      return this.__calculateLength(this.height, "__height");
    };

    View.prototype.layout = function() {
      var subview, _i, _len, _ref, _results;
      if (CB.Window.currentWindow().keyView !== this) {
        this.layer.css("top", this.__top());
        this.layer.css("left", this.__left());
        this.layer.width(this.__width());
        this.layer.height(this.__height());
      }
      _ref = this.subviews;
      _results = [];
      for (_i = 0, _len = _ref.length; _i < _len; _i++) {
        subview = _ref[_i];
        _results.push(subview.layout());
      }
      return _results;
    };

    View.prototype.addSubview = function() {
      var view, views, _i, _len;
      views = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      for (_i = 0, _len = views.length; _i < _len; _i++) {
        view = views[_i];
        view.superview = this;
        view.__loadLayer();
        if (this.show) {
          this.layer.append(view.layer);
        }
      }
      Array.prototype.push.apply(this.subviews, views);
    };

    View.prototype.addSubviews = function() {
      var subviews;
      subviews = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      return this.addSubview.apply(this, subviews);
    };

    View.prototype.removeFromSuperview = function() {
      var index;
      index = this.superview.subviews.indexOf(this);
      index > -1 && this.superview.subviews.splice(index, 1);
      this.superview = null;
      this.layer && this.layer.remove();
    };

    View.prototype.__sendActions = function(event) {
      if (this.eventDelegate) {
        return this.eventDelegate.__sendActions(event);
      }
      return this.sendActionsForUserEvent(event);
    };

    View.prototype.queryTargetActionEvent = function(target, action, event) {
      return this.__events.filter(function(obj) {
        return (target ? obj.target === target : true) && (action ? obj.action === action : true) && (event ? obj.event === event : true);
      });
    };

    View.prototype.addTargetForUserEvent = function(target, action, event) {
      return this.__events.push({
        target: target,
        action: action,
        event: event
      });
    };

    View.prototype.removeTargetForUserEvent = function(target, action, event) {
      return this.__events = this.__events.filter(function(obj) {
        return !this.queryTargetActionEvent(target, action, event);
      });
    };

    View.prototype.sendActionsForUserEvent = function(event) {
      return this.queryTargetActionEvent(null, null, event).forEach((function(_this) {
        return function(object) {
          return object.target[object.action](_this);
        };
      })(this));
    };

    View.prototype.__syncCSS = function() {
      var k, v, _i, _len, _ref, _results;
      _ref = this.__css;
      _results = [];
      for (v = _i = 0, _len = _ref.length; _i < _len; v = ++_i) {
        k = _ref[v];
        _results.push(this.layer.css(k, v));
      }
      return _results;
    };

    View.prototype.css = function() {
      var args, _ref;
      args = 1 <= arguments.length ? __slice.call(arguments, 0) : [];
      this.__css[args[0]] = this.__css[args[1]];
      if (this.layer) {
        return (_ref = this.layer).css.apply(_ref, args);
      }
    };

    View.prototype.cornerRadius = function(radius) {
      return this.css("border-radius", radius);
    };

    View.prototype.backgroundColor = function(color) {
      if (color instanceof CB.Color) {
        color = color.toString();
      }
      return this.css("background-color", color);
    };

    return View;

  })();

}).call(this);
(function() {
  CB.Renderer = (function() {
    function Renderer() {}

    Renderer.sharedRenderer = function() {
      this.__shared || (this.__shared = new CHESS.VIEW.Renderer);
      return this.__shared;
    };

    return Renderer;

  })();

}).call(this);
(function() {
  CB.ViewController = (function() {
    function ViewController() {}

    ViewController.property("view");

    ViewController.property("title", {
      get: function() {
        return document.title;
      },
      set: function(newTitle) {
        return document.title = newTitle;
      }
    });

    ViewController.prototype.isViewLoaded = function() {
      return !!this._view;
    };

    ViewController.prototype.loadView = function() {
      this.view = new CB.View;
    };

    ViewController.prototype.viewDidLoad = function() {};

    ViewController.prototype.viewWillAppear = function() {};

    ViewController.prototype.viewDidAppear = function() {};

    ViewController.prototype.viewWillDisappear = function() {};

    ViewController.prototype.viewDidDisappear = function() {};

    ViewController.prototype.viewWillLayoutSubviews = function() {};

    ViewController.prototype.viewDidLayoutSubviews = function() {};

    ViewController.property("childViewControllers", {
      get: function() {
        this._childViewControllers || (this._childViewControllers = []);
        return this._childViewControllers;
      }
    });

    ViewController.property("parentViewController");

    ViewController.prototype.addChildViewController = function(child) {
      this.childViewControllers.push(child);
    };

    ViewController.prototype.removeFromParentViewController = function() {
      var index;
      index = this.parentViewController.childViewControllers.indexOf(this);
      index > -1 && this.parentViewController.childViewControllers.splice(index, 1);
      this.parentViewController = null;
    };

    ViewController.prototype.willMoveToParentViewController = function(parent) {};

    ViewController.prototype.didMoveToParentViewController = function(parent) {};

    return ViewController;

  })();

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  CB.Application = (function(_super) {
    __extends(Application, _super);

    function Application() {
      this.__i = 0;
    }

    Application.sharedApplication = function() {
      this.__shared || (this.__shared = new CB.Application);
      return this.__shared;
    };

    Application.property("delegate");

    Application.property("keyWindow");

    Application.property("windows");

    Application.prototype.finishLaunchingWithInfo = function() {};

    return Application;

  })(Object);

  CB.ApplicationDelegate = (function(_super) {
    __extends(ApplicationDelegate, _super);

    function ApplicationDelegate() {
      this.__i = 0;
    }

    ApplicationDelegate.prototype.applicationWillFinishLaunchingWithOptions = function(options) {};

    ApplicationDelegate.prototype.applicationDidFinishLaunchingWithOptions = function(options) {};

    return ApplicationDelegate;

  })(Object);

  CB.Run = function(options) {
    var app;
    if (typeof options === 'function') {
      return $(document).ready(function() {
        return options();
      });
    } else if (typeof options === 'object') {
      options.application || (options.application = new CB.Application());
      CB.Application.__shared = options.application;
      app = CB.Application.sharedApplication();
      app.delegate = options.delegate;
      return $(document).ready(function() {
        app.delegate.applicationWillFinishLaunchingWithOptions();
        app.finishLaunchingWithInfo();
        return app.delegate.applicationDidFinishLaunchingWithOptions();
      });
    }
  };

}).call(this);
(function() {


}).call(this);
