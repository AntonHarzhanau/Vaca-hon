extends Control

@onready var message: RichTextLabel = $Panel/VBoxContainer/MarginContainer7/FeedbackMessage
@onready var login: LineEdit = $Panel/VBoxContainer/MarginContainer4/EmailLineEdit
@onready var password: LineEdit = $Panel/VBoxContainer/MarginContainer5/PasswordLineEdit
@onready var checkbox: CheckBox = $Panel/VBoxContainer/MarginContainer6/HBoxContainer/CheckBox
@onready var ip_settings_button = $Panel/VBoxContainer/HBoxContainer/MarginContainer2/Ip_settings_button
func _ready() -> void:
	login.text = UserData.user_name
	password.text = UserData.password
	checkbox.button_pressed = UserData.is_remebered
	
	# Stop playing BGM after logout
	AudioManager.fade_out_bgm()

func _on_connecter_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	var payload = {
		"login": login.text,  
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
		UserData.email = response.body["user"]["email"]
	
		if checkbox.button_pressed:
			#UserData.user_name = login.text
			UserData.password = password.text
		else:
			UserData.user_name = ""
			UserData.password = ""
		UserData.save_user_data()
		message.add_theme_color_override("default_color", "#00994f")
		message.text = "Login successful !"
		var scene = load("res://scenes/Menu/home.tscn")
		if scene:
			get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
	else:
		if response.response_code == 403 and response.body["detail"] == "Compte non activé. Veuillez confirmer votre adresse e-mail.":
			get_tree().change_scene_to_file("res://scenes/Menu/confirm_account.tscn")
		elif response.response_code == 401 and response.body["detail"] == "Mot de passe incorrect.":
			message.text = "Incorrect password. Please try again."
		elif response.response_code == 401 and response.body["detail"] == "Identifiants incorrects.":
			message.text = "User not found. Please check your credentials."
		else:
			message.text = "An error occurred. Please try again."
		print(response.body)

func _on_creer_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	var scene = load("res://scenes/Menu/Cree_compte.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/Cree_compte.tscn")	

func _on_link_button_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	get_tree().change_scene_to_file("res://scenes/Menu/send_email_reset.tscn")

func _on_check_box_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	UserData.is_remebered = checkbox.button_pressed
	UserData.save_user_data()


func _on_ip_settings_button_pressed() -> void:
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	var scene = load("res://Test/ip_settings.tscn")
	if scene:
		get_tree().change_scene_to_file("res://Test/ip_settings.tscn")
