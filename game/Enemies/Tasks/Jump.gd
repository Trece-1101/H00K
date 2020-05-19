extends ActionTask

func run(tick: Tick) -> int:
	var player_position:Vector2 = tick.blackboard.get("last_know_player_position")
	var random_position_add:float = rand_range(-200, 200.0)
	
	tick.blackboard.set("telport", true)
	tick.blackboard.set("telport_position", player_position + Vector2(random_position_add, 0.0))
	
	return OK
