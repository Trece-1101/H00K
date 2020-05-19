extends ConditionTask

func run(tick: Tick) -> int:
	var player_position:Vector2 = tick.blackboard.get("last_know_player_position")
	var npc_position:Vector2 = tick.blackboard.get("current_position")
	var npc_orientation:Vector2 = tick.blackboard.get("move_direction")
	
	# le dijo falcon al capi
	var on_your_left = player_position < npc_position
	
	tick.blackboard.set("last_move_direction", npc_orientation)
	
	if on_your_left:
		if npc_orientation.x == -1.0:
			return FAILED
		else:
			return OK
	else:
		if npc_orientation.x == -1.0:
			return OK
		else:
			return FAILED
	
