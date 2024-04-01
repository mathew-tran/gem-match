@tool
extends EditorPlugin

var Dock

func _enter_tree():
	Dock = preload("res://addons/levelcreator/LevelCreatorDock.tscn").instantiate()
	add_control_to_bottom_panel(Dock, "LevelCreator")


func _exit_tree():
	remove_control_from_bottom_panel(Dock)
	Dock.queue_free()
