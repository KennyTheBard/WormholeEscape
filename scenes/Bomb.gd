extends Area2D

onready var scale_down_tween : Tween = $ScaleDownTween
onready var scale_up_tween : Tween = $ScaleUpTween
onready var rotation_tween : Tween = $RotationTween
onready var sprite : Sprite = $Star

var angle_on_ring : float = 0

func _ready():
	rotation_tween.interpolate_property(sprite, "rotation", 0, -2 * PI, 5)
	rotation_tween.start()
	
	_on_ScaleUpTween_tween_completed(null, null)


func _on_ScaleDownTween_tween_completed(object, key):
	scale_up_tween.interpolate_property(sprite, "scale",
		Vector2(0.5, 0.5), Vector2(1, 1), 0.75,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.25)
	scale_up_tween.start()


func _on_ScaleUpTween_tween_completed(object, key):
	scale_down_tween.interpolate_property(sprite, "scale",
		Vector2(1, 1), Vector2(0.5, 0.5), 0.75,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0)
	scale_down_tween.start()
