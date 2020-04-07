extends State

"""
Estado hijo que maneja el movimiento de Air
Transicion a Idle o a Run
"""

#### señales
signal jumped

#### export variables
export var acceleration_x: float = 5000.0
export var get_momentum: bool = false
export(float, 0.5, 0.9) var momentum_divider: float = 0.5
"""

acceleration_x = la aceleracion horizontal cuando el jugador salta
max_jump_count = la cantidad de veces que puede saltar al despegarse del suelo
get_momentum = variable que indica si al saltar se mantiene la velocidad horizontal
	hasta tocar el suelo o por si el contrario al soltar izquierda o derecha
	dicha velocidad cae a 0
"""

#### onready variables
onready var move: = get_parent()
onready var freeze_timer:Timer = $FreezeTimer
onready var jump_delay: Timer = $JumpDelay

#### variables
var _is_jump_interrupted: bool
var _is_jumping: bool

#### Metodos
func unhandled_input(event: InputEvent) -> void:
	#var move: = get_parent()
	# Jump after falling off a ledge
	if event.is_action_pressed("jump"):
		if (move.velocity.y >= 0.0 and jump_delay.time_left > 0.0
			and not _is_jumping):
			move.velocity = calculate_jump_velocity(move.jump_impulse)
			_is_jumping = true
		#emit_signal("jumped")
	else:
		move.unhandled_input(event)

func physics_process(delta: float) -> void:	
	_is_jump_interrupted = Input.is_action_just_released("jump") and move.velocity.y < 0.0
	
	var direction: Vector2
	if freeze_timer.is_stopped():
		direction = move.get_move_direction()
	else:
		direction = Vector2(sign(move.velocity.x), 1.0)
	
	move.velocity = move.calculate_velocity(
		move.velocity, 
		move.max_speed,
		move.acceleration, 
		delta, 
		direction,
		move.max_speed_fall,
		_is_jump_interrupted)
	
	move.velocity = owner.move_and_slide(move.velocity, owner.FLOOR_NORMAL)
	Events.emit_signal("player_moved", owner)
	
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
		
		if owner.wall_detector.is_against_ledge():
			_state_machine.transition_to("Ledge", {move_state = move})
	
	if owner.is_on_wall():
		var wall_normal: float = owner.get_slide_collision(0).normal.x
		_state_machine.transition_to("Move/Wall", 
			{"normal": wall_normal, "velocity": move.velocity})


func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
#	if !owner.is_on_floor() && move.was_on_floor():
#		_is_jumping = false
	
	move.acceleration.x = acceleration_x
	
	if "velocity" in msg:
		move.velocity = msg.velocity
		move.max_speed.x = max(abs(msg.velocity.x), move.max_speed.x)
	if "impulse" in msg:
		jump()
		_is_jumping = true
	if "wall_jump" in msg:
		freeze_timer.start()
		_is_jumping = true
		move.acceleration = Vector2(acceleration_x, move.acceleration_default.y)
		move.max_speed.x = max(abs(move.velocity.x), move.max_speed_default.x)
	
	jump_delay.start()

func exit() -> void:
	move.acceleration = move.acceleration_default
	_is_jumping = false
	move.exit()

func jump() -> void:
	move.velocity += calculate_jump_velocity(move.jump_impulse)

func calculate_jump_velocity(impulse: float = 0.0) -> Vector2:
	return move.calculate_velocity(
		move.velocity,
		move.max_speed,
		Vector2(0.0, impulse),
		1.0,
		Vector2.UP,
		move.max_speed_fall
	)
