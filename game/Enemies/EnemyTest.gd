extends KinematicBody2D

var velocity: Vector2 = Vector2(40.0, 0.0)
var move_direction: float = 1.0
var move_range: float = 20.0
var start_position: float

func _ready() -> void:
	start_position = global_position.x

func _physics_process(delta: float) -> void:
	var current_position = global_position.x
	if (abs(current_position - start_position)) > move_range:
		move_direction *=-1
		
	move_and_slide(velocity * move_direction, Vector2.UP)
