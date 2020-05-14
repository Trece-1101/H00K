extends Decorator
class_name UntilFail, "res://assets/Sprites/BehaviorTree/repeat.png"

"""
Decorator Node Repeat Until Fail - Decorador que sigue llamando a su hijo hasta
que devuelva Fail, cuando esto sucede el nodo devuelve Success (return OK)
"""

#### Metodo run
func run(tick: Tick) -> int:
	for child in get_children():
		while true:
			if child._execute(tick) == FAILED:
				return OK
	
	return OK
