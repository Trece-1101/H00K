extends Node
class_name BehaviorBaseNode
"""
Behavior Base - Nodo padre del cual heredan el resto de los nodos tanto composite
(sequence, selector, decorator) como nodos leaf (action y condition).
Contiene los metodos para sobreescribir por dichas clases hijas que son llamados
a partir de metodos privados exclusivos de esta clase. _execute es el metodo de entrada
a todos los metodos de la clase.
"""

#### Metodos
func _execute(tick: Tick) -> int:
	_enter(tick)
	
	if not tick.blackboard.get('isOpen', tick.tree, self):
		_open(tick)
	
	var status := _run(tick)
	
	if status != ERR_BUSY:
		_close(tick)
	
	_exit(tick)
	
	return status


func _enter(tick: Tick) -> void:
	tick.enter_node(self)
	enter(tick)


func _open(tick: Tick) -> void:
	tick.open_node(self)
	tick.blackboard.set('isOpen', true, tick.tree, self)
	open(tick)


func _run(tick: Tick) -> int:
	tick.tick_node(self)
	return run(tick)


func _close(tick: Tick) -> void:
	tick.close_node(self)
	tick.blackboard.set('isOpen', false, tick.tree, self)
	close(tick)


func _exit(tick: Tick) -> void:
	tick.exit_node(self)
	exit(tick)


# The following functions are to be overridden in extending nodes
func enter(_tick: Tick) -> void:
	pass

func open(_tick: Tick) -> void:
	pass

func run(_tick: Tick) -> int:
	return OK

func close(_tick: Tick) -> void:
	pass

func exit(_tick: Tick) -> void:
	pass
