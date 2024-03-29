extends Control

var bIsDragged = false
var bIsEntered = false
var InitialPosition = Vector2.ZERO


func _ready():
	InitialPosition = global_position

func _input(event):
	if bIsEntered == false:
		return
	if event.is_action_pressed("click"):
		bIsDragged = true

func _process(delta):
	if bIsDragged:
		global_position = get_global_mouse_position() - Vector2(32,32)

	if Input.is_action_just_released("click"):
		bIsDragged = false
		if CheckSquare() == null:
			global_position = InitialPosition

func CheckSquare():
	var areas = $Sprite2D/Area2D.get_overlapping_areas()
	if areas:
		return areas[0]
	return null

func _on_mouse_entered():
	bIsEntered = true


func _on_mouse_exited():
	bIsEntered = false

