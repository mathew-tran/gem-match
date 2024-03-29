extends Node

signal GameOver(bWin)

func BroadcastGameOver(bWin):
	emit_signal("GameOver", bWin)
