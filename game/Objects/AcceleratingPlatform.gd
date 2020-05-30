extends KinematicBody2D

export(String, "right", "left") var direction
export(float, 310.0, 500.0) var impulse := 350.0 
export(bool) var timered := false
export(float, 1.5, 10.0) var time := 2.0

onready var animation := "arrow_right"
onready var player_detector := $PlayerDetector
onready var is_enable := false

func _ready() -> void:
	set_process(false)
	if direction == "left":
		impulse *= -1
		animation = "arrow_left"
	
	$AnimationPlayer.play(animation)
	if timered:
		$Timer.wait_time = 2.0
		$Timer.start()

func _process(_delta: float) -> void:
	if player_detector.get_overlapping_bodies().size() > 0:
		player_detector.get_overlapping_bodies()[0].move.apply_accelerating_impulse(impulse)

func toogle_enable(value: bool) -> void:
	set_process(value)
	is_enable = !value
	if value:
		$AnimationPlayer.play(animation)
	else:
		$AnimationPlayer.stop()


func _on_PlayerDetector_body_entered(body: Node) -> void:
	body.move.modify_max_speed(abs(impulse))


func _on_PlayerDetector_body_exited(body: Node) -> void:
	body.move.reset_max_speed()


func _on_Timer_timeout() -> void:
	if not $VisibilityNotifier2D.is_on_screen():
		$Timer.stop()
	toogle_enable(is_enable)
