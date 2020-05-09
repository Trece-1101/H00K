class_name Room
extends Node

################################################################################
#### Export variables
export var room_row_col: Vector2 = Vector2.ZERO

#### Variables
var room_name: String = "Room"
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

func _get_room_name() -> String:
	return room_name

func get_sensors() -> void:
	var sensors = get_node("Sensors").get_children()
	if not sensors.empty():
		door = get_node("Door")
		door.instant_close_door()
		sensor_left = sensors.size()

func _on_SaveArea_body_entered(body: Node) -> void:
	if body.name == 'Player':
		Game.set_player_respawn_position(respawn_point.global_position)
		Game.set_player_current_room(room_name)
		Game.set_camera_start(room_row_col)
		
		level.saving_notice()
		$SaveArea/PassRoom.play()
		$SaveArea/CollisionShape2D.set_deferred("disabled", true)
		
#		if !already_save:
#			level.saving_notice()
#			already_save = true
#			$SaveArea/PassRoom.play()
#		print("saved at {rp}".format({'rp': respawn_point.global_position}))

func activate_sensor() -> void:
	sensor_left -= 1
	if sensor_left <= 0:
		door.open_door()
################################################################################
