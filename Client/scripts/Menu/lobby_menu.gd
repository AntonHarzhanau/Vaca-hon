extends Control
const USER_PANEL = preload("res://scenes/Menu/user.tscn")
@onready var guests_container: VBoxContainer = $BackGround/GeustsContainer
@onready var lobby_id: Label = $BackGround/LobbyId
@onready var test: Label = $BackGround/TestMessage

var close_manualy:bool = false

func _ready() -> void:
	States.set_url(States.lobby_id,UserData.user_id)
	#var url = "ws://127.0.0.1:8000/ws/join/%s?user_id=%s" % [States.lobby_id, UserData.user_id]

	WebSocketClient.connect_to_server(States.URL)
	WebSocketClient.message_received.connect(_on_message_received)
	WebSocketClient.connection_closed.connect(_on_connection_closed)
	lobby_id.text = "Lobby_id: " + str(States.lobby_id)
	await get_tree().create_timer(0.3).timeout 
	var msg = {"action": "user_joined", "user_id": int(UserData.user_id)}
	WebSocketClient.send_message(JSON.stringify(msg))
	await get_tree().create_timer(0.1).timeout 
	
func _on_message_received(message: Variant):
	var action = message["action"]
	test.text = str(message)
	print("In lobby\n" + str(message))
	match action:
		"user_joined": join_user(message["user_id"], message["user_name"])
		"user_left": user_left(message["user_id"])
		"game_started": get_tree().change_scene_to_file("res://scenes/game.tscn")

func _on_start_game_pressed() -> void:
	var msg = {"action": "start_game", "user_id": int(UserData.user_id)}
	WebSocketClient.send_message(JSON.stringify(msg))

func join_user(user_id:int, user_name:String):
	var user = USER_PANEL.instantiate()
	user.set_user(user_id, user_name)
	guests_container.add_child(user)
	
func user_left(uid:int):
	for user in guests_container.get_children():
		if user.uid == uid:
			user.queue_free()

func _on_close_pressed() -> void:
	close_manualy = true
	WebSocketClient.close_connection()
	get_tree().change_scene_to_file("res://scenes/Menu/main_menu.tscn")
	
func _on_connection_closed():
	if not close_manualy:
		get_tree().change_scene_to_file("res://scenes/Menu/list_lobby.tscn")
