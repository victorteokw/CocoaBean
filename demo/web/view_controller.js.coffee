class DEMO.ViewController extends CB.ViewController
  constructor: () ->
    @view = new DEMO.View()
    @view.useBodyAsLayer = true # todo remove this from api
    @squareView = new DEMO.View()
    @squareView.width = @squareView.height = Math.min(CB.Window.currentWindow().width, CB.Window.currentWindow().height)
    @squareView.backgroundColor = 'red'
    @squareView.left = 0
    @squareView.top = 0
    @view.addSubview(@squareView)
