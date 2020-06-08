extends Control

onready var slot1 = $VBoxContainer/Buttons/Slot1
onready var slot2 = $VBoxContainer/Buttons/Slot2
onready var slot3 = $VBoxContainer/Buttons/Slot3

onready var slots = [slot1, slot2, slot3]
onready var labels = [$NoSlot1, $NoSlot2, $NoSlot3]
onready var details = {"slot_1": {}, "slot_2": {}, "slot_3": {}}

func _ready() -> void:
	toggle_slot(false, slot1, $NoSlot1, "slot_1")
	toggle_slot(false, slot2, $NoSlot2, "slot_2")
	toggle_slot(false, slot3, $NoSlot3, "slot_3")
	check_data_in_slots()

func check_data_in_slots() -> void:
	for i in range(1, 4):
		var slot := "slot_"
		slot += String(i)
		if GameSaver.check_user_performance_data(slot):
			details[slot] = GameSaver.load_details(slot)
			toggle_slot(true, slots[i-1], labels[i-1], slot)

func toggle_slot(turn_on: bool, in_slot: Panel, in_label: Label, slot: String) -> void:
	in_label.visible = !turn_on	
	if turn_on:
		in_slot.modulate = Color( 1, 1, 1, 1 )
		for child in in_slot.get_children():
			if "LoadGame" in child.name:
				child.disabled = false
			if child.name == "Level":
				child.text += ": " + details[slot]["current_level_name"]
			if child.name == "Room":
				child.text += ": " + details[slot]["current_room"]
			if child.name == "Deaths":
				child.text += ": " + String(details[slot]["total_death_count"])
			if child.name == "TimeElapsed":
				child.text += ": " + convert_time(details[slot]["time_elapsed"])
	else:
		for child in in_slot.get_children():
			if "LoadGame" in child.name:
				child.disabled = true
		in_slot.modulate = Color( 0, 0, 0, 1 )

func convert_time(time: int) -> String:
	var digit_format = "%02d"
	var hours = digit_format % [time / 3600]
	var minutes = digit_format % [time / 60]
	var seconds = digit_format % [int(ceil(time)) % 60]
	
	return "{h}:{m}:{s}".format({"h": hours, "m": minutes, "s": seconds})

func _on_LoadGame1_pressed() -> void:
	load_data("slot_1")

func _on_LoadGame2_pressed() -> void:
	load_data("slot_2")

func _on_LoadGame3_pressed() -> void:
	load_data("slot_3")

func load_data(slot: String) -> void:
	var data = GameSaver.load_performance(slot)
	
	Game.set_scene_to_load(data["level_to_load"])
	Game.set_player_respawn_position(data["respawn_position"])
	Game.set_player_current_level(data["current_level_name"], data["current_level_number"])
	Game.set_player_current_room(data["current_room"], data["current_room_version"])
	#Game.set_player_last_state(data["player_last_state"])
	Game.set_player_last_state("Load")
	if not data["last_door"].empty():
		Game.set_last_door_closed(data["last_door"]["door"], data["last_door"]["room"])
	Game.set_camera_start(data["camera"])
	GamePerformance.set_total_time_elapsed(data["time_elapsed"])
	GamePerformance.set_player_death_count(data["total_death_count"])
	GamePerformance.set_levels_performance(data["levels_performances"])
	
	get_tree().change_scene(Game.get_scene_to_load())
