class_name WallDetector
extends Position2D

#### onready variables
onready var ray_bottom: RayCast2D = $RayBottom
onready var ray_top: RayCast2D = $RayTop

#### export variables
export var is_active:bool = true

func _ready() -> void:
	assert(ray_top.cast_to.x >= 0)
	assert(ray_bottom.cast_to.x >= 0)
	
#func _unhandled_input(event: InputEvent) -> void:
#	if !Utils.get_aim_joystick_direction() == Vector2.ZERO:
#		if event.is_action_pressed("move_left"):
#			scale.x = -1
#		elif event.is_action_pressed("move_right"):
#			scale.x = 1

func is_against_ledge() -> bool:
	return (is_active 
		and ray_bottom.is_colliding() 
		and not ray_top.is_colliding())

func is_against_wall() -> bool:
	return is_active and (ray_bottom.is_colliding() or ray_top.is_colliding())

func get_cast_to_direction() -> Vector2:
	return ray_top.cast_to * scale

func get_top_global_position() -> Vector2:
	return ray_top.global_position
