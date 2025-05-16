extends Control

@onready var start_game_btn = $VBoxContainer/start

# popup
@onready var margin_container: MarginContainer = $VBoxContainer/MarginContainer
@onready var players_container: HBoxContainer = $VBoxContainer/MarginContainer/PlayersContainer
@onready var token_container: HBoxContainer = $VBoxContainer/Tokencontainer
var is_expanded := false

func _ready():
	var is_connected = WebSocketClient.connect_to_server(States.WS_BASE_URL+ "/" +str(States.lobby_id)+"?user_id="+str(UserData.user_id))
	print(is_connected)
	if !is_connected:
		print("websocket connection error")
		get_tree().change_scene_to_file("res://scenes/Menu/main_menu2.tscn")
	WebSocketClient.message_received.connect(_on_websocket_message_received)
	
	for child in token_container.get_children():
		child.toggled.connect(_on_token_select.bind(child))
			
	await get_tree().create_timer(0.3).timeout
	var msg = {"action": "user_joined", "user_id": int(UserData.user_id)}
	WebSocketClient.send_message(JSON.stringify(msg))
	
	# Hide start game button if not owner
	print("Current UserData : " + str(UserData.user_id))
	print("Lobby Owner : " + str(States.lobby_owner_id))
	if States.lobby_owner_id != UserData.user_id:
		start_game_btn.visible = false

func _on_websocket_message_received(data) -> void:
	print(data)
	var action = data.get("action", "Error")
	match action:
		"user_joined":
			var user = User.new()
			user.user_name = data["user_name"]
			user.user_color = data["user_color"]
			States.users[int(data["user_id"])] = user
			user_join(user)
			if data["user_token"]:
				user.user_token = data["user_token"]
				join_token(int(data["user_id"]), user.user_token)
		"user_left":
			var uid =  int(data["user_id"])
			user_left(uid)
		
		"token_selected":
			join_token(data["user_id"], data["token"])
		"get_available_tokens":
			refresh_token(data["available_tokens"])
		"game_started": 
			States.id_player_at_turn = int(data.get("current_turn_player_id", -1))
			get_tree().change_scene_to_file("res://scenes/game.tscn")
		"Error": 
			print(data)

func _on_token_select(pressed: bool, button) -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	if pressed:
		var msg = {"action": "select_token", "user_id": int(UserData.user_id), "token":button.name}
		WebSocketClient.send_message(JSON.stringify(msg))

func user_join(user:User) -> void:
	if user:
		var new_waiting_room_player = preload("res://scenes/Menu/waiting_room_player_2.tscn").instantiate();
		new_waiting_room_player.player_name = user.user_name
		new_waiting_room_player.player_color = user.user_color
		new_waiting_room_player.player_token = user.user_token
		players_container.add_child(new_waiting_room_player)

func user_left(user_id:int):
	var user: User = States.users[user_id] 
	for i in players_container.get_children():
		if user.user_name == i.player_name:
			i.queue_free()
		States.users.erase(user_id)

func join_token(user_id:int, token: String):
	var user = States.users[user_id]
	var texture = load("res://assets/Token/"+token+".png")
	for i in players_container.get_children():
		if i.player_name == user.user_name:
			i.player_token_sprite.texture = texture

func refresh_token(tokens):
	for i in token_container.get_children():
		if i.name in tokens:
			i.visible = true
		else :
			i.visible = false

func _on_start_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	var msg = {"action": "start_game", "user_id": int(UserData.user_id)}
	WebSocketClient.send_message(JSON.stringify(msg))


func _on_back_button_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	print("Attempting to load scene: res://scenes/Menu/home.tscn")
	WebSocketClient.close_connection()
	get_tree().change_scene_to_file("res://scenes/Menu/create_lobby2.tscn")  # Switch to main menu
