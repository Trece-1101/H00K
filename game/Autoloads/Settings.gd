extends Node

signal constrols_changed

enum { KB_MOUSE, GAMEPAD }
var controls := KB_MOUSE setget set_controls

func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton or event is InputEventJoypadMotion:
		if controls == KB_MOUSE:
			self.controls = GAMEPAD
	elif event is InputEventMouse:
		if controls == GAMEPAD:
			self.controls = KB_MOUSE

func set_controls(value: int) -> void:
	controls = value
	emit_signal("constrols_changed")
