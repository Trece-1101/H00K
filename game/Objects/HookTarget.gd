extends Area2D
class_name HookTarget
"""
Area2D que representa un enganche donde el gancho puede engancharse
Si se pone el  is_one_shot en true, el jugador solo puede engancharse una vez
"""

#### export variables
export var is_one_shot: bool = false
export var radius: float = 6.0

#### onready variables
onready var timer: Timer = $Timer

#### constantes
const COLOR_ACTIVE: Color = Color( 0.55, 0, 0.55, 1 )
const COLOR_INACTIVE: Color = Color(0.515625, 0.484941, 0.4552)

#### variables
var is_active: = true setget set_is_active
var color: = COLOR_ACTIVE setget set_color

#### señales
signal hooked_onto_from(hook_position)

# Metodos
func _ready() -> void:
	timer.connect("timeout", self, "_on_Timer_timeout")

func _draw() -> void:
	draw_circle(Vector2.ZERO, radius, color)

func _on_Timer_timeout() -> void:
	self.is_active = true

func hooked_from(hook_position: Vector2) -> void:
	self.is_active = false
	emit_signal("hooked_onto_from", hook_position)

func set_is_active(value:bool) -> void:
	is_active = value
	if is_active:
		self.color = COLOR_ACTIVE
	else:
		 self.color = COLOR_INACTIVE

	if not is_active and not is_one_shot:
		timer.start()

func set_color(value:Color) -> void:
	color = value
	update()
