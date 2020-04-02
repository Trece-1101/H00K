extends State

#### Metodos
func _on_PlayerAnimation_animation_finished(animation_name: String) -> void:
	_state_machine.transition_to("Spawn")

func enter(msg: Dictionary = {}) -> void:
	set_actives(false)
	owner.skin.play("die")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

func set_actives(active: bool) -> void:
	owner.set_is_active(active)
	if owner.camera_rig:
		owner.camera_rig.set_is_active(active)
