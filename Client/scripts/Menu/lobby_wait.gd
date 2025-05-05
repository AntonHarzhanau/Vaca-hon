extends Control

@onready var texture_button = $TextureRect/ColorRect/MarginContainer/TextureButton
@onready var edit_button = $TextureRect/MarginContainer/HBoxContainer/Traveler1/Player/edit
@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Parties publiques")
@onready var button_privee = filter_menu.get_node("Parties privees")

@onready var traveler2_invite = $TextureRect/MarginContainer/HBoxContainer/Traveler2/invite2
@onready var traveler3_invite = $TextureRect/MarginContainer/HBoxContainer/Traveler3/invite3
@onready var traveler4_invite = $TextureRect/MarginContainer/HBoxContainer/Traveler4/invite4

var is_expanded := false

func _ready():
	#filter_button.text = "  FILTRER         ▼"

	#filter_button.connect("pressed", _on_menu_button_pressed)
	button_publique.connect("pressed", _on_parties_publiques_pressed)
	button_privee.connect("pressed", _on_parties_publiques_pressed)
	edit_button.connect("pressed", _on_edit_pressed)

	# connect invite buttons (now used to enter lobby_room)
	traveler2_invite.connect("pressed", _on_invite_2_pressed)
	traveler3_invite.connect("pressed", _on_invite_3_pressed)
	traveler4_invite.connect("pressed", _on_invite_4_pressed)

func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/select_token.tscn")
	var scene = load("res://scenes/Menu/select_token.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")
	else:
		print("Failed to load scene.")

'''
func _on_menu_button_pressed() -> void:
	is_expanded = !is_expanded
	filter_menu.visible = is_expanded
	filter_button.text = "  FILTRER         ▲" if is_expanded else "  FILTRER         ▼"
'''

func _on_parties_publiques_pressed() -> void:
	pass # Replace with function body.

func _on_parties_privees_pressed() -> void:
	pass # Replace with function body.

func _on_edit_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/select_token.tscn")
	var scene = load("res://scenes/Menu/select_token.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")
	else:
		print("Failed to load scene.")

func _on_inviter_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/lobby_room.tscn")
	var scene = load("res://scenes/Menu/lobby_room.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")
	else:
		print("Failed to load scene.")

# Updated invite buttons to jump directly to lobby_room
func _on_invite_2_pressed() -> void:
	_jump_to_lobby_room()

func _on_invite_3_pressed() -> void:
	_jump_to_lobby_room()

func _on_invite_4_pressed() -> void:
	_jump_to_lobby_room()

func _jump_to_lobby_room() -> void:
	print("Switching to lobby_room...")
	get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")
