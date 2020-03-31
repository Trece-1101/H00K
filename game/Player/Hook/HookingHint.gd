tool
extends Node2D
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
	draw_circle(Vector2.ZERO, radius, color)
