extends Node

###############################################################################
## Señales
signal done

#### Variables onready
onready var http_request := $HTTPRequest
onready var http_result := {}
###############################################################################

###############################################################################
#### Setters y Getters
func get_result():
	return http_result

###############################################################################

###############################################################################
#### Metodos
func _ready() -> void:
	http_request.connect("request_completed", self, "_http_request_completed")
	
func Login(user: String, password: String) -> void:
	var query = JSON.print({"nickname": user, "password": password})
	send_request("login", query)

func SetLog(uname: String, platform: String) -> void:
	var query = JSON.print({"Nickname": uname, "Plataforma": platform})
	send_request("Log", query)

func GetBugTypes():
	http_request.request("http://142.93.201.7:3000/bugTypes")

func SetBug(
	nickname: String, 
	room: int, 
	version: int, 
	level: int, 
	id_log: int, 
	type_bug: int, 
	description: String
	) -> void:
		var query = JSON.print({"Nickname": nickname, 
			"NumRoom": room, 
			"Version": version, 
			"IdLevel": level, 
			"IdLog": id_log, 
			"IdTipoBug": type_bug, 
			"Descripcion": description}
			)
		send_request("bug", query)

func SetPerformance(
	nickname: String, 
	room: int, 
	version: int, 
	id_level: int, 
	time: String, 
	deaths: int, 
	complete: String
	) -> void:
		var query = JSON.print({"Nickname": nickname,
			"NumRoom": room,
			"Version": version,
			"IdLevel": id_level,
			"Tiempo": time,
			"Muertes": deaths,
			"Completo": complete})
		send_request("game", query)

func UpdatePerformance(id_game: int, time: String, deaths: int) -> void:
	print("update_performance")

func ClosePerformance(id_game: int, time: String) -> void:
	print("close_performance")

func send_request(request_name: String, query: String) -> void:
	var headers = ["Content-Type: application/json"]
	var url := "http://142.93.201.7:3000/" + request_name
	print(query)
	http_request.request(url, headers, false, HTTPClient.METHOD_POST, query)

func _http_request_completed(_result, response_code, _headers, body) -> void:
	var response = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		http_result = {"result": true, "value": response.result, "message": "OK"}
	else:
		var msj = "Error %s on database connection" % response_code
		http_result = {"result": false, "value": response.result, "message": msj}
	
	print(http_result)
	emit_signal("done")
