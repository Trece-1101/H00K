extends State

"""
Spawnea al jugador (no tiene control el usuario en el intermedio)
"""

#### variables
var _start_position: Vector2 = Vector2.ZERO


#### Metodos
func _ready() -> void:
	yield(owner, "ready")
	_start_position = owner.position

func _on_PlayerAnimation_animation_finished(animation_name: String) -> void:
	if not owner.is_on_floor():
		_state_machine.transition_to("Air")
	
	_state_machine.transition_to("Move/Idle")

func enter(msg: Dictionary = {}) -> void:
#	#owner.is_active = false
#	var active = false
#	owner.set_is_active(active)
#	if owner.camera_rig:
#		#owner.camera_rig.is_active = false
#		owner.camera_rig.set_is_active(active)
	set_actives(false)
	owner.position = _start_position
	owner.skin.play("spawn")
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

func exit() -> void:
#	#owner.is_active = true
#	var active = true
#	owner.set_is_active(true)
#	if owner.camera_rig:
#		owner.camera_rig.is_active = true
	#owner.hook.visible = true
	set_actives(true)
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

func set_actives(active: bool) -> void:
	owner.set_is_active(active)
#	if owner.camera_rig:
#		owner.camera_rig.set_is_active(active)
	
