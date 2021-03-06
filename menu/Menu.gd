extends Control

onready var wormhole_scene : PackedScene = load("res://scenes/Wormhole.tscn")

onready var main_menu_scene : PackedScene = preload("res://menu/MainMenu.tscn")
onready var settings_menu_scene : PackedScene = preload("res://menu/SettingsMenu.tscn")
onready var credits_scene : PackedScene = preload("res://menu/Credits.tscn")

func _ready():
	return_to_main_menu()


func _on_MainMenu_press_play():
	get_tree().change_scene_to(wormhole_scene)


func _on_MainMenu_press_settings():
	var instance = add_submenu_instance(settings_menu_scene)
	instance.connect("press_back", self, "return_to_main_menu")


func _on_MainMenu_press_credits():
	var instance = add_submenu_instance(credits_scene)
	instance.connect("press_back", self, "return_to_main_menu")


func _on_MainMenu_press_exit():
	get_tree().quit()


func return_to_main_menu():
	var instance = add_submenu_instance(main_menu_scene)
	instance.connect("press_play", self, "_on_MainMenu_press_play")
	instance.connect("press_settings", self, "_on_MainMenu_press_settings")
	instance.connect("press_credits", self, "_on_MainMenu_press_credits")
	instance.connect("press_exit", self, "_on_MainMenu_press_exit")


func add_submenu_instance(scene : PackedScene):
	var instance = scene.instance()
	instance.name = "SettingsMenu"
	for child in $Submenu.get_children():
		$Submenu.remove_child(child)
	$Submenu.add_child(instance)
	return instance
