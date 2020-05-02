extends Area2D
class_name Door

onready var close_door := false

func _on_body_entered(body: Node) -> void:
	if not close_door:
		close_door = true
		$AnimationPlayer.play("close")
