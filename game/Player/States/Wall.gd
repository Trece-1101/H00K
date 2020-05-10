extends State
"""
Este estado maneja lo que respecta al jugador cuando choca contra la pared
"""
################################################################################
#### export variables
export var slide_acceleration: float = 600.0
export var default_max_slide_speed: float = 180.0
export(float, 0.05, 0.95) var friction_wall: float = 0.30
export var wall_jump_strength: Vector2 = Vector2(250.0, 400.0)
export(float, 1.1, 3.0) var slide_speed_incrementor = 1.3
"""
slide_acceleration = si la velocidad de caida al tocar la pared es menor (ya esta
	bajando por la pared por ejemplo) va acelerando su caida
max_slide_speed = la velocidad de caida al tocar la pared (si viene mas rapido que
	esta velocidad, la baja al limite). Tener en cuenta que mas alto el valor
	mas rapido se desliza para abajo
friction_wall = para que el personaje no pase de la velocidad de caida derecho a la
	de slide, se aplica una friccion adentro de un lerp para hacerlo suave
jump_wall_strength = la fuerza con la que el jugador se impulsa desde la pared.
	En este caso a cuanto mayor X -> mas lejania horizontal y a cuanto mas Y ->
	mayor verticalidad
"""
#### variables
var _wall_normal: float = -1.0
var _velocity: Vector2 = Vector2.ZERO
var _pushing_against_wall: bool = true
var is_moving_away_from_wall: bool = false
var is_sliding: bool = false

#### onready variables
onready var move: = get_parent()
onready var max_slide_speed = default_max_slide_speed
################################################################################

################################################################################
#### Metodos
func unhandled_input(_event: InputEvent) -> void:
	if Input.is_action_just_pressed("jump"):
		jump()

func physics_process(delta: float) -> void:
	if (owner.right_wall_detector.head_at_wall_level() or owner.left_wall_detector.head_at_wall_level()) and !is_sliding:
		is_sliding = true
		owner.skin.play("wallslide")
	
	if ((sign(_wall_normal) > 0.0 and Input.is_action_pressed("move_left")) 
		or (sign(_wall_normal) < 0.0 and Input.is_action_pressed("move_right"))):
		_pushing_against_wall = true
	else:
		_pushing_against_wall = false
	
	if not(_pushing_against_wall):
		_state_machine.transition_to("Move/Air", {velocity = _velocity})
		#max_slide_speed = default_max_slide_speed * slide_speed_incrementor
	else:
		max_slide_speed = default_max_slide_speed

	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	
	if _velocity.y > max_slide_speed:
		_velocity.y = lerp(_velocity.y, max_slide_speed, friction_wall)
	else:
		_velocity.y += slide_acceleration * delta

	if !owner.right_wall_detector.is_all_body_against_wall() and !owner.left_wall_detector.is_all_body_against_wall():
			if !owner.is_on_wall():
				_state_machine.transition_to("Move/Air", {velocity = _velocity, is_jumping = true})

#	if (!owner.right_wall_detector.is_against_wall() and !owner.left_wall_detector.is_against_wall()):
#			if !owner.is_on_wall():
#				_state_machine.transition_to("Move/Air", {velocity = _velocity, is_jumping = true})
	
	#_velocity.y = clamp(_velocity.y,-max_slide_speed, max_slide_speed)
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)
	
	
	# sign devuelve solo el signo + o - de la direccion, copado
#	is_moving_away_from_wall = sign(move.get_move_direction().x) == sign(_wall_normal)
#
#	if is_moving_away_from_wall or not owner.wall_detector.is_against_wall():
#		#print("caer")
#		_state_machine.transition_to("Move/Air", {velocity = _velocity})
	
	
#	if owner.wall_detector.is_against_ledge():
#		_state_machine.transition_to("Ledge", {move_state = move})
	

func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	owner.slide_sound.play()
	
	if owner.right_wall_detector.head_at_wall_level() or owner.left_wall_detector.head_at_wall_level():
		owner.skin.play("wallslide")
	#owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	
	move.get_node("Air")._jump_after_hook = false
	_wall_normal = msg.normal
	_velocity.y = max(msg.velocity.y, -max_slide_speed)
	
	if "jump" in msg:
		jump()

func jump() -> void:
	owner.skin.scale.x *= -1
	owner.border_detector.position.x = -owner.skin.scale.x * 6
	var impulse: Vector2 = Vector2(_wall_normal, -1.0) * wall_jump_strength
	var msg: Dictionary = {
		velocity = impulse,
		wall_jump = true,
		is_jumping = true
	}
	
	owner.jump_sound.play()
#	if is_moving_away_from_wall or !owner.is_getting_input():
#		owner.wall_detector.scale.x *= -1
	_state_machine.transition_to("Move/Air", msg)

func exit() -> void:
	#owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	is_sliding = false
	move.exit()
################################################################################
