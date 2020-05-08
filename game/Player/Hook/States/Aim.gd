extends State

################################################################################
#### Variables
var can_aim : bool = true setget set_can_aim

#### Variables onready
onready var fire : State = $Fire
################################################################################

################################################################################
#### Setters y Getters
func set_can_aim(value: bool):
	can_aim = value
################################################################################

################################################################################
#### Metodos
func unhandled_input(event: InputEvent) -> void:
#	if event.is_action_pressed("debug_slowmo") and owner.can_hook():
#		owner.set_is_slowmo(not owner.get_is_slowmo())
#	if event.is_action_pressed("aim"):
#			owner.is_aiming = not owner.is_aiming
	
#	if event.is_action_pressed("debug_slowmo"):
#		owner.set_is_slowmo(not owner.get_is_slowmo())
	
	if event.is_action_pressed("hook") and owner.can_hook():
		_state_machine.transition_to("Aim/Fire")

func physics_process(_delta: float) -> void:
	if can_aim:
		var cast: Vector2 = owner.get_aim_direction() * owner.ray_cast.length
		var angle: float = cast.angle()
		owner.ray_cast.cast_to = cast
		owner.target_circle.rotation = angle
		fire.set_hooking_angle(rad2deg(angle))
		owner.snap_detector.rotation = angle
		owner.ray_cast.force_raycast_update()
################################################################################
