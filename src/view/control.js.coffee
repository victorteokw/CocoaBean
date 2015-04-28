class CB.Control extends CB.View
  constructor: (frame) ->
    super(frame)
    @items = []
    @enabled = true
    @selected = false
    @highlighted = false

  beginTrackingWithEvent: (event) ->
    if event.type == "mouse.down"
      this.sendActionsForControlEvents("mouse.down")
      return true
    if event.type == "touch.down"
      if event.allTouches.length == 1
        this.sendActionsForControlEvents("touch.down")
        return true
    return false

  continueTrackingWithEvent: (event) ->
    if event.type == "mouse.move"
      if @touchOrPointInside
        this.sendActionsForControlEvents("mouse.move.inside")
      else
        this.sendActionsForControlEvents("mouse.move.outside")
      return true
    if event.type == "touch.move"
      if event.allTouches.length == 1
        if @touchOrPointInside
          this.sendActionsForControlEvents("touch.move.inside")
          return true
        else
          this.sendActionsForControlEvents("touch.move.outside")
          return true
    return false

  endTrackingWithEvent: (event) ->
    if event.type == "mouse.up"
      if @touchOrPointInside
        this.sendActionsForControlEvents("mouse.up.inside")
      else
        this.sendActionsForControlEvents("mouse.up.outside")
    if event.type == "touch.up"
      if event.allTouches.length == 1
        if @touchOrPointInside
          this.sendActionsForControlEvents("touch.up.inside")
        else
          this.sendActionsForControlEvents("touch.up.outside")
    return

  cancelTrackingWithEvent: (event) ->
    if event.type == "mouse.exit"
      this.sendActionsForControlEvents("mouse.cancel")
    if event.type == "touch.exit"
      if event.allTouches.length == 1
        this.sendActionsForControlEvents("touch.cancel")

  @property "readonly", "tracking"

  @property "readonly", "touchOrPointInside"

  @property "readonly", "state"

  @property "enabled"

  @property "selected"

  @property "highlighted"

  @property "contentVerticalAlignment"

  @property "contentHorizontalAlignment"

  canBecomeFirstResponder: () ->
    @enabled && @userInteractionEnabled && @alpha >= 0.01 && !@hidden

  __queryTargetActionEvent: (target, action, controlEvents) ->
    @items.filter (obj) ->
      (if target then obj.target == target else true) &&
      (if action then obj.action == action else true) &&
      (if controlEvents then obj.controlEvents == controlEvents else true)

  sendActionToForEvent: (action, target, event) ->
    target[action](this, event)

  sendActionsForControlEvents: (controlEvents) ->
    items = this.__queryTargetActionEvent(null, null, controlEvents)
    for item in items
      this.sendActionToForEvent(item.action, item.target, controlEvents)

  # tentative implementation which only accept single event
  addTargetActionForControlEvents: (target, action, controlEvents) ->
    @items.push(target: target, action: action, controlEvents: controlEvents)

  # tentative implementation which only accept single event
  removeTargetActionForControlEvents: (target, action, controlEvents) ->
    toRemove = this.__queryTargetActionEvent(target, action, controlEvents)
    @items.forEach (i) =>
      if toRemove.indexOf(i) > -1
        index = @items.indexOf(i)
        @items.splice(index, 1)

  actionsForTargetForControlEvent: (target, controlEvent) ->
    this.__queryTargetActionEvent(target, null, controlEvent)

  allTargets: () ->
    targets = @items.map (i) =>
      i.target
    uniq = []
    $.each targets, (i, el) =>
      uniq.push(el) if $.inArray(el, uniq) == -1
    uniq

  allControlEvents: () ->
    events = @items.map (i) =>
      i.controlEvents
    uniq = []
    $.each events, (i, el) =>
      uniq.push(el) if $.inArray(el, uniq) == -1

  setTouchOrPointInsideForEvent: (event) ->
    if event.type.match(/mouse/)
      point = event.locationInView(this)
      @_touchOrPointInside = this.pointInsideWithEvent(point, event)
    else if event.type.match(/touch/)
      if event.allTouches.length == 1
        touch = event.allTouches[0]
        point = touch.locationInView(this)
        @_touchOrPointInside = this.pointInsideWithEvent(point, event)
      else
        @_touchOrPointInside = false
    else
      @_touchOrPointInside = false
    return

  # TODO: Touch event not available yet
  touchesBeganWithEvent: (event) ->
    @_tracking = true
    this.setTouchOrPointInsideForEvent(event)
    unless this.beginTrackingWithEvent(event)
      @_tracking = false

  touchesMovedWithEvent: (event) ->
    if @_tracking
      this.setTouchOrPointInsideForEvent(event)
      unless this.continueTrackingWithEvent(event)
        @_tracking = false

  touchesEndedWithEvent: (event) ->
    if @_tracking
      @_tracking = false
      this.setTouchOrPointInsideForEvent(event)
      this.endTrackingWithEvent(event)
      @_touchOrPointInside = false

  touchesCanceledWithEvent: (event) ->
    if @_tracking
      @_tracking = false
      this.setTouchOrPointInsideForEvent(event)
      this.cancelTrackingWithEvent(event)
      @_touchOrPointInside = false

  mouseDownWithEvent: (event) ->
    @_tracking = true
    this.setTouchOrPointInsideForEvent(event)
    unless this.beginTrackingWithEvent(event)
      @_tracking = false

  mouseMovedWithEvent: (event) ->
    if @_tracking
      this.setTouchOrPointInsideForEvent(event)
      unless this.continueTrackingWithEvent(event)
        @_tracking = false

  mouseUpWithEvent: (event) ->
    if @_tracking
      @_tracking = false
      this.setTouchOrPointInsideForEvent(event)
      this.endTrackingWithEvent(event)
      @_touchOrPointInside = false

  mouseExitedWithEvent: (event) ->
    if @_tracking
      @_tracking = false
      this.setTouchOrPointInsideForEvent(event)
      this.cancelTrackingWithEvent(event)
      @_touchOrPointInside = false
