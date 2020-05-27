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
export(int) var level_number
export(String) var next_scene
export(String) var next_level

#### Variables onready
onready var camera: Camera2D = $LevelTransitionCamera
################################################################################
#### Setters y Getters
func get_level_name() -> String:
	return level_name

################################################################################
#### Metodos
func _ready() -> void:
	if not GlobalMusic.playing:
		GlobalMusic.set_stream(load(music))
		GlobalMusic.play()
	
	close_door = Game.get_last_door_closed()
	
	if not close_door.empty() :
		close_last_door()
	
	Game.set_player_current_level(level_name, level_number)
	Game.set_player_next_level(next_level)
	
	if Game.get_player_last_state() == "Init":
		GamePerformance.init_level_performance(level_name, OS.get_unix_time())

func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		print("pausa")

func close_last_door() -> void:
	var room = get_node(close_door['room'])
	room.get_node(close_door['door']).instant_close_door()

func saving_notice() -> void:
	camera.saving()

func _on_ExitArea_body_entered(body: Node) -> void:
	body.toggle_is_active(false)
	camera.exit_level()

func _on_ChangeSceneArea_body_entered(_body: Node) -> void:
	get_tree().change_scene(next_scene)
################################################################################



