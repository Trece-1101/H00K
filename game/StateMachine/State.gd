class_name State
extends Node


#### onready variables
onready var _state_machine: = _get_state_machine(self)

#### Metodos
func unhandled_input(_event: InputEvent) -> void:
	pass

func physics_process(_delta: float) -> void:
	pass

func enter(_msg: Dictionary = {}) -> void:
	pass

func exit() -> void:
	pass

func _get_state_machine(node: Node) -> Node:
	if node != null and not node.is_in_group("state_machine"):
		return _get_state_machine(node.get_parent())
	return node
