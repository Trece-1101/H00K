extends Node

func check_directory() -> bool:
	var dir = Directory.new()
	if not dir.dir_exists("res://saves/"):
		dir.make_dir_recursive("res://saves/")
		return false
	
	return true
