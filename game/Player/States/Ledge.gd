extends State

#### Metodos
func _on_Skin_animation_finished(name: String) -> void:
	if name == "ledge":
		_state_machine.transition_to("Move/Run")

func enter(msg: Dictionary = {}) -> void:
	assert("move_state" in msg and msg.move_state is State)
	
	owner.skin.connect("animation_finished", self, "_on_Skin_animation_finished"
	, [], CONNECT_DEFERRED)
	
	var start_position:Vector2 = owner.global_position
	var ld: WallDetector = owner.wall_detector
	owner.global_position = ld.get_top_global_position() + ld.get_cast_to_direction()
	owner.global_position = owner.floor_detector.get_floor_position()
	msg.move_state.velocity.y = 0.0
	#owner.skin.position = start_position - owner.global_position
	owner.skin.play("ledge", {from=start_position - owner.global_position})

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_Skin_animation_finished")
