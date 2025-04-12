extends Control

@onready var message: Label = $ColorRect/Label
@onready var email: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Email
@onready var password: TextEdit = $ColorRect/MarginContainer/VBoxContainer/Password
@onready var user_name: TextEdit = $ColorRect/MarginContainer/VBoxContainer/UserName


#func _ready() -> void:
	#http_client = HTTPRequestClient.new("http://127.0.0.1:8000")
	#add_child(http_client)

func _on_register_pressed() -> void:
	
	message.text = ""
	
	var payload = {
		"email": email.text,
		"password": password.text,
		"username": user_name.text
	}
	
	var response = await HttpRequestClient.__post("/Users/", payload)
	
	if response.result != OK:
		message.text = "An error has occurred, please try again!"
		print(response.body)
	else:
		message.add_theme_color_override("default_color", "#00994f")
		message.text = "Success!!"
		print(response.body)

		
func _on_login_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/authentication.tscn")
