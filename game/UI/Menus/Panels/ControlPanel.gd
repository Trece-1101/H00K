extends OptionPanel

onready var controls := {
	"KBM": Settings.KB_MOUSE,
	"Gamepad": Settings.GAMEPAD
	}

var selected_control_index = 0

func _ready() -> void:
	for control in controls.keys():
		$OptionButton.add_item(control)
	
	var current_control := "Gamepad"
	if Game.get_main_controls() == 0:
		current_control = "KBM"
	
	for i in range($OptionButton.get_item_count()):
		if current_control == $OptionButton.get_item_text(i):
			$OptionButton.select(i)
			selected_control_index = i


func _on_Apply_pressed() -> void:
	._on_Apply_pressed()
	Game.set_main_controls(controls[$OptionButton.get_item_text(selected_control_index)])
	#GameSaver.update_user_data()


func _on_OptionButton_item_selected(id: int) -> void:
	selected_control_index = id
