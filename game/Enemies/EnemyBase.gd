extends KinematicBody2D
class_name EnemyBase

#### Variables export
export(Vector2) var velocity = Vector2.ZERO

#### Variables
var move_direction: Vector2 = Vector2(0.0, 1.0)

func _physics_process(delta: float) -> void:
	velocity = velocity * move_direction
	
	if is_on_floor():
		velocity.y = 0.0
	
	move_and_slide(velocity, Vector2.UP)
