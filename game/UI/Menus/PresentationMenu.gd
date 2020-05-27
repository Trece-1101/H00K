extends Control

signal press_send

func load_user() -> void:
	if not GameSave.check_directory(true) or not GameSave.check_user_data():
		$LoginMenu.show()
	else:
		$Sesion.visible = true
		var user_data = GameSave.load_user()
		Game.set_user(user_data["type"], user_data["name"])
		$LogPanel/ColorRect/UserInput.text = Game.get_user()["name"]
		emit_signal("press_send")
