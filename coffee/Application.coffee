goog.provide('Application')

goog.require 'Stage'
goog.require 'Bitmap'
goog.require 'Ticker'
goog.require 'box2d.Util'
goog.require 'box2d.AABB'
goog.require 'box2d.World'
goog.require 'goog.math.Rect'
goog.require 'box2d.BoxDef'
goog.require 'box2d.BodyDef'
goog.require 'goog.math.Vec2'
goog.require 'goog.math.Rect'

###
@ constructor
@ param {!HTMLCanvasElement} canvas
###
class Application
  constructor: (@canvas) ->
    this._stage = new Stage(@canvas)


    this._boundingBox = this._createBoundingBox()
    this._world = this._createWorld()
    this._shape = this._createShape()
    this._stage.addChild(this._shape)
    this._addWalls()

    Ticker.addListener(this)

  _createBoundingBox: () ->
    currentRect = new goog.math.Rect(0, 0, this.canvas.width, this.canvas.height)
    box = currentRect.toBox()
    return box.expand(Application._extent, Application._extent, Application._extent, Application._extent)

  _createWorld: () ->
    worldAABB = new box2d.AABB()
    worldAABB.minVertex.Set(this._boundingBox.left, this._boundingBox.top)
    worldAABB.maxVertex.Set(this._boundingBox.right, this._boundingBox.bottom)
    return new box2d.World(worldAABB, Application._gravity, true)

  _createShape: () ->
    image = new Image()
    image.src = Application._imageSrc
    shape = new Bitmap(image)
    shape.regX = Application._imgWidth / 2
    shape.regY = Application._imgHeight / 2

    bodyDef = new box2d.BoxDef()
    bodyDef.extents.Set(Application._imgWidth / 2, Application._imgHeight / 2)
    bodyDef.density = 0.0002
    bodyDef.restitution = 1
    bodyDef.friction = 0.5

    boxBd = new box2d.BodyDef()
    boxBd.AddShape(bodyDef)
    boxBd.position.Set(320, 240)
    boxBd.rotation = Math.PI / 2
    boxBd.angularVelocity = 2

    shape._body = this._world.CreateBody(boxBd)
    return shape

  _addWalls: () ->
    this._addWall(new goog.math.Rect(0, 480, 640, 10))
    this._addWall(new goog.math.Rect(-10, 0, 10, 480))
    this._addWall(new goog.math.Rect(640, 0, 10, 480))
    return

  _addWall: (rect) ->
    bodyDef = new box2d.BoxDef()
    bodyDef.extents.Set(rect.width / 2, rect.height / 2)
    bodyDef.restitution = 1
    bodyDef.friction = 0.5

    boxBd = new box2d.BodyDef()
    boxBd.AddShape(bodyDef)
    boxBd.position.Set(rect.left + rect.width / 2, rect.top + rect.height / 2)
    return

  tick: () ->
    this._updateShape()
    this._stage.update()
    return

  _updateShape: () ->
    this._world.Step(1/10, 1)
    s = this._shape
    s.x = s._body.m_position.x
    s.y = s._body.m_position.y
    s.rotation = goog.math.toDegrees(s._body.m_rotation)
    return

Application._imageSrc = '../images/pixellab_cropped.png'
Application._imgWidth = 119
Application._imgHeight = 95
Application._extent = 100
Application._gravity = new goog.math.Vec2(0, 10)
