extends Node

enum {
	SLOW = 1,
	NORMAL = 2,
	FAST = 3
}

var star_brightness : float = 1
var master_volume : float = 1
var difficulty : int = NORMAL


func get_difficulty_modifier() -> float:
	if difficulty == settings.SLOW:
		return 0.5
	elif difficulty == settings.NORMAL:
		return 1.0
	else :
		return 1.5
