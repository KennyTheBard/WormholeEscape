extends TextureProgress

onready var attacker_icon : TextureRect = $AttackerIcon


func _process(delta):
	var upper_value = margin_top
	var lower_value = margin_bottom
	var new_y = lerp(lower_value, upper_value, value * 1.0 / max_value)
	attacker_icon.rect_position = Vector2(attacker_icon.rect_position.x, new_y - rect_position.y + 20)
	print(attacker_icon.rect_position)
