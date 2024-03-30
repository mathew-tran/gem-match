extends TextureRect

var Row = -1
var Column = -1
var GemRef = null

signal Slotted(square)
signal Completed(square)

var bEntered = false

@export var bPreAdd = false

func _ready():
	add_to_group("GRIDPIECE")
	$AnimationPlayer.play("animIn")

func GetRow():
	return Row

func GetColumn():
	return Column

func IsPreAdd():
	return bPreAdd

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
	bEntered = true

func _on_button_mouse_exited():
	bEntered = false

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
	EnableSwitch(false)
	$Highlight.visible = false
	GemRef = gem
	if is_instance_valid(GemRef):
		GemRef.SetCollision(false)
		GemRef.DisableGem()
		gem.global_position = $GemPosition.global_position
	if type == "slot":
		emit_signal("Slotted", self)

func GetString():
	return "Row: " + str(Row) +", Column: " + str(Column)

func GetGemType():
	if is_instance_valid(GemRef):
		return GemRef.GemType
	return -1


func _process(delta):
	if bEntered == false:
		return
	if Game.bIsInSwitchMode:
		if Input.is_action_just_pressed("click"):
			Game.BroadcastSquareClicked(self)
			EnableSwitch(true)
		elif Input.is_action_just_pressed("unclick"):
			EnableSwitch(false)
			Game.BroadcastSquareUnClicked(self)

func EnableSwitch(bSwitch):
	$Switch.visible = bSwitch
