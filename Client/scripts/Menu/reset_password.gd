extends Control

@onready var code = $Main/Panel/VBoxContainer/CodeInput
@onready var new_password = $Main/Panel/VBoxContainer/NewPassword
@onready var new_password_confirm = $Main/Panel/VBoxContainer/ConfirmNewPassword
@onready var notif = $Main/Panel/ResetNotif

func _on_change_password_button_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
		
	if new_password.text.strip_edges() == "" or new_password_confirm.text.strip_edges() == "" or code.text.strip_edges() == "":
		notif.text = "Please fill in all fields."
		notif.modulate = Color(1, 0, 0)
		return
		
	## Check for valid password : at least 8 charcters, at least 1 number AND 1 special characer (@$!%*?&+-)
	if not Utils.is_valid_password(new_password.text):
		notif.text = "Please enter a valid password (Min: 8 characters. At least 1 number and 1 special character)."
		notif.modulate = Color(1, 0, 0)
		return
		
	## Check if confirmation password match
	if new_password.text != new_password_confirm.text:
		notif.text = "Passwords do not match."
		notif.modulate = Color(1, 0, 0)
		return
	
	var payload = {
		"email": States.global_email,
		"reset_code": code.text,
		"new_password": new_password.text
	}
	print(payload)
	var response = await HttpRequestClient.__post("/Users/reset-password", payload)
	print(response)
	
	if response.response_code == 200:
		notif.text ="✅ Password successfully reset!"
		notif.modulate = Color(0, 1, 0)
		get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")
	else:
		notif.text = "❌ Incorrect code."
		notif.modulate = Color(1, 0, 0)

func _on_texture_button_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")

func _on_change_mail_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	get_tree().change_scene_to_file("res://scenes/Menu/send_email_reset.tscn")
