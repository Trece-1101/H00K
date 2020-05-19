class_name MenuCustomButton
extends Button

export(String) var next_scene

func _ready() -> void:
	$Sprite.visible = false

func _on_mouse_entered() -> void:
	$AnimationPlayer.play("on_hover")

func _on_mouse_exited() -> void:
	$AnimationPlayer.play("off_hover")

func _on_button_up() -> void:
	if !next_scene == "":
		if next_scene == "exit":
			get_tree().quit()
		else:
			get_tree().change_scene(next_scene)

func _on_MenuButton_button_down() -> void:
	$AudioStreamPlayer.play()

func _on_MenuButton_focus_entered() -> void:
	$AnimationPlayer.play("on_hover")

func _on_MenuButton_focus_exited() -> void:
	$AnimationPlayer.play("off_hover")
