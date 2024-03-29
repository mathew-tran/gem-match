extends VBoxContainer


func _ready():
	InitializeGrid()

func InitializeGrid():
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			pass
