class CB.DebuggerView extends CB.View

  constructor: (frame) ->
    super(frame)
    @listView = new CB.View
    @listView.backgroundColor = "#99CCFF"
    @bodyView = new CB.LabelView
    @bodyView.backgroundColor = "#FFCC99"
    @closeButton = new CB.TextButton
    @closeButton.labelView.text = "✗"
    @closeButton.labelView.fontSize = 20
    this.addSubview(@listView)
    this.addSubview(@bodyView)
    this.addSubview(@closeButton)
    this.l()
    for e in ["mouse.up.inside", "touch.up.inside"]
      @closeButton.addTargetActionForControlEvents(this, "close", e)

  close: (sender, event) ->
    @hidden = true

  l: () ->
    windowFrame = CB.Window.currentWindow().frame
    left = 0
    height = 200
    top = windowFrame.height - height
    width = windowFrame.width
    @frame = new CB.Rect(left, top, width, height)

    left = 0
    width = 200
    height = @frame.height
    top = 0
    @listView.frame = new CB.Rect(left, top, width, height)

    left = @listView.frame.width
    top = 0
    width = @frame.width - @listView.frame.width
    height = @frame.height
    @bodyView.frame = new CB.Rect(left, top, width, height)

    intrinsic = @closeButton.sizeThatFits()
    width = intrinsic.width
    height = intrinsic.height
    left = @frame.width - width
    top = 0
    @closeButton.frame = new CB.Rect(left, top, width, height)

  layoutSubviews: () ->
    super()
    this.l()

  addEntry: (msg, url, line, col, extra) ->
    @bodyView.text = "Message: #{msg}\nURL: #{url}\n#(#{line}, #{col})\nEXTRA: #{extra}"
