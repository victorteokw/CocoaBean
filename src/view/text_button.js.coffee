class CB.TextButton extends CB.Control
  constructor: (frame) ->
    super(frame)
    @_labelView = new CB.LabelView()
    @_labelView.frame = new CB.Rect(0, 0, 0, 0)
    this.addSubview(@_labelView)

  @property "readonly", "labelView"

  sizeThatFits: (size) ->
    return @labelView.sizeThatFits(size)

  layoutSubviews: () ->
    @_labelView.frame = new CB.Rect(0, 0, @labelView.sizeThatFits().width, @labelView.sizeThatFits().height)
