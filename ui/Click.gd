extends Control

func _on_Timer_timeout():
	$Clicked.visible = not $Clicked.visible
	$Unclicked.visible = not $Unclicked.visible
