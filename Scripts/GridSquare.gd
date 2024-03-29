extends TextureRect

var Row = -1
var Column = -1
var GemRef = null

signal Slotted(square)
signal Completed(square)

func _ready():
	add_to_group("GRIDPIECE")

func GetRow():
	return Row

func GetColumn():
	return Column

func Setup(rowNum, colNum):
	Row = rowNum
	Column = colNum

func OnEnter():
	if IsEmpty():
		$Highlight.visible = true
	else:
		$HighlightFail.visible = true

func OnExit():
	$Highlight.visible = false
	$HighlightFail.visible = false

func _on_button_mouse_entered():
	pass

func _on_button_mouse_exited():
	pass

func IsEmpty():
	return GemRef == null

func _on_area_2d_area_entered(area):
	OnEnter()

func ShowSwitchableAreas(data):
	var switchArea = get_tree().get_nodes_in_group("TRANSITION")
	if switchArea:
		switchArea[0].SetTransitionArrows(self, data)




func _on_area_2d_area_exited(area):
	OnExit()

func SlotInGem(gem, type = "slot"):
	gem.global_position = $GemPosition.global_position
	$Highlight.visible = false
	GemRef = gem
	GemRef.SetCollision(false)
	if type == "slot":
		emit_signal("Slotted", self)

func GetString():
	return "Row: " + str(Row) +", Column: " + str(Column)

func GetGemType():
	return GemRef.GemType
