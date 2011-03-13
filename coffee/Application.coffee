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
    box2d.Util.requestAnimFrame(goog.bind(this.tick, this));

  tick: () ->
    s = this._shape
    if s.x < 0
      this._dx = Application.delta
    else if s.x > (this.canvas.width - Application.imageSize)
      this._dx = -Application.delta
    if s.y < 0
      this._dy = Application.delta
    else if s.y > (this.canvas.height - Application.imageSize)
      this._dy = -Application.delta
    s.x += this._dx
    s.y += this._dy
    this._stage.update();
    box2d.Util.requestAnimFrame(goog.bind(this.tick, this));

Application.imageSrc = '../images/pixellab.png'
Application.imageSize = 192
Application.delta = 5
