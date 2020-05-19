extends Control

export var next_scene: String

onready var user := $LogPanel/ColorRect/UserInput
onready var password := $LogPanel/ColorRect/PassInput

func _ready() -> void:
	user.grab_focus()
	#$Error.show()
	#$Error/ColorRect/Label.text = OS.get_name()

func load_next_scene() -> void:
	get_tree().change_scene(next_scene)

func _on_Salir_button_down() -> void:
	get_tree().quit()

func _on_Enter_button_down() -> void:
	load_next_scene()

func log_error() -> void:
	$Error.show()
	$ErrorTimer.start()
	user.editable = false
	password.editable = false

func _on_ErrorTimer_timeout() -> void:
	$Error.hide()
	user.text = ""
	password.text = ""
	user.editable = true
	password.editable = true
	user.grab_focus()

