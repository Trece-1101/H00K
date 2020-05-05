class_name Enemy
extends KinematicBody2D

#### Variables export
export(Vector2) var velocity = Vector2.ZERO

#### Varibales
var is_alive : bool = true

#### Onready Variables
onready var move_direction: Vector2 = Vector2(1.0, 1.0)
onready var explosion_area: Area2D = $ExplosionArea
onready var skin_animation : AnimationPlayer = $EnemySkin/AnimationPlayer

#### Metodos
func physics_process(delta: float) -> void:
	var movement: Vector2

	movement = velocity * move_direction
	
	if is_on_floor():
		movement.y = 0.0
	else:
		movement.x = 0.0

	move_and_slide(movement, Vector2.UP)


func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		skin_animation.play("go_explode")
		explosion_area.explode()


func _on_BodyDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.die()


func _on_ExplosionArea_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.die()
