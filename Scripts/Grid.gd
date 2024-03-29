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
	CheckRow(gridPiece.GetRow())
	CheckColumn(gridPiece.GetColumn())

func CheckRow(rowNum):
	print("Checking Row.. " + str(rowNum))
	pass

func CheckColumn(colNum):
	print("Checking Column.. " + str(colNum))
	pass
