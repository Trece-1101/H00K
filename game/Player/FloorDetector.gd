class_name FloorDetector
extends RayCast2D

################################################################################
#### Metodos
func is_close_to_floor() -> bool:
	return is_colliding()

func get_floor_position() -> Vector2:
	force_raycast_update()
	return get_collision_point()
################################################################################
