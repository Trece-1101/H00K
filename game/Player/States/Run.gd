extends State

"""
Estado hijo que maneja el movimiento de correr
Transicion a Idle o a Air
"""
#### onready variables
onready var move: = get_parent()
onready var jump_buffer: Timer = $JumpBuffer


#### Metodos
func unhandled_input(event: InputEvent) -> void:
	move.unhandled_input(event)

func physics_process(delta: float) -> void:
	if owner.is_on_floor():
		if move.get_move_direction().x == 0.0:
			_state_machine.transition_to("Move/Idle")
	else:
		_state_machine.transition_to("Move/Air")
	
	move.physics_process(delta)

func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	
	if not jump_buffer.is_stopped():
		_state_machine.transition_to("Move/Air", {impulse = move.jump_impulse})
		jump_buffer.stop()

func exit() -> void:
	move.exit()
