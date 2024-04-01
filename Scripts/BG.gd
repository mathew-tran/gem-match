extends TextureRect


# Called when the node enters the scene tree for the first time.
func _enter_tree():
	scale = Vector2(1,0)
	modulate.a = 0

func _ready():
	var tween = get_tree().create_tween()
	tween.tween_property(self, "scale", Vector2(1,1), .4)
	tween.tween_property(self, "modulate:a", 1, .6)
