extends ActionTask

func run(tick: Tick) -> int:
	var patrol_velocity = tick.blackboard.get("patrol_velocity")
	var chase_velocity = tick.blackboard.get("chase_velocity")
	var speed_increment = tick.blackboard.get("vel_increment")
	
	patrol_velocity *= speed_increment
	chase_velocity *= speed_increment
	
	patrol_velocity = clamp_velocity(tick, patrol_velocity)
	chase_velocity = clamp_velocity(tick, chase_velocity)
	
	tick.blackboard.set("patrol_velocity", patrol_velocity)
	tick.blackboard.set("chase_velocity", chase_velocity)
	
	tick.blackboard.set("was_chasing", false)
	
	return OK


func clamp_velocity(tick: Tick, vel: Vector2) -> Vector2:
	var max_speed = tick.blackboard.get("max_velocity")
	if vel > max_speed:
		vel = max_speed
	return vel
