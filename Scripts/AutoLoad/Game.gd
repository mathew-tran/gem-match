extends Node

signal GameOver(bWin)
signal SwitchClicked(square)
signal GemCombined
signal SwitchComplete

var SwitchAmount = 0
var bIsInSwitchMode = false
var SquareA = null
var SquareB = null
var bIsOver = false

var Points = 0

signal PointsAdded (amount)

func Restart():
	Points = 0
	SwitchAmount = 0
	bIsInSwitchMode = false
	ResetSwitches()

func AddPoints(amount):
	Points += amount
	emit_signal("PointsAdded", amount)

func GetPoints():
	return Points

func IsGameOver():
	return bIsOver

func CheckGrid():
	var grid = get_tree().get_nodes_in_group("GRID")
	if grid:
		grid[0].CheckGrid()

func _input(event):
	if event.is_action_pressed("restart"):
		Restart()
		if get_tree():
			get_tree().reload_current_scene()

func IsGridBeingChecked():
	var grid = get_tree().get_nodes_in_group("GRID")
	if grid:
		return grid[0].bIsCheckingGrid
	return false

func AreGemsBeingDestroyed():
	var gems = get_tree().get_nodes_in_group("GEM")
	for gem in gems:
		if gem.bIsDestroyed == true:
			return true
	return false

func DoGemsExist():
	var gems = get_tree().get_nodes_in_group("GEM")
	for gem in gems:
		if gem.bIsDestroyed == false:
			return true
	return false

func HaveAllGemsBeenPlaced():
	var gems = get_tree().get_nodes_in_group("GEM")
	for gem in gems:
		if gem.bCanBePlaced == true:
			return false
	return true

func HasSwitches():
	return SwitchAmount > 0

func BroadcastGameOver(bWin):
	emit_signal("GameOver", bWin)
	Game.BroadcastSwitchComplete()
	bIsOver = true

func BroadcastSquareUnClicked(square):
	if SquareA == square:
		SquareA = null

func BroadcastSquareClicked(square):

	if bIsInSwitchMode:
		emit_signal("SwitchClicked", square)
		if SquareA == null:
			SquareA = square
		elif SquareB == null:
			if SquareA == square:
				return
			SquareB = square
			bIsInSwitchMode = false
			var squareAData = SquareA.GemRef
			var squareBData = SquareB.GemRef
			SquareA.SlotInGem(squareBData, "switch")
			SquareB.SlotInGem(squareAData, "switch")
			await get_tree().process_frame
			BroadcastSwitchComplete()

func BroadcastGemCombined():
	emit_signal("GemCombined")
	bIsInSwitchMode = true

	ResetSwitches()

func ResetSwitches():
	if SquareA:
		SquareA.EnableSwitch(false)
	if SquareB:
		SquareB.EnableSwitch(false)
	SquareA = null
	SquareB = null

func BroadcastSwitchComplete():
	emit_signal("SwitchComplete")
	Game.AddPoints(50)
	ResetSwitches()
	SwitchAmount -= 1
	if SwitchAmount > 0:
		BroadcastGemCombined()
	else:
		bIsInSwitchMode = false
		SwitchAmount = 0
