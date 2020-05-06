extends State

################################################################################
var target: HookTarget
var hooking_angle : float = 0.0 setget set_hooking_angle
################################################################################

################################################################################
#### Setters y Getters
func set_hooking_angle(value: float) -> void:
	hooking_angle = value
################################################################################

################################################################################
#### Metodos
func physics_process(delta: float) -> void:
	get_parent().physics_process(delta)

func _on_Cooldown_timeout() -> void:
	_state_machine.transition_to("Aim")

func enter(msg: Dictionary = {}) -> void:
	owner.cooldown.connect("timeout", self, "_on_Cooldown_timeout", [], CONNECT_ONESHOT)	
	#owner.is_aiming = false
	owner.cooldown.start()
	#var target: HookTarget = owner.snap_detector.target
	target = owner.snap_detector.target
	if target:
		owner.arrow.hook_position = target.global_position
		target.hooked_from(owner.global_position)	
	#var target: HookTarget = owner.get_hook_target()
#	if target:
#		owner.arrow.hook_position = target.global_position
#		target.hooked_from(owner.global_position)
#	else:
#		owner.arrow.hook_position = owner.ray_cast.get_collision_point()
	
	#owner.emit_signal("hooked_onto_target", owner.get_target_position())
	var hooked_on_enemy = bool(target.get_parent() is EnemyBase)
	owner.set_can_slowmo(hooked_on_enemy)
	if hooked_on_enemy: 
		$SlowmoTapTimer.start()
		target.get_parent().set_queue(true)
	
	owner.emit_signal("hooked_onto_target", target.global_position, hooking_angle)

#func exit() -> void:
#	owner.cooldown.disconnect("timeout", self, "_on_Cooldown_timeout")
#	if owner.get_is_slowmo() == true:
#		owner.set_is_slowmo(false)

func set_visual_arrow_on_enemy(value: bool, rotation:Vector2) -> void:
	target.get_parent().set_arrow_queue(value, rotation)

func _on_SlowmoTapTimer_timeout() -> void:
	owner.set_can_slowmo(false)
	target.get_parent().set_queue(false)
################################################################################
