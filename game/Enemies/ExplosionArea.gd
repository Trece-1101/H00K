extends Area2D

#### variables onready
onready var explosion_area : CollisionShape2D = $ExplosionArea
onready var parent = get_parent()

func _ready() -> void:
	explosion_area.disabled = true

func explode() -> void:
	explosion_area.set_deferred("disabled", false)
	$AudioStreamPlayer.play()
	$AnimatedSprite.play("explosion")
	$Timer.start()

#func disable_area() -> void:
#	explosion_area.set_deferred("disabled", true)

func _on_AnimatedSprite_animation_finished() -> void:
	parent.call_deferred("queue_free")


func _on_Timer_timeout() -> void:
	explosion_area.set_deferred("disabled", true)
