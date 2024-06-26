extends VBoxContainer

var Width = -1
var Height = -1

signal CompleteCheck

var bIsCheckingGrid = true

func _ready():
	visible = false
	await get_tree().process_frame
	visible = true
	add_to_group("GRID")

func CheckGrid():
	bIsCheckingGrid = true
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			OnSquareCheck(get_child(row).get_child(column))
	bIsCheckingGrid = false

func IsGridEmpty():
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			if get_child(row).get_child(column).IsEmpty() == false:
				return false
	return true

func InitializeGrid():
	Width = len(get_children())
	Height = len(get_child(0).get_children())
	var data = load(Game.GetStage()) as LevelResource

	var dataIndex = 0
	Game.SwitchAmount = 0
	Game.bIsInSwitchMode = false
	Game.bIsOver = false

	var gemInventory = get_tree().get_nodes_in_group("GEMINVENTORY")[0]

	var internalIndex = 0


	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			var gridSquare = get_child(row).get_child(column)
			gridSquare.Setup(row, column)
			gridSquare.connect("Slotted", Callable(self, "OnGemPlaced"))

			var gem = null
			if data.LevelData[dataIndex] == LCDEFS.TYPES.RANDOM:
				pass
			else:
				gem = gemInventory.GrabPiece(data.LevelData[dataIndex])
			dataIndex += 1
			if gem != null:
				gem.bCanBePlaced = false
				gem.DisableGem()
				gridSquare.SlotInGem(gem, "auto")

	# Run through randoms last.
	for row in range(0, len(get_children())):
		for column in range(0, len(get_child(row).get_children())):
			var gridSquare = get_child(row).get_child(column)
			var gem = null
			if data.LevelData[internalIndex] == LCDEFS.TYPES.RANDOM:
				gem = gemInventory.PopTopPiece(true)
			if gem != null:
				gem.bCanBePlaced = false
				gem.DisableGem()
				gridSquare.SlotInGem(gem, "auto")
			internalIndex += 1

	Game.CheckGrid()
	while Game.IsGridBeingChecked():
		await get_tree().process_frame

	await get_tree().create_timer(1.0).timeout
	var bgToLoad = ""
	var instance = load(data.BG).instantiate()
	instance.z_index = -1
	instance.z_as_relative = false
	get_parent().add_child(instance)

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
	emit_signal("CompleteCheck")

func CheckRow(gridPiece):
	var consecutive = []
	var consecutiveType = Definitions.GEM_TYPE.NONE
	for gridSquare in get_child(gridPiece.GetRow()).get_children():
			if consecutiveType == gridSquare.GetGemType() and consecutiveType != - 1 and consecutiveType != Definitions.GEM_TYPE.NONE:
				if gridSquare.GemRef.bIsDestroyed == true:
					return
				consecutive.append(gridSquare)
				if len(consecutive) >= 5:
					Game.IncreaseSwitchAmount()
					Game.BroadcastGemCombined()
					for grid in consecutive:
						grid.GemRef.Destroy()
					consecutive.clear()
			else:
				consecutive.clear()
				consecutive.append(gridSquare)
				consecutiveType = gridSquare.GetGemType()

func CheckColumn(gridPiece):
	var consecutive = []
	var consecutiveType = Definitions.GEM_TYPE.NONE
	for column in get_children():
		var gridSquare = column.get_child(gridPiece.GetColumn())
		if consecutiveType == gridSquare.GetGemType() and consecutiveType != - 1 and consecutiveType != Definitions.GEM_TYPE.NONE:
			if gridSquare.GemRef.bIsDestroyed == true:
					return
			consecutive.append(gridSquare)
			if len(consecutive) >= 5:
				Game.AddPoints(100)
				Game.IncreaseSwitchAmount()
				Game.BroadcastGemCombined()
				for grid in consecutive:
					grid.GemRef.Destroy()
				consecutive.clear()
		else:
			consecutive.clear()
			consecutive.append(gridSquare)
			consecutiveType = gridSquare.GetGemType()
