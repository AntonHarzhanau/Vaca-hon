extends Control

# Save button groups
@onready var num_users_btn_group: HBoxContainer = $TextureRect/MarginContainer/Panel/Control/NumPlayerBtnContainer
@onready var time_game_group:HBoxContainer = $TextureRect/MarginContainer/Panel/Control/TimeGameBtnContainer
@onready var private_btn_group: HBoxContainer = $TextureRect/MarginContainer/Panel/Control2/PrivateBtnContainer

# Password-related nodes
@onready var label_mdp = $TextureRect/MarginContainer/Panel/Control2/Password
@onready var lineedit_mdp = $TextureRect/MarginContainer/Panel/Control2/PasswordEdit
@onready var message_mdp = $TextureRect/MarginContainer/Panel/Control2/FeedbackMessage

# Default selected button
var nb_player_max = 2
var time_sec = 30
var is_private = false
var secret = ''

func _ready():
	for child in num_users_btn_group.get_children():
		if child is CheckButton:
			child.toggled.connect(_on_num_player_selected.bind(child))
	
	for child in private_btn_group.get_children():
		if child is CheckButton:
			child.toggled.connect(_on_private_selected.bind(child))
	
	for child in time_game_group.get_children():
		if child is CheckButton:
			child.toggled.connect(_on_time_selected.bind(child))

	# Hide password fields initially
	label_mdp.visible = false
	lineedit_mdp.visible = false

func _on_num_player_selected(pressed: bool, button: CheckButton) -> void:
	if pressed:
		nb_player_max = int(button.text)
		
func _on_private_selected(pressed: bool, button: CheckButton) -> void:
	if pressed:
		if button.text == "Public":
			self.is_private = false
			label_mdp.visible = false
			lineedit_mdp.visible = false
		else:
			self.is_private = true
			label_mdp.visible = true
			lineedit_mdp.visible = true

func _on_time_selected(pressed: bool, button: CheckButton) -> void:
	if pressed:
		time_sec = int(button.text)

func _on_submit_create_lobby_pressed() -> void:
	var payload = {
		"owner_id": int(UserData.user_id),
		"owner_name": UserData.user_name,
		"nb_player_max": nb_player_max,
		"time_sec": time_sec,
		"is_private": is_private,
		"secret": lineedit_mdp.text if is_private else ""
	}

	# Check if Lobby secret is provided if Lobby is private
	if is_private and len(payload["secret"]) == 0:
		message_mdp.text = "Please enter a password for your game"
		return
	
	var response = await HttpRequestClient.__post("/lobbies", payload)
	
	if response.result != OK:
		print("An error occurred in the HTTP request.")
	else:
		print(response.body)
		States.lobby_id = int(response.body["id"])
		States.lobby_max_players = int(response.body["nb_player_max"])
		States.lobby_owner_id = int(response.body["owner_id"])
		get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")


func _on_back_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/main_menu2.tscn")
	var scene = load("res://scenes/Menu/main_menu2.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/main_menu2.tscn")
	else:
		print("Failed to load scene.")
