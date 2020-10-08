extends Node

signal press_back


func _on_Back_button_down():
	emit_signal("press_back")
