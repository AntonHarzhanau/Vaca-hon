extends Control

@onready var email = $Main/Panel/VBoxContainer/EmailInput
@onready var notif = $Main/Panel/VBoxContainer/Label

func _on_send_email_button_pressed() -> void:
	
	if email.text.strip_edges() == "":
		notif.text = "Please fill in all fields."
		return
	
	var email_regex = RegEx.new()
	email_regex.compile(r"^[\w\.-]+@[\w\.-]+\.\w{2,}$")
	if not email_regex.search(email.text):
		notif.text = "Please enter a valid email address."
		return
	
	var payload = { "email": email.text }
	var response = await HttpRequestClient.__post("/Users/request-reset", payload)
	States.global_email = email.text
	var scene = preload("res://scenes/Menu/reset_password.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/reset_password.tscn")
	print(response)
	
	if response.response_code == 200:
		notif.text ="✅ Code sent to your email address!"
		notif.modulate = Color(0, 1, 0)
	else:
		notif.text = "❌ Invalid email address."
		notif.modulate = Color(1, 0, 0)

func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")
