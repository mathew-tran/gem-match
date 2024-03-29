extends VBoxContainer


func _ready():
	InitializeGrid()

func InitializeGrid():
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			get_child(row).get_child(column).Setup(row, column)
			get_child(row).get_child(column).connect("Slotted", Callable(self, "OnGemSlotted"))


func OnGemSlotted(gridPiece):
	print(gridPiece.GetString() + " filled")
	CheckRow(gridPiece)
	CheckColumn(gridPiece)

func CheckRow(gridPiece):
	print("Checking Row..")
	var consecutive = []
	var consecutiveType = Definitions.GEM_TYPE.NONE
	for gridSquare in get_child(gridPiece.GetRow()).get_children():
		if gridSquare.IsEmpty() == false:
			if consecutiveType == gridSquare.GetGemType():
				consecutive.append(gridSquare)
				if len(consecutive) >= 5:
					for grid in consecutive:
						grid.GemRef.queue_free()
			else:
				consecutive.clear()
				consecutive.append(gridSquare)
				consecutiveType = gridSquare.GetGemType()

func CheckColumn(gridPiece):
	print("Checking Column..")
	var consecutive = []
	var consecutiveType = Definitions.GEM_TYPE.NONE
	for column in get_children():
		var gridSquare = column.get_child(gridPiece.GetColumn())
		if gridSquare.IsEmpty() == false:
			if consecutiveType == gridSquare.GetGemType():
				consecutive.append(gridSquare)
				if len(consecutive) >= 5:
					for grid in consecutive:
						grid.GemRef.queue_free()
			else:
				consecutive.clear()
				consecutive.append(gridSquare)
				consecutiveType = gridSquare.GetGemType()
