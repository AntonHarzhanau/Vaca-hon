extends Control

@onready var texture_button = $TextureRect/TextureButton
@onready var edit_button = $TextureRect/HBoxContainer/Traveler1/edit
@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Parties publiques")
@onready var button_privee = filter_menu.get_node("Parties privees")

# Traveler noeds
@onready var traveler2 = $TextureRect/HBoxContainer/Traveler2
@onready var traveler3 = $TextureRect/HBoxContainer/Traveler3
@onready var traveler4 = $TextureRect/HBoxContainer/Traveler4
@onready var traveler5 = $TextureRect/HBoxContainer/Traveler5
@onready var traveler6 = $TextureRect/HBoxContainer/Traveler6
@onready var traveler7 = $TextureRect/HBoxContainer/Traveler7

#invite buttom
@onready var invite2_5 = $TextureRect/HBoxContainer/Traveler5/invite2
@onready var invite3_6 = $TextureRect/HBoxContainer/Traveler6/invite3
@onready var invite4_7 = $TextureRect/HBoxContainer/Traveler7/invite4

# popup
@onready var margin_container = $TextureRect/MarginContainer
@onready var inviter_button = $TextureRect/MarginContainer/Panel/Partie_1/Inviter

@onready var overlay_mask = $TextureRect/OverlayMask

var is_expanded := false

func _ready():
	
	filter_menu.visible = false
	filter_button.text = "  FILTRER         ▼"
	
	filter_button.connect("pressed", _on_menu_button_pressed)
	button_publique.connect("pressed", _on_parties_publiques_pressed)
	button_privee.connect("pressed", _on_parties_publiques_pressed)
	edit_button.connect("pressed",_on_edit_pressed)
	
	margin_container.visible = false

	# initial Traveler5/6/7 non visible
	traveler5.visible = false
	traveler6.visible = false
	traveler7.visible = false

	# 连接新 invite 按钮
	invite2_5.connect("pressed", _on_invite_2_pressed)
	invite3_6.connect("pressed", _on_invite_3_pressed)
	invite4_7.connect("pressed", _on_invite_4_pressed)

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

func _on_cancel_2_pressed() -> void:
	traveler2.visible = false
	traveler5.visible = true


func _on_cancel_3_pressed() -> void:
	traveler3.visible = false
	traveler6.visible = true

func _on_cancel_4_pressed() -> void:
	traveler4.visible = false
	traveler7.visible = true


func _on_inviter_pressed() -> void:
	margin_container.visible = false
	# recover Traveler2, Traveler3, Traveler4
	traveler2.visible = true
	traveler3.visible = true
	traveler4.visible = true
	traveler5.visible = false
	traveler6.visible = false
	traveler7.visible = false


func _on_start_pressed() -> void:
	pass # Replace with function body.
