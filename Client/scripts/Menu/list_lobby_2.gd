extends Control

# Define constants for the four corners (used for rounded corners)
const SIDE_TOP_LEFT = 0
const SIDE_TOP_RIGHT = 1
const SIDE_BOTTOM_RIGHT = 2
const SIDE_BOTTOM_LEFT = 3

# Load scene nodes
@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Public Room")
@onready var button_privee = filter_menu.get_node("Private Room")
@onready var lobbies_grid_container = $TextureRect/MarginContainer3/Panel/MarginContainer/ScrollContainer/GridContainer
@onready var create_lobby_button = $TextureRect/MarginContainer2/VBoxContainer2/CreateLobby
@onready var texture_button = $TextureRect/ColorRect/MarginContainer/HBoxContainer/TextureButton

## Store the state of buttons
var is_expanded := false
var selected_button: Button = null
var default_style: StyleBoxFlat = null
var is_public: bool = true

# New: Added pop-up window and background mask nodes
@onready var rejoindre_popup := $Rejoindre/rejoindre_popup
@onready var rejoindre_popup_lobby_owner := $Rejoindre/rejoindre_popup/Panel/LobbyOwnerUsername
@onready var rejoindre_overlay := $TextureRect/Overlay

# Rejoindre The start and target position of the popup (center of the screen & outside the bottom)
var rejoindre_target_pos := Vector2(256, 201)
var rejoindre_start_pos := Vector2(256, 800)

# Load the lobby item scene
var lobby_item_scene = preload("res://scenes/Menu/list_lobby_item2.tscn")
var lobbies = []

func _ready():
	# Save default style (from the "publiques" button)
	var base_style = button_publique.get("theme_override_styles/normal")
	if base_style:
		default_style = base_style.duplicate()
	
	# Initialize state
	filter_menu.visible = false
	filter_button.text = "  FILTER         ▼"

	# Initialize pop-up window and mask
	rejoindre_popup.visible = false

	# Connect signals
	filter_button.connect("pressed", _on_filter_button_pressed)
	button_publique.connect("pressed", _on_publique_pressed)
	button_privee.connect("pressed", _on_privee_pressed)
	create_lobby_button.connect("pressed", _on_create_lobby_pressed)

	# Get Lobbies from Server
	_fetch_lobbies()
	
	# Listen to WebSocket Message 
	WebSocketClient.message_received.connect(_on_websocket_message_received)
   
func _on_filter_button_pressed():
	is_expanded = !is_expanded
	filter_menu.visible = is_expanded
	filter_button.text = "  FILTER         ▲" if is_expanded else "  FILTER         ▼"
	
func _on_publique_pressed():
	is_public = true
	_select_button(button_publique)
	print("Filter：Public Room")

func _on_privee_pressed():
	is_public = false
	_select_button(button_privee)
	print("Filter：Private Room")

func _select_button(button: Button):
	# Reset the previously selected button style
	_fetch_lobbies()
	if selected_button and selected_button != button:
		if default_style:
			selected_button.set("theme_override_styles/normal", default_style.duplicate())

	# Use hover style as the new normal style
	var hover_style = button.get("theme_override_styles/hover")
	if hover_style:
		button.set("theme_override_styles/normal", hover_style.duplicate())

	selected_button = button

# When the return button is pressed, switch back to the main menu scene
func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/main_menu2.tscn")
	var scene = preload("res://scenes/Menu/main_menu2.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/main_menu2.tscn")
	else:
		print("Failed to load scene.")

func _fetch_lobbies():
	# Get Lobbies from Server
	var response
	if is_public:
		response = await HttpRequestClient.__get("/lobbies?is_active=true&is_private=false")
	else : 
		response = await HttpRequestClient.__get("/lobbies?is_active=true&is_private=true")
	if response.result != OK:
		push_error("An error occurred in the HTTP request.")
		print("Error occured when retrieving lobbies from server")
	else:
		
		for lobby in lobbies_grid_container.get_children():
			lobby.queue_free()
			
		lobbies = response.body
		print(lobbies)
		for lobby in lobbies:
			var nb_players = lobby.players.size()
			var nb_player_max = lobby.nb_player_max
			
			var new_lobby = lobby_item_scene.instantiate()
			new_lobby.get_node("LobbyName").text = "Game of " + lobby.owner_name
			if lobby["is_private"]:
				new_lobby.lobby_theme = "Private"
			else:
				new_lobby.lobby_theme = "Public"
			new_lobby.get_node("LobbyPlayers").text = "Players: " + str(int(nb_players))+'/'+ str(int(nb_player_max))
			var join_button:Button = new_lobby.get_node("JoinLobby")
			join_button.pressed.connect(_on_join_pressed.bind(lobby))
			lobbies_grid_container.add_child(new_lobby)
			if nb_players >= nb_player_max:
				join_button.disabled = true

func _on_websocket_message_received(data):
	if ["get_available_tokens"].has(data.action):
		States.available_tokens = data.available_tokens
		get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")


func _on_join_pressed(lobby):
	States.lobby_id = int(lobby.id)
	States.lobby_max_players = int(lobby.nb_player_max)
	States.lobby_owner_id = int(lobby.owner_id)
	rejoindre_popup_lobby_owner.text = lobby.owner_name
	_show_rejoindre_popup()

func _on_refresh_btn_pressed():
	_fetch_lobbies()

func _on_create_lobby_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/create_lobby2.tscn")
	var scene = load("res://scenes/Menu/create_lobby2.tscn") 
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/create_lobby2.tscn")
	else:
		print("Failed to load scene.")

# Public function: Pop up the Rejoindre pop-up window (with animation)
func _show_rejoindre_popup():
	rejoindre_popup.visible = true
	$Rejoindre.visible = true

# Public function: Close the Rejoindre pop-up window (with animation)
func _hide_rejoindre_popup():
	rejoindre_popup.visible = false

# NON button in the pop-up window: close the pop-up window
func _on_non_pressed() -> void:
	_hide_rejoindre_popup()

# OUI button in the pop-up window: jump to select role select_token.tscn
func _on_oui_pressed() -> void:
	print("Joining lobby: ", States.lobby_id)
	get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")
