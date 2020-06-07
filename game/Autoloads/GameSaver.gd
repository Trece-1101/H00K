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
	
	ResourceSaver.save("res://saves/user_data.tres", new_save)

func save_user_game_data(slot: String) -> void:
	pass


func load_file(file_path):
	var data = load(file_path)
	return data

func load_user():
	var user_data = load_file("res://saves/user_data.tres")
	return [user_data.user_type, user_data.user_name]

func load_user_game_data(slot: String):
	var path = slot + ".tres"
	return load_file("res://saves/" + path)




