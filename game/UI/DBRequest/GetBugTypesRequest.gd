extends Node

signal done

onready var GetBugTypesRequest = get_node("GetBugTypesRequest")
onready var GetBugTypesResult

func _ready():
	GetBugTypesRequest.connect("request_completed", self, "_GetBugTypes_request_completed")

func GetBugTypes():
	GetBugTypesRequest.request("http://localhost:3000/bugTypes")

func _GetBugTypes_request_completed(_result, response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		GetBugTypesResult = json.result
	else:
		var msj = "Error %s on database connection" % response_code
		GetBugTypesResult = [response_code, msj]
	emit_signal("done")

