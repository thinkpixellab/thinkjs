var Application;
goog.provide('Application');
goog.require('Stage');
goog.require('Bitmap');
goog.require('Ticker');
goog.require('box2d.Util');
goog.require('box2d.AABB');
goog.require('box2d.World');
goog.require('goog.math.Rect');
goog.require('box2d.BoxDef');
goog.require('box2d.BodyDef');
goog.require('goog.math.Vec2');
/*
@ constructor
@ param {!HTMLCanvasElement} canvas
*/
Application = (function() {
  function Application(canvas) {
    this.canvas = canvas;
    this._stage = new Stage(this.canvas);
    this._boundingBox = this._createBoundingBox();
    this._world = this._createWorld();
    this._shape = this._createShape();
    this._stage.addChild(this._shape);
    Ticker.addListener(this);
  }
  Application.prototype.tick = function() {
    this._updateShape();
    return this._stage.update();
  };
  Application.prototype._createBoundingBox = function() {
    var box, currentRect;
    currentRect = new goog.math.Rect(0, 0, this.canvas.width, this.canvas.height);
    box = currentRect.toBox();
    return box.expand(Application._extent, Application._extent, Application._extent, Application._extent);
  };
  Application.prototype._createWorld = function() {
    var worldAABB;
    worldAABB = new box2d.AABB();
    worldAABB.minVertex.Set(this._boundingBox.left, this._boundingBox.top);
    worldAABB.maxVertex.Set(this._boundingBox.right, this._boundingBox.bottom);
    return new box2d.World(worldAABB, Application._gravity, true);
  };
  Application.prototype._createShape = function() {
    var bodyDef, boxBd, image, shape;
    image = new Image();
    image.src = Application._imageSrc;
    shape = new Bitmap(image);
    bodyDef = new box2d.BoxDef();
    bodyDef.extents.Set(Application._imgWidth / 2, Application._imgHeight / 2);
    bodyDef.density = 0.0002;
    bodyDef.restitution = 0.95;
    bodyDef.friction = 1.0;
    boxBd = new box2d.BodyDef();
    boxBd.AddShape(bodyDef);
    shape._body = this._world.CreateBody(boxBd);
    return shape;
  };
  Application.prototype._updateShape = function() {
    var s;
    this._world.Step(1, 1);
    s = this._shape;
    s.x = s._body.m_position.x;
    s.y = s._body.m_position.y;
    return console.log(s.x, s.y);
  };
  return Application;
})();
Application._imageSrc = '../images/pixellab_cropped.png';
Application._imgWidth = 119;
Application._imgHeight = 95;
Application._extent = 100;
Application._gravity = new goog.math.Vec2(0, 10);