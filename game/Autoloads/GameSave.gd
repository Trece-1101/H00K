extends Node

func check_directory(create: bool) -> bool:
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		if create:
			create_directory()
		
		return false
	
	return true

func create_directory() -> void:
	Directory.new().make_dir_recursive("res://saves/")

func check_user_data() -> bool:
	return check_file("res://saves/user_data.tres")

func check_user_game_data() -> bool:
	return check_file("res://saves/slot_1.tres")

func check_file(file_path: String) -> bool:
	var dir = Directory.new()
	if not dir.file_exists(file_path):
		return false
	
	return true

func create_user(uname: String) -> void:
	var user = {"type": "Jugador", "name": uname, "pass": "qwerty1234"}
	ResourceSaver.save("res://saves/user_data.tres", user)

func create_user_game_data() -> void:
	var player_state = {
		"respawn_position": Vector2.ZERO,
		"last_state": "Init",
		"current_room": "Room1",
		"current_room_version": 1,
		"current_level": {"level_name": "", "level_number": 0},
		"next_level": ""
	}
	
	var total_death_count: int = 0
	var levels_performance := []
	var level_performance := {}
	var total_time_elapsed := 0
	var total_rooms := 0


func load_file(file_path):
	var data = load(file_path)
	return data

func load_user():
	return load_file("res://saves/user_data.tres")

func load_user_game_data():
	return load_file("res://saves/slot_1.tres")




