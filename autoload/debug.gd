extends Node


var debug_mode_active : bool = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("activate_debug"):
		debug_mode_active = not debug_mode_active
		print(debug_mode_active)


func is_active() -> bool:
	return debug_mode_active
