extends Node

################################################################################
#### Variables
var player_death_count: int = 0
var player_respawn_position: Vector2 = Vector2.ZERO setget set_player_respawn_position, get_player_respawn_position
var player_last_state: String = "" setget set_player_last_state, get_player_last_state
var player_current_room: String = "Room1" setget set_player_current_room, get_player_current_room
var camera_start: Vector2 = Vector2.ZERO setget set_camera_start, get_camera_start
var last_door_closed := {}
################################################################################

################################################################################
#### Setters y Getters
func set_player_death_count(value: int) -> void:
	player_death_count = value

func get_player_death_count() -> int:
	return player_death_count

func set_player_last_state(value: String) -> void:
	player_last_state = value

func get_player_last_state() -> String:
	return player_last_state

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

func set_last_door_closed(door: String, room: String) -> void:
	last_door_closed = {'door': door, 'room': room}

func get_last_door_closed() -> Dictionary:
	return last_door_closed
################################################################################

################################################################################
#### Metodos
func increment_death_count() -> void:
	player_death_count += 1
################################################################################
