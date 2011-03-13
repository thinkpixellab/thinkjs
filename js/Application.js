var Application;
goog.provide('Application');
goog.require('Stage');
goog.require('Bitmap');
goog.require('Ticker');
/*
@ constructor
@ param {!HTMLCanvasElement} canvas
*/
Application = (function() {
  function Application(canvas) {
    var image;
    this.canvas = canvas;
    this._stage = new Stage(this.canvas);
    image = new Image();
    image.src = Application.imageSrc;
    this._shape = new Bitmap(image);
    this._stage.addChild(this._shape);
    this._dx = Application.delta;
    this._dy = Application.delta;
    Ticker.addListener(this);
  }
  Application.prototype.tick = function() {
    var s;
    s = this._shape;
    if (s.x < 0) {
      this._dx = Application.delta;
    } else if (s.x > (this.canvas.width - Application.imageSize)) {
      this._dx = -Application.delta;
    }
    if (s.y < 0) {
      this._dy = Application.delta;
    } else if (s.y > (this.canvas.height - Application.imageSize)) {
      this._dy = -Application.delta;
    }
    s.x += this._dx;
    s.y += this._dy;
    return this._stage.update();
  };
  return Application;
})();
Application.imageSrc = '../images/pixellab.png';
Application.imageSize = 192;
Application.delta = 10;