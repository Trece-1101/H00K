extends Decorator
class_name Failer, "res://assets/Sprites/BehaviorTree/failer.png"
"""
Decorator Node Failer - Nodo decorador que devuelve fail siempre sin importar
el resultado del nodo hijo
"""

#### Metodo run
func run(tick: Tick) -> int:
	for child in get_children():
		if child._execute(tick) == ERR_BUSY:
			return ERR_BUSY
	
	return FAILED
