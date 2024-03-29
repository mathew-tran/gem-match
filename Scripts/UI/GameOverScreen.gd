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
	$VBoxContainer/Label.text = "YOU WIN"
	pass


func ShowLose():
	visible = true
	$VBoxContainer/Label.text = "YOU LOSE"
	pass
