extends Node

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
	Required a password having at least 8 characters, at least 1 number and 1 special character
	"""
	var regex = RegEx.new()
	var pattern = r"^(?=.*\d)(?=.*[@$!%*?&+\-]).{8,}$"
	var error = regex.compile(pattern)
	if error != OK:
		print("Regex compile error:", error)
		return false
	return regex.search(password) != null
