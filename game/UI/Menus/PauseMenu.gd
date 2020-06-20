extends Control

export var menu_scene := ""
export var options_scene := ""
export(float, -4.0, -20.0) var lower_volume = -10.0

onready var original_volume := Game.get_volumes("Master")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if visible:
			close()
		else:
			get_tree().paused = true
			visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			Game.set_volumes("Master", lower_volume)


func _on_Exit_button_up() -> void:
	get_tree().quit()

func _on_Menu_button_up() -> void:
	close()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	get_tree().change_scene(menu_scene)

func _on_Continue_button_up() -> void:
	close()

func close() -> void:
	get_tree().paused = false
	visible = false
	Game.set_volumes("Master", original_volume)
	if Game.get_main_controls() == Settings.GAMEPAD:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
