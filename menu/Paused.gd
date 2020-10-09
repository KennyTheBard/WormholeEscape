extends Control

signal back_to_main_menu

func _on_Button_button_down():
	emit_signal("back_to_main_menu")
