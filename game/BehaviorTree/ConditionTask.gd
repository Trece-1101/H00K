extends BehaviorBaseNode
class_name ConditionTask, "res://assets/Sprites/BehaviorTree/condition_icon.png"
"""
Leaf Node Condition - Nodo que chequea si se comple cierta condicion. El nodo
debe tener una variable target.
Retorna Success si la condicion es True o Fail si es False.
Esta clase no se usa mas que para crear un script que herede de ella
"""

func run(_tick: Tick) -> int:
	return OK
