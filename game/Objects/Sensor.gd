extends Area2D

onready var active := false
onready var room : Room = get_parent().get_parent()

func activate() -> void:
	active = true
	modulate =  Color( 0, 0, 0, 1 )
	room.activate_sensor()

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and not active:
		activate()
