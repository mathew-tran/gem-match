extends Control


func _input(event):
	if event.is_action_pressed("click") or Game.IsMobileEvent(event):
		global_position = get_global_mouse_position() - Vector2(64, 64)
		$AnimationPlayer.stop()
		$AnimationPlayer.play("anim")
