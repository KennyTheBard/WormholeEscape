extends Label

var colors : Array = [
	Color(1, 1, 1),
	Color(1, 0.5, 0)
]
var color_index : int = 0


func _ready():
	change_color()


func change_color():
	add_color_override("font_color", colors[color_index % colors.size()])


func show():
	visible = true


func _on_ColorTimer_timeout():
	color_index += 1
	change_color()
