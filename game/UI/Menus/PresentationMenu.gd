extends Control

signal press_send

var db_request: Node
var user_name := ""

const DB_REQUEST_NODE = preload("res://game/HTTP/HttpDbRequest.tscn")

func _ready() -> void:
	GlobalMusic.play_music(GlobalMusic.musics.presentation)

func load_user() -> void:
	if not GameSaver.check_directory(true) or not GameSaver.check_user_data():
		$LoginMenu.set_create_user(true)
		$LoginMenu.show()
	else:
		$Sesion.visible = true
		var user_data = GameSaver.load_user()
		Game.set_user(user_data["user_type"], user_data["user_name"])
		Game.set_main_controls(user_data["controller"])
		Game.volumes["main_volume"] = user_data["volumes"]["Master"]
		Game.volumes["music_volume"] = user_data["volumes"]["Music"]
		Game.volumes["sfx_volume"] = user_data["volumes"]["Effects"]
		Game.set_screen(user_data["screen"]["resolution"], user_data["screen"]["full_screen"])
		$LoginMenu/LogPanel/ColorRect/UserInput.text = Game.get_user()["name"]
		emit_signal("press_send")


func _on_Exit_pressed() -> void:
	get_tree().quit()


func _on_OK_pressed() -> void:
	db_request = DB_REQUEST_NODE.instance()
	add_child(db_request)
	
	db_request.SetUser(user_name)
	yield(db_request, "done")
	var result = db_request.get_result()
	
	if result["result"]:
		get_tree().reload_current_scene()
