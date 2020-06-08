extends Node

var save_user_data := SaveUserData
var save_performance_data := SavePerformanceData

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

func check_user_performance_data(slot: String) -> bool:
	var path = slot + ".tres"
	return check_file("res://saves/" + path)

func check_file(file_path: String) -> bool:
	var dir = Directory.new()
	if not dir.file_exists(file_path):
		return false
	
	return true

func create_user(uname: String) -> void:
	var new_save = save_user_data.new()
	new_save.user_name = uname
	new_save.user_type = "Jugador"
	new_save.controller = 1
	new_save.main_volume = 0.0
	
	ResourceSaver.save("res://saves/user_data.tres", new_save)

func create_performance_slot(slot_name: String) -> void:
	GamePerformance.reset_performances()
	Game.reset_data()
	Game.init_level()
	save_performance(slot_name)


func update_performance_slot(slot_name: String) -> void:
	if check_user_performance_data(slot_name):
		save_performance(slot_name)

func save_performance(slot_name: String) -> void:
	var new_save = save_performance_data.new()
	
	new_save.level_to_load = Game.get_scene_to_load()
	new_save.respawn_position = Game.get_player_respawn_position()
	new_save.current_level_name = Game.get_player_current_level_name()
	new_save.current_level_number = Game.get_player_current_level_number()
	new_save.current_room = Game.get_player_current_room_int()
	new_save.current_room_version = Game.get_player_current_room_v()
	new_save.last_state = Game.get_player_last_state()
	new_save.last_door_closed = Game.get_last_door_closed()
	new_save.camera = Game.get_camera_start()
	
	new_save.levels_performance = GamePerformance.get_levels_performance()
	new_save.level_performance = GamePerformance.get_level_performance()
	
	new_save.total_death_count = GamePerformance.get_player_death_count()
	new_save.total_time_elapsed = GamePerformance.get_total_time_elapsed()
	
	var path = slot_name + ".tres"
	
	Game.set_current_slot(slot_name)
	ResourceSaver.save("res://saves/" + path, new_save)

func load_performance(slot_name: String) -> Dictionary:
	var path = slot_name + ".tres"
	var performance_data = load_file("res://saves/" + path)
	Game.set_current_slot(slot_name)
	
	return {
		"level_to_load": performance_data.level_to_load,
		"respawn_position": performance_data.respawn_position,
		"current_level_name": performance_data.current_level_name,
		"current_level_number": performance_data.current_level_number,
		"current_room": performance_data.current_room,
		"current_room_version": performance_data.current_room_version,
		"player_last_state": performance_data.last_state,
		"last_door": performance_data.last_door_closed,
		"camera": performance_data.camera,
		"levels_performances": performance_data.levels_performance,
		"level_performance": performance_data.level_performance,
		"total_death_count": performance_data.total_death_count,
		"time_elapsed": performance_data.total_time_elapsed,
	}

func load_details(slot_name: String) -> Dictionary:
	var path = slot_name + ".tres"
	var performance_details = load_file("res://saves/" + path)
	
	return {
		"current_level_name": performance_details.current_level_name,
		"current_level_number": performance_details.current_level_number,
		"current_room": performance_details.current_room,
		"total_death_count": performance_details.total_death_count,
		"time_elapsed": performance_details.total_time_elapsed,
	}

func delete_performance_slot(slot_name: String) -> void:
	var path = slot_name + ".tres"
	var dir = Directory.new()
	dir.remove("res://saves/" + path)

func save_user_game_data(_slot: String) -> void:
	pass

func load_file(file_path):
	var data = load(file_path)
	return data

func load_user() -> Dictionary:
	var user_data = load_file("res://saves/user_data.tres")
	return {
		"user_type": user_data.user_type,
		"user_name": user_data.user_name,
		"controller": user_data.controller,
		"main_volume": user_data.main_volume
	}


