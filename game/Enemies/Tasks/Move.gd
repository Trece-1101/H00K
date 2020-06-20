extends ActionTask

func run(tick: Tick) -> int:
	tick.blackboard.set("move_direction", tick.blackboard.get("last_move_direction"))
	
	return OK
