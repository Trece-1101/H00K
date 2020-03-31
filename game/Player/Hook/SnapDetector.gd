extends Area2D
"""Detecta y devuelve el mejor punto de enganche para el gancho"""

#### onready variables
onready var hooking_hint: Position2D = $HookingHint
onready var ray_cast: RayCast2D = $RayCast2D

#### variables
var target: HookTarget setget set_target

#### setters y getters
func set_target(value: HookTarget) -> void:
	target = value
	hooking_hint.visible = has_target()
	print(has_target())
	if target:
		hooking_hint.global_position = target.global_position

#### Metodos
func _ready() -> void:
	ray_cast.set_as_toplevel(true)

func _physics_process(delta: float) -> void:
	self.target = find_best_target()

"""
Devuelve el gancho mas cercano, saltea ganchos obstruidos
"""
func find_best_target() -> HookTarget:
	var closest_target: HookTarget = null
	var targets: = get_overlapping_areas()
	for t in targets:
		if not t.is_active:
			continue

		# Skip the target if there is a collider in the way
		ray_cast.global_position = global_position
		ray_cast.cast_to = t.global_position - global_position
		if ray_cast.is_colliding():
			continue

		closest_target = t
		break

	return closest_target

func has_target() -> bool:
	return target != null
