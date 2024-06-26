extends Panel

func _ready():
	Game.connect("GameOver", Callable(self, "OnGameOver"))

func OnGameOver(bHasWon):
	if bHasWon:
		ShowWin()
	else:
		ShowLose()

func ShowWin():
	visible = true
	$VBoxContainer/Label.text = "STAGE COMPLETE"
	$VBoxContainer/Restart.visible =false
	pass


func ShowLose():
	visible = true
	$VBoxContainer/Label.text = "GAME OVER"
	$VBoxContainer/Continue.visible = false
	pass

