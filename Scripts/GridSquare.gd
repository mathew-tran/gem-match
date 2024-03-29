extends TextureRect

var CurrentValue = Definitions.GEM_TYPE.NONE

func _on_button_mouse_entered():
	$Highlight.visible = true

func _on_button_mouse_exited():
	$Highlight.visible = false

