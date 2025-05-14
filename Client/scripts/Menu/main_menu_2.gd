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
	for button in get_tree().get_nodes_in_group("MainButtons"):
		if button is Button:
			button.mouse_entered.connect(func(): _hover(button, true))
			button.mouse_exited.connect(func(): _hover(button, false))
	
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

func _hover(button: Button, entering: bool):
	var tween := button.create_tween()
	var target_scale: Vector2
	if entering:
		target_scale = Vector2(1.1, 1.1)
		tween.set_ease(Tween.EASE_OUT)
	else:
		target_scale = Vector2(1, 1)
		tween.set_ease(Tween.EASE_IN)

	tween.set_trans(Tween.TRANS_ELASTIC)
	tween.tween_property(button, "scale", target_scale, 0.2)
