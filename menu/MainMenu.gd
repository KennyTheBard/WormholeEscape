extends Node

signal press_play
signal press_settings
signal press_credits
signal press_exit


func _on_Play_button_down():
	emit_signal("press_play")


func _on_Settings_button_down():
		emit_signal("press_settings")


func _on_Credits_button_down():
		emit_signal("press_credits")


func _on_Exit_button_down():
		emit_signal("press_exit")
