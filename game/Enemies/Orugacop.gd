extends Enemy

#### Variables Export
export var start_velocity : Vector2 = Vector2(40.0, 40.0)

#### Variables
var can_move : bool = true
var gravity : float = 400.0
var gravity_direction : String = "Down"
var rotation_modifier: int = 90

#### Varibales Onready
onready var void_detector : RayCast2D = $VoidDetector
onready var center_detector: RayCast2D = $CenterDetector

func _ready() -> void:
	select_start_direction()
	velocity.x = start_velocity.x
	velocity.x *= move_direction.x
	velocity.y = gravity
	mirror_detectors()	

func _physics_process(delta: float) -> void:
	if can_move:
		move_and_slide(velocity)
		if !void_detector.is_colliding():
			if !center_detector.is_colliding():
				can_move = false
				rotate_in_border()

func select_start_direction() -> void:
	randomize()
	var start_direction : int = 0
	while start_direction == 0:
		start_direction = int(rand_range(-2, 2))

	move_direction.x = start_direction

func mirror_detectors() -> void:
	rotation_modifier *= int(move_direction.x)
	void_detector.position.x *= move_direction.x
	center_detector.position.x *= move_direction.x

func rotate_in_border() -> void:
	rotation_degrees += rotation_modifier
	
	if move_direction.x == -1:
		if gravity_direction == "Down":
			go_left_platform()
		elif gravity_direction == "Right":
			go_down_platform()
		elif gravity_direction == "Up":
			go_right_platform()
		elif gravity_direction == "Left":
			go_up_platform()
	else:
		if gravity_direction == "Down":
			go_right_platform()
		elif gravity_direction == "Right":
			go_up_platform()
		elif gravity_direction == "Up":
			go_left_platform()
		elif gravity_direction == "Left":
			go_down_platform()

	can_move = true

func go_up_platform() -> void:
	velocity.x = start_velocity.x * move_direction.x
	velocity.y = gravity
	gravity_direction = "Down"

func go_left_platform() -> void:
	velocity.x = gravity
	velocity.y = start_velocity.y * -move_direction.x
	gravity_direction = "Right"

func go_down_platform() -> void:
	velocity.x = start_velocity.x * -move_direction.x
	velocity.y = -gravity
	gravity_direction = "Up"

func go_right_platform() -> void:
	velocity.x = -gravity
	velocity.y = start_velocity.y * move_direction.x
	gravity_direction = "Left"

