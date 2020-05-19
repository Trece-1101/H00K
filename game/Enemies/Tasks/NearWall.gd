extends ConditionTask

func run(tick: Tick):
	if tick.blackboard.get("wall_is_near"):
		tick.blackboard.set("last_move_direction", tick.blackboard.get("move_direction"))
		tick.blackboard.set("move_direction", Vector2(0.0, 1.0))
		return OK
	else:
		return FAILED
