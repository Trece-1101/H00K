extends Control


export(String, FILE, "*.tscn") var menu = ""


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_released("ui_accept"):
		get_tree().change_scene(menu)
