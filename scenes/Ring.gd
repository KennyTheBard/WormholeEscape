extends Node2D

export(int) var point_count = 10000

onready var radius_tween : Tween = $RadiusTween

var radius : float = 8
var ring_rotation : float = 0
var ring_rotation_ps : float = 0

var bomb_positions : Array = []
var bomb_texture : ImageTexture


func init(bomb_texture : ImageTexture):
	self.bomb_texture = bomb_texture


func _process(delta):
	ring_rotation = int(ring_rotation + delta * ring_rotation_ps) % 360
	update()


func _draw():
	draw_arc(Vector2(), radius, 0, 360, point_count, Color.white, 1, true)
	
	for pos in bomb_positions:
		var bomb_position = calculate_position_on_ring(pos + ring_rotation)
		var bomb_size = Vector2(radius / 12, radius / 12)
		draw_texture_rect(bomb_texture,
			Rect2(bomb_position - bomb_size/2, bomb_size),
			false,
			Color.red)


func calculate_position_on_ring(degree : float) -> Vector2:
	var radians = deg2rad(degree)
	return Vector2(cos(radians), -sin(radians)) * radius


func increase_radius(radius : float, transition_period : float = 1.0) -> void:
	radius_tween.interpolate_property(self, "radius", self.radius, radius,
		transition_period, Tween.TRANS_QUAD, Tween.EASE_IN)
	radius_tween.start()
