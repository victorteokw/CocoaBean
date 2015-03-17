(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  window.DEMO = {};

  DEMO.View = (function(_super) {
    __extends(View, _super);

    function View() {
      return View.__super__.constructor.apply(this, arguments);
    }

    return View;

  })(CB.View);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  DEMO.ViewController = (function(_super) {
    __extends(ViewController, _super);

    function ViewController() {
      this.view = new DEMO.View();
      this.view.useBodyAsLayer = true;
      this.squareView = new DEMO.View();
      this.squareView.width = this.squareView.height = Math.min(CB.Window.currentWindow().width, CB.Window.currentWindow().height);
      this.squareView.backgroundColor = 'red';
      this.squareView.left = 0;
      this.squareView.top = 0;
      this.view.addSubview(this.squareView);
    }

    return ViewController;

  })(CB.ViewController);

}).call(this);
(function() {
  var __hasProp = {}.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor(); child.__super__ = parent.prototype; return child; };

  DEMO.ApplicationDelegate = (function(_super) {
    __extends(ApplicationDelegate, _super);

    function ApplicationDelegate() {
      return ApplicationDelegate.__super__.constructor.apply(this, arguments);
    }

    ApplicationDelegate.prototype.applicationDidFinishLaunchingWithOptions = function(options) {
      var controller;
      controller = new DEMO.ViewController();
      return CB.Window.currentWindow().rootViewController = controller;
    };

    return ApplicationDelegate;

  })(CB.ApplicationDelegate);

}).call(this);
(function() {
  CB.Run({
    delegate: new DEMO.ApplicationDelegate()
  });

}).call(this);
