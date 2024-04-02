extends Control

var bIsDragged = false
var bIsEntered = false
var bCanBePlaced = true
var InitialPosition = Vector2.ZERO
var GemType = Definitions.GEM_TYPE.DIAMOND
var bIsDestroyed = false
var bActive = false
signal Placed(square)
signal Confirmed(square)
signal Destroyed(square)

var cachedEvent = null

func _ready():
	add_to_group("GEM")
	InitialPosition = global_position
	if GemType == Definitions.GEM_TYPE.DIAMOND:
		$Sprite2D.texture = Definitions.DiamondTexture
	elif GemType == Definitions.GEM_TYPE.TOPAZ:
		$Sprite2D.texture = Definitions.TopazTexture
	elif GemType == Definitions.GEM_TYPE.EMERALD:
		$Sprite2D.texture = Definitions.EmeraldTexture
	elif GemType == Definitions.GEM_TYPE.RUBY:
		$Sprite2D.texture = Definitions.RubyTexture
	elif GemType == Definitions.GEM_TYPE.AQUAMARINE:
		$Sprite2D.texture = Definitions.AquamarineTexture

func IsMobileEvent(event):
	if event is InputEventScreenTouch:
		return event.pressed == true
	if event is InputEventScreenDrag:
		return true


func MoveToPosition(newPosition, bQuick = true):
	InitialPosition = newPosition
	var tween = get_tree().create_tween()
	if bQuick:
		tween.tween_property(self, "global_position", newPosition, .1)
	else:
		tween.tween_property(self, "global_position", newPosition, .3)
	tween.play()

	$AnimationPlayer.play("animIn")

func _input(event):
	if (event.is_action_pressed("click") or IsMobileEvent(event)) and bCanBePlaced:
		cachedEvent = event
		print(cachedEvent)
	else:
		cachedEvent = null


func _process(_delta):
	if bCanBePlaced == false:
		return

	if bIsDragged:
		global_position = get_global_mouse_position() - Vector2(48,48)

	if cachedEvent == null:
		return

	if bIsDragged and (IsMobileEvent(cachedEvent) or cachedEvent.is_action_pressed("click")):
		var square = GetSquare()
		if square == null:
			pass
			#RevertToInitialPosition()
		else:
			bIsDragged = false
			if square.IsEmpty():
				square.SlotInGem(self)
				bCanBePlaced = false
				emit_signal("Placed", square)
				z_index = 0
				modulate = Color.WHITE
			else:
				pass

func RevertToInitialPosition():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "global_position", InitialPosition, .1)
	tween.play()
	$AnimationPlayer.play("animIn")

func Destroy():
	$AnimationPlayer.play("destroy")
	bIsDestroyed = true

func ConfirmPlacement():
	emit_signal("Confirmed", self)
	DisableGem()

func DisableGem():
	$Sprite2D/Area2D/CollisionShape2D.disabled = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	$AnimationPlayer.play_backwards("placed")

func GetSquare():
	var areas = $Sprite2D/Area2D.get_overlapping_areas()
	if areas:
		return areas[0].get_parent()
	return null

func _on_mouse_entered():
	bIsEntered = true
	if bCanBePlaced:
		modulate = Color.SILVER


func _on_mouse_exited():
	bIsEntered = false
	if bCanBePlaced:
		modulate = Color.WHITE

func SetCollision(bEnable):
	$Sprite2D/Area2D/CollisionShape2D.disabled = !bEnable



func _on_animation_player_animation_finished(anim_name):
	if anim_name != "destroy":
		return
	emit_signal("Destroyed", self)
	var gemInventory = get_tree().get_nodes_in_group("GEMINVENTORY")
	if gemInventory:
		gemInventory[0].StartTimer()
	queue_free()


func _on_button_button_up():
	pass


func _on_button_button_down():
	if bCanBePlaced == false:
		return

	if bIsDragged == false and (IsMobileEvent(cachedEvent) or cachedEvent.is_action_pressed("click")):
		await get_tree().create_timer(.1).timeout
		bIsDragged = true
		z_index = 1


