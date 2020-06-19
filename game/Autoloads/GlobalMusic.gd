extends Node

onready var musics :={
	"presentation": $Presentation,
	"main_menu": $Menu,
	"credits": $Credits,
	"intro": $Intro,
	"level_one": $LevelOne,
	"level_two": $LevelTwo
}

func play_music(music: Object) -> void:
	stop_music()
	music.play()

func stop_music() -> void:
	for child in get_children():
		child.stop()
