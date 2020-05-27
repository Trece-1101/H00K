extends Control

func _ready() -> void:
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	Game.add_run()
	print(Game.get_run_id())
