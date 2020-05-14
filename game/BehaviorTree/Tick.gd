class_name Tick
"""
Objeto creado por la instancia de BehaviorTree ejecutada. Funciona como un indicador
a cada nodo de a que arbol pertenecen, da una referencia al blackboar utilizado y
contiene un listado de nodos abiertos.
"""

#### Variables
var tree
var open_nodes := []
var debug: bool
var actor
var blackboard: Blackboard

#### Metodos
func open_node(node) -> void:	
	if debug:
		print("Opening node '%s'" % node.name)


func enter_node(node) -> void:	
	open_nodes.push_back(node)
	
	if debug:
		print("Entering node '%s'" % node.name)


func tick_node(node) -> void:
	if debug:
		print("Ticking node '%s'" % node.name)


func close_node(node) -> void:	
	if open_nodes.has(node):
		open_nodes.remove(open_nodes.find(node))
		
		if debug:
			print("Closing node '%s'" % node.name)


func exit_node(node) -> void:	
	if debug:
		print("Exiting node '%s'" % node.name)
