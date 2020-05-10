tool
class_name PathPoints
extends Line2D

################################################################################
#### Enums
enum Mode {CYCLE, PING_PONG}

#### Variables export
export(Mode) var mode := Mode.CYCLE setget set_mode
export var triangle_radius: float = 8.0

#### Variables
var current_point_position: int = 0
var direction: int = 1
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	set_as_toplevel(true)
	visible = Engine.editor_hint

func _draw() -> void:
	if not Engine.editor_hint:
		return
	
	if not points.size() > 1:
		return
	
	var triangles: = []
	var previous_point: = points[0]
	for point in points:
		if point == points[0] or (point == points[-1] and mode == Mode.CYCLE):
			continue
		triangles.append({
			center=(point + previous_point) / 2,
			angle=previous_point.angle_to_point(point)}
		)
		previous_point = point

	if mode == Mode.CYCLE:
		triangles.append({
			center=(points[-1] - points[0]) / 2,
			angle=points[-1].angle_to_point(points[0])}
		)
		draw_line(points[-1], points[0], default_color, width)
	for triangle in triangles:
		DrawingUtils.draw_triangle(self, triangle['center'], triangle['angle'], triangle_radius, Color(1, 1, 1, 1))

func get_start_position() -> Vector2:
	return points[0]

func get_current_position() -> Vector2:
	return points[current_point_position]

func get_next_position() -> Vector2:
	match mode:
		Mode.CYCLE:
			current_point_position = (current_point_position + 1) % points.size()
		Mode.PING_PONG:
			var index: int = current_point_position + direction
			if index < 0 or index == points.size():
				direction *= -1
			current_point_position += direction
	
	return get_current_position()

func set_mode(value: int) -> void:
	mode = value
	update()
################################################################################
