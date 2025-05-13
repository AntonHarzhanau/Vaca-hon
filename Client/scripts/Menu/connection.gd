extends Control

@onready var message: RichTextLabel = $Panel/VBoxContainer/MarginContainer7/FeedbackMessage
@onready var login: LineEdit = $Panel/VBoxContainer/MarginContainer4/EmailLineEdit
@onready var password: LineEdit = $Panel/VBoxContainer/MarginContainer5/PasswordLineEdit
@onready var checkbox: CheckBox = $Panel/VBoxContainer/MarginContainer6/HBoxContainer/CheckBox

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

	#TODO delete this
	UserData.password = password.text
	UserData.save_user_data()
	
	# Field Validation
	if login.text.is_empty() or password.text.is_empty():
		message.text = "Please enter all required fields."
		return
	
	var response = await HttpRequestClient.__post("/Users/login", payload)

	if response.response_code == 200:
		var user = response.body
		UserData.token = str(response.body["token"]) if response.body.has("token") else ""
		UserData.user_id = int(response.body["user"]["id"])
		UserData.user_name = response.body["user"]["username"]
		if checkbox.button_pressed:
			UserData.email = login.text
			UserData.password = password.text
		else:
			UserData.email = ""
			UserData.password = ""
		UserData.save_user_data()
		message.add_theme_color_override("default_color", "#00994f")
		message.text = "Login successful !"
		var scene = load("res://scenes/Menu/home.tscn")
		if scene:
			get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
	else:
		message.text = "Invalid credentials. Please retry !"
		print(response.body)
	

func _on_creer_pressed() -> void:
	var scene = load("res://scenes/Menu/Cree_compte.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/Cree_compte.tscn")


func _on_link_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/send_email_reset.tscn")
