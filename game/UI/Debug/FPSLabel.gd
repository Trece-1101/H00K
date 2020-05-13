extends Label

################################################################################
#### Metodos
func _ready() -> void:
	update_label()

func _process(_delta: float) -> void:
	update_label()

func update_label() -> void:
	text = "FPS: %s" % str(Engine.get_frames_per_second())
################################################################################
