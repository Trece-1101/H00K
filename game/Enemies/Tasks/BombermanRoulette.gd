extends ActionTask

export(float) var boom_chance = 10.0

var roulette: float

func run(tick: Tick) -> int:
	roulette = rand_range(0.0, 100.0)
	if roulette <= boom_chance:
		tick.blackboard.set("ka_boom", true)
		return OK
	else:
		return FAILED
