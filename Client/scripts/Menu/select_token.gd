extends Control

@onready var quitter_partie = $TextureRect/quitter_partie
@onready var return_button = $TextureRect/ColorRect/TextureButton
@onready var texture_rect := $TextureRect
@onready var overlay := $TextureRect/Overlay
@onready var validate_selection_btn = $TextureRect/ValidateSelectionButton

# Small Token nodes
@onready var button_flight = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/flight
@onready var button_ship = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/ship
@onready var button_car = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/car
@onready var button_helicopter = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer/helicopter
@onready var token_buttons_group = $TextureRect/ScrollContainer/CenterContainer/HBoxContainer.get_children()

# Large image nodes
@onready var img_flight = $TextureRect/flight
@onready var img_ship = $TextureRect/ship
@onready var img_car = $TextureRect/car
@onready var img_helicopter = $TextureRect/helicopter

# Currently selected button
var selected_button: BaseButton = null
var available_tokens: Array = []
var player_id: int

var popup_target_pos := Vector2(256, 201)
var popup_start_pos := Vector2(256, 800)

func _ready():
	quitter_partie.visible = false
	overlay.visible = false
	overlay.mouse_filter = Control.MOUSE_FILTER_IGNORE  

	# Connect all buttons
	button_flight.connect("pressed", _on_flight_pressed)
	button_ship.connect("pressed", _on_ship_pressed)
	button_car.connect("pressed", _on_car_pressed)
	button_helicopter.connect("pressed", _on_helicopter_pressed)
	validate_selection_btn.connect("pressed", _on_validate_selection_button_pressed)
	
	WebSocketClient.message_received.connect(_on_websocket_message_received)
	player_id = int(UserData.user_id)
	available_tokens = States.available_tokens
	
	# Populate Token List with available tokens from server
	_refresh_token_list()

func _on_texture_button_pressed() -> void:
	quitter_partie.visible = true
	overlay.visible = true
	quitter_partie.position = popup_start_pos  # 保证初始在屏幕下方

	var tween = create_tween()
	tween.tween_property(quitter_partie, "position", popup_target_pos, 0.4)\
		.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)

func _on_non_pressed() -> void:
	var tween = create_tween()
	tween.tween_property(quitter_partie, "position", popup_start_pos, 0.3)\
		.set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_IN)
	await tween.finished
	quitter_partie.visible = false
	overlay.visible = false

func _on_oui_pressed() -> void:
	var path = "res://scenes/Menu/home.tscn"
	if ResourceLoader.exists(path):
		get_tree().change_scene_to_file(path)

func _on_validate_selection_button_pressed() -> void:
	if selected_button:
		print("Selected Token : " + selected_button.name)
		# Send WebSocket "user_joined" message to server to book the selected token
		var message = {"action": "user_joined", "user_id": UserData.user_id, "selected_token": selected_button.name}
		WebSocketClient.send_message(JSON.stringify(message))
	else:
		print("Show message : You should select a token to continue")

# On token buttons clicked
func _on_flight_pressed():
	_show_selected_token("flight")
	_set_selected_button(button_flight)

func _on_ship_pressed():
	_show_selected_token("ship")
	_set_selected_button(button_ship)

func _on_car_pressed():
	_show_selected_token("car")
	_set_selected_button(button_car)

func _on_helicopter_pressed():
	_show_selected_token("helicopter")
	_set_selected_button(button_helicopter)

# Switch large image display
func _show_selected_token(selected: String) -> void:
	img_flight.visible = (selected == "flight")
	img_ship.visible = (selected == "ship")
	img_car.visible = (selected == "car")
	img_helicopter.visible = (selected == "helicopter")

# Switch selected button style
func _set_selected_button(button: BaseButton) -> void:
	# Reset the previously selected button to normal.
	if selected_button and selected_button != button:
		selected_button.button_pressed = false

	# Set the current button to pressed
	selected_button = button
	selected_button.button_pressed = true

func _refresh_token_list() -> void:	
	# Renew the token list by making invisible unavailable tokens
	for token_button in token_buttons_group:
		if token_button.name in available_tokens:
			token_button.visible = true
		else:
			token_button.visible = false

func _on_websocket_message_received(data) -> void:	
	if ["get_available_tokens", "user_joined"].has(data.action) :
		# Update tokens list from server response
		self.available_tokens = data.available_tokens
		
		if data.action == "user_joined" and self.player_id == int(data.user_id) :
			States.users = data.players
			get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")
			
		_refresh_token_list()
		
	if ["player_connected", "player_disconnected"].has(data.action) :
		States.users = data.players
