extends Control

func _on_Timer_timeout():
	$Space.visible = not $Space.visible
	$Unspace.visible = not $Unspace.visible
