extends State

"""
Spawnea al jugador (no tiene control el usuario en el intermedio)
"""
################################################################################
#### variables
var _start_position: Vector2 = Vector2.ZERO
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position

func _on_PlayerAnimation_animation_finished(_animation_name: String) -> void:
	if not owner.is_on_floor():
		_state_machine.transition_to("Air")
	
	_state_machine.transition_to("Move/Idle")

func enter(_msg: Dictionary = {}) -> void:
	owner.set_is_active(false)
	if Game.get_player_respawn_position() == Vector2.ZERO:
		owner.position = _start_position
		Game.set_player_respawn_position(_start_position)
	else:
		owner.position = Game.get_player_respawn_position()
	
	play_animation_and_sound()

func play_animation_and_sound() -> void:	
	owner.skin.play("spawn")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	if Game.get_player_last_state() == "Die":
		owner.respawn_sound.play()

func exit() -> void:
	owner.set_is_active(true)
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
################################################################################
