extends Node2D



func _on_body_entered(body: Node) -> void:
	print("colision")
	if body.name == "Player":
		print("Player")
