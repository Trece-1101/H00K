extends Enemy

#### Variables
var can_move : bool = true

#### Varibales Onready
onready var _void_detector : RayCast2D = $VoidDetector

func _ready() -> void:
	_void_detector.position.x *= move_direction.x

func _physics_process(delta: float) -> void:
	if _void_detector.is_colliding():
		print("piso")
	else:
		change_direction()

func change_direction() -> void:
	move_direction.x *= -1
	_void_detector.position.x *= -1
