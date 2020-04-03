extends Position2D
class_name Hook
"""
Tira un raycast que interactua con cuerpos enganchables 
y calcula un vector que tira.
"""

#### onready variables
onready var ray_cast: RayCast2D = $RayCast2D
onready var arrow: Node2D = $Arrow
onready var snap_detector: Area2D = $SnapDetector
onready var cooldown: Timer = $Cooldown

#### variables
var is_active:bool = true setget set_is_active
var is_slowmo:bool = false setget set_is_slowmo

#### constantes
const HOOKABLE_PHYSICS_LAYER: = 4

#### señales
signal hooked_onto_target(target_global_position)


#### Setters y Getters
func set_is_active(value: bool) -> void:
	is_active = value
	visible = value
	set_process_unhandled_input(value)
	set_physics_process(value)

## TODO: refactorizar esta bosta
func set_is_slowmo(value: bool) -> void:
	is_slowmo = value
	if is_slowmo:
		Engine.time_scale = 0.25
	else:
		Engine.time_scale = 1.0

func get_is_slowmo() -> bool:
	return is_slowmo

#### Metodos
func can_hook() -> bool:
	return is_active and snap_detector.has_target() and cooldown.is_stopped()

func get_aim_direction() -> Vector2:
	var direction: = Vector2.ZERO
	match Settings.controls:
		Settings.GAMEPAD:
			direction = Utils.get_aim_joystick_direction()
		Settings.KB_MOUSE:
			direction = (get_global_mouse_position() - global_position).normalized()
			
	return direction


