class_name OptionPanel
extends Control

func _on_HideTimer_timeout() -> void:
	$Apply.disabled = false
	$Popup.hide()

func _on_Apply_pressed() -> void:
	$Apply.disabled = true
	$Popup.set_global_position(Vector2(620.0, 270.0))
	$Popup.show()
	$HideTimer.start()
