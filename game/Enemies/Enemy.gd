class_name Enemy
extends KinematicBody2D

#### Variables export
export(Vector2) var velocity = Vector2.ZERO

#### Varibales
var is_alive : bool = true

#### Onready Variables
onready var move_direction: Vector2 = Vector2(1.0, 1.0)

#### Metodos
func physics_process(delta: float) -> void:
	var movement: Vector2

	movement = velocity * move_direction
	
	if is_on_floor():
		movement.y = 0.0
	else:
		movement.x = 0.0

	move_and_slide(movement, Vector2.UP)
