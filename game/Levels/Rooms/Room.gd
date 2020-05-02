extends Node
class_name Room

var room_name : String = "Room"

onready var respawn_point : Position2D = $SaveArea/RespawnPoint

export var room_row_col : Vector2 = Vector2.ZERO

func _ready() -> void:
	room_name = self.name

func _get_room_name() -> String:
	return room_name

func _on_SaveArea_body_entered(body: Node) -> void:
	if body.name == 'Player':
		Game.set_player_respawn_position(respawn_point.global_position)
		Game.set_player_current_room(room_name)
		Game.set_camera_start(room_row_col)

#		print("saved at {rp}".format({'rp': respawn_point.global_position}))
