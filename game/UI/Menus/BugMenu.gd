extends Control

var user: String
var room: String
var version: String
var level: String
var tipo_bug: String
var descripcion: String

func _ready() -> void:
	user = Game.user["name"]
	room = Game.get_player_current_room()
	level = Game.get_player_current_level()
	
	$UserName.text = user
	$UserName.editable = false


func _on_SendButton_pressed() -> void:
	if tipo_bug == "" or descripcion == "":
		$ErrorPopup.show()
		$Timer.start()
		toggle_enable(false)
	else:
		pass

func toggle_enable(value: bool) -> void:
	$SendButton.disabled = !value
	$TipoBug.editable = value
	$DescriptionTextEdit.readonly = !value

func _on_Timer_timeout() -> void:
	$ErrorPopup.hide()
	toggle_enable(true)
