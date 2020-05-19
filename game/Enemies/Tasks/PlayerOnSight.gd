extends ConditionTask

func run(tick: Tick):
	if tick.blackboard.get("player_on_sight"):
		tick.blackboard.set("current_velocity", tick.blackboard.get("chase_velocity"))
		tick.blackboard.set("was_chasing", true)
		tick.blackboard.set("never_chasing", false)
		return OK
	else:
		tick.blackboard.set("current_velocity", tick.blackboard.get("patrol_velocity"))
		return FAILED
