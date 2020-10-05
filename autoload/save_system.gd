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
		"master_volume": settings.master_volume
	})
	file.store_line(data)
	print("SAVED: ", data)
	file.close()


func load_settings():
	var file = File.new()
	if file.open("user://" + settings_filename, File.READ) == OK:
		var data = JSON.parse(file.get_line())
		print("LOADED: ", data.result)
		settings.star_brightness = data.result["star_brightness"]
		settings.master_volume = data.result["master_volume"]
		print(settings.star_brightness, settings.master_volume)
		file.close()
