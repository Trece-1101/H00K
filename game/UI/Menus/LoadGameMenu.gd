extends Control

onready var slot1 = $VBoxContainer/Buttons/Slot1
onready var slot2 = $VBoxContainer/Buttons/Slot2
onready var slot3 = $VBoxContainer/Buttons/Slot3


func _ready() -> void:
	#toggle_slot(false, slot1, $NoSlot1)
	toggle_slot(false, slot2, $NoSlot2)
	toggle_slot(false, slot3, $NoSlot3)

func toggle_slot(turn_on: bool, in_slot: Panel, in_label: Label) -> void:
	in_label.visible = !turn_on
	if turn_on:
		in_slot.modulate = Color( 1, 1, 1, 1 )
	else:
		for child in in_slot.get_children():
			if child.name == "LoadGame":
				child.disabled = true
		in_slot.modulate = Color( 0, 0, 0, 1 )


func _on_LoadGame_pressed() -> void:
	print_debug("Hola")
