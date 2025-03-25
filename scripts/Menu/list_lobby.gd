extends Control

@onready var lobby_list_panel = $LobbyListPanel
@onready var back_to_home_btn: Button = $BackToHome
@onready var http_client: HTTPRequestClient

var lobbies = []

func _ready():
	# Setup signals
	back_to_home_btn.pressed.connect(_on_back_to_home_pressed)
	
	# Get Lobbies from Server
	http_client = HTTPRequestClient.new("http://127.0.0.1:8000")	
	add_child(http_client)
	var response = await http_client.__get("/lobbies")
	if response.result != OK:
		push_error("An error occurred in the HTTP request.")
		print("Error occured when retrieving lobbies from server")
	else:
		lobbies = response.body
	
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

func _on_join_pressed(lobby_name):
	print("Joining lobby: ", lobby_name)

func _on_back_to_home_pressed():
	get_tree().change_scene_to_file("res://scenes/Menu/main_menu.tscn")
