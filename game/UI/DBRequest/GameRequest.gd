extends Node

signal done

onready var GameRequest = get_node("GameRequest")
onready var GameResult

func _ready():
	GameRequest.connect("request_completed", self, "_GameRequest_request_completed")
	
func SetGame(Nickname :String, NumRoom :String, Version :String, IdLevel :String, Tiempo :String, Muertes :String, Completo :String):
	var headers = ["Content-Type: application/json"]
	var query = JSON.print({"Nickname": Nickname, "NumRoom": NumRoom, "Version": Version, "IdLevel": IdLevel, "Tiempo": Tiempo, "Muertes": Muertes, "Completo": Completo})
	GameRequest.request("http://142.93.201.7:3000/bug",headers,false,HTTPClient.METHOD_POST,query)

func _GameRequest_request_completed(_result, response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	if response_code == 200:
		GameResult = json.result['IdGame'] ##DEVUELVE EL NUMERO DE ID DEL GAME
	else:
		var msj = "Error %s on database connection" % response_code
		GameResult = msj ##DEVUELVE MSJ DE ERROR SERIA BUENO MOSTRARLO POR PANTALLA
	emit_signal("done")

### PARA IMPLEMENTAR HAY AGREGAR EL NODO

### En el script agregarlo
## onready var BDRequest := $GameRequest

### Para usarlo 
## BDRquest.SetGame(Nickname, NumRoom, Version, IdLevel, Tiempo, Muertes, Completo)
## yield(BDRquest,"done")
## var result = BDRquest.GetBugTypesResult
