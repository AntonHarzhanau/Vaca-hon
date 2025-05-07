extends Node2D

@onready var rules_popup = $RulesPopup
@onready var music_slider = $Music
@onready var sfx_slider = $SFX
@onready var vibration_toggle = $Vibrations
@onready var notification_toggle = $Notifications
@onready var language_option = $Language
@onready var privacy_dialog = $Privacy_Policy
@onready var settings_manager = get_node("Settingsm") 
@onready var sfx_click = $SFX_click
@onready var username_input = $UsernameLineEdit
@onready var confirm_button = $UsernameLineEdit/ConfirmName

func _ready():
	$RulesPopup/ScrollContainer/Label.text = """
Welcome to the Game Rules!

1. 
2. 
3. 
4. 
5. 

Have fun!
"""

	settings_manager.load_settings()
	username_input.text = settings_manager.username
	music_slider.value = settings_manager.music_volume
	sfx_slider.value = settings_manager.sfx_volume
	vibration_toggle.button_pressed = settings_manager.vibration_enabled
	notification_toggle.button_pressed = settings_manager.notifications_enabled
	language_option.select(settings_manager.language)

func _on_music_changed(value: float) -> void:
	var music_bus_index = AudioServer.get_bus_index("Music")
	if music_bus_index != -1:
		var volume_db = linear_to_db(clamp(value, 0.001, 1.0)) 
		AudioServer.set_bus_volume_db(music_bus_index, volume_db)
		settings_manager.music_volume = value
		settings_manager.save_settings()


func _on_sfx_changed(value: float) -> void:
	settings_manager.sfx_volume = value
	settings_manager.save_settings()

func _on_vibrations_pressed() -> void:
	settings_manager.vibration_enabled = vibration_toggle.button_pressed
	Input.start_joy_vibration(0.0,5.0,5.0)
	settings_manager.save_settings()
	sfx_click.play()

func _on_notifications_pressed() -> void:
	settings_manager.notifications_enabled = notification_toggle.button_pressed
	settings_manager.save_settings()
	sfx_click.play()

func _on_language_option_item_selected(index: int):
	settings_manager.language = index
	settings_manager.save_settings()
	sfx_click.play()


func _on_privacy_policy_pressed():
	privacy_dialog.popup_centered()
	sfx_click.play()

func _on_privacy_dialog_confirmed():
	OS.shell_open("https://www.lelien.com/privacy")

func _on_privacy_policy_2_pressed() -> void:
	privacy_dialog.popup_centered()
	sfx_click.play()

func _on_datapp_pressed() -> void:
	privacy_dialog.popup_centered()
	sfx_click.play()

func _on_review_data_consent_pressed() -> void:
	privacy_dialog.popup_centered()
	sfx_click.play()



func _on_rules_pressed() -> void:
	rules_popup.popup_centered()
	sfx_click.play()
	
func _on_close_button_pressed() -> void:
	rules_popup.hide()
	sfx_click.play()
	
func _on_username_line_edit_text_changed(new_text: String) -> void:
	settings_manager.username = new_text
	settings_manager.save_settings()
	sfx_click.play()



func _on_confirm_name_pressed() -> void:
	var new_name = username_input.text.strip_edges()
	if new_name != "":
		settings_manager.username = new_name
		settings_manager.save_settings()
		sfx_click.play()
	else:
		print("Nom d'utilisateur vide")
