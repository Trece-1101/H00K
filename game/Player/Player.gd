class_name Player
extends KinematicBody2D

#### variables onready
onready var state_machine: StateMachine = $StateMachine
onready var player_collider: CollisionShape2D = $PlayerCollider
onready var hook: Hook = $Hook
onready var camera_rig: Position2D = $CameraRig
onready var skin: Node2D = $PlayerSkin

export var can_slowmo: bool = true

#### Constantes
const FLOOR_NORMAL: = Vector2.UP

#### Variables
var is_active: = true setget set_is_active

#### Setters y Getters
func set_is_active(value: bool) -> void:
	is_active = value
	if not player_collider:
		return
	player_collider.disabled = not value
	## TODO: refactorizar esto cuando se implemente el daño
	hook.set_is_active(value)


## TODO: solo DEBUG. REMOVER para version release
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("debug_player_die"):
		self.state_machine.transition_to("Die")

func slowmo() -> void:
	if can_slowmo:
		#hook.set_is_slowmo(true)
		hook.set_is_slowmo(not hook.get_is_slowmo())
