extends Control
@onready var screen = $control
# Button node references
@onready var creer_partie_button = $control/CREER
@onready var rejoindre_partie_button = $control/REJOINDRE
@onready var return_button = $control/ColorRect/TextureButton

@onready var left_container = $control/VBoxContainer/MarginContainer/HBoxContainer2/VBoxContainer
@onready var right_container = $control/VBoxContainer/MarginContainer/HBoxContainer2/VBoxContainer2
@onready var middle_spacer = $control/VBoxContainer/MarginContainer/HBoxContainer2

@onready var image1 = $control/VBoxContainer/MarginContainer/HBoxContainer2/VBoxContainer/TextureRect
@onready var image2 = $control/VBoxContainer/MarginContainer/HBoxContainer2/VBoxContainer2/TextureRect2

func _ready():
	pass
	
# When "CRÉER UNE PARTIE" is clicked, switch to create_lobby2.tscn
func _on_creer_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/create_lobby2.tscn")
	var scene = load("res://scenes/Menu/create_lobby2.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/create_lobby2.tscn")
	else:
		print("Failed to load scene.")

# When "REJOINDRE UNE PARTIE" is clicked, switch to list_lobby2.tscn
func _on_rejoindre_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/list_lobby2.tscn")
	var scene = load("res://scenes/Menu/list_lobby2.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/list_lobby2.tscn")
	else:
		print("Failed to load scene.")

# When the return button is clicked, go back to home.tscn
func _on_texture_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")
