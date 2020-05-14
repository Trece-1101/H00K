tool
extends Decorator 
class_name Inverter, "res://assets/Sprites/BehaviorTree/inverter_icon.png"
"""
Decorator Node Inverter - Nodo decorador que invierte el resultado de su nodo
hijo, si es success devuelve fail y si es fail devuelve success. Si esta corriendo
pasa el mismo resultado al igual que si es un error customizado.
"""

# Metodo run
func run(tick: Tick) -> int:
	for child in get_children():
		var result: int = child._execute(tick)
		
		if result == ERR_BUSY:
			return result
		elif result == OK:
			return FAILED
		elif result == FAILED:
			return OK
		else:
			return result
