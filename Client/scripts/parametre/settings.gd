extends CanvasLayer

@onready var settings_panel = $Panel/SettingsPanel
@onready var bgm_slider: = $Panel/SettingsPanel/Musique/HSlider1
@onready var sfx_slider: = $Panel/SettingsPanel/EffetsSonores/HSlider2

func _ready():
	#settings_panel.visible = false
	bgm_slider.value = UserData.bgm_volume
	sfx_slider.value = UserData.sfx_volume
	

func _on_close_button_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	$".".visible = false

func _on_parametre_pressed() -> void:
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	settings_panel.visible = true

func _on_bgm_slider_value_changed(value: float) -> void:
	AudioManager.set_bgm_volume(value)

func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
