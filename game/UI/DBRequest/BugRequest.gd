extends Node

signal done

onready var bug_request = get_node("BugRequest")
onready var bug_result

func get_bug_result():
	return bug_result

func _ready() -> void:
	bug_request.connect("request_completed", self, "_BugRequest_request_completed")

func SetBug(
	nickname: String, 
	room: int, 
	version: int, 
	level: int, 
	id_log: int, 
	type_bug: int, 
	description: String
	) -> void:
		var headers = ["Content-Type: application/json"]
		var query = JSON.print({"Nickname": nickname, 
			"NumRoom": room, 
			"Version": version, 
			"IdLevel": level, 
			"IdLog": id_log, 
			"IdTipoBug": type_bug, 
			"Descripcion": description}
			)
		bug_request.request("http://142.93.201.7:3000/bug", headers, false, HTTPClient.METHOD_POST, query)

func _BugRequest_request_completed(_result, response_code, _headers, body) -> void:
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		bug_result = {"response": true, "id_bug": json.result['IdBug'], "message": ""}
	else:
		var msj = "Error %s on database connection" % response_code
		bug_result = {"response": false, "id_bug": 0, "message": msj}
	
	emit_signal("done")

