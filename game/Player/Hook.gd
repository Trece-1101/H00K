extends State

"""
Mueve al player hasta el gancho
"""

#### export variables
export var arrive_push: = 500.0

#### variables
var target_global_position: = Vector2(INF, INF)
var velocity: = Vector2.ZERO

#### constantes
const HOOK_MAX_SPEED: = 1600.0


#### Metodos
func physics_process(delta: float) -> void:
	var new_velocity: = Steering.arrive_to(
		velocity,
		owner.global_position,
		target_global_position,
		HOOK_MAX_SPEED
	)
	if new_velocity.length() > arrive_push:
		new_velocity = new_velocity
	else:
		new_velocity.normalized() * arrive_push
	#new_velocity = new_velocity if new_velocity.length() > arrive_push else new_velocity.normalized() * arrive_push
	velocity = owner.move_and_slide(new_velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)

	var to_target: Vector2 = target_global_position - owner.global_position
	var distance: = to_target.length()

	if distance < velocity.length() * delta:
		velocity = velocity.normalized() * arrive_push
		_state_machine.transition_to("Move/Air", {velocity = velocity})

func enter(msg: Dictionary = {}) -> void:
	#print(msg)
	match msg:
		{"target_global_position": var tgp, "velocity": var v}:
			target_global_position = tgp
			velocity = v

func exit() -> void:
	target_global_position = Vector2(INF, INF)
	velocity = Vector2.ZERO
