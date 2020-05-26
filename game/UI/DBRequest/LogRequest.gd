extends Node

signal done

onready var LogRequest = get_node("LogRequest")
onready var LogResult

func _ready():
	LogRequest.connect("request_completed", self, "_LogRequest_request_completed")
	
func SetLog(Nickname :String, Plataforma :String):
	var headers = ["Content-Type: application/json"]
	var query = JSON.print({"Nickname": Nickname, "Plataforma": Plataforma})
	LogRequest.request("http://localhost:3000/bug",headers,false,HTTPClient.METHOD_POST,query)

func _LogRequest_request_completed(_result, response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		LogResult = json.result
	else:
		var msj = "Error %s on database connection" % response_code
		LogResult = msj
	emit_signal("done")

### PARA IMPLEMENTAR HAY AGREGAR EL NODO

### En el script agregarlo
## onready var BDRequest := $LogRequest

### Para usarlo 
## BDRquest.SetLog(Nickname, Plataforma)
## yield(BDRquest,"done")
## var result = BDRquest.GetBugTypesResult
