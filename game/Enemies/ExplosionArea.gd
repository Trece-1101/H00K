extends Area2D

onready var explosion_area : CollisionShape2D = $ExplosionArea

func _ready() -> void:
	explosion_area.disabled = true

func explode() -> void:
	explosion_area.set_deferred("disabled", false)
	$AnimatedSprite.play("explosion")
