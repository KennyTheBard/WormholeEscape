extends KinematicBody2D

export(NodePath) var look_to_path

onready var look_to : Node2D = get_node(look_to_path)

onready var thrusters : Particles2D = $Thrusters

func _process(delta):
	if look_to:
		var angle = look_to.global_position.angle_to_point(global_position)
		rotation = angle


func toggle_thrusters(activate : bool):
	thrusters.emitting = activate
