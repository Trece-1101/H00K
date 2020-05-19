extends ActionTask

func run(tick: Tick) -> int:
	var direction = tick.blackboard.get("last_move_direction")
	
	if direction.x == 1.0:
		tick.blackboard.set("last_move_direction", Vector2(-1.0, 1.0))
	elif direction.x == -1.0:
		tick.blackboard.set("last_move_direction", Vector2(1.0, 1.0))
	else:
		tick.blackboard.set("last_move_direction", Vector2(0.0, 1.0))
	
	tick.blackboard.set("move_direction", Vector2(0.0, 1.0))
	
	return OK
