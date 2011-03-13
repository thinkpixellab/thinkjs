goog.provide('Application')

goog.require 'Stage'
goog.require 'Bitmap'
goog.require 'Ticker'
goog.require 'box2d.Util'

###
@ constructor
@ param {!HTMLCanvasElement} canvas
###
class Application
  constructor: (@canvas) ->
    this._stage = new Stage(@canvas)

    image = new Image();
    image.src = Application.imageSrc
    
    
    this._shape = new Bitmap(image);
    this._stage.addChild(this._shape);
    
    this._dx = Application.delta;
    this._dy = Application.delta;
    Ticker.addListener(this)

  tick: () ->
    this._updateShape()
    this._stage.update()

  _updateShape: () ->
    s = this._shape
    if s.x < 0
      this._dx = Application.delta
    else if s.x > (this.canvas.width - Application.imgWidth)
      this._dx = -Application.delta
    if s.y < 0
      this._dy = Application.delta
    else if s.y > (this.canvas.height - Application.imgHeight)
      this._dy = -Application.delta
    s.x += this._dx
    s.y += this._dy

Application.imageSrc = '../images/pixellab_cropped.png'
Application.imgWidth = 119
Application.imgHeight = 95
Application.delta = 5
