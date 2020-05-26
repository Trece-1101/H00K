extends Node

signal done

onready var BugRequest = get_node("BugRequest")
onready var BugResult

func _ready():
	BugRequest.connect("request_completed", self, "_BugRequest_request_completed")
	
func SetBug(Nickname :String, NumRoom :String, Version :String, IdLevel :String, IdLog :String, IdTipoBug :String, Descripcion :String):
	var headers = ["Content-Type: application/json"]
	var query = JSON.print({"Nickname": Nickname, "NumRoom": NumRoom, "Version": Version, "IdLevel": IdLevel, "IdLog": IdLog, "IdTipoBug": IdTipoBug, "Descripcion": Descripcion})
	BugRequest.request("http://142.93.201.7:3000/bug",headers,false,HTTPClient.METHOD_POST,query)

func _BugRequest_request_completed(_result, response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		BugResult = [true, json.result['IdBug']] ##DEVUELVE EL NUMERO DE ID BUG SERIA BUENO MOSTRARLO POR PANTALLA
	else:
		var msj = "Error %s on database connection" % response_code
		BugResult = msj ##DEVUELVE MSJ DE ERROR SERIA BUENO MOSTRARLO POR PANTALLA
	emit_signal("done")

