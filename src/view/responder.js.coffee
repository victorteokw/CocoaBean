class CB.Responder

  @currentFirstResponder = null

  constructor: () ->

  @property "currentFirstResponder",
    get: () ->
      return CB.Responder.currentFirstResponder
    set: (newValue) ->
      CB.Responder.currentFirstResponder = newValue

  # Basics

  nextResponder: () ->
    null

  isFirstResponder: () ->
    @currentFirstResponder == this

  canBecomeFirstResponder: () ->
    false

  acceptsFirstResponder: () ->
    this.canBecomeFirstResponder()

  becomeFirstResponder: () ->
    return false unless this.canBecomeFirstResponder()
    if @currentFirstResponder and @currentFirstResponder != this
      if @currentFirstResponder.resignFirstResponder()
        @currentFirstResponder = this
        return true
      else
        return false
    else if @currentFirstResponder and @currentFirstResponder == this
      return true
    else
      @currentFirstResponder = this
      true

  canResignFirstResponder: () ->
    true

  resignFirstResponder: () ->
    if this.canResignFirstResponder()
      @currentFirstResponder = null
      true
    else
      false

  # Touch events

  touchesBeganWithEvent: (event) ->

  touchesMovedWithEvent: (event) ->

  touchesEndedWithEvent: (event) ->

  touchesCanceledWithEvent: (event) ->

  # Mouse events

  mouseDownWithEvent: (event) ->

  mouseDraggedWithEvent: (event) ->

  mouseUpWithEvent: (event) ->

  mouseEnteredWithEvent: (event) ->

  mouseMovedWithEvent: (event) ->

  mouseExitedWithEvent: (event) ->

  # Key events

  keyDownWithEvent: (event) ->

  keyUpWithEvent: (event) ->
