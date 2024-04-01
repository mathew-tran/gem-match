extends Button


func _on_button_up():
	print("pressed")
	release_focus()

func _input(event):
	if event.is_action_released("escape"):
		if get_tree().paused == false:
			emit_signal("button_up")
