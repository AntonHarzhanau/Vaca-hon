extends Control

@onready var message: Label = $ColorRect/Label
@onready var login: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Login
@onready var password: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Password

func _on_register_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/registration.tscn")

func _on_login_pressed() -> void:
	var payload = {
		# "username" or "login"
		"email": login.text,
		"username": login.text,  
		"password": password.text
	}

	var response = await HttpRequestClient.__post("/Users/login", payload)

	if response.response_code == 200:
		var user = response.body
		message.text = "Login successful:"
		print(user)
	else:
		message.text = "Incorrect login or password"
		print(response.body)
