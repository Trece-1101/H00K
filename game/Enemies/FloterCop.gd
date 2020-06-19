extends Enemy

const POINT_RADIUS := 2

export var speed := 200
export var nav_map_name: String

var path
var nav_map: TileMap

onready var started := false

func _ready() -> void:
	set_physics_process(false)
	nav_map = owner.get_node(nav_map_name)
	
	path = nav_map.find_path(self.global_position, $EndPosition.global_position)

	if path:
		$AudioStreamPlayer2D.play()
		path.remove(0)


func _physics_process(delta: float) -> void:
	make_your_move(delta)

func make_your_move(delta: float) -> void:
	if path:
		var target = path[0]
		
		var direction: Vector2 = (target - position).normalized()
		
		position += direction * speed * delta
		
		
		if position.distance_to(target) < POINT_RADIUS:
			path.remove(0)
			
			if path.size() == 0:
				path = null
				go_explode()



