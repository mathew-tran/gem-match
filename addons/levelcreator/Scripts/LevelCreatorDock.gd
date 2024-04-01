@tool

extends Control

class_name LevelCreatorRoot
@onready var Tiles = $HBoxContainer/VBoxContainer2/Tiles
func _ready():
	add_to_group("LCCreator")
	$HBoxContainer/VBoxContainer2/HBoxContainer3/BrushButton.connect("UpdateBrush", Callable(self, "OnUpdateBrush"))

func OnUpdateBrush(index):
	print("brushUpdate")
	for row in Tiles.get_children():
		for element in row.get_children():
			element.InternalIndex = index
