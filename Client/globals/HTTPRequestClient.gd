extends Node

var _base_url: String = "http://127.0.0.1:8000"
@onready var http_request: HTTPRequest = HTTPRequest.new()

func _ready() -> void:
	add_child(http_request)

func set_base_url(url: String) -> void:
	_base_url = url

func __post(uri_path: String, payload: Dictionary) -> Dictionary:
	print(_base_url)
	var body = JSON.stringify(payload)  # <-- String, не PackedByteArray
	var headers = ["Content-Type: application/json"]
	var url = _base_url + uri_path

	http_request.request(url, headers, HTTPClient.METHOD_POST, body)
	var result = await http_request.request_completed
	return _parse_response(result)


func __get(uri_path: String, payload: Dictionary = {}) -> Dictionary:
	print(_base_url)
	var body = JSON.stringify(payload)  # <-- String
	var headers = ["Content-Type: application/json"]
	var url = _base_url + uri_path

	http_request.request(url, headers, HTTPClient.METHOD_GET, body)
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
