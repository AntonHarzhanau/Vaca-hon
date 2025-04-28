
extends Control

@onready var button_left := $TextureRect/Panel/Langue/HBoxContainer/Button
@onready var button_right := $TextureRect/Panel/Langue/HBoxContainer/Button2
@onready var toggle_vibration := $TextureRect/Panel/Vibrations/TextureButton
@onready var toggle_notifications := $TextureRect/Panel/Notifications/TextureButton

func _ready():
	
	pass
	
	
func _on_texture_button_pressed():
	var scene = load("res://scenes/Menu/home.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")


func _on_button_pressed() -> void:
	pass # Replace with function body.


func _on_button_2_pressed() -> void:
	pass # Replace with function body.
