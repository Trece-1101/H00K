class_name Player
extends KinematicBody2D

################################################################################
#### Constantes
const FLOOR_NORMAL: = Vector2.UP

#### export variables
export var can_slowmo: bool = true

#### Variables
var is_active := true setget set_is_active
var is_alive: bool = true setget set_is_alive, get_is_alive

#### variables onready
onready var state_machine: StateMachine = $StateMachine
onready var move: State = $StateMachine/Move
onready var hook: Hook = $Hook
onready var player_collider: CollisionShape2D = $PlayerCollider
onready var skin: Node2D = $PlayerSkin
onready var left_wall_detector: WallDetector = $LeftWallDetector
onready var right_wall_detector: WallDetector = $RightWallDetector
onready var floor_detector: FloorDetector = $FloorDetector
onready var border_detector: Position2D = $BorderDetector
onready var respawn_sound: AudioStreamPlayer = $SFX/Respawn
onready var jump_sound: AudioStreamPlayer = $SFX/Jump
onready var hook_sound: AudioStreamPlayer = $SFX/Hook
onready var die_sound: AudioStreamPlayer = $SFX/Die
onready var impulse_sound: AudioStreamPlayer = $SFX/Impulse
onready var level_camera := get_parent().get_node("LevelTransitionCamera")
onready var can_move := true
onready var exiting: bool = false
################################################################################

################################################################################
#### Setters y Getters
func set_is_active(value: bool) -> void:
	is_active = value
	if not player_collider:
		return
	player_collider.call_deferred("disabled", not value)
	## TODO: refactorizar esto cuando se implemente el daño
	hook.set_is_active(value)

func set_can_move(value: bool) -> void:
	can_move = value

func get_can_move() -> bool:
	return can_move

func get_is_alive() -> bool:
	return is_alive

func set_is_alive(value: bool) -> void:
	is_alive = value
################################################################################

################################################################################
#### Metodos
func _physics_process(_delta: float) -> void:
	if is_alive:
		check_damage()

func is_getting_input() -> bool:
	if not Utils.get_aim_joystick_direction() == Vector2.ZERO:
		return true
	return false

func apply_move_impulse(impulse_direction: String) -> void:
	move.apply_impulse(impulse_direction)

func check_damage() -> void:
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("Damage") and is_alive:
			die()

# TODO: sacar esto en produccion
func test() -> void:
	print("Hola mundo soy el player")

func toggle_is_active(value: bool) -> void:
	can_move = value
	#set_is_active(false)
	hook.set_is_active(value)
	exiting = not value
	is_alive = value

func die() -> void:
	is_alive = false
	set_is_active(false)
	GamePerformance.increment_death_count(Game.get_player_current_level_name())
	GamePerformance.add_time(Game.get_player_current_level_name(), OS.get_unix_time())
	self.state_machine.transition_to("Die")
################################################################################
