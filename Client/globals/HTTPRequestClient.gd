extends Node

@onready var http_request: HTTPRequest = HTTPRequest.new()

func _ready() -> void:
	add_child(http_request)
	#var tls_options = TLSOptions.client_unsafe()
	#http_request.set_tls_options(tls_options)

func __post(uri_path: String, payload: Dictionary) -> Dictionary:
	var body = JSON.stringify(payload)  # <-- String, не PackedByteArray
	var headers = ["Content-Type: application/json"]
	var url = States.HTTP_BASE_URL + uri_path
	print(HTTPClient.METHOD_POST)
	print(url)

	http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	var result = await http_request.request_completed
	return _parse_response(result)


func __get(uri_path: String) -> Dictionary:
	#var body = JSON.stringify(payload)  # <-- String
	var headers = ["Content-Type: application/json"]
	var url = States.HTTP_BASE_URL + uri_path
	print("Executing GET Request to : " + url)
	http_request.request(url, headers, HTTPClient.METHOD_GET)
	var result = await http_request.request_completed
	return _parse_response(result)

func _parse_response(response: Array) -> Dictionary:
	var json = JSON.new()
	json.parse(response[3].get_string_from_utf8())
	return {
		"result": response[0],
		"response_code": response[1],
		"headers": response[2],
		"body": json.get_data()
	}
	
func http_build_query(params: Dictionary) -> String:
	var parts := []
	for key in params.keys():
		var value = str(params[key]).uri_encode()
		parts.append("%s=%s" % [key, value])
	return "&".join(parts)
