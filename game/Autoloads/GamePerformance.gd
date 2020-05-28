extends Node

################################################################################
var total_death_count: int = 0
var levels_performance := []
var level_performance := {}
var total_time_elapsed := 0
var total_rooms := 0
################################################################################
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
################################################################################
func set_player_death_count(value: int) -> void:
	total_death_count = value

func get_player_death_count() -> int:
	return total_death_count

func get_time_performance(level_name: String) -> String:
	for level in levels_performance:
		if level["level"] == level_name:
			var elapsed = level["time"]
			var minutes = elapsed / 60
			var seconds = elapsed % 60
			var str_elapsed = "%02d:%02d" % [minutes, seconds]
			#print("------------------------")
			#print("Tiempo Total", str_elapsed)
			#print(str_elapsed)
			return(str_elapsed)
	
	return "00:00"

func get_death_performance(level_name: String) -> int:
	for level in levels_performance:
		if level["level"] == level_name:
			return level["deaths"]
	
	return 0
################################################################################

################################################################################
#### Metodos
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
			level["enter"] = level["exit"]


################################################################################
