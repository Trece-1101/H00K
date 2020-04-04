extends State

"""
Estado hijo que maneja el movimiento de Air
Transicion a Idle o a Run
"""

#### export variables

export var acceleration_x: float = 5000.0
export var max_jump_count: int = 2
export var max_dash_count: int = 1
export var get_momentum: bool = false
export(float, 0.5, 0.9) var momentum_divider: float = 0.5
"""

acceleration_x = la aceleracion horizontal cuando el jugador salta
max_jump_count = la cantidad de veces que puede saltar al despegarse del suelo
get_momentum = variable que indica si al saltar se mantiene la velocidad horizontal
	hasta tocar el suelo o por si el contrario al soltar izquierda o derecha
	dicha velocidad cae a 0
"""

#### señales
signal jumped

#### onready variables
onready var move: = get_parent()

#### variables
var _jump_count = 0
var _dash_count = 0


#### Metodos
func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("jump") and _jump_count < max_jump_count:
		jump()
	
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	move.physics_process(delta)
	
	if owner.is_on_floor():
		var target_state: String
		if move.get_move_direction().x == 0.0:
			target_state = "Move/Idle"
		else:
			target_state = "Move/Run"
		
		_state_machine.transition_to(target_state)
	else:
		if move.get_move_direction().x == 0.0 and not get_momentum:
			move.velocity.x *= momentum_divider


func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	move.acceleration.x = acceleration_x
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
		
	if "impulse" in msg:
		jump()
	else:
		_jump_count += 1
	

func exit() -> void:
	move.acceleration = move.acceleration_default
	_jump_count = 0
	_dash_count = 0
	move.exit()

func jump() -> void:
	move.velocity += calculate_jump_velocity(move.jump_impulse)
	_jump_count += 1

func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP
	)
