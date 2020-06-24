extends Control

func _ready() -> void:
	GlobalMusic.play_music(GlobalMusic.musics.main_menu)
	$Menu/CenterRow/Buttons/NewGameButton.grab_focus()
	if Game.user.type in Game.players:
		OS.window_size = Game.get_screen()["resolution"]
		OS.window_fullscreen = Game.get_screen()["full_screen"]
	
	#Game.print_user_data()
