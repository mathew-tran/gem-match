extends Button


var SlotA = null
var SlotB = null

signal Switched

func Setup(slotA, slotB):
	SlotA = slotA
	SlotB = slotB

func PreformGemSwitch():
	var gemA = SlotA.GemRef
	if SlotB == null:
		SlotA.SlotInGem(gemA, "confirm")
		emit_signal("Switched")
		return

	var gemB = SlotB.GemRef
	SlotA.SlotInGem(gemB, "switch")
	SlotB.SlotInGem(gemA, "switch")
	emit_signal("Switched")

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("animIn")


func _on_button_up():
	PreformGemSwitch()
