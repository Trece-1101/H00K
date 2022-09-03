extends Control

export var menu := {"normal_player": "", "tester": ""}

onready var return_button := $VBoxContainer/ReturnButton
onready var header_label := $VBoxContainer/CenterRow/VBoxContainer/Header

onready var panels = {
	"volume_panel": "res://game/UI/Menus/Panels/VolumePanel.tscn",
	"screen_panel": "res://game/UI/Menus/Panels/ScreenPanel.tscn",
	"control_panel": "res://game/UI/Menus/Panels/ControlPanel.tscn"
}

func _ready() -> void:
	header_label.modulate = Color( 1, 1, 1, 0 )
	return_button.next_scene = menu["normal_player"]
#	if Game.get_user()["type"] in Game.testers:
#		return_button.next_scene = menu["tester"]

func toogle_panel(header: String, panel: String) -> void:
	var internal_panel = load(panel).instance()
	$VBoxContainer/CenterRow/VBoxContainer/MarginContainer.add_child(internal_panel)
	header_label.text = header
	header_label.modulate = Color( 1, 1, 1, 1 )

func _on_Volume_button_up() -> void:
	toogle_panel("Volumen", panels["volume_panel"])

func _on_Screen_button_up() -> void:
	toogle_panel("Pantalla", panels["screen_panel"])

func _on_Control_button_up() -> void:
	toogle_panel("Control", panels["control_panel"])
