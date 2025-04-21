extends Control

@onready var lobby_list_panel = $LobbyListPanel
@onready var vbox = $ScrollContainer/VBoxContainer
@onready var refresh_btn = $RefreshButton
@onready var back_to_home_btn: Button = $BackToHome

# Load the lobby item scene
var lobby_item_scene = preload("res://scenes/Menu/list_lobby_item.tscn")


var lobbies = []

func _ready():
	# Setup signals
	back_to_home_btn.pressed.connect(_on_back_to_home_pressed)
	refresh_btn.pressed.connect(_on_refresh_btn_pressed)
	
	# Get Lobbies from Server
	_fetch_lobbies()
	
	# Configure Panel to fill its parent
	size_flags_vertical = Control.SIZE_EXPAND_FILL
	size_flags_horizontal = Control.SIZE_EXPAND_FILL

	# Create ScrollContainer
	var scroll = ScrollContainer.new()
	scroll.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.anchor_right = 1.0  # Full width
	scroll.anchor_bottom = 1.0  # Full height

	# Add margins inside the scroll container
	scroll.add_theme_constant_override("margin_left", 10)
	scroll.add_theme_constant_override("margin_right", 10)
	scroll.add_theme_constant_override("margin_top", 10)
	scroll.add_theme_constant_override("margin_bottom", 10)
	
	# Container that will center the content
	var center = CenterContainer.new()
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	scroll.add_child(center)
	
	# Create GridContainer with 2 columns for Content
	var grid = GridContainer.new()
	grid.columns = 2
	grid.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN  # Don't expand
	grid.add_theme_constant_override("h_separation", 96)  # Horizontal spacing
	grid.add_theme_constant_override("v_separation", 8)   # Vertical spacing
	center.add_child(grid)

	for lobby in lobbies:
		# Lobby label - fixed width
		var label = Label.new()
		label.text = "Lobby N° " + str(int(lobby["id"]))
		label.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		label.add_theme_constant_override("margin_left", 5)
		grid.add_child(label)

		# Join button - fixed width
		var button = Button.new()
		button.text = " Join "
		button.size_flags_horizontal = Control.SIZE_SHRINK_BEGIN
		button.connect("pressed", _on_join_pressed.bind(lobby))
		grid.add_child(button)
	
	lobby_list_panel.add_child(scroll)

func _on_join_pressed(lobby):
	States.lobby_id = int(lobby.id)
	print("Joining lobby: ", lobby)
	get_tree().change_scene_to_file("res://scenes/Menu/lobby_menu.tscn")
	
func _fetch_lobbies():
	# Get Lobbies from Server
	HttpRequestClient.set_base_url(States.HTTP_URL)
	var response = await HttpRequestClient.__get("/lobbies")
	if response.result != OK:
		push_error("An error occurred in the HTTP request.")
		print("Error occured when retrieving lobbies from server")
	else:
		for lobby in vbox.get_children():
			lobby.queue_free()
		lobbies = response.body
		for lobby in lobbies:
			var nb_players = lobby.players.size()
			var nb_player_max = lobby.nb_player_max
			
				
			var new_lobby = lobby_item_scene.instantiate()
			vbox.add_child(new_lobby)
			new_lobby.get_node("PanelContainer/MarginContainer/HBoxContainer/LobbyName").text = "Lobby N°" + str(int(lobby.id))
			new_lobby.get_node("PanelContainer/MarginContainer/HBoxContainer/LobbyPrivacy").text = "🔓 Public" if lobby.is_private == false else "🔒 Privé"
			new_lobby.get_node("PanelContainer/MarginContainer/HBoxContainer/NbPlayers").text = str(int(nb_players))+'/'+ str(int(nb_player_max))
			var join_button:Button = new_lobby.get_node("PanelContainer/MarginContainer/HBoxContainer/JoinLobby")
			join_button.pressed.connect(_on_join_pressed.bind(lobby))
			if nb_players >= nb_player_max:
				join_button.disabled = true

func _on_refresh_btn_pressed():
	_fetch_lobbies()

func _on_back_to_home_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu/main_menu.tscn")
