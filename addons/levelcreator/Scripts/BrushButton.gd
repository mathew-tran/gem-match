@tool
extends Button

var Index = LCDEFS.TYPES.EMPTY

signal UpdateBrush(index)

func Increment():
	Index += 1
	if Index > len(LCDEFS.TYPES.keys()) - 1:
		Index = 0

	if Index == LCDEFS.TYPES.RANDOM:
		text = "R"
	else:
		text = str(Index)

	emit_signal("UpdateBrush", Index)
	release_focus()

func _on_button_down():
	Increment()

