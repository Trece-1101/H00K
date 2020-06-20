extends Area2D

#### Variables Onready
onready var ejectable = false


#### Metodos
func _on_body_entered(body: Node) -> void:
	if body.move.velocity.y > 0:
		body.move.apply_bumper_impulse(body.move.velocity.y)
		$AnimatedSprite.play("eject")
		$AudioStreamPlayer.play()
		ejectable = false

func _on_AnimatedSprite_animation_finished() -> void:
	ejectable = true
	$AnimatedSprite.play("idle")
