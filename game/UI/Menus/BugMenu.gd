class_name BugMenu
extends Control

var user: String
var tipo_bug: String

export var levels := 2

onready var db_request := $HttpDbRequest

#onready var bg_get_bug_types := $GetBugTypesRequest
#onready var bug_request := $BugRequest

func _ready() -> void:
	$OptionButton.grab_focus()
	user = Game.user["name"]
	
	$UserName.text = user
	$UserName.editable = false
	
	fill_properties()

func fill_properties() -> void:
	$LevelOption.clear()
	$RoomOption.clear()
	fill_level_options()
	fill_bug_options()

func fill_level_options() -> void:
	var level_label = Game.get_player_current_level_name()
	var level_id = Game.get_player_current_level_number()
	#print(level_label, level_id)	
	if level_label == "":
		for i in range(levels):
			var label = "{value}".format({"value": i + 1})
			var id = i + 1
			$LevelOption.add_item(label, id)
		
		for i in range(40):
			var label2 = "{value2}".format({"value2": i + 1})
			var id2 = i + 1
			$RoomOption.add_item(label2, id2)
		
	else:
		$LevelOption.add_item(level_label, level_id)
		var room_label: String = Game.get_player_current_room()
		var room_id: int = int(room_label.substr(4,-1))
		#print(room_label, room_id)
		$RoomOption.add_item(room_label, room_id)


func fill_bug_options() -> void:
	$OptionButton.clear()
	db_request.GetBugTypes()
	yield(db_request,"done")
	var result = db_request.get_result()
	#print(result)
	for value in result["value"]:
		var label = value["descripcion"]
		var id = value["idtipobug"]
		$OptionButton.add_item(label, id)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("bug_menu") and Game.get_user()["type"] in Game.testers:
		if visible:
			get_tree().paused = false
			visible = false
			if Game.get_main_controls() == Settings.GAMEPAD:
				Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
		else:
			fill_properties()
			get_tree().paused = true
			visible = true
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _on_SendButton_pressed() -> void:
	if $DescriptionTextEdit.text == "" or user == "":
		pop_up("error", "El campo descripcion no puede estar vacio", true)
	else:
		db_request.SetBug(
			Game.get_user()["name"], #nickname
			$RoomOption.get_selected_id(), #room
			Game.get_player_current_room_v(), #room_version
			$LevelOption.get_selected_id(), #level
			Game.get_log_id(), #log_id
			$OptionButton.get_selected_id(), #bug_type
			$DescriptionTextEdit.text #descripcion
		)

		pop_up("wait", "Enviando registro bug", false)
		yield(db_request, "done")
		var result = db_request.get_result()
		if result["result"]:
			pop_up("ok", "Bug con ID: {id} registrado".format({"id":result["value"]["IdBug"]}), true)
			$DescriptionTextEdit.text = ""
		else:
			pop_up("error", "Error '{error}' al registrar bug".format({"error":result["message"]}), true)

func pop_up(type: String, text: String, timer: bool) -> void:
	$ErrorPopup.show()
	$ErrorPopup/Label.text = text
	toggle_enable(false)
	if type == "error":
		$ErrorPopup/ColorRect.color = Color( 1, 0, 0, 1 )
	elif type == "ok":
		$ErrorPopup/ColorRect.color = Color( 0, 1, 0, 1 )
	elif type == "wait":
		$ErrorPopup/ColorRect.color = Color( 1, 0.55, 0, 1 )
	
	if timer:
		$Timer.start()

func toggle_enable(value: bool) -> void:
	$OptionButton.disabled = !value
	$SendButton.disabled = !value
	$DescriptionTextEdit.readonly = !value
	$LevelOption.disabled = !value
	$RoomOption.disabled = !value

func _on_Timer_timeout() -> void:
	$ErrorPopup.hide()
	toggle_enable(true)
