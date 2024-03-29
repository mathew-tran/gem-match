extends Control

var bIsDragged = false
var bIsEntered = false
var bCanBePlaced = true
var InitialPosition = Vector2.ZERO
var GemType = Definitions.GEM_TYPE.DIAMOND

signal Placed(square)
signal Confirmed(square)

func _ready():
	Setup()
	if GemType == Definitions.GEM_TYPE.DIAMOND:
		$Sprite2D.texture = Definitions.DiamondTexture
	elif GemType == Definitions.GEM_TYPE.TOPAZ:
		$Sprite2D.texture = Definitions.TopazTexture
	elif GemType == Definitions.GEM_TYPE.EMERALD:
		$Sprite2D.texture = Definitions.EmeraldTexture

func Setup():
	InitialPosition = global_position

func _input(event):
	if bIsEntered == false or bCanBePlaced == false:
		return
	if event.is_action_pressed("click"):
		bIsDragged = true
		z_index = 1

func _process(delta):
	if bCanBePlaced == false:
		return

	if bIsDragged:
		global_position = get_global_mouse_position() - Vector2(32,32)

	if Input.is_action_just_released("click"):
		bIsDragged = false
		var square = GetSquare()
		if square == null:
			global_position = InitialPosition
		else:
			if square.IsEmpty():
				square.SlotInGem(self)
				bCanBePlaced = false
				emit_signal("Placed", square)
				z_index = 0
			else:
				global_position = InitialPosition

func ConfirmPlacement():
	emit_signal("Confirmed", self)

func GetSquare():
	var areas = $Sprite2D/Area2D.get_overlapping_areas()
	if areas:
		return areas[0].get_parent()
	return null

func _on_mouse_entered():
	bIsEntered = true


func _on_mouse_exited():
	bIsEntered = false

func SetCollision(bEnable):
	$Sprite2D/Area2D/CollisionShape2D.disabled = !bEnable

