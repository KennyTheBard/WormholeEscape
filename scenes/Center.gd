extends Position2D

onready var clockwise : Sprite = $Clockwise
onready var counter_clockwise : Sprite = $CounterClockwise
onready var clockwise_tween : Tween = $Clockwise/Tween
onready var counter_clockwise_tween : Tween = $CounterClockwise/Tween
onready var scale_up_tween : Tween = $ScaleUpTween
onready var scale_down_tween : Tween = $ScaleDownTween

func _ready():
	# start rotating clockwise component
	clockwise_tween.interpolate_property(clockwise, "rotation", 0, 2 * PI, 2.5)
	clockwise_tween.start()
	
	# start rotating counterclockwise component
	counter_clockwise_tween.interpolate_property(counter_clockwise, "rotation", 0, -2 * PI, 2.5)
	counter_clockwise_tween.start()
	
	# start animating scaling circulary
	_on_ScaleDownTween_tween_completed(null, null)


func _on_ScaleDownTween_tween_completed(object, key):
	scale_up_tween.interpolate_property(self, "scale",
		Vector2(1, 1), Vector2(1.5, 1.5), 0.75,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.25)
	scale_up_tween.start()


func _on_ScaleUpTween_tween_completed(object, key):
	scale_down_tween.interpolate_property(self, "scale",
		Vector2(1.5, 1.5), Vector2(1, 1), 0.75,
		Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 0.25)
	scale_down_tween.start()
