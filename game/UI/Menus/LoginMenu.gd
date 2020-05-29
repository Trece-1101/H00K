extends Control

var ok_answer := false
var create_user := false

export var next_scene: String
export var is_tester: bool = false

onready var user := $LogPanel/ColorRect/UserInput
onready var password := $LogPanel/ColorRect/PassInput
onready var db_request := $HttpDbRequest

func set_create_user(value: bool) -> void:
	create_user = value

func _ready() -> void:
	user.grab_focus()
	if get_parent().name == "PresentationMenu":
		get_parent().connect("press_send", self, "log_user")
	

func load_next_scene() -> void:
	get_tree().change_scene(next_scene)

func _on_Salir_button_down() -> void:
	get_tree().quit()

func _on_Enter_button_down() -> void:
	if is_tester:
		make_login(user.text, password.text)
	else:
		make_login(user.text)

func log_user() -> void:
	make_login(user.text)

func make_login(uname: String, upass: String = "qwerty1234") -> void:
	# login_request
	db_request.Login(uname.to_lower(), upass.to_lower())
	if visible:
		$Searching.show()
	toggle_insert(false)
	yield(db_request, "done")
	var result = db_request.get_result()
	#print(result)	
	if result["result"]:
		# Guardo el nombre del usuario logueado y el tipo de usuario
		Game.set_user(result["value"]["Tipo"], uname.to_lower())
		# log_request
		db_request.SetLog(Game.get_user()["name"], OS.get_name())
		yield(db_request, "done")
		var log_result = db_request.get_result()
		if log_result["result"]:
			#print(log_result)
			# Guardo el valor del log
			Game.set_log_id(log_result["value"]["IdLog"])
			if create_user:
				GameSaver.create_user(Game.get_user()["name"])
			$OK/ColorRect/Label.text = "Iniciando sesion con ID {id}".format({"id": Game.get_log_id()})
			pop_up_show($OK)
			ok_answer = true
		else:
			$Error/ColorRect/Label.text = log_result["message"]
			pop_up_show($Error)
	else:
		if result["value"] == "Usuario Incorrecto." and not is_tester:
			print("crear usuario")
		else:
			$Error/ColorRect/Label.text = result["message"]
			if "401" in result["message"]:
				$Error/ColorRect/Label.text = "Error conexion"
			pop_up_show($Error)
			ok_answer = false

func pop_up_show(popup: Popup) -> void:
	$Timer.start()
	if visible:
		$Searching.hide()
		popup.show()
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

