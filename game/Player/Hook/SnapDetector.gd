tool
extends Area2D
"""
Detecta y devuelve el mejor punto de enganche para el gancho
"""
################################################################################
#### variables
var target: HookTarget setget set_target
var last_target: HookTarget

#### onready variables
#onready var hooking_hint: Position2D = $HookingHint
onready var ray_cast: RayCast2D = $RayCast2D
################################################################################

################################################################################
#### setters y getters
func set_target(value: HookTarget) -> void:
	target = value
	#hooking_hint.visible = has_target()
	if target and target.get_is_active():
		last_target = target
		target.focus_gain()
		#hooking_hint.global_position = target.global_position
	else:
		if last_target != null:
			last_target.focus_lost()
################################################################################
#### Metodos
func _ready() -> void:
	ray_cast.set_as_toplevel(true)

func _physics_process(_delta: float) -> void:
	self.target = find_best_target()

"""
Devuelve el gancho mas cercano, saltea ganchos obstruidos
"""
func find_best_target() -> HookTarget:
	force_update_transform()
	var targets := get_overlapping_areas()
	if not targets:
		return null
	
	var closest_target: HookTarget = null
	var distance_to_closest: float = 100000.0
	for t in targets:
		if not t.is_active:
			continue
		
		var distance: = global_position.distance_to(t.global_position)
		if distance > distance_to_closest:
			continue

		# No toma al target si hay algo en el medio
		ray_cast.global_position = global_position
		ray_cast.cast_to = t.global_position - global_position
		ray_cast.force_update_transform()
		if ray_cast.is_colliding():
			continue
		
		distance_to_closest = distance
		closest_target = t
	
	return closest_target

func has_target() -> bool:
	return self.target != null

func calculate_length() -> float:
	var length: float = -1.0
	for collider in [$CapsuleH, $CapsuleV]:
		if not collider:
			continue
		var capsule: CapsuleShape2D = collider.shape
		var capsule_length: float = collider.position.length() + capsule.height / 2 * sin(collider.rotation) + capsule.radius
		length = max(length, capsule_length)
	
	return length
################################################################################
