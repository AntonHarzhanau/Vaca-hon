extends Control

@onready var texture_button = $TextureRect/TextureButton
@onready var edit_button = $TextureRect/HBoxContainer/Traveler1/edit
@onready var inviter_button = $TextureRect/MarginContainer/Panel/Partie_1/Inviter
@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Parties publiques")
@onready var button_privee = filter_menu.get_node("Parties privees")


@onready var margin_container = $TextureRect/MarginContainer
@onready var traveler2_invite = $TextureRect/HBoxContainer/Traveler2/invite2
@onready var traveler3_invite = $TextureRect/HBoxContainer/Traveler3/invite3
@onready var traveler4_invite = $TextureRect/HBoxContainer/Traveler4/invite4

@onready var overlay_mask = $TextureRect/OverlayMask

var is_expanded := false

func _ready():
	
	filter_menu.visible = false
	filter_button.text = "  FILTRER         ▼"
	
	filter_button.connect("pressed", _on_menu_button_pressed)
	button_publique.connect("pressed", _on_parties_publiques_pressed)
	button_privee.connect("pressed", _on_parties_publiques_pressed)
	edit_button.connect("pressed",_on_edit_pressed)
	inviter_button.connect("pressed",_on_inviter_pressed)
	
	margin_container.visible = false  # default

	# connect with Traveler2/3/4 's invite buttom
	traveler2_invite.connect("pressed", _on_invite_2_pressed)
	traveler3_invite.connect("pressed", _on_invite_3_pressed)
	traveler4_invite.connect("pressed", _on_invite_4_pressed)
	
	overlay_mask.connect("gui_input", _on_overlay_mask_input)
	overlay_mask.visible = false
	
func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/select_token.tscn")
	var scene = load("res://scenes/Menu/select_token.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")  # Switch to main menu
	else:
		print("Failed to load scene.")


func _on_menu_button_pressed() -> void:
	is_expanded = !is_expanded
	filter_menu.visible = is_expanded
	filter_button.text = "  FILTRER         ▲" if is_expanded else "  FILTRER         ▼"



func _on_parties_publiques_pressed() -> void:
	pass # Replace with function body.


func _on_parties_privees_pressed() -> void:
	pass # Replace with function body.


func _on_edit_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/select_token.tscn")
	var scene = load("res://scenes/Menu/select_token.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")  # Switch to main menu
	else:
		print("Failed to load scene.")


func _on_inviter_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/lobby_room.tscn")
	var scene = load("res://scenes/Menu/lobby_room.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")  # Switch to main menu
	else:
		print("Failed to load scene.")


func _on_invite_2_pressed() -> void:
	margin_container.visible = true
	overlay_mask.visible = true

func _on_invite_3_pressed() -> void:
	margin_container.visible = true
	overlay_mask.visible = true

func _on_invite_4_pressed() -> void:
	margin_container.visible = true
	overlay_mask.visible = true
	
	
func _on_overlay_mask_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.pressed:
		margin_container.visible = false
		overlay_mask.visible = false
