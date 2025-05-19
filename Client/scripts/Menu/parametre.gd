
extends Control

@onready var button_left := $TextureRect/Panel/Langue/HBoxContainer/Button
@onready var button_right := $TextureRect/Panel/Langue/HBoxContainer/Button2
@onready var toggle_vibration := $TextureRect/Panel/Vibrations/TextureButton
@onready var toggle_notifications := $TextureRect/Panel/Notifications/TextureButton
@onready var bgm_slider: = $TextureRect/Panel/Musique/HSlider1
@onready var sfx_slider: = $TextureRect/Panel/EffetsSonores/HSlider1

func _ready():
	bgm_slider.value = UserData.bgm_volume
	sfx_slider.value = UserData.sfx_volume

	
func _on_texture_button_pressed():
	# Play Click SFX Audio
	AudioManager.play_sfx(preload("res://audio/SFX/sfx_click.ogg"))
	
	var scene = load("res://scenes/Menu/home.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_bgm_slider_value_changed(value: float) -> void:
	AudioManager.set_bgm_volume(value)
	
func _on_sfx_slider_value_changed(value: float) -> void:
	AudioManager.set_sfx_volume(value)
