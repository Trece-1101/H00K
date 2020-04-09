extends Camera2D

#### export variables


#### onready variables
onready var window_size = OS.get_window_size()
onready var step_x = ProjectSettings.get("display/window/size/width")
onready var step_y = ProjectSettings.get("display/window/size/height")
onready var player: Player = get_parent().get_node("Player")

#### variables
var current_position_x: int
var current_position_y: int
var steping = false
var borders: Dictionary = {"top": 0, "bottom": 0, "left": 0, "right": 0}

#### Metodos
func _ready() -> void:
	borders["top"] = global_position.y - (step_y / 2)
	borders["bottom"] = global_position.y + (step_y / 2)
	borders["left"] = global_position.x - (step_x / 2)
	borders["right"] = global_position.x + (step_x / 2)

func _process(delta: float) -> void:
	if player.global_position.y < borders["top"]:
		move_camera("top")
	
	if player.global_position.y > borders["bottom"]:
		move_camera("bottom")
	
	if player.global_position.x < borders["left"]:
		move_camera("left")	
	
	if player.global_position.x > borders["right"]:
		move_camera("right")

func move_camera(move_to: String) -> void:
	if move_to == "top":
		global_position.y -= step_y
		borders["bottom"] = borders["top"]
		borders["top"] -= step_y
	elif move_to == "bottom":
		global_position.y += step_y
		borders["top"] = borders["bottom"]
		borders["bottom"] += step_y
	elif move_to == "left":
		global_position.x -= step_x
		borders["right"] = borders["left"]
		borders["left"] -= step_x
	elif move_to == "right":
		global_position.x += step_x
		borders["right"] = borders["left"]
		borders["left"] += step_x 
	
	print_borders()

func print_borders() -> void:
	print("----------------------------")
	for border in borders:
		print(border, " - ", borders[border])
