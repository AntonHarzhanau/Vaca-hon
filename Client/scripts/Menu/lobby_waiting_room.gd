extends Control

@onready var lobby_title_label: RichTextLabel = $RichTextLabel
@onready var connected_players_hbox: HBoxContainer = $PanelContainer/MarginContainer/ConnectedPlayersHBox
@onready var start_game_btn: Button = $StartGameButton
@onready var back_btn: Button = $BackButton

@export var lobby_id: String = "Unknown"
@export var players: Array = []

func _ready() -> void:
	# Set signals
	WebSocketClient.message_received.connect(_on_websocket_message_received)
	back_btn.pressed.connect(_on_back_btn_pressed)
	start_game_btn.pressed.connect(_on_start_game_btn_pressed)
	
	# Update views
	lobby_title_label.text = lobby_title_label.text.replacen("{{lobby_id}}", lobby_id)
	_refresh_player_list()

func _on_websocket_message_received(data) -> void:
	if ["player_connected", "player_disconnected"].has(data.action) :
		self.players = data.players
		
		if data.action == "player_disconnected":
			_refresh_player_list()
		
	if ["token_selected"].has(data.action):
		self.players = data.players
		_refresh_player_list()
		
func _refresh_player_list() -> void:
	# Remove all old children
	var current_players = connected_players_hbox.get_children()
	for player in current_players:
		player.queue_free()
	
	# Renew the list
	for new_player in players:
		var new_waiting_room_player = preload("res://scenes/Menu/waiting_room_player.tscn").instantiate();
		new_waiting_room_player.player_name = new_player.name
		new_waiting_room_player.player_token = load("res://assets/Players/" + new_player.selected_token + ".png")
		connected_players_hbox.add_child(new_waiting_room_player)

func _on_back_btn_pressed() -> void:
	# Get back to the token selection scene by remove this waiting scene child
	get_parent().remove_child(self)
	
func _on_start_game_btn_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/game.tscn")
