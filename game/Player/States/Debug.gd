extends State
################################################################################
#### export variables
export var speed:Vector2 = Vector2(600.0, 600.0)

#### variables
var velocity

#### onready variables
onready var sprinting:bool = false
################################################################################

################################################################################
#### Metodos
func unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_sprint"):
		sprinting = not sprinting
		if sprinting:
			speed *= 2.0
		else:
			speed /= 2.0
	
	if event.is_action_pressed("debug_move"):
		_state_machine.transition_to("Move/Air", {"velocity": Vector2.ZERO})
	
	if event.is_action_pressed("debug_go_clic"):
		owner.position += owner.get_local_mouse_position()

func physics_process(delta: float) -> void:
	var direction:Vector2 = get_move_direction()
	var multiplier: float
	
	velocity = direction * speed
	owner.position += velocity * delta
	Events.emit_signal("player_moved")

func enter(msg: Dictionary = {}) -> void:
	owner.set_is_active(false)

func exit() -> void:
	owner.set_is_active(true)

static func get_move_direction() -> Vector2:
	return Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("debug_move_down") - Input.get_action_strength("debug_move_up")
	)
################################################################################
