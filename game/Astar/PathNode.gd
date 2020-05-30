class_name PathNode
extends Node

var parent: PathNode
var position: Vector2
var G: int = 0
var H: int = 0
var F: int = 0

func _init(parent_node: PathNode, pos: Vector2, h: int) -> void:
	parent = parent_node
	position = pos
	H = h

func is_equal(a_path_node: Vector2) -> bool:
	return position.x == a_path_node.x and position.y == a_path_node.y

#### Metodo para debug de nodos
func print_node_data() -> void:
	print('----------------------------------------')
	print('Parent: {parent}'.format({'parent': parent}))
	print('Position: {pos}'.format({'pos': position}))
	print('G: {g}'.format({'g': G}))
	print('H: {h}'.format({'h': H}))
	print('F: {f}'.format({'f': F}))
