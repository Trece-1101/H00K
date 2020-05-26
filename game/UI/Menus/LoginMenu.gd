extends Control

var ok_answer := false

export var next_scene: String

onready var user := $LogPanel/ColorRect/UserInput
onready var password := $LogPanel/ColorRect/PassInput
onready var BDRequest := $LoginRequest

func _ready() -> void:
	user.grab_focus()

func load_next_scene() -> void:
	get_tree().change_scene(next_scene)

func _on_Salir_button_down() -> void:
	get_tree().quit()

func _on_Enter_button_down() -> void:
	BDRequest.Login(user.text, password.text)
	$Searching.show()
	toggle_insert(false)
	yield(BDRequest, "done")
	var result = BDRequest.LoginResult
	#print(result)
	if result[0] == 200:
		## ACA DEVUELVE EL TIPO DE USUARIO Q ES Y DEBERIA SER GUARDADO EN UNA VARIABLE GLOBAL DEL JUEGO
		## tipoUser = result[1] 
		pop_up_show($OK)
		ok_answer = true
	else:
		$Error/ColorRect/Label.text = result[1]
		if result[0] != 401:
			$Error/ColorRect/Label.text = "Error conexion"
		pop_up_show($Error)
		ok_answer = false

func pop_up_show(popup: Popup) -> void:
	$Searching.hide()
	popup.show()
	$Timer.start()
	toggle_insert(false)

func toggle_insert(value: bool) -> void:
	user.editable = value
	password.editable = value
	$LogPanel/ColorRect/Salir.disabled = not value
	$LogPanel/ColorRect/Enter.disabled = not value

func _on_Timer_timeout() -> void:
	if ok_answer:
		load_next_scene()
	else:
		$Error.hide()
		user.text = ""
		password.text = ""
		toggle_insert(true)
		user.grab_focus()

