extends Panel

var bCanUnpause = false

func _ready():
	$VBoxContainer/Button.connect("button_up", Callable(self,"OnResumeButtonUp"))
	$"../OptionsButton".connect("button_up", Callable(self, "OnOptionButtonUp"))
	OnResumeButtonUp()

func OnOptionButtonUp():
	visible = true
	await get_tree().process_frame
	bCanUnpause = true
	get_tree().paused = true

func OnResumeButtonUp():
	visible = false
	await get_tree().process_frame
	bCanUnpause = false
	get_tree().paused = false

func _exit_tree():
	get_tree().paused = false

func _input(event):
	if bCanUnpause == false:
		return
	if event.is_action_released("escape"):
		if get_tree().paused:
			OnResumeButtonUp()
