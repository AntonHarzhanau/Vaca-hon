extends Control
@onready var max_players_spinbox: SpinBox = $FormPanel/MaxPlayers/MaxPlayersSpinBox
@onready var lobby_duration_spinbox: SpinBox = $FormPanel/LobbyDuration/LobbyDurationSpinBox
@onready var is_private_checkbutton: CheckButton = $FormPanel/LobbyIsPrivate/IsPrivateCheckButton
@onready var lobby_private_secret_group : Control = $FormPanel/LobbyPrivateSecret
@onready var lobby_private_secret_lineedit: LineEdit = $FormPanel/LobbyPrivateSecret/LobbyPrivateSecretLineEdit
@onready var create_lobby_btn: Button = $FormPanel/CreateButton
@onready var http_request = HTTPRequest

func _ready() -> void:
	is_private_checkbutton.toggled.connect(_on_lobby_is_private_toggled)
	create_lobby_btn.pressed.connect(_on_create_lobby_pressed)
	
	# Create an HTTP request node and connect its completion signal.
	http_request = HTTPRequest.new()
	add_child(http_request)
	http_request.request_completed.connect(_http_request_completed)
	
func _on_lobby_is_private_toggled(toggled_on: bool) -> void:
	lobby_private_secret_group.visible = toggled_on
	
func _on_create_lobby_pressed():
	var nb_player_max = max_players_spinbox.get_line_edit().text
	var time_sec = int(lobby_duration_spinbox.get_line_edit().text) * 60
	var is_private = is_private_checkbutton.button_pressed
	var secret = lobby_private_secret_lineedit.text if is_private else ""
	
	var payload = {
		"nb_player_max": nb_player_max,
		"time_sec": time_sec,
		"is_private": is_private,
		"secret": secret
	}
	print("CREATE LOBBY : Payload Sent =>")
	print(payload)
	var body = JSON.new().stringify(payload)
	var error = http_request.request("http://127.0.0.1:8000/lobbies", [], HTTPClient.METHOD_POST, body)
	if error != OK:
		push_error("An error occurred in the HTTP request.")
	
func _http_request_completed(result, response_code, headers, body):
	var json = JSON.new()
	json.parse(body.get_string_from_utf8())
	var response = json.get_data()
	print(response)
