extends State

#### Metodos
func _on_PlayerAnimation_animation_finished(animation_name: String) -> void:
	_state_machine.transition_to("Spawn")

func enter(msg: Dictionary = {}) -> void:
	owner.skin.play("die")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
