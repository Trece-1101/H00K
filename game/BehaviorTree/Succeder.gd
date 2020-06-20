extends Decorator
class_name Succeder, "res://assets/Sprites/BehaviorTree/succeder.png"
"""
Decorator Node Succeder - Nodo decorador que devuelve success siempre sin importar
el resultado del nodo hijo
"""

#### Metodo run
func run(tick: Tick) -> int:
	for child in get_children():
		if child._execute(tick) == ERR_BUSY:
			return ERR_BUSY
	
	return OK
