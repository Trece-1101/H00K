extends KinematicBody2D

onready var activated := false


func _on_PlayerDetector_body_entered(_body: Node) -> void:
	if not activated:
		$AnimationPlayer.play("shake")
		activated = true
		$Timer.start()


func disable_collider() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	$PlayerDetector/CollisionShape2D.set_deferred("disabled", true)


func _on_Timer_timeout() -> void:
	$AnimationPlayer.stop()
	$AnimationPlayer.play("fall")
