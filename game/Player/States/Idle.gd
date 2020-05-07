extends State
"""
Estado hijo que maneja el movimiento de idle
Transicion a Correr o a Air
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
	if owner.is_on_floor() and move.get_move_direction().x != 0.0:
		_state_machine.transition_to("Move/Run")
	elif not owner.is_on_floor():
		_state_machine.transition_to("Move/Air")

func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	owner.skin.play("idle_stand")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	
	move.max_speed = move.max_speed_default
	move.velocity = Vector2.ZERO
	
	if not jump_buffer.is_stopped():
		_state_machine.transition_to("Move/Air", {impulse = move.jump_impulse})
		jump_buffer.stop()


func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	move.exit()
################################################################################
