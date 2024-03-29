extends TextureRect

var GemAmountPerType = 5
var Gems = []

var GemTypes = [
	Definitions.GEM_TYPE.DIAMOND,
	Definitions.GEM_TYPE.EMERALD,
	Definitions.GEM_TYPE.TOPAZ
]
func PopulateGems():
	for type in GemTypes:
		for x in range(0, 5):
			var instance = load("res://Prefab/GemPiece.tscn").instantiate()
			instance.GemType = type
			instance.global_position = Vector2(-1000, 0)
			add_child(instance)
			Gems.append(instance)

func SlotNextGemPiece():
	if len(Gems) > 0:
		Gems[0].global_position = global_position + Vector2(16,16)
		Gems[0].Setup()
		Gems[0].connect("Confirmed", Callable(self, "OnGemConfirmed"))
		Gems.remove_at(0)
		$Label.text = str(len(Gems) + 1)
	else:
		await get_tree().process_frame
		$Label.text = "EMPTY"
		var grid = get_tree().get_nodes_in_group("GRIDPIECE")
		for piece in grid:
			if piece.IsEmpty() == false:
				Game.BroadcastGameOver(false)
				return
		Game.BroadcastGameOver(true)


func OnGemConfirmed(square):
	SlotNextGemPiece()

func _ready():
	PopulateGems()
	Gems.shuffle()
	SlotNextGemPiece()
