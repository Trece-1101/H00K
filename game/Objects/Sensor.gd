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
################################################################################

################################################################################
#### Metodos
func _ready() -> void:
	if timered:
		$Timer.wait_time = reset_time

#func activate() -> void:
#	active = true
#	room.activate_sensor()
#	$SpriteActivated.visible = true
#	$Sprite.visible = false
#	$PlayerHologram.visible = true
#	$PlayerHologram.scale.x = hologram_direction

func change_status(value: bool) -> void:
	active = value
	$SpriteActivated.visible = value
	$Sprite.visible = !value
	$PlayerHologram.scale.x = hologram_direction
	$PlayerHologram.visible = value
	if value:
		room.activate_sensor(1)
	else:
		room.activate_sensor(-1)

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and not active:
		hologram_direction = body.skin.scale.x
		#activate()
		change_status(true)
		$Activated.play()
		if timered:
			$Timer.start()

func _on_Timer_timeout() -> void:
	if room.get_left_sensors() > 0:
		change_status(false)
################################################################################


