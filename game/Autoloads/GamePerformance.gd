extends Node

################################################################################
#### Local performance
var total_death_count: int = 0
var total_time_elapsed := 0
var levels_performance := []
var level_performance := {}

#### Database performance
var room_death_count := 0
var room_time := 0
var start_time := 0
var end_time := 0
################################################################################

################################################################################
func reset_performances() -> void:
	total_death_count = 0
	total_time_elapsed = 0
	levels_performance = []
	level_performance = {}

func get_levels_performance():
	return levels_performance

func get_level_performance():
	return level_performance

func set_player_death_count(value: int) -> void:
	total_death_count = value

func get_player_death_count() -> int:
	return total_death_count

func set_total_time_elapsed(value: int) -> void:
	total_time_elapsed = value

func get_total_time_elapsed() -> int:
	return total_time_elapsed

func set_levels_performance(value: Array) -> void:
	levels_performance = value

func set_level_performance(value: Dictionary) -> void:
	level_performance = value

func init_level_performance(level_name: String, enter: int) -> void:
	level_performance["level"] = level_name
	level_performance["deaths"] = 0
	level_performance["enter"] = enter
	level_performance["exit"] = 0
	level_performance["time"] = 0
	
	var already_in = false
	for level in levels_performance:
		if level["level"] == level_name:
			already_in = true
			break
	
	if not already_in:
		levels_performance.append(level_performance)

func get_performance(level_name: String) -> void:
	get_time_performance(level_name, false)
	get_death_performance(level_name, false)

func get_time_performance(level_name: String, show: bool) -> String:
	for level in levels_performance:
		if level["level"] == level_name:
			var elapsed = level["time"]
			var minutes = elapsed * 0.0166666666666667
			var seconds = elapsed % 60
			var str_elapsed = "%02d:%02d" % [minutes, seconds]
			if show:
				print("------------------------")
				print("Tiempo Total: ", str_elapsed)
			return(str_elapsed)
	
	return "00:00"

func get_death_performance(level_name: String, show: bool) -> int:
	for level in levels_performance:
		if level["level"] == level_name:
			if show:
				print("Muertes nivel: ", level["deaths"])
				print("Muertes totales: ", total_death_count)
			return level["deaths"]
	
	return 0

func increment_death_count(level_name: String) -> void:
	total_death_count += 1
	for level in levels_performance:
		if level["level"] == level_name:
			level["deaths"] += 1

func add_time(level_name: String, exit: int) -> void:
	for level in levels_performance:
		if level["level"] == level_name:
			level["exit"] = exit
			level["time"] += level["exit"] - level["enter"]
			total_time_elapsed += level["exit"] - level["enter"]
			level["enter"] = level["exit"]

func adjust_time(level_name: String, enter: int) -> void:
	for level in levels_performance:
		if level["level"] == level_name:
			level["enter"] = enter
################################################################################
func init_db_room_performance() -> void:
	room_death_count = 0
	start_time = OS.get_unix_time()
	end_time = 0
	room_time = 0
################################################################################


################################################################################
func get_room_death_count() -> int:
	return room_death_count

func add_death_room_count() -> void:
	room_death_count += 1

func get_room_time() -> String:
	var minutes = room_time * 0.0166666666666667
	var seconds = room_time % 60
	var str_room_time = "00:%02d:%02d" % [minutes, seconds]
	return str_room_time

func calculate_room_time() -> void:
	end_time = OS.get_unix_time()
	room_time += (end_time - start_time)
	start_time = end_time
################################################################################

################################################################################








