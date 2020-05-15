class_name HookTargetDinamyc
extends HookTarget

export var timer_open: float = 3.0
export var timer_close: float = 2.0

onready var open_time = $OpenTime
onready var close_time = $CloseTime

func _ready() -> void:
	open_time.wait_time = timer_open
	close_time.wait_time = timer_close
	yield(owner, "ready")
	open_time.start()

func _on_Timer_timeout() -> void:
	._on_Timer_timeout()
	open_time.start()

func _on_TimerOpen_timeout() -> void:
	$AnimationPlayer.play("close")
	self.is_active = false
	close_time.start()

func _on_TimerClose_timeout() -> void:
	$AnimationPlayer.play("go_open")
	self.is_active = true
	open_time.start()

func hooked_from(hook_position: Vector2) -> void:
	.hooked_from(hook_position)
	open_time.stop()
	close_time.stop()
