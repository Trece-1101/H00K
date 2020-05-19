extends BehaviorBaseNode
class_name ActionTask, "res://assets/Sprites/BehaviorTree/action_icon.png"
"""
Leaf Node Action - Nodo que realiza cambios en los estados del actor.
Retorna Success si puede realizarse o Fail si no puede.
Esta clase no se usa mas que para crear un script que herede de ella
"""

func run(_tick: Tick) -> int:
	return OK
