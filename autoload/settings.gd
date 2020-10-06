extends Node

enum {
	SLOW = 1,
	NORMAL = 2,
	FAST = 3
}

var star_brightness : float = 1
var master_volume : float = 1 setget set_master_volume
var difficulty : int = NORMAL


func get_difficulty_modifier() -> float:
	if difficulty == settings.SLOW:
		return 0.5
	elif difficulty == settings.NORMAL:
		return 1.0
	else :
		return 1.5


func set_master_volume(value : float):
	master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -52.0 * (1.0 - value) * (1.0 - value))
