extends Control

export var next_scene := ""

onready var slot := ""

onready var slot1 = $VBoxContainer/Buttons/Slot1
onready var slot2 = $VBoxContainer/Buttons/Slot2
onready var slot3 = $VBoxContainer/Buttons/Slot3

onready var slots = [slot1, slot2, slot3]
onready var details = {"slot_1": {}, "slot_2": {}, "slot_3": {}}

onready var buttons := {
	"text_slot_1": $VBoxContainer/Buttons/Slot1/NewGame1,
	"text_slot_2": $VBoxContainer/Buttons/Slot2/NewGame2,
	"text_slot_3": $VBoxContainer/Buttons/Slot3/NewGame3
	}

func _ready() -> void:
	check_data_in_slots()


func check_data_in_slots() -> void:	
	for i in range(1, 4):
		var slot := "slot_"
		slot += String(i)
		if GameSaver.check_user_performance_data(slot):
			var button = "text_slot_" + String(i)
			change_button_label(buttons[button])
			details[slot] = GameSaver.load_details(slot)
			load_details(slots[i - 1], slot)

func change_button_label(button: Button) -> void:
	button.text = "Sobre-escribir datos"

func load_details(in_slot: Panel, slot_name: String) -> void:
	for child in in_slot.get_children():
		if child.name == "Level":
			child.text += ": " + details[slot_name]["current_level_name"]
		if child.name == "Room":
			child.text += ": " + details[slot_name]["current_room"]
		if child.name == "Deaths":
			child.text += ": " + String(details[slot_name]["total_death_count"])
		if child.name == "TimeElapsed":
			child.text += ": " + convert_time(details[slot_name]["time_elapsed"])

func convert_time(time: int) -> String:
	var digit_format = "%02d"
	var hours = digit_format % [time * 0.000277778]
	var minutes = digit_format % [time * 0.0166666666666667]
	var seconds = digit_format % [int(ceil(time)) % 60]
	
	return "{h}:{m}:{s}".format({"h": hours, "m": minutes, "s": seconds})

func _on_NewGame1_pressed() -> void:
	slot = "slot_1"
	start_game(buttons["text_slot_1"])

func _on_NewGame2_pressed() -> void:
	slot = "slot_2"
	start_game(buttons["text_slot_1"])

func _on_NewGame3_pressed() -> void:
	slot = "slot_3"
	start_game(buttons["text_slot_1"])

func start_game(button: Button) -> void:
	if button.text == "Nueva Partida":
		GameSaver.create_performance_slot(slot)
	else:
		GameSaver.delete_performance_slot(slot)
		GameSaver.create_performance_slot(slot)
	
	get_tree().change_scene(next_scene)
