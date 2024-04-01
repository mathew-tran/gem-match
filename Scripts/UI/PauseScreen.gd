extends Panel


func _ready():
	$VBoxContainer/Button.connect("button_up", Callable(self,"OnResumeButtonUp"))
	$"../OptionsButton".connect("button_up", Callable(self, "OnOptionButtonUp"))
	OnResumeButtonUp()

func OnOptionButtonUp():
	visible = true
	get_tree().paused = true

func OnResumeButtonUp():
	visible = false
	get_tree().paused = false

func _exit_tree():
	get_tree().paused = false
