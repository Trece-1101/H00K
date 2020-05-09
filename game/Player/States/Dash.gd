extends State

onready var timer: Timer = $DashTimer

export var dash_speed: float = 1500.0

var direction: Vector2 = Vector2.ZERO
var velocity: Vector2 = Vector2.ZERO setget set_velocity

func set_velocity(value: Vector2) -> void:
	velocity = value

func enter(msg: Dictionary = {}) -> void:
	timer.connect("timeout", self, "_on_DashTimer_timeout", [], CONNECT_ONESHOT)
	direction = msg.direction
	timer.start()

func physics_process(delta: float) -> void:
	velocity = owner.move_and_slide(direction * dash_speed, owner.FLOOR_NORMAL)
	#Events.emit_signal("player_moved", owner)

func _on_DashTimer_timeout() -> void:
	_state_machine.transition_to("Move/Air", {velocity = velocity/2})
