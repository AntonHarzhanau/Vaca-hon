extends Node
# Create new ConfigFile object.
var config:ConfigFile
var path_to_save_file = "user://monopoly.cfg"
var section_name = "user_data"

var user_id: int
var user_name: String
var email: String
var password: String
var token: String
var is_active: bool

func _ready() -> void:
	load_user_data()


func save_user_data() -> void:
	config.set_value(section_name, "user_id", user_id)
	config.set_value(section_name, "user_name", user_name)
	config.set_value(section_name, "email", email)
	config.set_value(section_name, "password", password)
	config.set_value(section_name, "token", token)
	config.save_encrypted_pass(path_to_save_file, OS.get_unique_id())
	
func load_user_data() -> void:
	config = ConfigFile.new()
	config.load_encrypted_pass(path_to_save_file, OS.get_unique_id())
	user_id = config.get_value(section_name, "user_id",-1)
	user_name = config.get_value(section_name, "user_name", "")
	email = config.get_value(section_name, "email", "")
	password = config.get_value(section_name, "password", "")
	token = config.get_value(section_name, "token", "")
