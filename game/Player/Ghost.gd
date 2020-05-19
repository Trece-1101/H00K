extends Sprite

export var ghost_duration := 0.4

func _ready() -> void:
	$Tween.interpolate_property(
		self,
		"modulate",
		Color(1, 1, 1, 1),
		Color(1, 1, 1, 0),
		ghost_duration,
		Tween.TRANS_SINE,
		Tween.EASE_OUT)
	
	$Tween.start()

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	queue_free()
