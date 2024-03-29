extends VBoxContainer

var Width = -1
var Height = -1

func _ready():
	InitializeGrid()
	add_to_group("GRID")

func CheckGrid():
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			OnSquareCheck(get_child(row).get_child(column))

func InitializeGrid():
	Width = len(get_children())
	Height = len(get_child(0).get_children())
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			get_child(row).get_child(column).Setup(row, column)
			get_child(row).get_child(column).connect("Slotted", Callable(self, "OnGemPlaced"))

func IsPieceTheSameType(pieceA, pieceB):
	return pieceA.GetGemType() == pieceB.GetGemType()

func OnGemPlaced(gridPiece):
	var left = null
	if gridPiece.GetColumn() > 0:
		var piece = get_child(gridPiece.GetRow()).get_child(gridPiece.GetColumn() - 1)
		if piece.IsEmpty() == false:
			if IsPieceTheSameType(gridPiece, piece) == false:
				left = piece

	var right = null
	if gridPiece.GetColumn() < Width - 1:
		var piece = get_child(gridPiece.GetRow()).get_child(gridPiece.GetColumn() + 1)
		if piece.IsEmpty() == false:
			if IsPieceTheSameType(gridPiece, piece) == false:
				right = piece

	var up = null
	if gridPiece.GetRow() > 0:
		var piece = get_child(gridPiece.GetRow() - 1).get_child(gridPiece.GetColumn())
		if piece.IsEmpty() == false:
			if IsPieceTheSameType(gridPiece, piece) == false:
				up = piece

	var down = null
	if gridPiece.GetRow() < Height - 1:
		var piece = get_child(gridPiece.GetRow() + 1).get_child(gridPiece.GetColumn())
		if piece.IsEmpty() == false:
			if IsPieceTheSameType(gridPiece, piece) == false:
				down = piece


	var data = {
		"LEFT" : left,
		"RIGHT" : right,
		"UP" : up,
		"DOWN" : down
	}
	gridPiece.ShowSwitchableAreas(data)

func OnSquareCheck(gridPiece):
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
