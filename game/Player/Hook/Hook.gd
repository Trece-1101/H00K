tool
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
onready var target_circle:DrawingUtils = $TargetCircle

#### variables
var is_active:bool = true setget set_is_active
var is_slowmo:bool = false setget set_is_slowmo
var last_aim_direction: Vector2 = Vector2.ZERO
var can_slowmo: bool = false setget set_can_slowmo, get_can_slowmo

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

func set_can_slowmo(value: bool) -> void:
	can_slowmo = value

func get_can_slowmo() -> bool:
	return can_slowmo

## TODO: refactorizar esta bosta
func set_is_slowmo(value: bool) -> void:
	is_slowmo = value
	if is_slowmo:
		Engine.time_scale = 0.05
		var timer: = get_tree().create_timer(0.08)
		yield(timer, "timeout")
		Engine.time_scale = 1.0
	else:
		Engine.time_scale = 1.0

func get_is_slowmo() -> bool:
	return is_slowmo

#### Metodos
func _ready() -> void:
	if Engine.editor_hint:
		update()

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("slowmo") and can_slowmo:
		set_is_slowmo(true)

func _draw() -> void:
	if not Engine.editor_hint:
		return
	
	var radius: float = snap_detector.calculate_length()
	DrawingUtils.draw_circle_outline(self, Vector2.ZERO, radius, Color.lightblue)

#func has_target() -> bool:
#	var has_target:bool = snap_detector.has_target()
#	if not has_target and ray_cast.is_colliding():
#		var collider: = ray_cast.get_collider()
#		has_target = collider.get_collision_layer_bit(HOOKABLE_PHYSICS_LAYER)
#	return has_target()

func can_hook() -> bool:
	return is_active and snap_detector.has_target() and cooldown.is_stopped()
	#return is_active and has_target() and cooldown.is_stopped()

func get_aim_direction() -> Vector2:
	var direction: = Vector2.ZERO
	match Settings.controls:
		Settings.GAMEPAD:
			direction = Utils.get_aim_joystick_direction()
			if direction != Vector2(0, 0):
				last_aim_direction = direction
			else:
				direction = last_aim_direction
		Settings.KB_MOUSE:
			direction = (get_global_mouse_position() - global_position).normalized()
	return direction

func get_hook_target() -> HookTarget:
	return snap_detector.target

func get_target_position() -> Vector2:
	if snap_detector.target:
		return snap_detector.target.global_position
	else:
		return ray_cast.get_collision_point()
