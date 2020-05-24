class_name LevelTransitionCamera
extends Camera2D

################################################################################
#### Variables export
export var start_room_fila: int = 1
export var start_room_columna: int = 1
export var transition_time: float = 0.5
export var shake_displacement: Vector2 = Vector2(2.5, 3.5)
export var shake_speed: float = 0.06

#### Variables
var steping := false
var borders: Dictionary = {"top": 0, "bottom": 0, "left": 0, "right": 0}
var last_moved : String = ""
var death_count : int = 0
var shake_list := []

#### onready variables
onready var window_size = OS.get_window_size()
onready var step_x = ProjectSettings.get("display/window/size/width")
onready var step_y = ProjectSettings.get("display/window/size/height")
onready var player: Player = get_parent().get_node("Player")
onready var tween: Tween = $Tween
onready var shake_tween: Tween = $ShakeTween
onready var timer: Timer = $Timer
onready var transition := false
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS	
	
	if Game.get_main_controls() == Settings.GAMEPAD:
		Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	else:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	if Game.get_camera_start() == Vector2.ZERO or Game.get_player_last_state() == "Init":
		start_room_fila = start_room_fila
		start_room_columna = start_room_columna
		($AnimationPlayer as AnimationPlayer).play("enter_level")
	else:
		start_room_fila = int(Game.get_camera_start().x)
		start_room_columna = int(Game.get_camera_start().y)
	
	set_start_borders()
	
	if Game.get_player_last_state() == "Die":
		set_death_count_label()
	
	create_shake_list()
	
	var camera_x = (step_x * 0.5) + (step_x * (start_room_columna - 1))
	var camera_y = (step_y * 0.5) + (step_y * (start_room_fila - 1))
	
	global_position = Vector2(camera_x, camera_y)


func _process(_delta: float) -> void:
	if not transition and not player.exiting:
		if player.border_detector.global_position.y < borders["top"]:
			move_camera("top")
		elif player.global_position.y > borders["bottom"]:
			move_camera("bottom")
		elif player.border_detector.global_position.x < borders["left"]:
			move_camera("left")
		elif player.border_detector.global_position.x > borders["right"]:
			move_camera("right")

func set_start_borders() -> void:
	borders["top"] = step_y * (start_room_fila - 1)
	borders["bottom"] = step_y * start_room_fila
	borders["left"] = step_x * (start_room_columna - 1)
	borders["right"] = step_x * start_room_columna

func create_shake_list() -> void:
# warning-ignore:unused_variable
	for i in range(20):
		randomize()
		var shake_x: float = 0.0
		var shake_y: float = 0.0
		while (abs(shake_x) - 0.0 < 0.5) or (abs(shake_y) - 0.0 < 0.5):
			shake_x = rand_range(-shake_displacement.x, shake_displacement.x)
			shake_y = rand_range(-shake_displacement.y, shake_displacement.y)
		shake_list.append(Vector2(shake_x, shake_y))

func move_camera(move_to: String) -> void:
	var new_global_position: Vector2 = Vector2.ZERO
	transition = true
	last_moved = move_to
	if move_to == "top":
		new_global_position.y = global_position.y - step_y
		new_global_position.x = global_position.x
		borders["bottom"] = borders["top"]
		borders["top"] -= step_y
	elif move_to == "bottom":
		new_global_position.y = global_position.y + step_y
		new_global_position.x = global_position.x
		borders["top"] = borders["bottom"]
		borders["bottom"] += step_y
	elif move_to == "left":
		new_global_position.x = global_position.x - step_x
		new_global_position.y = global_position.y
		borders["right"] = borders["left"]
		borders["left"] -= step_x
	elif move_to == "right":
		new_global_position.x = global_position.x + step_x
		new_global_position.y = global_position.y
		borders["left"] = borders["right"]
		borders["right"] += step_x
	
#	print("global_position {gp}".format({'gp': global_position}))
#	print("new_global_position {ngp}".format({'ngp': new_global_position}))
	smooth_transition(new_global_position)

func smooth_transition(new_global_position: Vector2) -> void:
	get_tree().paused = true
	tween.stop_all()
	tween.interpolate_property(
		self, "global_position", global_position, new_global_position,
		transition_time, Tween.TRANS_LINEAR, Tween.EASE_OUT)
	tween.start()
	timer.start()

func print_borders() -> void:
	print("----------------------------")
	for border in borders:
		print(border, " - ", borders[border])

func saving() -> void:
	#$AnimationPlayer.play("saving")
	($AnimationPlayer as AnimationPlayer).play("saving")

func set_death_count_label() -> void:
	$AnimationPlayer.stop()
	$LabelDeathCount.text = "x{death}".format({"death": GamePerformance.get_player_death_count()})
	($AnimationPlayer as AnimationPlayer).play("show_death_count")
	#$AnimationPlayer.play("show_death_count")

func camara_shake() -> void:
	var shake_vector = shake_list[randi() % 20]

	shake_tween.interpolate_property(
		self,
		"offset",
		shake_vector,
		Vector2.ZERO,
		shake_speed,
		Tween.TRANS_SINE,
		tween.EASE_IN_OUT)
	
	shake_tween.start()

func _on_Timer_timeout() -> void:
	transition = false

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	get_tree().paused = false
	player.apply_move_impulse(last_moved)

func exit_level() -> void:
	$AnimationPlayer.play("exit_level")
################################################################################
