extends Node2D

var close_door := {}

func _ready() -> void:
	close_door = Game.get_last_door_closed()
	if not close_door.empty() :
		close_last_door()

func close_last_door() -> void:
	var room = get_node(close_door['room'])
	room.get_node(close_door['door']).close_door()
