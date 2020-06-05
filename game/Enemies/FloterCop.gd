extends Enemy

const POINT_RADIUS := 2

export var speed := 200

var path
var nav_map: TileMap

func _ready() -> void:
	set_physics_process(false)
	nav_map = get_parent().get_parent().get_node("NavMap")
	
	path = nav_map.find_path(self.global_position, $EndPosition.global_position)
	if path:
		$AudioStreamPlayer2D.play()
		path.remove(0)


func _physics_process(delta: float) -> void:
	if path:
		var target = path[0]
		
		var direction: Vector2 = (target - position).normalized()
		
		position += direction * speed * delta
		
		
		if position.distance_to(target) < POINT_RADIUS:
			path.remove(0)
			
			if path.size() == 0:
				path = null
				go_explode()
