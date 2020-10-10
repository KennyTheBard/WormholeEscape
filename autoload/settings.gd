extends Node

enum {
	SLOWEST = 1,
	SLOW = 2,
	NORMAL = 3,
	FAST = 4,
	FASTEST = 5
}

var star_brightness : float = 1
var master_volume : float = 1 setget set_master_volume
var music_volume : float = 1 setget set_music_volume
var sfx_volume : float = 1 setget set_sfx_volume
var difficulty : int = NORMAL
var high_contrast_mode : bool = false


func get_difficulty_modifier() -> float:
	if difficulty == settings.SLOWEST:
		return 0.25
	elif difficulty == settings.SLOW:
		return 0.5
	elif difficulty == settings.NORMAL:
		return 1.0
	elif difficulty == settings.FAST:
		return 1.5
	else :
		return 2.0


func set_master_volume(value : float):
	master_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), -75.0 * (1.0 - value) * (1.0 - value))


func set_music_volume(value : float):
	music_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Music"), -75.0 * (1.0 - value) * (1.0 - value))


func set_sfx_volume(value : float):
	sfx_volume = value
	AudioServer.set_bus_volume_db(AudioServer.get_bus_index("SFX"), -75.0 * (1.0 - value) * (1.0 - value))
