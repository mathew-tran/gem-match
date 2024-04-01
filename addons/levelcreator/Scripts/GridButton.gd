@tool

extends Button




var Index = LCDEFS.TYPES.EMPTY

var bIsHovered = false

var InternalIndex = LCDEFS.TYPES.EMPTY

func _on_pressed():
	Increment()

func Increment():

	Index += 1
	if Index > len(LCDEFS.TYPES.keys()) - 1:
		Index = 0

	if Index == LCDEFS.TYPES.RANDOM:
		text = "R"
	else:
		text = str(Index)
	release_focus()

func SetIndex(index):
	Index = index
	if Index == LCDEFS.TYPES.RANDOM:
		text = "R"
	else:
		text = str(Index)

func _input(event):
	if is_visible_in_tree():
		if bIsHovered:
			if event.is_action_pressed("ui_accept", true):
				SetIndex(InternalIndex)
func _on_mouse_entered():
	bIsHovered = true


func _on_mouse_exited():
	bIsHovered = false
