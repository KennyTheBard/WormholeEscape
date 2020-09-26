extends Node2D

export(int) var point_count = 10000

onready var radius_tween : Tween = $RadiusTween

var radius : float = 0
var image : Image = Image.new()
var texture : ImageTexture = ImageTexture.new()
var ring_rotation : float = 0

var bomb_positions : Array = [275, 325, 355]


# Called when the node enters the scene tree for the first time.
func _ready():
	radius_tween.interpolate_property(self, "radius", 0, 1000, 2, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	radius_tween.start()
	image.load("res://icon.png")
	texture.create_from_image(image)


func _process(delta):
	ring_rotation += delta * 60
	update()


func _draw():
	draw_arc(position, radius, 0, 360, point_count, Color.white, 1, true)
	
	for pos in bomb_positions:
		var radians = deg2rad(pos + ring_rotation)
		var bomb_position = position + Vector2(cos(radians), -sin(radians)) * radius
		var bomb_size = Vector2(radius / 15, radius / 15)
		draw_texture_rect(texture, Rect2(bomb_position - bomb_size/2, bomb_size), false)
	
