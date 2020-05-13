class_name FloorDetector
extends RayCast2D

################################################################################
#### Metodos
func is_close_to_floor() -> bool:
	return is_colliding()

func is_in_platform() -> bool:
	if get_collider() != null:
		if "MovingPlatform" in get_collider().name:
			return true
	
	return false

func get_floor_position() -> Vector2:
	force_raycast_update()
	return get_collision_point()
################################################################################
