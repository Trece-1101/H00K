extends State

################################################################################
#### Metodos
func _on_PlayerAnimation_animation_finished(_animation_name: String) -> void:
	#owner.get_current_room().reset()
	get_tree().reload_current_scene()
	_state_machine.transition_to("Spawn")

func enter(_msg: Dictionary = {}) -> void:
	Game.set_player_last_state("Die")
	owner.skin.play("die")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
################################################################################
