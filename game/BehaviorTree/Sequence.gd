extends BehaviorBaseNode
class_name Sequence, "res://assets/Sprites/BehaviorTree/sequence_icon.png"
"""
Composite Node Sequence - ejecuta secuencialmente los nodos hijos hasta que uno
devuelva FAILED or ERR_BUSY
Devuelve Success SOLO si todos los hijos devuelve Succes (return OK)
"""

#### Metodo run
func run(tick: Tick) -> int:
	var result := OK #Si no tiene hijos devuelve SUCCESS
	
	for child in get_children():
		result = child._execute(tick)
		
		if not result == OK:
			break
	
	return result
