extends State

export var animation: String = ""

onready var move: = get_parent()
onready var go_run = 0

func enter(msg: Dictionary = {}) -> void:
	move.enter(msg)
	$WaitRun.start()
	owner.skin.play(animation)
	owner.skin.connect("animation_finished", self, "_on_PlayerAnimation_animation_finished")

func physics_process(_delta: float) -> void:
	var velocity = move.max_speed_default * Vector2(owner.skin.scale.x, 1.0) * Vector2(go_run, go_run)
	owner.move_and_slide_with_snap(velocity, Vector2.DOWN * 20.0, owner.FLOOR_NORMAL)

	if owner.get_can_move():
		exit()

func exit() -> void:
	owner.skin.disconnect("animation_finished", self, "_on_PlayerAnimation_animation_finished")
	move.exit()


func _on_WaitRun_timeout() -> void:
	go_run = 1
