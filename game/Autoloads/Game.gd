extends Node

################################################################################
#### Variables
var camera_start: Vector2 = Vector2.ZERO setget set_camera_start, get_camera_start
var last_door_closed := {}
var main_control := Settings.GAMEPAD

var user = {"type": "", "name": ""}
var testers = ["QATester", "Tester"]
var bug_testers = ["QATester"]
var performers = ["Tester", "Jugador"]
var log_id := 0
var game_id := 0

var player_state = {
	"respawn_position": Vector2.ZERO,
	"last_state": "Init",
	"current_room": "Room1",
	"last_room": "Room0",
	"current_room_version": 1,
	"last_room_version": 1,
	"current_level": {"level_name": "", "level_number": 0},
	"next_level": ""
	}
################################################################################

################################################################################
#### Setters y Getters
func set_user(utype: String, uname: String) -> void:
	user["type"] = utype
	user["name"] = uname

func get_user():
	return user

func set_log_id(value: int) -> void:
	log_id = value

func get_log_id() -> int:
	return log_id

func set_game_id(value: int) -> void:
	game_id = value

func get_game_id() -> int:
	return game_id

func set_player_last_state(value: String) -> void:
	player_state["last_state"] = value

func get_player_last_state() -> String:
	return player_state["last_state"]

func set_player_respawn_position(value: Vector2) -> void:
	player_state["respawn_position"] = value

func get_player_respawn_position() -> Vector2:
	return player_state["respawn_position"]

func set_player_current_room(value: String, version: int) -> void:
	player_state["current_room"] = value
	player_state["current_room_version"] = version

func get_player_current_room() -> String:
	return player_state["current_room"]

func get_player_current_room_int() -> int:
	return int(player_state["current_room"].substr(4,-1))

func get_player_last_room_int() -> int:
	return int(player_state["last_room"].substr(4,-1))

func get_player_current_room_v() -> int:
	return player_state["current_room_version"]

func set_player_last_room(value: String, version: int) -> void:
	player_state["last_room"] = value
	player_state["last_room_version"] = version

func get_player_last_room() -> String:
	return player_state["last_room"]

func get_player_last_room_v() -> int:
	return player_state["last_room_version"]

func set_player_current_level(name: String, number: int) -> void:
	player_state["current_level"]["level_name"] = name
	player_state["current_level"]["level_number"] = number

func get_player_current_level_name() -> String:
	return player_state["current_level"]["level_name"]

func get_player_current_level_number() -> String:
	return player_state["current_level"]["level_number"]

func set_player_next_level(value: String) -> void:
	player_state["next_level"] = value

func get_player_next_level() -> String:
	return player_state["next_level"]

func set_camera_start(value: Vector2) -> void:
	camera_start = value

func get_camera_start() -> Vector2:
	return camera_start

func set_last_door_closed(door: String, room: String) -> void:
	last_door_closed = {'door': door, 'room': room}

func clear_last_door_closed() -> void:
	last_door_closed = {}

func get_last_door_closed() -> Dictionary:
	return last_door_closed

func get_main_controls():
	return main_control

func set_main_controls(value) -> void:
	main_control = value
################################################################################

################################################################################

func init_level() -> void:
	set_camera_start(Vector2.ZERO)
	clear_last_door_closed()
	set_player_current_room("Room1", 0)
	set_player_respawn_position(Vector2.ZERO)
	set_player_last_state("Init")

func print_user_data() -> void:
	print(user)
	print("log: ", log_id)


