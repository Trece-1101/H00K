extends Control

var ok_answer := false

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
	if user.text == "omar13" and password.text == "passomar13":
		pop_up_show($OK)
		ok_answer = true
	else:
		pop_up_show($Error)
		ok_answer = false


func pop_up_show(popup: Popup) -> void:
	popup.show()
	$Timer.start()
	user.editable = false
	password.editable = false
	$LogPanel/ColorRect/Salir.disabled = true


func _on_Timer_timeout() -> void:
	if ok_answer:
		load_next_scene()
	else:
		$Error.hide()
		user.text = ""
		password.text = ""
		user.editable = true
		password.editable = true
		$LogPanel/ColorRect/Salir.disabled = false
		user.grab_focus()

