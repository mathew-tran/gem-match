extends TextureRect

var GemAmountPerType = 5
var Gems = []

var GemTypes = [
	Definitions.GEM_TYPE.DIAMOND,
	Definitions.GEM_TYPE.EMERALD,
	Definitions.GEM_TYPE.TOPAZ,
	Definitions.GEM_TYPE.RUBY
]

var GemAmount = 0
func _ready():
	add_to_group("GEMINVENTORY")
	PopulateGems()
	Gems.shuffle()
	SlotNextGemPiece()
	Game.connect("SwitchComplete", Callable(self, "OnSwitchComplete"))

func OnSwitchComplete():
	Game.CheckGrid()
	while Game.IsGridBeingChecked():
		await get_tree().process_frame

	OnGemConfirmed(null)

func PopulateGems():
	for type in GemTypes:
		for x in range(0, 5):
			var instance = load("res://Prefab/GemPiece.tscn").instantiate()
			instance.GemType = type
			instance.global_position = Vector2(-1000, 0)
			add_child(instance)
			Gems.append(instance)
			GemAmount += 1


func PopTopPiece():
	var gem = Gems[0]
	Gems[0].MoveToPosition(global_position + Vector2(16,16))
	Gems[0].Setup()
	Gems[0].connect("Confirmed", Callable(self, "OnGemConfirmed"))
	Gems[0].connect("Destroyed", Callable(self, "OnGemDestroyed"))
	Gems.remove_at(0)
	$Label.text = str(len(Gems))
	return gem

func SlotNextGemPiece():
	if len(Gems) > 0:
		PopTopPiece()
	else:
		CheckGameOver()


func CheckGameOver():
	if Game.HaveAllGemsBeenPlaced() == false:
		return
	StartTimer()
	await $Timer.timeout
	await get_tree().process_frame

	$Label.text = ""
	if is_instance_valid(get_tree()) == false:
		return

	if Game.DoGemsExist():
		if Game.HasSwitches():
			$SwitchLabel.visible = true
			return
		Game.BroadcastGameOver(false)
	else:
		Game.BroadcastGameOver(true)
		$SwitchLabel.visible = false

func StartTimer():
	$Timer.start()

func OnGemDestroyed(square):
	GemAmount -= 1
	if GemAmount == 0:
		CheckGameOver()

func OnGemConfirmed(square):
	$SwitchLabel.visible = false
	$Label.text = str(len(Gems))
	$Timer.start()
	await $Timer.timeout
	while Game.IsGridBeingChecked():
		await get_tree().process_frame
	print("grid check complete")
	if Game.HasSwitches() and Game.DoGemsExist():
		Game.bIsInSwitchMode = true
		$SwitchLabel.visible = true
		return


	SlotNextGemPiece()

func _on_button_button_up():
	SkipSwitch()

func SkipSwitch():
	Game.SwitchAmount = 1
	Game.BroadcastSwitchComplete()

func _input(event):
	if $SwitchLabel.is_visible_in_tree():
		if event.is_action_pressed("skip"):
			SkipSwitch()
