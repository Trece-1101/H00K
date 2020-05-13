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
	room.activate_sensor()
	$SpriteActivated.visible = true
	$Sprite.visible = false
	$PlayerHologram.visible = true
	$PlayerHologram.scale.x = hologram_direction

func _on_body_entered(body: Node) -> void:
	if body.name == "Player" and not active:
		hologram_direction = body.skin.scale.x
		activate()
		$Activated.play()
################################################################################
