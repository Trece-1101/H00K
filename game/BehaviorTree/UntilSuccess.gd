tool
extends Decorator
class_name UntilSuccess, "res://assets/Sprites/BehaviorTree/repeat.png"
"""
Decorator Node Repeat Until Success - Decorador que sigue llamando a su hijo hasta
que devuelva Success, cuando esto sucede el nodo devuelve Success (return OK)
"""

func run(tick: Tick) -> int:
	for child in get_children():
		while true:
			if child._execute(tick) == OK:
				return OK
	
	return OK
