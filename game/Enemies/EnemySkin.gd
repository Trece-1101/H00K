extends Node2D

#### señales
signal animation_finished(anim_name)

#### Variables onready
onready var animation_player = $AnimationPlayer

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "go_explode":
		emit_signal("animation_finished", anim_name)
