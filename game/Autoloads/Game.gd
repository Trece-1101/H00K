extends Node

var player_respawn_position : Vector2 = Vector2.ZERO setget set_player_respawn_position, get_player_respawn_position
var player_current_room: String = "" setget set_player_current_room, get_player_current_room
var camera_start : Vector2 = Vector2.ZERO setget set_camera_start, get_camera_start

func set_player_respawn_position(value: Vector2) -> void:
	player_respawn_position = value

func get_player_respawn_position() -> Vector2:
	return player_respawn_position

func set_player_current_room(value: String) -> void:
	player_current_room = value

func get_player_current_room() -> String:
	return player_current_room

func set_camera_start(value: Vector2) -> void:
	camera_start = value

func get_camera_start() -> Vector2:
	return camera_start
