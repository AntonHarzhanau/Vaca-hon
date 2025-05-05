extends Control

@onready var texture_button = $TextureRect/ColorRect/MarginContainer/TextureButton
@onready var edit_button = $TextureRect/MarginContainer2/HBoxContainer/Traveler1/Player/edit
@onready var filter_button = $TextureRect/MenuButton
@onready var filter_menu = $TextureRect/VBoxContainer
@onready var button_publique = filter_menu.get_node("Parties publiques")
@onready var button_privee = filter_menu.get_node("Parties privees")

# Traveler noeds
@onready var traveler2 = $TextureRect/MarginContainer2/HBoxContainer/Traveler2
@onready var traveler3 = $TextureRect/MarginContainer2/HBoxContainer/Traveler3
@onready var traveler4 = $TextureRect/MarginContainer2/HBoxContainer/Traveler4
@onready var traveler5 = $TextureRect/MarginContainer2/HBoxContainer/Traveler5
@onready var traveler6 = $TextureRect/MarginContainer2/HBoxContainer/Traveler6
@onready var traveler7 = $TextureRect/MarginContainer2/HBoxContainer/Traveler7

#invite buttom
@onready var invite2_5 = $TextureRect/MarginContainer2/HBoxContainer/Traveler5/invite2
@onready var invite3_6 = $TextureRect/MarginContainer2/HBoxContainer/Traveler6/invite3
@onready var invite4_7 = $TextureRect/MarginContainer2/HBoxContainer/Traveler7/invite4



var is_expanded := false

func _ready():
	
	#filter_button.text = "  FILTRER         ▼"
	
	#filter_button.connect("pressed", _on_menu_button_pressed)
	button_publique.connect("pressed", _on_parties_publiques_pressed)
	button_privee.connect("pressed", _on_parties_publiques_pressed)
	edit_button.connect("pressed",_on_edit_pressed)


	# initial Traveler5/6/7 non visible
	traveler5.visible = false
	traveler6.visible = false
	traveler7.visible = false
	
'''
	# 连接新 invite 按钮
	invite2_5.connect("pressed", _on_invite_2_pressed)
	invite3_6.connect("pressed", _on_invite_3_pressed)
	invite4_7.connect("pressed", _on_invite_4_pressed)
'''	

func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/select_token.tscn")
	var scene = load("res://scenes/Menu/select_token.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")  # Switch to main menu
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
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")  # Switch to main menu
	else:
		print("Failed to load scene.")

'''
func _on_invite_2_pressed() -> void:
	_reload_scene()

func _on_invite_3_pressed() -> void:
	_reload_scene()

func _on_invite_4_pressed() -> void:
	_reload_scene()


func _reload_scene():
	print("Reloading lobby_room to reset player slots...")
	get_tree().change_scene_to_file("res://scenes/Menu/lobby_room.tscn")
'''
		
func _on_cancel_2_pressed() -> void:
	print("Cancel 2 button clicked!")
	traveler2.visible = false
	#traveler5.visible = true


func _on_cancel_3_pressed() -> void:
	traveler3.visible = false
	#traveler6.visible = true

func _on_cancel_4_pressed() -> void:
	traveler4.visible = false
	#traveler7.visible = true




func _on_start_pressed() -> void:
	pass # Replace with function body.
