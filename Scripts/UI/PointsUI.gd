extends TextureRect


var cacheAmount = 0
func _ready():
	Game.connect("PointsAdded", Callable(self, "OnPointsAdded"))
	OnPointsAdded(0)
	$Added.visible = false

func OnPointsAdded(amount):
	$Label.text = str(Game.GetPoints())
	$AnimationPlayer.play("gainPoints")

	if amount != 0:
		cacheAmount += amount
		$Added.global_position = get_global_mouse_position() - Vector2(0,32)
		$Added.text = " +" + str(cacheAmount)
		$Added.visible = true
		$Timer.start()


func _on_timer_timeout():
	$Added.visible = false
	cacheAmount = 0
