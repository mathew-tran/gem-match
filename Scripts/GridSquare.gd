extends TextureRect

var CurrentValue = Definitions.GEM_TYPE.NONE

func _on_button_mouse_entered():
	$Highlight.visible = true

func _on_button_mouse_exited():
	$Highlight.visible = false



func _on_area_2d_area_entered(area):
	$Highlight.visible = true



func _on_area_2d_area_exited(area):
	$Highlight.visible = false

