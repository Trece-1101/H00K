extends Control

func _ready() -> void:
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	Game.add_run()
	Game.print_user_data()
