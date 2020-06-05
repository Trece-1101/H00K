class_name Enemy
extends KinematicBody2D

################################################################################
#### Variables export
export(Vector2) var velocity = Vector2.ZERO

#### Varibales
var is_alive: bool = true

#### Onready Variables
onready var move_direction: Vector2 = Vector2(1.0, 1.0)
onready var explosion_area: Area2D = $ExplosionArea
onready var skin_animation : AnimationPlayer = $EnemySkin/AnimationPlayer
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	set_physics_process(false)

func physics_process(_delta: float) -> void:
	var movement: Vector2

	movement = velocity * move_direction

	if is_on_floor():
		movement.y = 0.0
	else:
		movement.x = 0.0

	move_and_slide(movement, Vector2.UP)


func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		go_explode()
#		velocity = Vector2.ZERO
#		skin_animation.connect("animation_finished", self, "explode")
#		skin_animation.play("go_explode")

func go_explode() -> void:
	velocity = Vector2.ZERO
	skin_animation.connect("animation_finished", self, "explode")
	skin_animation.play("go_explode")

func explode(_anim_name: String) -> void:
	explosion_area.explode()
	skin_animation.disconnect("animation_finished", self, "explode")
	die()

func die() -> void:
	$EnemySkin.visible = false
	$CollisionShape2D.set_deferred("disabled", true)
	$BodyDetector/CollisionShape2D.set_deferred("disabled", true)
	$PlayerDetector/CollisionShape2D.set_deferred("disabled", true)

func _on_BodyDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.die()


func _on_ExplosionArea_body_entered(body: Node) -> void:
	if body.name == "Player":
		body.die()
################################################################################
