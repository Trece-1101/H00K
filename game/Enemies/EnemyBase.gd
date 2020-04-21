extends KinematicBody2D
class_name EnemyBase

#### Variables export
export(Vector2) var velocity = Vector2.ZERO

#### Variables
var move_direction: Vector2 = Vector2(0.0, 1.0)
var set_aim:bool = false
var start_rotation:float = 0.0
var is_alive:bool = true
onready var arrow_queue: Position2D = $EnemyArrowQueue


#### Metodos
func _physics_process(delta: float) -> void:
	velocity = velocity * move_direction
	if set_aim:
		var cast: Vector2 = get_aim_direction()
		var angle: float = rad2deg(cast.angle())
		check_arrow_rotation(start_rotation, cast, angle)
	
	if is_on_floor():
		velocity.y = 0.0
	
	move_and_slide(velocity, Vector2.UP)

func check_arrow_rotation(
	start_rotation: float,
	cast: Vector2,
	angle: float
	) -> void:
	var arrow_rotation: float = 0
	
	if cast == Vector2.ZERO:
		arrow_rotation = start_rotation
	else:
		if start_rotation == 45:
			arrow_rotation = clamp(angle, -90, 0)
			arrow_queue.rotation_degrees = arrow_rotation + 90
		elif start_rotation == -45:
			#print("angle {an}".format({"an": angle}))
			if angle >= 180:
				angle = -180
			arrow_rotation = clamp(angle, -180, -90)
			#print("rotation {an}".format({"an": arrow_rotation}))
			arrow_queue.rotation_degrees = arrow_rotation - 270


func set_queue(value: bool) -> void:
	$EnemyVisualQueue.visible = value

func set_arrow_queue(value: bool, rotation: Vector2) -> void:
	arrow_queue.visible = value
	is_alive = false
	if rotation.x <= 0:
		start_rotation = -45
	else:
		start_rotation = 45
	arrow_queue.rotation_degrees = start_rotation
	if value:
		set_aim = true
	else:
		set_aim = false


func _on_PlayerEnterDirection_body_entered(body: Node) -> void:
	if not is_alive:
		$EnemyCollisionBody.set_deferred("disabled", true)
		$EnemyCollisionFeets.set_deferred("disabled", true)
		$PlayerEnterDirection/CollisionShape2D.set_deferred("disabled", true)
		$EnemySprite.visible = false
	else:
		body.die()

func get_aim_direction() -> Vector2:
	var direction: = Vector2.ZERO
	match Settings.controls:
		Settings.GAMEPAD:
			direction = Utils.get_aim_joystick_direction()
		Settings.KB_MOUSE:
			direction = (get_global_mouse_position() - global_position).normalized()
	return direction


func _on_PlayerImpulseZone_body_entered(body: Node) -> void:
	if not is_alive:
		body.get_node("StateMachine/Move/Air").fatality()
