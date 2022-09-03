extends Node2D

################################################################################
#### variables
var hook_position: = Vector2.ZERO setget set_hook_position
var length: = 20.0 setget set_length

#### onready variables
onready var head: Sprite = $Head
onready var tail: Line2D = $Tail
onready var tween: Tween = $Tween
onready var start_length: float = head.position.x
################################################################################

################################################################################
#### setters y getters
func set_length(value: float) -> void:
	length = value
	tail.points[-1].x = length
	head.position.x = tail.points[-1].x + tail.position.x
################################################################################

################################################################################
#### Metodos
func set_hook_position(value: Vector2) -> void:
	hook_position = value
	var to_target: = hook_position - global_position
	self.length = to_target.length()
	rotation = to_target.angle()
	tween.interpolate_property(
			self, 'length', length, start_length, 
			0.25, Tween.TRANS_QUAD, Tween.EASE_OUT)
	tween.start()
	visible = true

func get_hook_to_target() -> Vector2:
	var to_target: = hook_position - global_position
	return to_target.normalized()

func _on_Tween_tween_completed(_object: Object, _key: NodePath) -> void:
	visible = false
################################################################################
