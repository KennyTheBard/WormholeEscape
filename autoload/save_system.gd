extends Node

var highscore_filename : String = "highscore.dat"
var settings_filename : String = "settings.dat"


func save_score(score : int):
	var file = File.new()
	file.open("user://" + highscore_filename, File.WRITE)
	file.store_32(score)
	file.close()


func load_score() -> int:
	var highscore : int = 0
	var file = File.new()
	if file.open("user://" + highscore_filename, File.READ) == OK:
		highscore = file.get_32()
		file.close()
	return highscore


func save_settings():
	var file = File.new()
	file.open("user://" + settings_filename, File.WRITE)
	var data = JSON.print({
		"star_brightness": settings.star_brightness,
		"master_volume": settings.master_volume,
		"music_volume": settings.music_volume,
		"sfx_volume": settings.sfx_volume,
		"difficulty": settings.difficulty
	})
	file.store_line(data)
	file.close()


func load_settings():
	var file = File.new()
	if file.open("user://" + settings_filename, File.READ) == OK:
		var data = JSON.parse(file.get_line())
		settings.star_brightness = data.result.get("star_brightness", 1)
		settings.master_volume = data.result.get("master_volume", 1)
		settings.music_volume = data.result.get("music_volume", 1)
		settings.sfx_volume = data.result.get("sfx_volume", 1)
		settings.difficulty = data.result.get("difficulty", settings.NORMAL)
		file.close()
