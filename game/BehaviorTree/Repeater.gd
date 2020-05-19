extends Decorator
class_name Repeater, "res://assets/Sprites/BehaviorTree/repeat.png"
"""
Decorator Node Repeater - Decorador que repite sus nodos hijos una N cantidad de
veces sin importar el estado que retorner (fail o success).
"""

#### Metodo run
func run(tick: Tick) -> int:
	for child in get_children():
		while true:
			if child.run(tick) == ERR_BUSY:
				return ERR_BUSY
	
	return OK
