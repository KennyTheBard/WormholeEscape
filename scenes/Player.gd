extends Area2D

signal died
signal collected_coin

export(NodePath) var look_to_path

onready var look_to : Node2D = get_node(look_to_path)

onready var thrusters : Particles2D = $Thrusters

func _process(delta):
	if look_to:
		var angle = look_to.global_position.angle_to_point(global_position)
		rotation = angle


func toggle_thrusters(activate : bool):
	thrusters.emitting = activate


func _on_Player_area_entered(area):
	if area.get_collision_layer_bit(2):
		emit_signal("died")
	
	if area.get_collision_layer_bit(3):
		emit_signal("collected_coin")
		area.queue_free()
