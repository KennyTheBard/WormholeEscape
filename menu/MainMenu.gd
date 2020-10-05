extends Control

onready var timer : Timer = $Timer
onready var brightness_slider : HSlider = $BrightnessSlider
onready var sound_slider : HSlider = $BrightnessSlider


func _ready():
	save_system.load_settings()
	brightness_slider.value = settings.star_brightness
	sound_slider.value = settings.master_volume


func _process(delta):
	if Input.is_action_just_pressed("advance"):
		get_tree().change_scene_to(load("res://scenes/Wormhole.tscn"))
	if Input.is_action_just_pressed("pause"):
		get_tree().quit()


func _on_BrightnessSlider_value_changed(value):
	settings.star_brightness = value
	print(settings.star_brightness)
	timer.start(1)


func _on_SoundSlider_value_changed(value):
	settings.master_volume = value
	print(settings.master_volume)
	timer.start(1)


func _on_Timer_timeout():
	save_system.save_settings()
