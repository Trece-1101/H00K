class_name LevelState
extends Node2D

################################################################################
#### Variables
var close_door := {}

var time_start = 0
var time_now = 0

#### Variables Export
export(String) var music
export(String) var level_name

#### Variables onready
onready var camera: Camera2D = $LevelTransitionCamera
################################################################################
#### Setters y Getters
func get_level_name() -> String:
	return level_name

################################################################################
#### Metodos
func _ready() -> void:
	if !GlobalMusic.playing:
		GlobalMusic.set_stream(load(music))
		GlobalMusic.play()
	close_door = Game.get_last_door_closed()
	if not close_door.empty() :
		close_last_door()
	
	Game.set_player_current_level(level_name)
	
	if Game.get_player_last_state() == "Init":
		GamePerformance.init_level_performance(level_name, OS.get_unix_time())


func close_last_door() -> void:
	var room = get_node(close_door['room'])
	room.get_node(close_door['door']).instant_close_door()

#func _process(_delta: float) -> void:
#		time_now = OS.get_unix_time()
#		var elapsed = time_now - time_start
#		var minutes = elapsed / 60
#		var seconds = elapsed % 60
#		var str_elapsed = "%02d : %02d" % [minutes, seconds]
#		print("elapsed --  ", str_elapsed)

func saving_notice() -> void:
	camera.saving()
################################################################################


func _on_ExitArea_body_entered(body: Node) -> void:
	#body.die()
	body.disable_collider()
