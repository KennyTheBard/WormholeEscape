extends Node2D

export(int) var point_count = 10000
export(float) var ring_rotation_ps = 60

onready var radius_tween : Tween = $RadiusTween

var radius : float = 0
var ring_rotation : float = 0

var bomb_positions : Array
var bomb_texture : ImageTexture


func init(bomb_texture : ImageTexture, bomb_positions : Array = []):
	self.bomb_texture = bomb_texture
	self.bomb_positions = bomb_positions


func _process(delta):
	ring_rotation += delta * ring_rotation_ps
	update()


func _draw():
	draw_arc(Vector2(), radius, 0, 360, point_count, Color.white, 1, true)
	
	for pos in bomb_positions:
		var radians = deg2rad(pos + ring_rotation)
		var bomb_position = Vector2(cos(radians), -sin(radians)) * radius
		var bomb_size = Vector2(radius / 15, radius / 15)
		draw_texture_rect(bomb_texture, Rect2(bomb_position - bomb_size/2, bomb_size), false)


func increase_radius(radius : float, transition_period : float = 1.0) -> void:
	radius_tween.interpolate_property(self, "radius", self.radius, radius, transition_period, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	radius_tween.start()
