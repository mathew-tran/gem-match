@tool
extends Button

@export var Index = LCDEFS.TYPES.EMPTY

signal UpdateBrush(index)

func _ready():
	if Index == LCDEFS.TYPES.RANDOM:
		text = "R"
	else:
		text = str(Index)

func UpdateBrushClick():
	emit_signal("UpdateBrush", Index)
	release_focus()


func _on_button_down():
	UpdateBrushClick()

