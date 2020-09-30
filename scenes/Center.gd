extends Position2D

onready var clockwise : Sprite = $Clockwise
onready var counter_clockwise : Sprite = $CounterClockwise
onready var clockwise_tween : Tween = $Clockwise/Tween
onready var counter_clockwise_tween : Tween = $CounterClockwise/Tween


func _ready():
	clockwise_tween.interpolate_property(clockwise, "rotation", 0, 2 * PI, 2.5)
	clockwise_tween.start()
	
	counter_clockwise_tween.interpolate_property(counter_clockwise, "rotation", 0, -2 * PI, 2.5)
	counter_clockwise_tween.start()
