class_name LevelState
extends Node2D

################################################################################
#### Constantes
const DB_REQUEST_NODE = preload("res://game/HTTP/HttpDbRequest.tscn")
const BUG_MENU = preload("res://game/UI/Menus/BugMenu.tscn")

#### Variables
var db_request: Node
var close_door := {}
var time_start := 0
var time_now := 0

#### Variables Export
export(String) var music
export(String) var level_name
export(int) var level_number
export(String) var next_scene
export(String) var next_level
export(String) var my_route

#### Variables onready
onready var camera: Camera2D = $LevelTransitionCamera
onready var is_performer:bool = Game.get_user()["type"] in Game.performers
onready var is_bug_tester:bool = Game.get_user()["type"] in Game.bug_testers
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
	if not close_door.empty():
		close_last_door()
	
	Game.set_scene_to_load(my_route)
	Game.set_player_current_level(level_name, level_number)
	Game.set_player_next_level(next_level)
	
	if is_performer:
		db_request = DB_REQUEST_NODE.instance()
		add_child(db_request)
	
	if is_bug_tester:
		var bug_menu = BUG_MENU.instance()
		$OnFrontView.add_child(bug_menu)
	
	if Game.get_player_last_state() == "Init":
		GamePerformance.init_level_performance(level_name, OS.get_unix_time())
		GameSaver.update_performance_slot(Game.get_current_slot())
		start_performance_to_db(Game.get_player_current_room_int(), Game.get_player_current_room_v())
	elif Game.get_player_last_state() == "Load":
		GamePerformance.adjust_time(level_name, OS.get_unix_time())
	else:
		GameSaver.update_performance_slot(Game.get_current_slot())
		update_performance_to_db()

func start_performance_to_db(room: int, version: int) -> void:
	if is_performer:
		GamePerformance.init_db_room_performance()
		db_request.SetPerformance(
			Game.get_user()["name"], # nombre usuario
			room, # salon
			version, # version salon
			Game.get_player_current_level_number(), # nivel
			"00:00:00", # tiempo hh:mm:ss
			0, # muertes
			"false" # room completo
		)
		yield(db_request, "done")
		Game.set_game_id(db_request.get_result()["value"]["IdGame"])

func update_performance_to_db() -> void:
	if is_performer:
		GamePerformance.add_death_room_count()
		GamePerformance.calculate_room_time()
		db_request.UpdatePerformance(
			Game.get_game_id(), 
			GamePerformance.get_room_time(),
			GamePerformance.get_room_death_count())

func close_performance_to_db(exiting: bool = false) -> void:
	if is_performer:
		GamePerformance.calculate_room_time()
		db_request.ClosePerformance(Game.get_game_id(), GamePerformance.get_room_time())
		
		if not exiting:
			yield(db_request, "done")
			start_performance_to_db(Game.get_player_current_room_int(), Game.get_player_current_room_v())


func close_last_door() -> void:
	var room = get_node(close_door['room'])
	room.get_node(close_door['door']).instant_close_door()

func saving_notice() -> void:
	camera.saving()

func _on_ExitArea_body_entered(body: Node) -> void:
	close_performance_to_db(true)
	GamePerformance.add_time(level_name, OS.get_unix_time())
	body.toggle_is_active(false)
	camera.exit_level()

func _on_ChangeSceneArea_body_entered(_body: Node) -> void:
	get_tree().change_scene(next_scene)
################################################################################



