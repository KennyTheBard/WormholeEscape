extends "res://entities/Entity.gd"

onready var attacker_position : Vector2 = global_position
onready var variation : float = (rand_range(10, 100) + rand_range(10, 100)) * sign(randf())


func _process(delta):
	look_to_target()
