extends Control

signal press_send

func load_user() -> void:
	if not GameSaver.check_directory(true) or not GameSaver.check_user_data():
		$LoginMenu.set_create_user(true)
		$LoginMenu.show()
	else:
		$Sesion.visible = true
		var user_data = GameSaver.load_user()
		Game.set_user(user_data[0], user_data[1])
		$LoginMenu/LogPanel/ColorRect/UserInput.text = Game.get_user()["name"]
		emit_signal("press_send")
