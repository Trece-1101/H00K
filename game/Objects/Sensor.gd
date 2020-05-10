extends Area2D

################################################################################
#### Variables
var hologram_direction: int = 1

#### Variables onready
onready var active: bool = false
onready var room: Room = get_parent().get_parent()
################################################################################

################################################################################
#### Metodos
func activate() -> void:
	active = true
	$Sprite.modulate = Color( 0, 0, 0, 1 )
	room.activate_sensor()
	$PlayerHologram.visible = true
	$PlayerHologram.scale.x = hologram_direction

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and not active:
		hologram_direction = body.skin.scale.x
		activate()
		$Activated.play()
################################################################################
