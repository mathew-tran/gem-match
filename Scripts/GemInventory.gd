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
	$SwitchLabel.visible = false
	SlotNextGemPiece()

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
	StartTimer()
	await $Timer.timeout
	await get_tree().process_frame

	$Label.text = "EMPTY"
	if is_instance_valid(get_tree()) == false:
		return
	var grid = get_tree().get_nodes_in_group("GRIDPIECE")
	for piece in grid:
		if piece.IsEmpty() == false:
			if Game.SwitchAmount > 0:
				return
			Game.BroadcastGameOver(false)
			return
	Game.BroadcastGameOver(true)
	$SwitchLabel.visible = false

func StartTimer():
	$Timer.start()

func OnGemDestroyed(square):
	GemAmount -= 1
	if GemAmount == 0:
		CheckGameOver()

func OnGemConfirmed(square):
	$Label.text = str(len(Gems))
	$Timer.start()
	await $Timer.timeout
	if Game.bIsInSwitchMode:
		$SwitchLabel.visible = true
		return

	var grid = get_tree().get_nodes_in_group("GRID")
	if grid:
		SlotNextGemPiece()

func _on_button_button_up():
	Game.BroadcastSwitchComplete()


func _input(event):
	if $SwitchLabel.is_visible_in_tree():
		if event.is_action_pressed("skip"):
			Game.BroadcastSwitchComplete()
