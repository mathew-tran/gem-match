extends VBoxContainer

var Width = -1
var Height = -1

signal CompleteCheck


func _ready():
	await get_tree().process_frame
	InitializeGrid()
	add_to_group("GRID")

func CheckGrid():
	print("==========GRID TEST")
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			OnSquareCheck(get_child(row).get_child(column))
			await get_tree().create_timer(.01).timeout
	print("==========GRID TEST END")

func InitializeGrid():
	Width = len(get_children())
	Height = len(get_child(0).get_children())
	Game.SwitchAmount = 0
	Game.bIsInSwitchMode = false
	var gemInventory = get_tree().get_nodes_in_group("GEMINVENTORY")[0]
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			var gridSquare = get_child(row).get_child(column)
			gridSquare.Setup(row, column)
			gridSquare.connect("Slotted", Callable(self, "OnGemPlaced"))
			if gridSquare.IsPreAdd():
				var gem = gemInventory.PopTopPiece()
				gem.bCanBePlaced = false
				gem.DisableGem()
				gridSquare.SlotInGem(gem, "auto")

func IsPieceTheSameType(pieceA, pieceB):
	if pieceA.GemRef == null:
		return false
	if pieceB.GemRef == null:
		return false
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
	print("CompleteCheck")
	emit_signal("CompleteCheck")

func CheckRow(gridPiece):
	print("Checking Row..")
	var consecutive = []
	var consecutiveType = Definitions.GEM_TYPE.NONE
	for gridSquare in get_child(gridPiece.GetRow()).get_children():
			if consecutiveType == gridSquare.GetGemType() and consecutiveType != - 1 and consecutiveType != Definitions.GEM_TYPE.NONE:
				if gridSquare.GemRef.bIsDestroyed == true:
					return
				consecutive.append(gridSquare)
				if len(consecutive) >= 5:
					Game.SwitchAmount += 1
					Game.BroadcastGemCombined()
					for grid in consecutive:
						grid.GemRef.Destroy()
					consecutive.clear()
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
		if consecutiveType == gridSquare.GetGemType() and consecutiveType != - 1 and consecutiveType != Definitions.GEM_TYPE.NONE:
			if gridSquare.GemRef.bIsDestroyed == true:
					return
			consecutive.append(gridSquare)
			if len(consecutive) >= 5:
				Game.SwitchAmount += 1
				Game.BroadcastGemCombined()
				for grid in consecutive:
					grid.GemRef.Destroy()
				consecutive.clear()
		else:
			consecutive.clear()
			consecutive.append(gridSquare)
			consecutiveType = gridSquare.GetGemType()
