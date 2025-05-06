extends Control

@onready var texture_button = $TextureRect/TextureButton
#@onready var edit_button = $TextureRect/MarginContainer2/HBoxContainer/Traveler1/edit
@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Parties publiques")
@onready var button_privee = filter_menu.get_node("Parties privees")
@onready var start_game_btn = $TextureRect/MarginContainer/start

# Traveler nodes
@onready var connected_players_hbox = $TextureRect/MarginContainer2/HBoxContainer
@onready var traveler2 = $TextureRect/MarginContainer2/HBoxContainer/Traveler2
@onready var traveler3 = $TextureRect/MarginContainer2/HBoxContainer/Traveler3
@onready var traveler4 = $TextureRect/MarginContainer2/HBoxContainer/Traveler4
@onready var traveler5 = $TextureRect/MarginContainer2/HBoxContainer/Traveler5
@onready var traveler6 = $TextureRect/MarginContainer2/HBoxContainer/Traveler6
@onready var traveler7 = $TextureRect/MarginContainer2/HBoxContainer/Traveler7

#invite buttom
@onready var invite2_5 = $TextureRect/MarginContainer2/HBoxContainer/Traveler5/invite2
@onready var invite3_6 = $TextureRect/MarginContainer2/HBoxContainer/Traveler6/invite3
@onready var invite4_7 = $TextureRect/MarginContainer2/HBoxContainer/Traveler7/invite4

# popup
@onready var margin_container = $TextureRect/MarginContainer
@onready var inviter_button = $TextureRect/MarginContainer/Panel/Partie_1/Inviter

@onready var overlay_mask = $TextureRect/OverlayMask

var is_expanded := false

var players: Array = []

func _ready():
	
	filter_menu.visible = false
	filter_button.text = "  FILTRER         ▼"
	
	# Set signals
	filter_button.connect("pressed", _on_menu_button_pressed)
	button_publique.connect("pressed", _on_parties_publiques_pressed)
	button_privee.connect("pressed", _on_parties_publiques_pressed)
	#edit_button.connect("pressed",_on_edit_pressed)
	start_game_btn.pressed.connect(_on_start_game_btn_pressed)
	WebSocketClient.message_received.connect(_on_websocket_message_received)
	
	# initial Traveler5/6/7 non visible
	traveler5.visible = false
	traveler6.visible = false
	traveler7.visible = false

	# 连接新 invite 按钮
	invite2_5.connect("pressed", _on_invite_2_pressed)
	invite3_6.connect("pressed", _on_invite_3_pressed)
	invite4_7.connect("pressed", _on_invite_4_pressed)

	overlay_mask.connect("gui_input", _on_overlay_mask_input)
	overlay_mask.visible = false
	
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


func _on_menu_button_pressed() -> void:
	is_expanded = !is_expanded
	filter_menu.visible = is_expanded
	filter_button.text = "  FILTRER         ▲" if is_expanded else "  FILTRER         ▼"



func _on_parties_publiques_pressed() -> void:
	pass # Replace with function body.


func _on_parties_privees_pressed() -> void:
	pass # Replace with function body.


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

func _on_cancel_2_pressed() -> void:
	traveler2.visible = false
	traveler5.visible = true


func _on_cancel_3_pressed() -> void:
	traveler3.visible = false
	traveler6.visible = true

func _on_cancel_4_pressed() -> void:
	traveler4.visible = false
	traveler7.visible = true


func _on_inviter_pressed() -> void:
	margin_container.visible = false
	# recover Traveler2, Traveler3, Traveler4
	traveler2.visible = true
	traveler3.visible = true
	traveler4.visible = true
	traveler5.visible = false
	traveler6.visible = false
	traveler7.visible = false

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

func _on_start_game_btn_pressed() -> void:
	var msg = {"action": "start_game", "user_id": int(UserData.user_id)}
	WebSocketClient.send_message(JSON.stringify(msg))
