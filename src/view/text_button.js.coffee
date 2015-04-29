class CB.TextButton extends CB.Control
  constructor: (frame) ->
    super(frame)
    @_labelView = new CB.LabelView()
    @_labelView.frame = new CB.Rect(0, 0, 0, 0)
    this.addSubview(@_labelView)
    @cursor = "pointer"

  @property "readonly", "labelView"

  @property "cursor",
    set: (newPointer) ->
      @_pointer = newPointer
      @css("cursor", newPointer)
      return

  sizeThatFits: (size) ->
    return @labelView.sizeThatFits(size)

  layoutSubviews: () ->
    intrinsicHeight = @labelView.sizeThatFits().height
    @_labelView.frame = new CB.Rect(0, (@frame.height - intrinsicHeight) / 2, @frame.width, intrinsicHeight)
