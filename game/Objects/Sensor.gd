extends Area2D

################################################################################
#### Variables
var hologram_direction: int = 1

#### Variables export
export(bool) var timered = false
export(float) var reset_time = 10

#### Variables onready
onready var active: bool = false
onready var room: Room = get_parent().get_parent()
onready var running_timer := false
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	set_process(false)
	if timered:
		$Timer.wait_time = reset_time

func _process(_delta: float) -> void:
	if running_timer:
		$TimeLeft.text = "%3.1f" % $Timer.time_left
	
	if room.get_left_sensors() == 0:
		$TimeLeft.visible = false
		set_process(false)


func change_status(value: bool) -> void:
	active = value
	$SpriteActivated.visible = value
	$Sprite.visible = !value
	$PlayerHologram.scale.x = hologram_direction
	$PlayerHologram.visible = value
	$TimeLeft.visible = value
	running_timer = value
	if value:
		room.activate_sensor(1)
	else:
		room.activate_sensor(-1)


func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and not active:
		hologram_direction = body.skin.scale.x
		change_status(true)
		$Activated.play()
		if timered:
			set_process(true)
			$Timer.start()


func _on_Timer_timeout() -> void:
	$Timer.stop()
	if room.get_left_sensors() > 0:
		change_status(false)
################################################################################


