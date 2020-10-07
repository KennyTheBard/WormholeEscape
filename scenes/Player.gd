extends Area2D

signal died
signal collected_coin
signal game_over

export(NodePath) var look_to_path

onready var look_to : Node2D = get_node(look_to_path)

onready var sprite : Sprite = $Sprite
onready var thrusters : Particles2D = $Thrusters
onready var dead_effect : Node2D = $DeadEffect
onready var radius_tween : Tween = $RadiusTween
onready var rotation_tween : Tween = $RotationTween
onready var color_tween : Tween = $ColorTween

var target_radius : float = 100
var target_rotation : float = randf()
var color : Color
var died : bool = false

func _ready():
	radius_tween.interpolate_property(self, "target_radius", 500, 50, 1.25,
		Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	radius_tween.start()
	
	rotation_tween.interpolate_property(self, "target_rotation",
		target_rotation, target_rotation + 2 * PI, 0.8)
	rotation_tween.start()
	
	color_tween.interpolate_property(self, "color", Color(0, 0.75, 0.75, 0),
		Color(0, 0.75, 0.75, 1), 0.15, Tween.TRANS_LINEAR, Tween.EASE_IN, 0)
	color_tween.start()


func _draw():
	if died:
		return
	
	draw_arc(Vector2(), target_radius,
		0 + target_rotation, PI - deg2rad(45) + target_rotation,
		200, color, 1, true)
	draw_arc(Vector2(), target_radius,
		PI + target_rotation, 2 * PI - deg2rad(45) + target_rotation,
		200, color, 1, true)


func _process(delta):
	update()
	if look_to:
		var angle = look_to.global_position.angle_to_point(global_position)
		rotation = angle


func toggle_thrusters(activate : bool):
	thrusters.emitting = activate
	toggle_collision(activate)


func toggle_collision(activate : bool):
	set_collision_layer_bit(1, activate)
	set_collision_layer_bit(2, activate)
	set_collision_layer_bit(3, activate)


func _on_Player_area_entered(area):
	# destoyed ships cannot collide with other objects
	if died:
		return
	
	# wall or bomb collision
	if area.get_collision_layer_bit(1) or area.get_collision_layer_bit(2):
		emit_signal("died")
		died = true
		sprite.visible = false
		dead_effect.play_effect()
		toggle_thrusters(false)
	
	# coin collision
	if area.get_collision_layer_bit(3):
		emit_signal("collected_coin")
		area.delete()


func _on_DeadEffect_dead_effect_ended():
	emit_signal("game_over")

