extends TileMap

#### Variables onready
onready var valid_tiles := self.get_used_cells() # posiciones/tiles validos

#### Set abierto, cerrado y de todos los nodos (validos)
var all_set = []
var open_set = []
var closed_set = []

#### Nodo inicio y final
var start_position : Vector2 = Vector2.ZERO # Posicion del player en el viewport
var end_position : Vector2 = Vector2.ZERO # Posicion del hongo en el viewport
var start_node: PathNode # Nodo correspondiente a la posicion del player
var end_node: PathNode # Nodo correspondiente a la posicion del hongo


#### Getter de debug para verificar lo que devuelve get_used_cells()
func get_valid_tiles(show: bool = false):
	if show:
		print ('(c, f)')
		print ('------')
	
	for node in valid_tiles:
		if show:
			print(node)
	
	return get_used_cells()


#### Metodo que encuentra el camino entre el player y el hongo
func find_path(start, end):
	start_position = pos_to_node(start) # convierto la posicion x,y en un vector c,f
	end_position = pos_to_node(end)
	
	init_grid(false) # Inicializacion de todos los nodos
	
	var current_node: PathNode = start_node # El primer nodo a evaluar siempre es el de inicio
	
	## mientras el nodo evaluado/cerrado no sea el nodo final
	while current_node != end_node:
		current_node = find_closer_nodes(current_node) # encontrar y abrir nodos y devolver que nodo cerraremos
	
	find_closer_nodes(end_node) # si llegamos hasta el nodo cerrado solo nos falta ese
	
	var node_path = find_optimal_path() # de todos los nodos cerrados buscamos el camino optimo
	
	return path_node_to_pos(node_path) # devolvemos el camino


#### Metodo que inicializa la grilla. Para cada tile valido crea un objeto de
#### PathNode y lo instancia con su posicion y la H
func init_grid(show: bool) -> void:
	for position in valid_tiles:
		var node := PathNode.new(null, position, (manhattan_distance(position, end_position)) * 10)
		all_set.append(node) # agrega el nodo a la lista de nodos validos
		
		set_start_end_nodes(node) # setea el nodo start y end
	
	# Para debug
	if show:
		for node in all_set:
			print(node.print_node_data())


#### Metodo para setear nodos start y end
func set_start_end_nodes(node: PathNode) -> void:
	if node.is_equal(start_position):
		start_node = node
	
	if node.is_equal(end_position):
		end_node = node


#### Metodo que detecta los nodos aledaños del nodo en el que estamos parados (current)
func find_closer_nodes(current_node: PathNode) -> PathNode:
	closed_set.append(current_node) # cierra el nodo
	if current_node in open_set:
		open_set.erase(current_node) # quita el nodo de la lista de nodos abiertos
	
	var c : int = -1
	var temp_nodes = [] # lista temporal para almacenar las posiciones c,f de los nodos que vamos a evaluar

# warning-ignore:unused_variable
	for i in range(3):
		var node_up : Vector2 = Vector2((current_node.position.x + c), current_node.position.y - 1) # nodos arriba
		var node_center : Vector2 = Vector2((current_node.position.x + c), current_node.position.y) # nodos centro
		var node_low : Vector2 = Vector2((current_node.position.x + c), current_node.position.y + 1) # nodos abajo 
		
		temp_nodes.append(node_up)
		temp_nodes.append(node_center)
		temp_nodes.append(node_low)
		
		c += 1
	
	#### Una vez que se abrieron todos los nodos aledaños hay que evaluarlos
	for node_position in temp_nodes:
		open_nodes(node_position, current_node)
	
	var new_current_node : PathNode = check_new_parent_node() # evaluamos la lista de nodos abiertos
	
	return new_current_node # devolvemos al loop principal el nuevo nodo que vamos a cerrar

#### Metodo que chequea si el nodo aledaño es valido. Para ser valido debe cumplir:
#### - Encontrarse en la lista de nodos validos
#### - No encontrarse en la lista de nodos cerrados
#### - No ser el mismo nodo en que estamos parados
#### Si es valido se agrega a la lista de nodos abiertos y se le asigna el nodo padre
func open_nodes(node_position: Vector2, current_node: PathNode) -> void:
	var is_current_node : bool = current_node.is_equal(node_position) #### descartar no estar evaluando la posicion del nodo actual
	
	var near_node: PathNode # near_node sera el nodo aledaño a evaluar
	for node in all_set:
		if node.is_equal(node_position):
			near_node = node # le pasamos la posicion que estamos evaluando y le asignamos su nodo

	if (near_node in all_set and not near_node in closed_set 
		and not is_current_node and not near_node in open_set):
			near_node.parent = current_node # le asignamos al nuevo nodo abierto su padre
			var parent_position: Vector2 = near_node.parent.position
			near_node.G = (near_node.parent.G 
				+ get_my_fucking_diagonal(near_node.position, parent_position)) # calculamos G
			near_node.F = near_node.G + near_node.H # calculamos F
			open_set.append(near_node) # agregamos el nodo a la lista de nodos abiertos
	
	## Si el nodo no cumplio las anteriores condiciones todavia puede ser posible
	## que sea un nodo abierto con anterioridad
	if near_node in open_set:
		# calculamos un nuevo G con este padre distinto
		var new_g = (current_node.G + get_my_fucking_diagonal(near_node.position, current_node.position))
		if new_g < near_node.G: # si este valor nuevo de G es menor al anterior
			near_node.parent = current_node # cambiamos de padre
			near_node.G = new_g # asignamos el nuevo valor de G
			near_node.F = near_node.G + near_node.H # recalculamos F


#### Como para la distancia de manhattan un nodo en diagonal esta a '2' de distancia
#### esto genera que distintos caminos tengan el mismo peso.
#### Por esto vamos a modificar un poco el valor devuelto para G
func get_my_fucking_diagonal(node_position: Vector2, parent_position: Vector2) -> int:
	var result: int = manhattan_distance(node_position, parent_position)
	
	## si el nodo evaluado esta en una fila y columna distinta al nodo padre
	## significa que esta en diagonal
	if node_position.x != parent_position.x and node_position.y != parent_position.y:
		result *= 7 # 2 * 7 = 14
	else:
		result *= 10 # 1 * 10 = 10
	
	return result


#### Metodo que itera en la lista de nodos abiertos y devuelve un nuevo nodo a cerrar/padre
func check_new_parent_node() -> PathNode:
	var set_size = open_set.size() - 1
	var lowest_f: int = open_set[set_size].F # el F mas chico inicial es el del ultimo nodo abierto
	var new_parent: PathNode
	
	## iteramos la lista de nodos abiertos buscando el mas chico
	## el desempate es por posicion, el mas nuevo en entrar es el que sale antes LIFO
	## esto esta dado por el "=".
	for node in open_set:
		if node.F <= lowest_f:
			lowest_f = node.F
			new_parent = node # el nodo con el F mas chico es el nuevo nodo a cerrar

	return new_parent


#### Metodo que define de todos los nodos cerrados cual es el camino ideal
func find_optimal_path():
	var optimal_path = [] # lista temporal para almacenar nodos cerrados ideales
	var last_parent : PathNode = end_node # si llegamos a aca el ultimo nodo cerrado es el end_node
	
	optimal_path.append(end_node) # agregamos el end_node a la lista
	
	## la lista de nodos cerrados se itera de atras para adelante
	## el "-2" es para desestimar el nodo cerrado que ya agregamos
	## hasta -1 significa que evaluara hasta la posicion 0 = nodo inicio
	## step -1 es para ir de atras para adelante
	for i in range(closed_set.size() - 2, -1, -1):
		if closed_set[i] == last_parent.parent: # si el nodo que estamos evaluando tiene como padre al last_parent 
			optimal_path.append(closed_set[i]) # agregamos ese nodo a la lista optima
			last_parent = closed_set[i] # ese nodo se convierte en el ultimo padre
	
	return optimal_path # devolvemos la lista optima
	

func manhattan_distance(point_1: Vector2, point_2: Vector2):
	return abs(point_1.x - point_2.x) + abs(point_1.y - point_2.y)


#### Metodo que convierte a una posicion x,y en c,f
func pos_to_node(position: Vector2) -> Vector2:
	var fila: int = int((position.y - 8) / 16)
	var col: int = int((position.x - 8) / 16)
	#print("Position ({pos}) ({posc},{posf})".format({'pos': position, 'posc': col, 'posf': fila}))
	#print("({posc},{posf})".format({'posc': col, 'posf': fila}))
	
	return Vector2(col, fila)


####  Metodo que toma una lista de nodos y devuelve una lista de vectores posicion x,y
func path_node_to_pos(optimal_path):
	var path_positions = []
	
	for i in range(optimal_path.size() - 1, -1, -1):
		var position : Vector2 = Vector2.ZERO
		position.x = (optimal_path[i].position.x * 16) + 8
		position.y = (optimal_path[i].position.y * 16) + 8
		path_positions.append(position)
	
	return path_positions
