extends Button



func _on_button_up():
	Game.Restart()
	get_tree().reload_current_scene()
