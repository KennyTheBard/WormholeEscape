extends Control

onready var timer : Timer = $Timer

onready var brightness_slider : HSlider = $Brightness/BrightnessSlider
onready var brightness_label : Label = $Brightness/Value

onready var sound_slider : HSlider = $Sound/SoundSlider
onready var sound_label : Label = $Sound/Value

onready var difficulty_slider : HSlider = $Difficulty/DifficultySlider
onready var difficulty_label : Label = $Difficulty/Value

# because the fact that preloading is done at compilation,
# you cannot preload cyclic dependencies
onready var wormhole_scene : PackedScene = load("res://scenes/Wormhole.tscn")

func _ready():
	save_system.load_settings()
	brightness_slider.value = settings.star_brightness
	sound_slider.value = settings.master_volume
	difficulty_slider.value = settings.difficulty


func _process(delta):
	if Input.is_action_just_pressed("advance"):
		save_system.save_settings()
		get_tree().change_scene_to(wormhole_scene)
	if Input.is_action_just_pressed("pause"):
		save_system.save_settings()
		get_tree().quit()


func _on_Timer_timeout():
	save_system.save_settings()


func _on_BrightnessSlider_value_changed(value):
	settings.star_brightness = value
	brightness_label.text = str(int(value * 100)) + "%"
	timer.start(1)


func _on_SoundSlider_value_changed(value):
	settings.master_volume = value
	sound_label.text = str(int(value * 100)) + "%"
	timer.start(1)


func _on_DifficultySlider_value_changed(value):
	settings.difficulty = value
	if value == settings.SLOW:
		difficulty_label.text = "SLOW"
	elif value == settings.NORMAL:
		difficulty_label.text = "NORMAL"
	else :
		difficulty_label.text = "FAST"
	timer.start(1)
