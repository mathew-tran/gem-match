extends Node

signal GameOver(bWin)
signal SwitchClicked(square)
signal GemCombined
signal SwitchComplete

var bIsInSwitchMode = false
var SquareA = null
var SquareB = null

func BroadcastGameOver(bWin):
	emit_signal("GameOver", bWin)

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
			print("preformSwitch")
			bIsInSwitchMode = false
			var squareAData = SquareA.GemRef
			var squareBData = SquareB.GemRef
			SquareA.SlotInGem(squareBData, "switch")
			SquareB.SlotInGem(squareAData, "switch")
			await get_tree().process_frame
			SquareA.EnableSwitch(false)
			SquareB.EnableSwitch(false)
			BroadcastSwitchComplete()

func BroadcastGemCombined():
	emit_signal("GemCombined")
	bIsInSwitchMode = true
	SquareA = null
	SquareB = null

func BroadcastSwitchComplete():
	emit_signal("SwitchComplete")
