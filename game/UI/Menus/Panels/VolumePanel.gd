extends OptionPanel

var modifier := 5.0

onready var indexes := {
	"master": AudioServer.get_bus_index("Master"),
	"music": AudioServer.get_bus_index("Music"),
	"sfx": AudioServer.get_bus_index("Effects")
}

onready var labels :={
	"Master": $VBoxContainer/MainVolume/GeneralValue,
	"Music": $VBoxContainer/MusicVolume/MusicValue,
	"Effects": $VBoxContainer/EffectsVolume/EffectsValue
}


func _ready() -> void:
	update_volume_label("Master")
	update_volume_label("Music")
	update_volume_label("Effects")

func _on_GeneralMinus_pressed() -> void:
	change_volume("Master", false)


func _on_GeneralPlus_pressed() -> void:
	change_volume("Master", true)

func _on_MusicMinus_pressed() -> void:
	change_volume("Music", false)


func _on_MusicPlus_pressed() -> void:
	change_volume("Music", true)


func _on_EffectsMinus_pressed() -> void:
	change_volume("Effects", false)


func _on_EffectsPlus_pressed() -> void:
	change_volume("Effects", true)

func change_volume(bus: String, up: bool) -> void:
	$AudioStreamPlayer.play()
	Game.change_volume(bus, modifier, up)
	update_volume_label(bus)

func update_volume_label(bus: String) -> void:
	var label_text := "%01d" % [Game.get_volumes(bus)]
	labels[bus].text = label_text

func _on_Apply_pressed() -> void:
	._on_Apply_pressed()
	GameSaver.update_user_data()
	


