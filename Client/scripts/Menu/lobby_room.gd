extends Control

@onready var texture_button = $ColorRect/MarginContainer/TextureButton
@onready var start_game_btn = $MarginContainer/start

# Traveler nodes
@onready var connected_players_hbox = $MarginContainer2/HBoxContainer
@onready var traveler2 = $MarginContainer2/HBoxContainer/Traveler2
@onready var traveler3 = $MarginContainer2/HBoxContainer/Traveler3
@onready var traveler4 = $MarginContainer2/HBoxContainer/Traveler4

# popup
@onready var margin_container = $MarginContainer
@onready var inviter_button = $MarginContainer/Panel/Partie_1/Inviter

@onready var overlay_mask = $OverlayMask

var is_expanded := false

var players: Array = []

func _ready():
	
	#edit_button.connect("pressed",_on_edit_pressed)
	WebSocketClient.message_received.connect(_on_websocket_message_received)
	
	# Hide start game button if not owner
	print("Current UserData : " + str(UserData.user_id))
	print("Lobby Owner : " + str(States.lobby_owner_id))
	if States.lobby_owner_id != UserData.user_id:
		start_game_btn.visible = false

	# Setting up initial player list
	players = States.users
	_refresh_player_list()
	
func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/home.tscn")
	var scene = load("res://scenes/Menu/home.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")  # Switch to main menu
	else:
		print("Failed to load scene.")


func _on_edit_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/select_token.tscn")
	var scene = load("res://scenes/Menu/select_token.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")  # Switch to main menu
	else:
		print("Failed to load scene.")


func _on_invite_2_pressed() -> void:
	margin_container.visible = true
	overlay_mask.visible = true

func _on_invite_3_pressed() -> void:
	margin_container.visible = true
	overlay_mask.visible = true

func _on_invite_4_pressed() -> void:
	margin_container.visible = true
	overlay_mask.visible = true
	
	
func _on_overlay_mask_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		margin_container.visible = false
		overlay_mask.visible = false

func _on_inviter_pressed() -> void:
	margin_container.visible = false
	# recover Traveler2, Traveler3, Traveler4
	traveler2.visible = true
	traveler3.visible = true
	traveler4.visible = true

func _on_websocket_message_received(data) -> void:		
	var action = data.get("action", "Error")
	match action:
		"user_joined", "user_left":
			self.players = data.players
			_refresh_player_list()
		"game_started": 
			States.id_player_at_turn = int(data.get("current_turn_player_id", -1))
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		"Error": 
			print(data)
		
func _refresh_player_list() -> void:
	# Remove all old children
	var current_players = connected_players_hbox.get_children()
	for player in current_players:
		player.queue_free()
	
	# Renew the list
	for i in range(States.lobby_max_players):
		if i < len(players) and players[i]:
			print(players)
			# For active players, show the waiting players scene
			var new_waiting_room_player = preload("res://scenes/Menu/waiting_room_player_2.tscn").instantiate();
			new_waiting_room_player.player_name = players[i].username
			new_waiting_room_player.player_token = load("res://assets/Token/" + players[i].selected_token + ".png")
			new_waiting_room_player.player_color = players[i].player_color
			connected_players_hbox.add_child(new_waiting_room_player)
		else:
			# For remaining place, show the placeholder/invite scene
			var new_waiting_room_placeholder = preload("res://scenes/Menu/waiting_room_placeholder.tscn").instantiate();
			connected_players_hbox.add_child(new_waiting_room_placeholder)


func _on_start_pressed() -> void:
	var msg = {"action": "start_game", "user_id": int(UserData.user_id)}
	WebSocketClient.send_message(JSON.stringify(msg))
