extends Control

var user: String
var room: String
var version: String
var level: String
var tipo_bug: String
var descripcion: String

onready var BDGetBugTypes := $GetBugTypesRequest
onready var BDRquest := $BugRequest

func _ready() -> void:
	user = Game.user["name"]
	room = Game.get_player_current_room()
	#level = Game.get_player_current_level()
	
	
	$UserName.text = user
	$UserName.editable = false
	BDGetBugTypes.GetBugTypes()
	yield(BDGetBugTypes,"done")
	var result = BDGetBugTypes.GetBugTypesResult
	for i in range(0, result.size()):
		var label = result[i]["descripcion"]
		var id = result[i]["idtipobug"]
		$OptionButton.add_item(label, id)

func _on_SendButton_pressed() -> void:
	if descripcion == "":
		$ErrorPopup.show()
		$Timer.start()
		toggle_enable(false)
	else:
		pass
		## BDRquest.SetBug(Nickname, NumRoom, Version, IdLevel, IdLog, IdTipoBug, Descripcion)
		## yield(BDRquest,"done")
		## var result = BDRquest.GetBugTypesResult

func toggle_enable(value: bool) -> void:
	$SendButton.disabled = !value
	$TipoBug.editable = value
	$DescriptionTextEdit.readonly = !value

func _on_Timer_timeout() -> void:
	$ErrorPopup.hide()
	toggle_enable(true)
