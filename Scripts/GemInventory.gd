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
		Gems[0].connect("Placed", Callable(self, "OnGemPlaced"))
		Gems.remove_at(0)

func OnGemPlaced(square):
	SlotNextGemPiece()

func _ready():
	PopulateGems()
	Gems.shuffle()
	SlotNextGemPiece()
