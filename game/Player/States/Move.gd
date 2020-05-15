extends State

"""
Estado padre que abstrae y maneja movimientos basicos
Estados hijos relacionados al movimiento pueden delegar movimientos al padre
o usar funcionalidades de él
"""
################################################################################
#### variables
var velocity: Vector2 = Vector2.ZERO
var transition_move: int = 45

#### export variables
export var max_speed_default: Vector2 = Vector2(220.0, 800.0)
export var acceleration_default: Vector2 = Vector2(1000.0, 1600.0)
export var max_speed_fall: float = 500.0
export var jump_impulse: float = 450.0
export var fatality_impulse: float = 500.0
export var hook_jump_impulse: float = 200.0
export var transition_impulse: float = 150.0
"""
Todos estos valores default seran asignados a las variables correspondientes
al iniciar el juego/nivel

max_speed = la velocidad maxima que puede alcanzar el jugador. La velocidad horizontal
	dictamina que tan rapido corre (+X +Velocidad) y la velocidad en vertical
	dictamina que tanto puede saltar (no es la fuerza de salto) y a cuanta velocidad
	puede caer (no es la gravedad, es mas bien que tan rapido puede llegar a caer)
acceleration = la aceleracion horizontal (resistencia/friccion) y vertical (gravedad)
	en este caso a menor aceleracion horizontal mas resistencia (+X +resistencia)
	lo que significa que el jugador tarda mas en llegar a la max_speed y a mayor
	aceleracion vertical mas gravedad (+Y +gravedad) lo que significa que el jugador
	es mas pesado (cuesta mas saltar y cae mas rapido)
max_speed_fall = la velocidad maxima a la que puede caer el player. Bajar este
	valor puede dar la sensacion de flotar al caer, por el contrario subir este
	valor puede hacer que la velocidad se incremente muchisimo desde grandes alturas
jump_impulse = fuerza del salto (que tan para arriba va)
"""
#### Variables onready
onready var acceleration: = acceleration_default
onready var max_speed: = max_speed_default
################################################################################

################################################################################
#### metodos
func unhandled_input(event: InputEvent) -> void:
	if owner.is_on_floor() and event.is_action_pressed("jump"):
		if !owner.floor_detector.is_in_platform():
			_state_machine.transition_to("Move/Air", {impulse = true})
		else:
			_state_machine.transition_to("Move/Air", {impulse = true, platform = true})

	## TODO: solo DEBUG
	if event.is_action_pressed("debug_move"):
		_state_machine.transition_to("Debug")


func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		max_speed = max_speed_default
		get_node("Air")._jump_after_hook = false
	
	velocity = calculate_velocity(velocity, max_speed, acceleration, delta,
	get_move_direction(), max_speed_fall)
	
	velocity = owner.move_and_slide_with_snap(velocity, Vector2.DOWN * 20.0, owner.FLOOR_NORMAL)
	#velocity = owner.move_and_slide(velocity, owner.FLOOR_NORMAL)
	#Events.emit_signal("player_moved", owner)
	
func _on_Hook_hooked_onto_target(target_global_position: Vector2, hooking_animation: String) -> void:
	var to_target: Vector2 = target_global_position - owner.global_position
	if owner.is_on_floor() and to_target.y > 0.0:
		return
	
	_state_machine.transition_to("Hook", {target_global_position = target_global_position,
	velocity = velocity, hooking_animation = hooking_animation})

func enter(_msg: Dictionary = {}) -> void:
	owner.hook.connect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.connect("jumped", $Idle.jump_buffer, "start")
	$Air.connect("jumped", $Run.jump_buffer, "start")

func exit() -> void:
	owner.hook.disconnect("hooked_onto_target", self, "_on_Hook_hooked_onto_target")
	$Air.disconnect("jumped", $Idle.jump_buffer, "start")
	$Air.disconnect("jumped", $Run.jump_buffer, "start")

static func calculate_velocity(
		old_velocity: Vector2, 
		max_speed_func: Vector2,
		acceleration_func: Vector2,
		delta: float,
		move_direction: Vector2,
		max_speed_fall_func: float,
		is_jump_interrupted: bool = false
	) -> Vector2:
	var new_velocity: = old_velocity
	
	new_velocity += move_direction * acceleration_func * delta
	if is_jump_interrupted:
		new_velocity.y = 0.0
	new_velocity.x = clamp(new_velocity.x, -max_speed_func.x, max_speed_func.x)
	new_velocity.y = clamp(new_velocity.y, -max_speed_func.y, max_speed_fall_func)
	
	return new_velocity

func apply_impulse(direction: String) -> void:
	if direction == "right":
		owner.global_position.x += transition_move
	elif direction == "left":
		owner.global_position.x -= transition_move
	elif direction == "top":
		velocity.y -= transition_impulse

## TODO: esto liquida el movimiento con KB
## SOLUCIONALO
static func get_move_direction() -> Vector2:
	return Vector2(Utils.get_aim_joystick_strenght().x, 1.0)
#	return Vector2(
#		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 1.0
#	)

static func get_move_kb_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 1.0
	)

static func get_sprite_direction(last_direction: float) -> float:
	var direction: float = get_move_direction().x
	var result
	
	if direction == 0.0:
		return last_direction
	else:
		if direction > 0.0:
			result = 1.0
		else:
			result = -1.0
	
	return result
################################################################################
