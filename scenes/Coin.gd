extends "res://scenes/Bomb.gd"

onready var collision_shape : CollisionShape2D = $CollisionShape2D
onready var dead_effect = $DeadEffect


func delete():
	sprite.visible = false
	collision_shape.set_deferred("disabled", true)
	dead_effect.play_effect()


func _on_DeadEffect_dead_effect_ended():
	queue_free()
