extends Control
@onready var max_players_spinbox: SpinBox = $FormPanel/MaxPlayers/MaxPlayersSpinBox
@onready var lobby_duration_spinbox: SpinBox = $FormPanel/LobbyDuration/LobbyDurationSpinBox
@onready var is_private_checkbutton: CheckButton = $FormPanel/LobbyIsPrivate/IsPrivateCheckButton
@onready var lobby_private_secret_group : Control = $FormPanel/LobbyPrivateSecret
@onready var lobby_private_secret_lineedit: LineEdit = $FormPanel/LobbyPrivateSecret/LobbyPrivateSecretLineEdit
@onready var create_lobby_btn: Button = $FormPanel/CreateButton
@onready var message_feedback_label: RichTextLabel = $FormPanel/MessageFeedback
@onready var back_to_home_btn: Button = $BackToHome

func _ready() -> void:
	is_private_checkbutton.toggled.connect(_on_lobby_is_private_toggled)
	create_lobby_btn.pressed.connect(_on_create_lobby_pressed)
	back_to_home_btn.pressed.connect(_on_back_to_home_pressed)
	$ColorRect/IP.text = States.URL
	#Create an HTTPRequestClient node and add it to the tree
	
func _on_lobby_is_private_toggled(toggled_on: bool) -> void:
	lobby_private_secret_group.visible = toggled_on
	
func _on_create_lobby_pressed():
	message_feedback_label.text = ""
	var nb_player_max = max_players_spinbox.get_line_edit().text
	var time_sec = int(lobby_duration_spinbox.get_line_edit().text) * 60
	var is_private = is_private_checkbutton.button_pressed
	var secret = lobby_private_secret_lineedit.text if is_private else ""
	
	var payload = {
		"owner_id": int(UserData.user_id),
		"nb_player_max": nb_player_max,
		"time_sec": time_sec,
		"is_private": is_private,
		"secret": secret
	}
	HttpRequestClient.set_base_url(States.HTTP_URL)
	
	var response = await HttpRequestClient.__post("/lobbies/", payload)
	
	if response.result != OK:
		push_error("An error occurred in the HTTP request.")
		message_feedback_label.add_theme_color_override("default_color", "#ff2334")
		message_feedback_label.text = "An error has occurred, please try again.!"
	else:
		message_feedback_label.add_theme_color_override("default_color", "#00994f")
		message_feedback_label.text = "New Lobby created!"
		print(response.body)
		States.lobby_id = int(response.body["id"])
		get_tree().change_scene_to_file("res://scenes/Menu/lobby_menu.tscn")
	
	
func _on_back_to_home_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu/main_menu.tscn")
