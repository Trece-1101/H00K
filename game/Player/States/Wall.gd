extends State
"""
Este estado maneja lo que respecta al jugador cuando choca contra la pared
"""

#### export variables
export var slide_acceleration: float = 800.0
export var max_slide_speed: float = 200.0
export(float, 0.05, 0.95) var friction_wall: float = 0.15

"""
slide_acceleration = si la velocidad de caida al tocar la pared es menor (ya esta
	bajando por la pared por ejemplo) va acelerando su caida
max_slide_speed = la velocidad de caida al tocar la pared (si viene mas rapido que
	esta velocidad, la baja al limite). Tener en cuenta que mas alto el valor
	mas rapido se desliza para abajo
friction_wall = para que el personaje no pase de la velocidad de caida derecho a la
	de slide, se aplica una friccion adentro de un lerp para hacerlo suave
"""
#### onready variables
onready var move: = get_parent()

#### variables
var _wall_normal: float = -1.0
var _velocity: Vector2 = Vector2.ZERO


#### Metodos
func physics_process(delta: float) -> void:
	if _velocity.y > max_slide_speed:
		_velocity.y = lerp(_velocity.y, max_slide_speed, friction_wall)
	else:
		_velocity.y += slide_acceleration * delta
	#_velocity.y = clamp(_velocity.y,-max_slide_speed, max_slide_speed)
	_velocity = owner.move_and_slide(_velocity, owner.FLOOR_NORMAL)
	
	if owner.is_on_floor():
		_state_machine.transition_to("Move/Idle")
	
	# sign devuelve solo el signo + o - de la direccion, copado
	var is_moving_away_from_wall: bool = sign(move.get_move_direction().x) == sign(_wall_normal)
	
	if is_moving_away_from_wall:
		_state_machine.transition_to("Move/Air", {velocity = _velocity})
	

func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	_wall_normal = msg.normal
	#_velocity.y = clamp(msg.velocity.y,-max_slide_speed, max_slide_speed)
	_velocity.y = msg.velocity.y

func exit() -> void:
	move.exit()
