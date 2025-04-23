extends Node2D

@onready var music_slider = $Music
@onready var sfx_slider = $SFX
@onready var vibration_toggle = $Vibrations
@onready var notification_toggle = $Notifications
@onready var language_option = $Language
@onready var privacy_dialog = $Privacy_Policy
@onready var settings_manager = get_node("Settingsm") 
@onready var sfx_click = $SFX_click
func _ready():
	settings_manager.load_settings()
	
	music_slider.value = settings_manager.music_volume
	sfx_slider.value = settings_manager.sfx_volume
	vibration_toggle.button_pressed = settings_manager.vibration_enabled
	notification_toggle.button_pressed = settings_manager.notifications_enabled
	language_option.select(settings_manager.language)

func _on_music_changed(value: float) -> void:
	settings_manager.music_volume = value
	settings_manager.save_settings()

func _on_sfx_changed(value: float) -> void:
	settings_manager.sfx_volume = value
	settings_manager.save_settings()

func _on_vibrations_pressed() -> void:
	settings_manager.vibration_enabled = vibration_toggle.button_pressed
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
