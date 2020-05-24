extends Node2D

################################################################################
#### señales
signal animation_finished(animation_name)

#### onready variables
onready var animation: AnimationPlayer = $PlayerAnimation
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	animation.connect("animation_finished", self,
	 "_on_PlayerAnimation_animation_finished")

func _on_PlayerAnimation_animation_finished(animation_name: String) -> void:
	emit_signal("animation_finished", animation_name)

func play(animation_name: String, _data: Dictionary = {}) -> void:
	assert(animation_name in animation.get_animation_list())
#	if "from" in data:
#		position = data["from"]
	animation.stop()
	animation.play(animation_name)
################################################################################
