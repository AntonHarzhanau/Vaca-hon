extends Node

var music_volume: float = 0.5
var sfx_volume: float = 0.5
var vibration_enabled: bool = true
var notifications_enabled: bool = true
var language: int = 0  
var username: String = "Joueur"


const SAVE_PATH = "user://settings.cfg"

func _ready():
	load_settings()

func load_settings():
	var config = ConfigFile.new()
	if config.load(SAVE_PATH) == OK:
		music_volume = config.get_value("audio", "music_volume", music_volume)
		sfx_volume = config.get_value("audio", "sfx_volume", sfx_volume)
		vibration_enabled = config.get_value("preferences", "vibration_enabled", vibration_enabled)
		notifications_enabled = config.get_value("preferences", "notifications_enabled", notifications_enabled)
		language = config.get_value("preferences", "language", language)
	var configg = ConfigFile.new()
	var err = configg.load("user://settings.cfg")
	if err == OK:
		username = configg.get_value("general", "username", "Joueur")

func save_settings():
	var config = ConfigFile.new()
	config.set_value("audio", "music_volume", music_volume)
	config.set_value("audio", "sfx_volume", sfx_volume)
	config.set_value("preferences", "vibration_enabled", vibration_enabled)
	config.set_value("preferences", "notifications_enabled", notifications_enabled)
	config.set_value("preferences", "language", language)
	
	var configg = ConfigFile.new()
	configg.set_value("audio", "music_volume", music_volume)
	configg.set_value("general", "username", username)
	# ...
	configg.save("user://settings.cfg")
	
	config.save(SAVE_PATH)
