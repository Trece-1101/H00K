extends Control

signal press_send

func load_user() -> void:
	if not GameSaver.check_directory(true) or not GameSaver.check_user_data():
		$LoginMenu.set_create_user(true)
		$LoginMenu.show()
	else:
		$Sesion.visible = true
		var user_data = GameSaver.load_user()
		Game.set_user(user_data["user_type"], user_data["user_name"])
		Game.set_main_controls(user_data["controller"])
		Game.set_main_volume(user_data["main_volume"])
		$LoginMenu/LogPanel/ColorRect/UserInput.text = Game.get_user()["name"]
		emit_signal("press_send")
