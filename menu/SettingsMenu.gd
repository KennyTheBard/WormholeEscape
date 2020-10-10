extends Node

signal press_back

export(float) var update_settings_file_delay : float = 1.0

onready var timer : Timer = $Timer

onready var brightness_slider : HSlider = $Brightness/BrightnessSlider
onready var brightness_label : Label = $Brightness/Value

onready var master_slider : HSlider = $Master/MasterSlider
onready var master_label : Label = $Master/Value

onready var music_slider : HSlider = $Music/MusicSlider
onready var music_label : Label = $Music/Value

onready var sound_slider : HSlider = $Sound/SoundSlider
onready var sound_label : Label = $Sound/Value

onready var difficulty_slider : HSlider = $Difficulty/DifficultySlider
onready var difficulty_label : Label = $Difficulty/Value

onready var high_contrast_mode_checkbox : CheckBox = $HighContrast/CheckBox

# because the fact that preloading is done at compilation,
# you cannot preload cyclic dependencies
onready var wormhole_scene : PackedScene = load("res://scenes/Wormhole.tscn")


func _ready():
	brightness_slider.value = settings.star_brightness
	master_slider.value = settings.master_volume
	music_slider.value = settings.music_volume
	sound_slider.value = settings.sfx_volume
	difficulty_slider.value = settings.difficulty
	high_contrast_mode_checkbox.pressed = settings.high_contrast_mode


func _on_Timer_timeout():
	save_system.save_settings()


func _on_BrightnessSlider_value_changed(value):
	settings.star_brightness = value
	brightness_label.text = str(int(value * 100)) + "%"
	timer.start(1)


func _on_MasterSlider_value_changed(value):
	settings.master_volume = value
	master_label.text = str(int(value * 100)) + "%"
	timer.start(1)


func _on_MusicSlider_value_changed(value):
	settings.music_volume = value
	music_label.text = str(int(value * 100)) + "%"
	timer.start(1)


func _on_SoundSlider_value_changed(value):
	settings.sfx_volume = value
	sound_label.text = str(int(value * 100)) + "%"
	timer.start(1)


func _on_DifficultySlider_value_changed(value):
	settings.difficulty = value
	if value == settings.SLOW:
		difficulty_label.text = "SLOW"
	elif value == settings.SLOW:
		difficulty_label.text = "SLOW"
	elif value == settings.NORMAL:
		difficulty_label.text = "NORMAL"
	elif value == settings.FAST:
		difficulty_label.text = "FAST"
	else:
		difficulty_label.text = "FASTEST"
	timer.start(1)


func _on_Back_button_down():
	save_system.save_settings()
	emit_signal("press_back")


func _on_CheckBox_toggled(button_pressed):
	settings.high_contrast_mode = button_pressed
	timer.start(1)
