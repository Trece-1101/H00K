class_name Player
extends KinematicBody2D

#### variables onready
onready var state_machine: StateMachine = $StateMachine
onready var player_collider: CollisionShape2D = $PlayerCollider
onready var hook: Hook = $Hook
onready var camera_rig = $CameraRig


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


#### DEBUG
func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("debug_restart"):
		get_tree().reload_current_scene()
	
	if event.is_action_pressed("debug_player_die"):
		state_machine.transition_to("Die")
