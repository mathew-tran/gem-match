@tool

extends Button


enum TYPES {
	EMPTY,
	GEM_1,
	GEM_2,
	GEM_3,
	GEM_4,
	GEM_5,
	RANDOM
}

var Index = TYPES.EMPTY

func _on_button_up():
	Index += 1
	if Index > len(TYPES.keys()) - 1:
		Index = 0

	if Index == TYPES.RANDOM:
		text = "R"
	else:
		text = Index

