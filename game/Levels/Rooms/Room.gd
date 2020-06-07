class_name Room
extends Node

################################################################################
#### Export variables
export var room_row_col: Vector2 = Vector2.ZERO
export var last_room := false
export var version := 1

#### Variables
var room_name:String = "Room"
var sensor_left := 0
var door: Door
var already_save: bool = false

#### Onready variables
onready var respawn_point: Position2D = $SaveArea/RespawnPoint
onready var level: LevelState = get_parent()
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	room_name = self.name
	
	if Game.get_player_current_room() == room_name:
		$SaveArea/CollisionShape2D.set_deferred("disabled", true)
	
	if get_node("Sensors"):
		get_sensors()


func get_sensors() -> void:
	var sensors = get_node("Sensors").get_children()
	if not sensors.empty():
		door = get_node("Door")
		door.instant_close_door()
		sensor_left = sensors.size()
	
	manage_exit(sensor_left)


func close_my_door() -> void:
	door = get_node("Door")
	door.close_door()

func _on_SaveArea_body_entered(body: Node) -> void:
	if body.name == 'Player':
		# Avisos
		level.saving_notice()
		$SaveArea/PassRoom.play()
		$SaveArea/CollisionShape2D.set_deferred("disabled", true)
		
		update_data_and_performance()

func update_data_and_performance() -> void:
	# Data jugador local
	Game.set_player_respawn_position(respawn_point.global_position)
	Game.set_player_last_room(Game.get_player_current_room(), Game.get_player_current_room_v())
	Game.set_player_current_room(room_name, version)
	Game.set_camera_start(room_row_col)
	
	# Performance jugador local
	GamePerformance.add_time(level.get_level_name(), OS.get_unix_time())
	GamePerformance.get_time_performance(level.get_level_name())
	
	# Performance base de datos
	level.close_performance_to_db()
	#level.send_performance_to_db(Game.get_player_current_room_int(), Game.get_player_current_room_v())

func activate_sensor(value: int) -> void:
	sensor_left -= value
	if sensor_left <= 0:
		door.open_door()
	
	manage_exit(sensor_left)

func get_left_sensors() -> int:
	return sensor_left

func manage_exit(value: int) -> void:
	if not last_room:
		return
	
	var exit_area: Area2D = get_node("ExitArea")
	if value <= 0:
		exit_area.enable_collider()
	else:
		exit_area.disable_collider()

################################################################################
