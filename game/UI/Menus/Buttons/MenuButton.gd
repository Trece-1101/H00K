extends Button

export(String) var next_scene

func _ready() -> void:
	$Sprite.visible = false

func _on_mouse_entered() -> void:
	#$Sprite.visible = true
	$AnimationPlayer.play("on_hover")

func _on_mouse_exited() -> void:
	$AnimationPlayer.play("off_hover")
	#$Sprite.visible = false

func _on_button_up() -> void:
	if next_scene == "exit":
		get_tree().quit()
	else:
		get_tree().change_scene(next_scene)
