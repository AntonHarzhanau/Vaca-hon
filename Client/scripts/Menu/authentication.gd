extends Control

@onready var message: Label = $ColorRect/Label
@onready var login: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Login
@onready var password: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Password

signal change_to_login

func _ready() -> void:
	login.text = UserData.user_name
	password.text = UserData.password

func _on_login_pressed() -> void:
	var payload = {
		# "username" or "login"
		"email": login.text,
		"username": login.text,  
		"password": password.text
	}

	print(HttpRequestClient._base_url)
	var response = await HttpRequestClient.__post("/Users/login", payload)

	if response.response_code == 200:
		var user = response.body
		print(user) 
		UserData.token = str(response.body["token"]) if response.body.has("token") else ""
		UserData.user_id = int(response.body["id"])
		UserData.user_name = response.body["username"]
		UserData.save_user_data()
		message.text = "Login successful:"
		#var url = "ws://127.0.0.1:8000/ws/login/" + UserData.user_id
		#WebSocketClient.connect_to_server(url)
	else:
		message.text = "Incorrect login or password"
		print(response.body)



func _on_register_pressed() -> void:
	emit_signal("change_to_login")
