extends Node2D

func _ready() -> void:
	Game.init_level()
	
	var level_number := Game.get_player_current_level_number()
	var level_name := Game.get_player_current_level_name()
	
	$LevelCompleted.text = "Nivel {level} completado".format({"level": level_number})
	$Time.text = GamePerformance.get_time_performance(level_name)
	$Death.text = "x {deaths}".format({"deaths": GamePerformance.get_death_performance(level_name)})

func load_level() -> void:
	get_tree().change_scene(Game.get_player_next_level())
