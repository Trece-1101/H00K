extends Area2D

onready var room := get_parent()

func _ready() -> void:
	disable_collider()

func enable_collider() -> void:
	$CollisionShape2D.set_deferred("disabled", false)

func disable_collider() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
