extends Control

# Define constants for the four corners (used for rounded corners)
const SIDE_TOP_LEFT = 0
const SIDE_TOP_RIGHT = 1
const SIDE_BOTTOM_RIGHT = 2
const SIDE_BOTTOM_LEFT = 3

# Load scene nodes
@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Parties publiques")
@onready var button_privee = filter_menu.get_node("Parties privees")
@onready var lobbies_grid_container = $TextureRect/MarginContainer/Panel/MarginContainer/ScrollContainer/GridContainer
@onready var create_lobby_button = $TextureRect/CreateLobby
@onready var texture_button = $TextureRect/TextureButton

## Store the state of buttons
var is_expanded := false
var selected_button: Button = null
var default_style: StyleBoxFlat = null

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
	filter_button.text = "  FILTRER         ▼"

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
	filter_button.text = "  FILTRER         ▲" if is_expanded else "  FILTRER         ▼"

func _on_publique_pressed():
	_select_button(button_publique)
	print("Filter：Parties publiques")

func _on_privee_pressed():
	_select_button(button_privee)
	print("Filter：Parties privées")

func _select_button(button: Button):
	# Reset the previously selected button style
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
	print("Attempting to load scene: res://scenes/Menu/home.tscn")
	var scene = preload("res://scenes/Menu/home.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")  # 切换到主菜单场景
	else:
		print("Failed to load scene.")

func _fetch_lobbies():
	# Get Lobbies from Server
	var response = await HttpRequestClient.__get("/lobbies")
	
	if response.result != OK:
		push_error("An error occurred in the HTTP request.")
		print("Error occured when retrieving lobbies from server")
	else:
		for lobby in lobbies_grid_container.get_children():
			lobby.queue_free()
		lobbies = response.body
		for lobby in lobbies:
			var nb_players = lobby.players.size()
			var nb_player_max = lobby.nb_player_max
			
			var new_lobby = lobby_item_scene.instantiate()
			new_lobby.get_node("LobbyName").text = "Partie N°" + str(int(lobby.id))
			#new_lobby.get_node("PanelContainer/MarginContainer/HBoxContainer/LobbyPrivacy").text = "🔓 Public" if lobby.is_private == false else "🔒 Privé"
			new_lobby.get_node("LobbyPlayers").text = "Joueurs: " + str(int(nb_players))+'/'+ str(int(nb_player_max))
			var join_button:Button = new_lobby.get_node("JoinLobby")
			join_button.pressed.connect(_on_join_pressed.bind(lobby))
			lobbies_grid_container.add_child(new_lobby)
			if nb_players >= nb_player_max:
				join_button.disabled = true

func _on_websocket_message_received(data):
	if ["get_available_tokens"].has(data.action):
		# Get available tokens for Token Selection Scene
		var message = {"action": "get_available_tokens"}
		var lobby_token_selection = preload("res://scenes/Menu/lobby_token_selection.tscn").instantiate();
		lobby_token_selection.lobby_id = str(States.lobby_id)
		lobby_token_selection.player_id = int(UserData.user_id)
		lobby_token_selection.available_tokens = data.available_tokens
		get_tree().get_root().add_child(lobby_token_selection)

func _on_join_pressed(lobby):
	States.lobby_id = int(lobby.id)
	#States.set_url(States.lobby_id, UserData.user_id)
	print("Joining lobby: ", lobby)
	WebSocketClient.connect_to_server(States.WS_BASE_URL+ "/" +str(States.lobby_id)+"?user_id="+str(UserData.user_id))

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
