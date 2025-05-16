
extends Control

@onready var button_left := $TextureRect/Panel/Langue/HBoxContainer/Button
@onready var button_right := $TextureRect/Panel/Langue/HBoxContainer/Button2
@onready var toggle_vibration := $TextureRect/Panel/Vibrations/TextureButton
@onready var toggle_notifications := $TextureRect/Panel/Notifications/TextureButton
@onready var music_vol: = $TextureRect/Panel/Musique/HSlider1

func _ready():
	music_vol.value = States.music_val
	pass
	

	
func _on_texture_button_pressed():
	var scene = load("res://scenes/Menu/home.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	pass # Replace with function body.


func _on_h_slider_1_value_changed(value: float) -> void:
	States.music_val = music_vol.value
	print(States.music_val)
