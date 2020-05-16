tool
extends BehaviorBaseNode
class_name Decorator
"""
Decorator Node - Clase padre decorator. De esta clase heredan todos los tipos de
decoradores. Un decorador puede tener un solo hijo.
"""

#### Metodos
func run(tick: Tick) -> int:
	if get_child_count() != 1:
		push_error(str(name,  " es un decorador y debe tener un hijo."))
	
	return ._run(tick)


func _notification(notification: int) -> void:	
	if notification == NOTIFICATION_PARENTED or notification == NOTIFICATION_UNPARENTED:
		update_configuration_warning()


func _get_configuration_warning() -> String:	 
	if not get_child_count() == 1:
		return "Decoradores deben tener exactamente un hijo"
	return ""
