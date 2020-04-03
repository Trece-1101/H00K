extends Position2D
"""
Rig to move a child camera based on the player's input, to give them more forward visibility
"""

#### export variables
export var offset: = Vector2(300.0, 300.0)
export var mouse_range: = Vector2(100.0, 500.0)

#### onready variables
onready var camera: Camera2D = $ShakingCamera

#### variables
var is_active: bool = true setget set_is_active, get_is_active


#### Setters y Getters
func set_is_active(value: bool) -> void:
	is_active = value

func get_is_active() -> bool:
	return is_active

#### metodos
func _physics_process(delta: float) -> void:
	update_position()

func update_position(velocity: Vector2 = Vector2.ZERO) -> void:
	"""Updates the camera rig's position based on the player's state and controller position"""
	if not is_active:
		return
	
	match Settings.controls:
		Settings.KB_MOUSE:
			var mouse_position: = get_local_mouse_position()
			var distance_ratio: = clamp(mouse_position.length(), mouse_range.x, mouse_range.y) / mouse_range.y
			camera.position = distance_ratio * mouse_position.normalized() * offset
		Settings.GAMEPAD:
			var joy_strenght = Utils.get_aim_joystick_strenght()
			camera.position = joy_strenght * offset
