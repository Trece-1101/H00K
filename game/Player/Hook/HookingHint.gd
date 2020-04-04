tool
#extends Node2D
extends DrawingUtils
"""Dibuja un circulo en el enganche para dar un aviso visual de
que se puede enganchar ahi
"""

#### export variables
export var color: Color
export var radius: float = 4.0


#### Metodos
func _ready() -> void:
	set_as_toplevel(true)
	update()

func _draw() -> void:
	draw_circle_outline(self, Vector2.ZERO, radius + 2.0, color, 2.0)
	draw_circle(Vector2.ZERO, radius, color)
