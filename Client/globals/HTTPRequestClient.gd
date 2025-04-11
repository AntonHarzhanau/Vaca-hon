class_name HTTPRequestClient
extends Node

@onready var http_request: HTTPRequest

var _base_url: String

func _init(url) -> void:
	_base_url = url
	
func _ready() -> void:
	http_request = HTTPRequest.new()
	add_child(http_request)

func __post(uri_path: String, payload: Dictionary) -> Dictionary:
	var request_body = JSON.new().stringify(payload)
	http_request.request(_base_url + uri_path, [], HTTPClient.METHOD_POST, request_body)
	
	var http_response = await http_request.request_completed
	var response_body_raw = JSON.new()
	response_body_raw.parse(http_response[3].get_string_from_utf8())
	var response_body = response_body_raw.get_data()
	
	var response_json = {
		"result": http_response[0],
		"response_code": http_response[1],
		"headers": http_response[2],
		"body": response_body
	}
	
	return response_json
	
func __get(uri_path: String) -> Dictionary:
	http_request.request(_base_url + uri_path)
	
	var http_response = await http_request.request_completed
	var response_body_raw = JSON.new()
	response_body_raw.parse(http_response[3].get_string_from_utf8())
	var response_body = response_body_raw.get_data()
	
	var response_json = {
		"result": http_response[0],
		"response_code": http_response[1],
		"headers": http_response[2],
		"body": response_body
	}
	
	return response_json
