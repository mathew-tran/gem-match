extends Node2D


var GridAnimations = [
	"animGrid",
	"animGrid2",
	"animGrid3",
	"animGrid4",
	"animGrid5"
]

# Called when the node enters the scene tree for the first time.
func _ready():
	$CanvasLayer/RemainingSlot.visible = false
	$CanvasLayer/Points.visible = false
	$CanvasLayer/AnimationPlayer.play(GridAnimations[randi()% len(GridAnimations)])

func _on_animation_player_animation_finished(anim_name):
	$CanvasLayer/Grid.InitializeGrid()
	$CanvasLayer/RemainingSlot.visible = true
	$UIDelay.start()


func _on_ui_delay_timeout():

	$CanvasLayer/Points.visible = true

