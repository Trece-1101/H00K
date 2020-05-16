extends ConditionTask

func run(tick: Tick) -> int:
	if tick.blackboard.get("was_chasing"):
		return OK
	else:
		return FAILED
