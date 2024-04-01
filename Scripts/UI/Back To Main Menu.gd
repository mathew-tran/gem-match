extends Button

var bDoublePrompt = false

func _on_button_up():
	if bDoublePrompt == false:
		bDoublePrompt = true
		$Timer.start()
		$Label.visible = true
	else:
		get_tree().change_scene_to_file("res://Scenes/Title.tscn")


func _on_timer_timeout():
	bDoublePrompt = false
	$Label.visible = false
