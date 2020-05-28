extends Control

func _ready() -> void:
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	Game.print_user_data()
