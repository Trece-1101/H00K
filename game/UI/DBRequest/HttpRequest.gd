extends CanvasLayer

func _ready():
	$HTTPRequest.connect("request_completed", self, "_on_request_completed")

func _on_Button_pressed():
	$HTTPRequest.request("http://142.93.201.7:3000/users")

func _on_HTTPRequest_request_completed(_result, _response_code, _headers, body):
	var json = JSON.parse(body.get_string_from_utf8())
	print(json.result)
