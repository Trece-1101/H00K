extends Enemy

#### Variables
var _position : int = 1
var can_move : bool = true

#### Variables onready
onready var turn_positions = {
	'UpRight': $UpRightTurn.global_position,
	'UpLeft': $UpLeftTurn.global_position,
	'DownRight': $DownRightTurn.global_position,
	'DownLeft': $DownLeftTurn.global_position 
}

func _ready() -> void:
	_position = 4 if move_direction.x == 1 else 1
