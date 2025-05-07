extends Control

@onready var message: RichTextLabel = $VBoxContainer/MarginContainer7/FeedbackMessage
@onready var user_name: LineEdit = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/UsernameLineEdit
@onready var email: LineEdit = $VBoxContainer/HBoxContainer/MarginContainer/VBoxContainer/EmailLineEdit
@onready var password: LineEdit = $VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer2/PasswordLineEdit
@onready var confirm_password: LineEdit = $VBoxContainer/HBoxContainer/MarginContainer2/VBoxContainer2/ConfirmPasswordLineEdit

func _on_creer_pressed() -> void:
	message.text = ""
	
	# Fields Validation
	## Check for empty field
	if user_name.text.is_empty() \
		or email.text.is_empty() \
		or password.text.is_empty() \
		or confirm_password.text.is_empty():
		message.text = "Please complete all required fields."
		return
		
	## Check for valid email address
	if not is_valid_email(email.text):
		message.text = "Please enter a valid email address."
		return
		
	## Check for valid password : at least 8 charcters, at least 1 number AND 1 special characer (@$!%*?&+-)
	if not is_valid_password(password.text):
		message.text = "Please enter a valid password (Min: 8 characters. At least 1 number and 1 special character)."
		return
		
	## Check if confirmation password match
	if password.text != confirm_password.text:
		message.text = "Password and Confirm Password do not match. Please try again."
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
		message.text = "Successfully registered ! Loading..."
		print(response.body)
		UserData.user_id = int(response.body["id"])
		UserData.email = response.body["email"]
		UserData.user_name = response.body["username"]
		UserData.save_user_data()
		var scene = preload("res://scenes/Menu/home.tscn")
		if scene:
			get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")


func _on_texture_button_pressed() -> void:
	var scene = preload("res://scenes/Menu/Connection.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/Connection.tscn")

func is_valid_email(email: String) -> bool:
	"""
	Check if provided email address have the right format
	"""
	var regex = RegEx.new()
	var pattern = r"^[\w\.-]+@[\w\.-]+\.\w{2,}$"
	var error = regex.compile(pattern)
	if error != OK:
		print("Regex compile error:", error)
		return false
	return regex.search(email) != null

func is_valid_username(username: String) -> bool:
	"""
	Required at least 3 characters for username
	"""
	return len(username) >= 3

func is_valid_password(password: String) -> bool:
	"""
	Required a password having at least 8 chars, at least 1 number and 1 special character
	"""
	var regex = RegEx.new()
	var pattern = r"^(?=.*\d)(?=.*[@$!%*?&+\-]).{8,}$"
	var error = regex.compile(pattern)
	if error != OK:
		print("Regex compile error:", error)
		return false
	return regex.search(password) != null
