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
var is_active: = true setget set_is_active

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

#### Metodos
func can_hook() -> bool:
	return is_active and snap_detector.has_target() and cooldown.is_stopped()

func get_aim_direction() -> Vector2:
	var direction: = Vector2.ZERO
	direction = (get_global_mouse_position() - global_position).normalized()
	return direction


