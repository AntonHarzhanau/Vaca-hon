extends Control

@onready var message: RichTextLabel = $TextureRect/Panel/VBoxContainer/FeedbackMessage
@onready var login: LineEdit = $TextureRect/Panel/VBoxContainer/EmailLineEdit
@onready var password: LineEdit = $TextureRect/Panel/VBoxContainer/PasswordLineEdit

func _ready() -> void:
	login.text = UserData.user_name
	password.text = UserData.password

func _on_connecter_pressed() -> void:
	var payload = {
		# "username" or "login"
		"email": login.text,
		"username": login.text,  
		"password": password.text
	}
	
	var response = await HttpRequestClient.__post("/Users/login", payload)

	if response.response_code == 200:
		var user = response.body
		print(user) 
		UserData.token = str(response.body["token"]) if response.body.has("token") else ""
		UserData.user_id = int(response.body["id"])
		UserData.user_name = response.body["username"]
		UserData.save_user_data()
		message.text = "Login successful:"
		var scene = load("res://scenes/Menu/home.tscn")
		if scene:
			get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
	else:
		message.text = "Incorrect login or password"
		print(response.body)
	

func _on_creer_pressed() -> void:
	var scene = load("res://scenes/Menu/Cree_compte.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/Cree_compte.tscn")
