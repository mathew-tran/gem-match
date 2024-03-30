extends Control

var GridPiece = null

signal Transitioned

func _ready():
	add_to_group("TRANSITION")
	HideHints()
	$SwitchLeft.connect("Switched", Callable(self, "OnSwitched"))
	$SwitchRight.connect("Switched", Callable(self, "OnSwitched"))
	$SwitchDown.connect("Switched", Callable(self, "OnSwitched"))
	$SwitchUp.connect("Switched", Callable(self, "OnSwitched"))
	$SwitchMiddle.connect("Switched", Callable(self, "OnSwitched"))

func OnSwitched():
	HideHints()
	GridPiece.GemRef.ConfirmPlacement()
	Game.CheckGrid()



func HideHints():
	$SwitchRight.visible = false
	$SwitchLeft.visible = false
	$SwitchDown.visible = false
	$SwitchUp.visible = false
	$SwitchMiddle.visible = false
	emit_signal("Transitioned")

func SetTransitionArrows(gridPiece, data):
	GridPiece = gridPiece
	global_position = gridPiece.global_position
	ShowSwitchableAreas(data)


func ShowSwitchableAreas(data):
	var nulls = 0

	if data["LEFT"]:
		$SwitchLeft.visible = true
		$SwitchLeft.Setup(GridPiece, data["LEFT"])
	else:
		nulls += 1

	if data["RIGHT"]:
		$SwitchRight.visible = true
		$SwitchRight.Setup(GridPiece, data["RIGHT"])
	else:
		nulls += 1

	if data["UP"]:
		$SwitchUp.visible = true
		$SwitchUp.Setup(GridPiece, data["UP"])
	else:
		nulls += 1

	if data["DOWN"]:
		$SwitchDown.visible = true
		$SwitchDown.Setup(GridPiece, data["DOWN"])
	else:
		nulls += 1
	if nulls == 4:
		if is_instance_valid(GridPiece.GemRef):
			GridPiece.GemRef.ConfirmPlacement()
		Game.CheckGrid()
		emit_signal("Transitioned")


	else:
		$SwitchMiddle.Setup(GridPiece, null)
		$SwitchMiddle.visible = true
