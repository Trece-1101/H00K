extends BehaviorBaseNode
class_name Selector, "res://assets/Sprites/BehaviorTree/selector_icon.png"
"""
Composite Node Selector - ejecuta a los nodos hijos secuencialmente hasta que uno
devuelve OK o ERR_BUSY
Devuelve Fail SOLO si todos sus nodos hijos devuelve Fail (return FAILED)
"""

#### Metodo run
func run(tick: Tick) -> int:
	var result := OK #Si no tiene hijos devuelve SUCCESS
	
	for child in get_children():
		result = child._execute(tick)
		
		if not result == FAILED:
			break
	
	return result
