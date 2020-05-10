tool
extends KinematicBody2D

################################################################################
#### Variables export
export var speed: float = 200.0
export var wait_time: float = 1.0 setget set_wait_time

#### Varibales onready
onready var timer: Timer = $Timer
onready var tween: Tween = $Tween
onready var path_points := $Pathpoints
onready var started: bool = false
#onready var path_points: PathPoints
################################################################################

################################################################################
#### Setters y getters
func set_wait_time(value: float) -> void:
	wait_time = value
	if not timer:
		yield(self, "ready")
	timer.wait_time = wait_time
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	set_process(false)
	
	if Engine.editor_hint:
		return
	
	if not path_points:
		printerr("Falta ruta para la plataforma")
		return

func _process(_delta: float) -> void:
	if !started:
		started = true
		position = path_points.get_start_position()
		timer.start()

func _on_Timer_timeout() -> void:
	var target_position: Vector2 = path_points.get_next_position()
	var distance_to_target := position.distance_to(target_position)
	tween.interpolate_property(self, "position", position, target_position, distance_to_target / speed)
	tween.start()


func _on_Tween_tween_all_completed() -> void:
	timer.start()
################################################################################
