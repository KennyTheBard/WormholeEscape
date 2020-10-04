extends Node

var highscore_filename : String = "highscore.dat"


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
