extends State
"""
Mueve al player hasta el gancho
"""
################################################################################
#### constantes
const HOOK_MAX_SPEED: = 1600.0

#### export variables
export var arrive_push: float = 350.0
export var jump_after_hook: bool = false

#### variables
var target_global_position := Vector2.INF
var velocity := Vector2.ZERO
var release_from_hook: bool = false setget set_release_from_hook, get_release_from_hook
var hooking_animation: String = ""
var sprite_offset := Vector2(1, -18)

onready var ghost := preload("res://game/Player/Ghost.tscn")
################################################################################
#### Setters y Getters
func set_release_from_hook(value: bool) -> void:
	release_from_hook = value

func get_release_from_hook() -> bool:
	return release_from_hook

################################################################################
#### Metodos
func physics_process(delta: float) -> void:
	var new_velocity: = Steering.arrive_to(
		velocity,
		owner.global_position,
		target_global_position,
		HOOK_MAX_SPEED
	)

	var _low_speed = false

	if new_velocity.length() > arrive_push:
		new_velocity = new_velocity
	else:
		new_velocity = new_velocity.normalized() * arrive_push
		_low_speed = true
	
	if owner.is_on_ceiling():
		_state_machine.transition_to("Move/Air", 
			{velocity = velocity, can_jump_after_hook = jump_after_hook})
		
	velocity = owner.move_and_slide(new_velocity, owner.FLOOR_NORMAL)
	#Events.emit_signal("player_moved", owner)
	
	var to_target: Vector2 = target_global_position - owner.global_position
	var distance: = to_target.length()
	
	if distance < velocity.length() * delta:
		velocity = velocity.normalized() * arrive_push
		_state_machine.transition_to("Move/Air", 
			{velocity = velocity, can_jump_after_hook = jump_after_hook})
		owner.impulse_sound.play()
	else:
		if release_from_hook:
			_state_machine.transition_to("Move/Air", 
			{velocity = velocity * 0.6, can_jump_after_hook = jump_after_hook})
			owner.impulse_sound.play()

func enter(msg: Dictionary = {}) -> void:
	$GhostTimer.start()
	release_from_hook = false
	match msg:
# warning-ignore:unassigned_variable
# warning-ignore:unassigned_variable
# warning-ignore:unassigned_variable
		{"target_global_position": var tgp, "velocity": var v, "hooking_animation": var animation}:
			target_global_position = tgp
			velocity = v
			hooking_animation = animation
	
	owner.hook_sound.play()
	owner.skin.play(hooking_animation)
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

	owner.level_camera.camara_shake()

func exit() -> void:
	$GhostTimer.stop()
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	release_from_hook = false
	target_global_position = Vector2.INF
	velocity = Vector2.ZERO

func _on_GhostTimer_timeout() -> void:
	var new_ghost := ghost.instance()
	var new_ghost_texture: String = owner.hook.ghost_sprite
	owner.get_parent().add_child(new_ghost)
	new_ghost.global_position = owner.global_position + sprite_offset
	new_ghost.scale.x = owner.skin.scale.x
	new_ghost.texture = load(new_ghost_texture)
################################################################################	
