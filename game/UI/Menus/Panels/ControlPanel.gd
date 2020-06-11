extends OptionPanel

onready var controls := {
	"Gamepad": Settings.GAMEPAD,
	"KBM": Settings.KB_MOUSE,
	}

var selected_control_index = 0

func _ready() -> void:
	for control in controls.keys():
		$OptionButton.add_item(control)


func _on_Apply_pressed() -> void:
	._on_Apply_pressed()
	GameSaver.update_user_data()


func _on_OptionButton_item_selected(id: int) -> void:
	selected_control_index = id
