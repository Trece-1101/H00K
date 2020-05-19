extends Enemy

#### Variables
var player: Player

#### Variables export
export var patrol_velocity: Vector2 = Vector2(150.0, 250.0)
export var chase_velocity: Vector2 = Vector2(350.0, 250.0)
export var max_velocity: Vector2 = Vector2(500.0, 250.0)
export var velocity_increment: float = 1.1

#### Variables onready
onready var blackboard = $Blackboard
onready var behavior_tree = $BehaviorTree

onready var right_player_detector = $RightPlayerDetector
onready var left_player_detector = $LeftPlayerDetector
onready var wall_detector = $WallDetector
onready var floor_detector = $FloorDetector

func _ready() -> void:
	player = owner.get_node("Player")
	
	blackboard.set("player_on_sight", false)
	blackboard.set("wall_is_near", false)
	blackboard.set("void_is_near", false)
	blackboard.set("was_chasing", false)
	blackboard.set("ka_boom", false)
	
	blackboard.set("patrol_velocity", patrol_velocity)
	blackboard.set("chase_velocity", chase_velocity)
	blackboard.set("max_velocity", max_velocity)
	blackboard.set("vel_increment", velocity_increment)
	
	blackboard.set("current_velocity", patrol_velocity)
	blackboard.set("current_position", null)
	blackboard.set("move_direction", Vector2(-1.0, 1.0))
	blackboard.set("last_move_direction", blackboard.get("move_direction"))
	blackboard.set("last_know_player_position", null)
	

func _physics_process(_delta: float) -> void:
	npc_movement()


func update_behavior_tree() -> void:
	check_player()
	check_wall()
	check_void()
	
	behavior_tree.run(self, blackboard, false)

func npc_movement() -> void:
	var new_velocity: Vector2 = (
		blackboard.get("current_velocity") * get_move_direction()
		)
	
	move_and_slide(new_velocity, Vector2.UP)
	
	if is_on_floor():
		new_velocity.y = 0.0
	else:
		new_velocity.x = 0.0
	
	blackboard.set("current_position", global_position)

func get_move_direction() -> Vector2:
	var move_direction = blackboard.get("move_direction")
	var sign_direction = sign(move_direction.x)

	wall_detector.scale.x = move_direction.x
	floor_detector.position.x = 15 if sign_direction == 1 else -15
	
	return move_direction

#### Sentidos NPC
func check_player() -> void:
	if left_player_detector.is_colliding() or right_player_detector.is_colliding():
		blackboard.set("player_on_sight", true)
		blackboard.set("last_know_player_position", player.global_position)
	else:
		blackboard.set("player_on_sight", false)

func check_wall() -> void:
	if wall_detector.is_colliding():
		blackboard.set("wall_is_near", true)
	else:
		blackboard.set("wall_is_near", false)

func check_void() -> void:
	if floor_detector.is_colliding():
		blackboard.set("void_is_near", false)
	else:
		blackboard.set("void_is_near", true)

func _on_PlayerDetector_body_entered(body: Node) -> void:
	if body.name == "Player":
		blackboard.set("current_velocity", Vector2.ZERO)
		$Updater.stop()
		skin_animation.connect("animation_finished", self, "explode")
		skin_animation.play("go_explode")

func _on_Updater_timeout() -> void:
	update_behavior_tree()
