extends Control

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

func change_button_label(button: Button) -> void:
	button.text = "Sobre-escribir datos"

func _on_NewGame1_pressed() -> void:
	start_game(buttons["text_slot_1"])

func _on_NewGame2_pressed() -> void:
	start_game(buttons["text_slot_1"])

func _on_NewGame3_pressed() -> void:
	start_game(buttons["text_slot_1"])

func start_game(button: Button) -> void:
	if button.text == "Nueva Partida":
		print_debug("nueva partida")
	else:
		print_debug("sobre escribir")
