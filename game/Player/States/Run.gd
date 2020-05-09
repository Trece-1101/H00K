extends State
"""
Estado hijo que maneja el movimiento de correr
Transicion a Idle o a Air
"""
################################################################################
#### onready variables
onready var move: = get_parent()
onready var jump_buffer: Timer = $JumpBuffer
################################################################################

################################################################################
#### Metodos
func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	owner.skin.scale.x = move.get_sprite_direction(owner.skin.scale.x)
	owner.border_detector.position.x = owner.skin.scale.x * 16
	
	if !owner.get_is_alive():
		owner.set_is_alive(true)
	
	if owner.is_on_floor():
		if move.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	
	move.physics_process(delta)

func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	owner.skin.play("run")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	
	if not jump_buffer.is_stopped():
		_state_machine.transition_to("Move/Air", {impulse = move.jump_impulse})
		jump_buffer.stop()

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	move.exit()
################################################################################
