@tool

extends Control

class_name LevelCreatorRoot


@onready var Tiles = $HBoxContainer/VBoxContainer2/Tiles
@onready var Line = $HBoxContainer/VBoxContainer2/HBoxContainer4/LineEdit
@onready var Dialog = $FileDialog
var save_path = "res://LevelContent/Easy/1.tres"

func _ready():
	add_to_group("LCCreator")
	$HBoxContainer/VBoxContainer2/HBoxContainer3/BrushButton.connect("UpdateBrush", Callable(self, "OnUpdateBrush"))

func OnUpdateBrush(index):
	for row in Tiles.get_children():
		for element in row.get_children():
			element.InternalIndex = index

func Save():
	var tiles = []
	for row in Tiles.get_children():
		for element in row.get_children():
			tiles.append(element.Index)

	var data = LevelResource.new()
	data.LevelData = tiles


	var file = ResourceSaver.save(data, GetFileName())


func _on_save_button_button_up():
	Save()

func GetFileName():
	return Line.text + ".tres"

func _on_load_button_button_up():
	Dialog.popup_centered()



func _on_new_button_button_up():
	for row in Tiles.get_children():
		for element in row.get_children():
			element.SetIndex(LCDEFS.TYPES.EMPTY)



func _on_file_dialog_confirmed():
	Line.text = ""
	pass # Replace with function body.


func _on_file_dialog_file_selected(path):
	Line.text = path.split(".tres")[0]
	var save_path = GetFileName()
	if FileAccess.file_exists(save_path):
		var data = load(save_path) as LevelResource

		var tiles = data.LevelData
		var index = 0
		for row in Tiles.get_children():
			for element in row.get_children():
				element.SetIndex(tiles[index])
				index += 1
