extends Control

@onready var tokens_grid_container: GridContainer = $ScrollContainer/GridContainer
@onready var current_selected_token: RichTextLabel = $SelectedToken
@onready var current_selected_token_texturerect: TextureRect = $SelectedTokenTextureRect
@onready var validate_selection_btn: Button = $ValidateSelectionButton
@onready var back_btn: Button = $GameTopBar/BackButton

@export var lobby_id: String = "Unknown"
@export var players: Array = []
@export var player_id: int
@export var available_tokens: Array = []

func _ready() -> void:
	# Get available tokens from server
	_get_availables_tokens_from_server()
	
	# Set signals handlers
	validate_selection_btn.pressed.connect(_on_validate_selection_pressed)
	back_btn.pressed.connect(_on_back_btn_pressed)
	WebSocketClient.message_received.connect(_on_websocket_message_received)
	
	# Populate Token List with available tokens from server
	_refresh_token_list()

func _on_token_item_pressed(token) -> void:
	"""
	Set current selected token based on player selection
	"""
	current_selected_token.text = token
	current_selected_token_texturerect.texture = load("res://assets/Players/" + token + ".png")

func _on_validate_selection_pressed() -> void:
	"""
	Validate token selection to server and Redirect to the lobby waiting room
	"""
	# Send WebSocket "select_token" message to server to book the selected token
	var message = {"action": "select_token", "selected_token": current_selected_token.text}
	WebSocketClient.send_message(JSON.stringify(message))
	
func _on_websocket_message_received(data) -> void:	
	if ["get_available_tokens", "token_selected"].has(data.action) :
		# Update tokens list from server response
		self.available_tokens = data.available_tokens
		
		if data.action == "token_selected" and self.player_id == int(data.player_id) :
			self.players = data.players
			print("SERVER")
			print(data)
			_go_to_lobby_waiting_room()
			
		_refresh_token_list()
		
	if ["player_connected", "player_disconnected"].has(data.action) :
		self.players = data.players
		# Get available tokens from server
		_get_availables_tokens_from_server()

func _go_to_lobby_waiting_room():
	"""
	Redirect or update current scene to Lobby Waiting List
	"""
	var waiting_room_scene = preload("res://scenes/Menu/lobby_waiting_room.tscn").instantiate();
	waiting_room_scene.lobby_id = self.lobby_id
	waiting_room_scene.players = self.players
	get_tree().get_root().add_child(waiting_room_scene)
	
func _get_availables_tokens_from_server():
	# Send WebSocket "get_available_tokens" message to server to get updated on available tokens
	var message = {"action": "get_available_tokens"}
	WebSocketClient.send_message(JSON.stringify(message))

func _refresh_token_list() -> void:
	# Remove all old children
	var current_tokens = tokens_grid_container.get_children()
	for token in current_tokens:
		token.queue_free()
	
	# Renew the list
	for new_token in available_tokens:
		var token_item_btn = preload("res://scenes/Menu/token_item_button.tscn").instantiate();
		token_item_btn.name = new_token
		token_item_btn.token_texture = load("res://assets/Players/" + new_token + ".png")
		token_item_btn.pressed.connect(_on_token_item_pressed.bind(new_token))
		tokens_grid_container.add_child(token_item_btn)

func _on_back_btn_pressed() -> void:
	# Close WebSocket connection and Get back to the lobby_list scene 
	WebSocketClient.close_connection()
	get_parent().remove_child(self)
