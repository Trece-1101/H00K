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
var target_global_position: = Vector2.INF
var velocity: = Vector2.ZERO
var release_from_hook:bool = false
################################################################################

################################################################################
#### Metodos
func physics_process(delta: float) -> void:
	var new_velocity: = Steering.arrive_to(
		velocity,
		owner.global_position,
		target_global_position,
		HOOK_MAX_SPEED
	)

	var low_speed = false

	if new_velocity.length() > arrive_push:
		new_velocity = new_velocity
	else:
		new_velocity = new_velocity.normalized() * arrive_push
		low_speed = true
	
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
	else:
		if release_from_hook:
			_state_machine.transition_to("Move/Air", 
			{velocity = velocity * 0.6, can_jump_after_hook = jump_after_hook})

func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("idlehook_mid")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	release_from_hook = false
	match msg:
		{"target_global_position": var tgp, "velocity": var v}:
			target_global_position = tgp
			velocity = v

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	release_from_hook = false
	target_global_position = Vector2.INF
	velocity = Vector2.ZERO
################################################################################
