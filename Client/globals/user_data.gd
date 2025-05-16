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
var is_remebered: bool
var is_active: bool
var bgm_volume: float
var sfx_volume: float

func _ready() -> void:
	load_user_data()


func save_user_data() -> void:
	config.set_value(section_name, "user_id", user_id)
	config.set_value(section_name, "user_name", user_name)
	config.set_value(section_name, "email", email)
	config.set_value(section_name, "password", password)
	config.set_value(section_name, "token", token)
	config.set_value(section_name, "is_remebered", is_remebered)
	config.set_value(section_name, "bgm_volume", bgm_volume)
	config.set_value(section_name, "sfx_volume", sfx_volume)
	config.save_encrypted_pass(path_to_save_file, OS.get_unique_id())
	
func load_user_data() -> void:
	config = ConfigFile.new()
	config.load_encrypted_pass(path_to_save_file, OS.get_unique_id())
	user_id = config.get_value(section_name, "user_id",-1)
	user_name = config.get_value(section_name, "user_name", "")
	email = config.get_value(section_name, "email", "")
	password = config.get_value(section_name, "password", "")
	is_remebered = config.get_value(section_name, "is_remebered", false)
	token = config.get_value(section_name, "token", "")
	bgm_volume = config.get_value(section_name, "bgm_volume", 1.0)
	sfx_volume = config.get_value(section_name, "sfx_volume", 1.0)
