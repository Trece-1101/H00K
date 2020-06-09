extends Node2D

func _ready() -> void:
	var level_number := Game.get_player_current_level_number()
	var level_name := Game.get_player_current_level_name()
	
	$LevelCompleted.text = "Nivel {level} completado".format({"level": level_number})
	$Time.text = GamePerformance.get_time_performance(level_name, false)
	$Death.text = "x {deaths}".format({"deaths": GamePerformance.get_death_performance(level_name, false)})
	
	Game.init_level()

func load_level() -> void:
	get_tree().change_scene(Game.get_player_next_level())
