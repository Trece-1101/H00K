extends Camera2D

#### export variables

#### onready variables
onready var window_size = OS.get_window_size()
onready var step_x = ProjectSettings.get("display/window/size/width")
onready var step_y = ProjectSettings.get("display/window/size/height")
onready var player: Player = get_parent().get_node("Player")
onready var tween: Tween = $Tween
onready var timer: Timer = $Timer
onready var transition := false

#### variables
export var start_room_fila: int = 1
export var start_room_columna: int = 1
export var transition_time: float = 0.5
var steping := false
var borders: Dictionary = {"top": 0, "bottom": 0, "left": 0, "right": 0}

#### Metodos
func _ready() -> void:
	pause_mode = Node.PAUSE_MODE_PROCESS
	
	if Game.get_camera_start() == Vector2.ZERO:
		start_room_fila = start_room_fila
		start_room_columna = start_room_columna
	else:
		start_room_fila = Game.get_camera_start().x
		start_room_columna = Game.get_camera_start().y
	
	set_start_borders()
	
	global_position.x = (step_x / 2) + (step_x * (start_room_columna - 1))
	global_position.y = (step_y / 2) + (step_y * (start_room_fila - 1))


func set_start_borders() -> void:
	borders["top"] = step_y * (start_room_fila - 1)
	borders["bottom"] = step_y * start_room_fila
	borders["left"] = step_x * (start_room_columna - 1)
	borders["right"] = step_x * start_room_columna



func _process(delta: float) -> void:
	if not transition:
		if player.global_position.y < borders["top"]:
			move_camera("top")
		elif player.global_position.y > borders["bottom"]:
			move_camera("bottom")
		elif player.border_detector.global_position.x < borders["left"]:
			move_camera("left")
		elif player.border_detector.global_position.x > borders["right"]:
			move_camera("right")

#		elif player.global_position.x < borders["left"]:
#			move_camera("left")
#		elif player.global_position.x > borders["right"]:
#			move_camera("right")

func move_camera(move_to: String) -> void:
	var new_global_position: Vector2 = Vector2.ZERO
	transition = true
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

func _on_Timer_timeout() -> void:
	transition = false

func _on_Tween_tween_completed(object: Object, key: NodePath) -> void:
	get_tree().paused = false
