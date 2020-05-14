extends Decorator
class_name Limiter, "res://assets/Sprites/BehaviorTree/limiter.png"
"""
Decorator Node Limiter - Decorador que tiene un numero maximo de llamados para hacer
en la ejecucion del arbol. Excedido ese numero de ejecucion no puede volver a ser
llamado.
"""

export(int) var max_calls := 0
var total_calls := 0

func run(tick: Tick) -> int:
	if total_calls >= max_calls:
		return FAILED
		
	for child in get_children():
		total_calls += 1
		
		return child._execute(tick)
	
	return FAILED
