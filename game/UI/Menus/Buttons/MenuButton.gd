extends Button

func _ready() -> void:
	$Sprite.visible = false

func _on_mouse_entered() -> void:
	#$Sprite.visible = true
	$AnimationPlayer.play("on_hover")

func _on_mouse_exited() -> void:
	$AnimationPlayer.play("off_hover")
	#$Sprite.visible = false

