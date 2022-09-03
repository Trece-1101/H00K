extends Node2D


func _on_PlayerDetector_body_entered(_body: Node) -> void:
	$PlayerDetector.set_deferred("disabled", true)
	queue_free()
