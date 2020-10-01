extends Node2D

signal dead_effect_ended

export(float) var effect_duration = 1.2

onready var transparency_tween : Tween = $TransparencyTween
onready var radius_tween : Tween = $RadiusTween
onready var timer : Timer = $Timer

var radius : float
var circle_color : Color
var playing : bool = false


func play_effect():
	# set transparency tween
	transparency_tween.interpolate_property(self, "circle_color", Color(1, 1, 1, 1), Color(1, 1, 1, 0),
		effect_duration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	transparency_tween.start()
	
	# set radius tween
	radius_tween.interpolate_property(self, "radius", 20, 200,
		effect_duration, Tween.TRANS_CIRC, Tween.EASE_OUT)
	radius_tween.start()
	
	# start playing
	playing = true
	timer.start(effect_duration)


func _process(delta):
	if playing:
		update()


func _draw():
	draw_circle(Vector2(), radius, circle_color)


func _on_Timer_timeout():
	playing = false
	emit_signal("dead_effect_ended")
	update()
