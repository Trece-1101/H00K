extends Node

signal done

onready var http_request := $HTTPRequest
onready var http_result := {}

func get_result():
	return http_result

func _ready() -> void:
	http_request.connect("request_completed", self, "_http_request_completed")
	
func Login(user: String, password: String) -> void:
	var headers = ["Content-Type: application/json"]
	var query = JSON.print({"nickname": user, "password": password})
	#print(query)
	http_request.request("http://142.93.201.7:3000/login", headers, false, HTTPClient.METHOD_POST, query)

func SetLog(uname: String, platform: String) -> void:
	var headers = ["Content-Type: application/json"]
	var query = JSON.print({"Nickname": uname, "Plataforma": platform})
	#print(query)
	http_request.request("http://142.93.201.7:3000/Log", headers, false, HTTPClient.METHOD_POST, query)

func _http_request_completed(_result, response_code, _headers, body) -> void:
	var response = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		http_result = {"result": true, "value": response.result, "message": "OK"}
	else:
		var msj = "Error %s on database connection" % response_code
		http_result = {"result": false, "value": response.result, "message": msj}
	
	emit_signal("done")
