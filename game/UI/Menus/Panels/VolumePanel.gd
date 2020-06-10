extends OptionPanel

#AudioServer.set_bus_volume_db(AudioServer.get_bus_index("Master"), lower_volume)

var modifier := 5.0

onready var indexes := {
	"master": AudioServer.get_bus_index("Master"),
	"music": AudioServer.get_bus_index("Music"),
	"sfx": AudioServer.get_bus_index("Effects")
}

onready var labels :={
	"master": $VBoxContainer/MainVolume/GeneralValue,
	"music": $VBoxContainer/MusicVolume/MusicValue,
	"sfx": $VBoxContainer/EffectsVolume/EffectsValue
}


func _ready() -> void:
	update_volume_label("master")
	update_volume_label("music")
	update_volume_label("sfx")

func _on_GeneralMinus_pressed() -> void:
	change_volume(indexes["master"], false, "master")


func _on_GeneralPlus_pressed() -> void:
	change_volume(indexes["master"], true, "master")

func _on_MusicMinus_pressed() -> void:
	change_volume(indexes["music"], false, "music")


func _on_MusicPlus_pressed() -> void:
	change_volume(indexes["music"], true, "music")


func _on_EffectsMinus_pressed() -> void:
	change_volume(indexes["sfx"], false, "sfx")


func _on_EffectsPlus_pressed() -> void:
	change_volume(indexes["sfx"], true, "sfx")

func change_volume(index: int, up: bool, bus: String) -> void:
	$AudioStreamPlayer.play()
	var current_volume = AudioServer.get_bus_volume_db(index)
	if up:
		AudioServer.set_bus_volume_db(index, current_volume + modifier)
	else:
		AudioServer.set_bus_volume_db(index, current_volume - modifier)
	
	update_volume_label(bus)

func update_volume_label(bus: String) -> void:
	var label_text := "%01d" % [AudioServer.get_bus_volume_db(indexes[bus])]
	labels[bus].text = label_text

func _on_Apply_pressed() -> void:
	._on_Apply_pressed()


