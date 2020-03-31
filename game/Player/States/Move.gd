extends State

"""
Estado padre que abstrae y maneja movimientos basicos
Estados hijos relacionados al movimiento pueden delegar movimientos al padre
o usar funcionalidades de él
"""
#### export variables
export var max_speed_default: = Vector2(500.0, 1500.0)
export var acceleration_default: = Vector2(100000.0, 3000.0)
export var max_speed_fall: = 800

#### variables
var acceleration: = acceleration_default
var max_speed: = max_speed_default
var velocity: = Vector2.ZERO

#### metodos
func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		_state_machine.transition_to("Move/Air", {impulse = true})

func physics_process(delta: float) -> void:
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta,
	get_move_direction())
	velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	
func _on_Hook_hooked_onto_target(target_global_position: Vector2) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return
	
	_state_machine.transition_to("Hook", {target_global_position = target_global_position,
	velocity = velocity})

func enter(msg: Dictionary = {}) -> void:
	pass
	#owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")

func exit() -> void:
	pass
	#owner.hook.disconnect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")

static func calculate_velocity(
		old_velocity: Vector2, 
		max_speed: Vector2,
		acceleration: Vector2,
		delta: float,
		move_direction: Vector2,
		max_speed_fall: = 1000
	) -> Vector2:
	var new_velocity: = old_velocity
	
	new_velocity += move_direction * acceleration * delta
	new_velocity.x = clamp(new_velocity.x, -max_speed.x, max_speed.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed.y, max_speed.y)	
	return new_velocity


static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 1.0
	)
