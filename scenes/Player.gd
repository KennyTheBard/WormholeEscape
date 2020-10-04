extends Area2D

signal died
signal collected_coin
signal game_over

export(NodePath) var look_to_path

onready var look_to : Node2D = get_node(look_to_path)

onready var sprite : Sprite = $Sprite
onready var thrusters : Particles2D = $Thrusters
onready var dead_effect : Node2D = $DeadEffect

func _process(delta):
	if look_to:
		var angle = look_to.global_position.angle_to_point(global_position)
		rotation = angle


func toggle_thrusters(activate : bool):
	thrusters.emitting = activate


func _on_Player_area_entered(area):
	# wall or bomb collision
	if area.get_collision_layer_bit(1) or area.get_collision_layer_bit(2):
		emit_signal("died")
		sprite.visible = false
		dead_effect.play_effect()
	
	# coin collision
	if area.get_collision_layer_bit(3):
		emit_signal("collected_coin")
		area.delete()


func _on_DeadEffect_dead_effect_ended():
	emit_signal("game_over")
