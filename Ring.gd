extends Node2D

export(int) var point_count = 10000
export(float) var ring_rotation_ps = 60

onready var radius_tween : Tween = $RadiusTween

var radius : float = 0
var ring_rotation : float = 0

var image : Image = Image.new()
var texture : ImageTexture = ImageTexture.new()

var bomb_positions : Array = [275, 325, 355]


# Called when the node enters the scene tree for the first time.
func _ready():
	image.load("res://icon.png")
	texture.create_from_image(image)


func _process(delta):
	ring_rotation += delta * ring_rotation_ps
	update()


func _draw():
	draw_arc(Vector2(), radius, 0, 360, point_count, Color.white, 1, true)
	
	for pos in bomb_positions:
		var radians = deg2rad(pos + ring_rotation)
		var bomb_position = Vector2(cos(radians), -sin(radians)) * radius
		var bomb_size = Vector2(radius / 15, radius / 15)
		draw_texture_rect(texture, Rect2(bomb_position - bomb_size/2, bomb_size), false)


func increase_radius(radius : float, transition_period : float = 1.0) -> void:
	radius_tween.interpolate_property(self, "radius", self.radius, radius, transition_period, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	radius_tween.start()
