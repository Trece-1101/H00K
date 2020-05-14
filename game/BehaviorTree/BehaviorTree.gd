tool
extends Node
class_name BehaviorTree, "res://assets/Sprites/BehaviorTree/root_icon.png"
"""
No es el nodo raiz, es el nodo contenedor de la raiz. Contiene un solo hijo, el
cual es la raiz propiamente dicha (un selector, un sequence).
Es el punto de entrada a la logica del BT. Crea un objeto 'Tick' y llama recursivamente
a sus hijos corriendo el _execute que es el metodo de entrada para cualquier nodo
"""

####
onready var tick := Tick.new()


#### Metodos
func _ready() -> void:
	if get_child_count() != 1:
		push_error(str("BehaviorTree \"", name, "\" puede tener solo un hijo."))


func run(actor, blackboard, debug = false) -> int:
	tick.tree = self
	tick.actor = actor
	tick.blackboard = blackboard
	tick.debug = debug
	
	var result = FAILED
	
	for child in get_children():
		result = child._execute(tick)
	
	# Close nodes from last tick, if needed
	var last_open_nodes: Array = tick.blackboard.get('openNodes', self)
	var current_open_nodes := tick.open_nodes

	# If node isn't currently open, but was open during last tick, close it
	for node in last_open_nodes:
		if (not current_open_nodes.has(node) 
			and tick.blackboard.get('isOpen', tick.tree, node)):
				node._close(tick)

	# Populate the blackboard
	blackboard.set('openNodes', current_open_nodes, self)
	return result


func _notification(notification: int) -> void:
	if notification == NOTIFICATION_PARENTED or notification == NOTIFICATION_UNPARENTED:
		update_configuration_warning()


func _get_configuration_warning() -> String:
	if get_child_count() != 1:
		return "Un BehaviorTree debe tener exactamente un hijo"
	return ""

