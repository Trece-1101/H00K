extends Area2D
class_name Door

onready var is_door_open := true

func _on_body_entered(body: Node) -> void:
	if body.name == "Player":
		close_door()
		var parent_room = get_parent().name
		Game.set_last_door_closed(name, parent_room)

func close_door() -> void:
	if is_door_open:
		is_door_open = false
		$AnimationPlayer.play("close")

func open_door() -> void:
	if not is_door_open:
		is_door_open = true
		$AnimationPlayer.play("open")

func instant_close_door() -> void:
	if is_door_open:
		is_door_open = false
		$AnimationPlayer.play("instant_close")
