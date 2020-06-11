extends OptionPanel

onready var resolutions := {
	"960 x 540": Vector2(960, 540),
	"1280 x 720": Vector2(1280, 720),
	"1366 x 768": Vector2(1366, 768),
	"1600 x 900": Vector2(1600, 900),
	"1920 x 1080": Vector2(1920, 1080)
	}

var selected_resolution_index = 0

func _ready() -> void:
	for res in resolutions.keys():
		$OptionButton.add_item(res)
	
	$CheckBox.set_pressed(OS.window_fullscreen)
	
	var text_windows_size = String(OS.window_size.x) + " x "  + String(OS.window_size.y)
	
	for i in range($OptionButton.get_item_count()):
		if text_windows_size == $OptionButton.get_item_text(i):
			$OptionButton.select(i)
			selected_resolution_index = i


func _on_OptionButton_item_selected(id: int) -> void:
	selected_resolution_index = id

func _on_Apply_pressed() -> void:
	._on_Apply_pressed()
	var new_resolution:Vector2 = resolutions[$OptionButton.get_item_text(selected_resolution_index)]
	var is_full_screen:bool = $CheckBox.is_pressed()
	OS.window_size = new_resolution
	OS.window_fullscreen = is_full_screen
	Game.set_screen(new_resolution, is_full_screen)
	GameSaver.update_user_data()
