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
	var query = JSON.print({"Nickname": user, "Password": password})
	send_request("login", query, HTTPClient.METHOD_POST)

func SetLog(uname: String, platform: String) -> void:
	var query = JSON.print({"Nickname": uname, "Plataforma": platform})
	send_request("Log", query, HTTPClient.METHOD_POST)

func SetUser(uname: String) -> void:
	var query = JSON.print({"Nickname": uname})
	send_request("users", query, HTTPClient.METHOD_POST)

func GetBugTypes():
	http_request.request("http://142.93.201.7:3000/bugTypes")

func SetBug(
	room: int, 
	version: int,
	id_level: int, 
	id_log: int, 
	type_bug: int, 
	description: String
	) -> void:
		var query = JSON.print({
			"NumRoom": room, 
			"Version": version, 
			"IdLevel": id_level,
			"IdLog": id_log, 
			"IdTipoBug": type_bug, 
			"Descripcion": description}
			)

		send_request("bug", query, HTTPClient.METHOD_POST)

func SetPerformance(
	nickname: String, 
	room: int, 
	version: int, 
	id_level: int, 
	time: String, 
	deaths: int, 
	complete: String
	) -> void:
		var query = JSON.print({
			"Nickname": nickname,
			"NumRoom": room,
			"Version": version,
			"IdLevel": id_level,
			"Tiempo": time,
			"Muertes": deaths,
			"Completo": complete})
		
		send_request("game", query, HTTPClient.METHOD_POST)

func UpdatePerformance(id_game: int, time: String, deaths: int) -> void:
	var query = JSON.print({"IdGame": id_game, "Tiempo": time, "Muertes": deaths})
	send_request("game", query, HTTPClient.METHOD_PUT)

func ClosePerformance(id_game: int, time: String) -> void:
	var query = JSON.print({"IdGame": id_game, "Tiempo": time})
	send_request("gameComplete", query, HTTPClient.METHOD_PUT)

func send_request(request_name: String, query: String, method: int) -> void:
	var headers = ["Content-Type: application/json"]
	var url := "http://142.93.201.7:3000/" + request_name
	#print(query)
	http_request.request(url, headers, false, method, query)

func _http_request_completed(_result, response_code, _headers, body) -> void:
	var response = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		http_result = {"result": true, "value": response.result, "message": "OK"}
	else:
		var msj: String = "Error %s on database connection" % response_code
		http_result = {"result": false, "value": response.result, "message": msj}
	
	#print_debug(http_result)
	emit_signal("done")
