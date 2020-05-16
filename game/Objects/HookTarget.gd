class_name HookTarget
extends Area2D
"""
Area2D que representa un enganche donde el gancho puede engancharse
Si se pone el  is_one_shot en true, el jugador solo puede engancharse una vez
"""
################################################################################
#### señales
signal hooked_onto_from(hook_position)

#### export variables
export var is_one_shot: bool = false

#### variables
var is_active: = true setget set_is_active, get_is_active
var is_targeted : bool = false

#### onready variables
onready var timer: Timer = $Timer
onready var parent_name : String = get_parent().name
onready var animation_player : AnimationPlayer = $AnimationPlayer
################################################################################
#### Setters y Getters
func set_is_active(value: bool) -> void:
	is_active = value
	if is_active:
		animation_player.play("open")
	else:
		animation_player.play("close")

	if not is_active and not is_one_shot:
		timer.start()

func get_is_active() -> bool:
	return is_active
################################################################################
# Metodos
func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")

func focus_lost() -> void:
	if is_active:
		animation_player.play("open")

func focus_gain() -> void:
	if is_active:
		animation_player.play("can_hook")

func _on_Timer_timeout() -> void:
	self.is_active = true
	animation_player.play("go_open")

func hooked_from(hook_position: Vector2) -> void:
	self.is_active = false
	animation_player.play("hooked")
	emit_signal("hooked_onto_from", hook_position)



func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		#body.get_node("StateMachine/Hook").release_from_hook = true
		body.get_node("StateMachine/Hook").set_release_from_hook(true)
		animation_player.play("close")
#		if parent_name == "EnemyBase":
#			queue_free()

#func _on_body_exited(body: Node) -> void:
#	if body.name == "Player" and parent_name == "EnemyTest":
#		body.slowmo()
################################################################################
