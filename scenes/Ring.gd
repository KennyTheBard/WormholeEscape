extends Node2D

export(int) var point_count = 10000
export(float) var scaling_factor = 0.0035

onready var radius_tween : Tween = $RadiusTween

const bomb_scene = preload("res://scenes/Bomb.tscn")

var radius : float = 8 setget set_radius
var ring_rotation : float = 0
var ring_rotation_ps : float = 0
var rotating : bool = true

var bombs : Dictionary = {}


func _process(delta):
	if rotating:
		ring_rotation = int(ring_rotation + delta * ring_rotation_ps) % 360
	update()


func _draw():
	draw_arc(Vector2(), radius, 0, 360, point_count, Color.white, 1, true)


func create_bombs(bomb_positions : Array):
	for pos in bomb_positions:
		var instance = bomb_scene.instance()
		bombs[pos] = instance
		add_child(instance)
		update_bombs()


func calculate_position_on_ring(degree : float) -> Vector2:
	var radians = deg2rad(degree)
	return Vector2(cos(radians), -sin(radians)) * radius


func increase_radius(radius : float, transition_period : float = 1.0) -> void:
	radius_tween.interpolate_property(self, "radius", self.radius, radius,
		transition_period, Tween.TRANS_QUAD, Tween.EASE_IN)
	radius_tween.start()


func set_radius(new_radius : float):
	radius = new_radius
	update_bombs()


func update_bombs():
	for bomb_position in bombs.keys():
		var bomb = bombs.get(bomb_position)
		bomb.position = calculate_position_on_ring(bomb_position)
		bomb.scale = Vector2(radius * scaling_factor, radius * scaling_factor)
