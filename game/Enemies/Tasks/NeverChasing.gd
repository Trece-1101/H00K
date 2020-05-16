extends ConditionTask

func run(tick: Tick) -> int:
	if tick.blackboard.get("never_chasing"):
		return OK
	else:
		return FAILED
