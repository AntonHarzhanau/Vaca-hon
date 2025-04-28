extends Control

@onready var message: RichTextLabel = $TextureRect/Panel/FeedbackMessage
@onready var email: LineEdit = $TextureRect/Panel/HBoxContainer/VBoxContainer/EmailLineEdit
@onready var password: LineEdit = $TextureRect/Panel/HBoxContainer/VBoxContainer2/PasswordLineEdit
@onready var confirm_password: LineEdit = $TextureRect/Panel/HBoxContainer/VBoxContainer2/ConfirmPasswordLineEdit
@onready var user_name: LineEdit = $TextureRect/Panel/HBoxContainer/VBoxContainer/UsernameLineEdit

func _on_creer_pressed() -> void:
	message.text = ""
	
	if password.text != confirm_password.text:
		message.text = "Les mots de passe saisis ne correspondent pas. Merci de vérifier."
		return
	
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
		UserData.user_id = int(response.body["id"])
		UserData.email = response.body["email"]
		UserData.user_name = response.body["username"]
		UserData.save_user_data()
		var scene = preload("res://scenes/Menu/home.tscn")
		if scene:
			get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")


func _on_texture_button_pressed() -> void:
	var scene = preload("res://scenes/Menu/home.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
