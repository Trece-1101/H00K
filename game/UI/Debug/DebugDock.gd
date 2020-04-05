extends MarginContainer

#### Metodos
#func _gui_input(event: InputEvent) -> void:
#	if event.is_action_pressed('toggle_debug_menu'):
#		print("cambiar")
#		visible = not visible
#		accept_event()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('toggle_debug_menu'):
		print("cambiar")
		visible = not visible
		accept_event()
