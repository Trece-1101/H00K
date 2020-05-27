extends Node

signal done

onready var log_request = get_node("LogRequest")
onready var log_result

func get_log_result():
	return log_result

func _ready() -> void:
	log_request.connect("request_completed", self, "_LogRequest_request_completed")
	
func SetLog(Nickname: String, Plataforma: String) -> void:
	var headers = ["Content-Type: application/json"]
	var query = JSON.print({"Nickname": Nickname, "Plataforma": Plataforma})
	log_request.request("http://142.93.201.7:3000/Log", headers, false, HTTPClient.METHOD_POST, query)

func _LogRequest_request_completed(_result, response_code, _headers, body) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		log_result = {"result": true, "value": json.result['IdLog'], "message": ""}
		#LogResult = [true, json.result['IdLog']] ##DEVUELVE EL NUMERO DE ID DEL LOG SERIA BUENO MOSTRARLO POR PANTALLA
	else:
		var msj = "Error %s on database connection" % response_code
		log_result = {"result": false, "value": 0, "message": msj}
		#LogResult = [false, msj] ##DEVUELVE MSJ DE ERROR SERIA BUENO MOSTRARLO POR PANTALLA
	
	emit_signal("done")
