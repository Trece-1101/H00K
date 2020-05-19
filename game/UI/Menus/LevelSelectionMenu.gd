extends Control

onready var buttons_grid := $MainContainer/OptionsContainer/OptionPanel/GridContainer

func _ready() -> void:
	connect_buttons()

func connect_buttons() -> void:
	for button in buttons_grid.get_children():
		button.connect("pressed", self, "load_room", [button.get_level_to_load()])

func load_room(level_to_load: String) -> void:
	if level_to_load != "":
		get_tree().change_scene(level_to_load)
