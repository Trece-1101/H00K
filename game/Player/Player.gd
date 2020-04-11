class_name Player
extends KinematicBody2D

#### variables onready
onready var state_machine: StateMachine = $StateMachine
onready var player_collider: CollisionShape2D = $PlayerCollider
onready var hook: Hook = $Hook
#onready var camera_rig: Position2D = $CameraRig
onready var skin: Node2D = $PlayerSkin
onready var left_wall_detector: WallDetector = $LeftWallDetector
onready var right_wall_detector: WallDetector = $RightWallDetector
onready var floor_detector: FloorDetector = $FloorDetector

#### export variables
export var can_slowmo: bool = true

#### Constantes
const FLOOR_NORMAL: = Vector2.UP

#### Variables
var is_active: = true setget set_is_active
var is_alive:bool = true

#### Setters y Getters
func set_is_active(value: bool) -> void:
	is_active = value
	if not player_collider:
		return
	player_collider.disabled = not value
	## TODO: refactorizar esto cuando se implemente el daño
	hook.set_is_active(value)

func get_is_alive() -> bool:
	return is_alive

func set_is_alive(value: bool) -> void:
	is_alive = value

## TODO: solo DEBUG. REMOVER para version release
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("debug_player_die"):
		self.state_machine.transition_to("Die")

func _physics_process(delta: float) -> void:
	if is_alive:
		check_damage()

func slowmo() -> void:
	if can_slowmo:
		#hook.set_is_slowmo(true)
		hook.set_is_slowmo(not hook.get_is_slowmo())

func is_getting_input() -> bool:
	if !Utils.get_aim_joystick_direction() == Vector2.ZERO:
		return true
	return false

func check_damage() -> void:
	var collision_counter = get_slide_count() - 1
	if collision_counter > -1:
		var col = get_slide_collision(collision_counter)
		if col.collider.is_in_group("Damage"):
			is_alive = false
			self.state_machine.transition_to("Die")
		
