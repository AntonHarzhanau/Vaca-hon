extends Control

# Save button groups
@onready var group_joueurs = $TextureRect/MarginContainer/Panel/Control/HBoxContainer.get_children()
@onready var group_temps = $TextureRect/MarginContainer/Panel/Control/HBoxContainer2.get_children()
@onready var group_type = $TextureRect/MarginContainer/Panel/Control2/HBoxContainer3.get_children()

# Password-related nodes
@onready var label_mdp = $TextureRect/MarginContainer/Panel/Control2/Label5
@onready var lineedit_mdp = $TextureRect/MarginContainer/Panel/Control2/LineEdit
@onready var message_mdp = $TextureRect/MarginContainer/Panel/Control2/FeedbackMessage

# Store the original normal style for each button
var default_styles := {}

# Button node reference
@onready var texture_button = $TextureRect/ColorRect/MarginContainer/HBoxContainer/TextureButton

@onready var create_lobby_btn: Button = $TextureRect/MarginContainer/Panel/MarginContainer/SubmitCreateLobby

# Default selected button
var nb_player_max = 2
var time_sec = 30 * 60
var is_private = false
var secret = ''

func _ready():
	# Connect all button groups
	_connect_buttons(group_joueurs)
	_connect_buttons(group_temps)
	_connect_buttons(group_type)
	create_lobby_btn.pressed.connect(_on_create_lobby_pressed)

	# Hide password fields initially
	label_mdp.visible = false
	lineedit_mdp.visible = false
	
	# Auto select default values on group buttons
	group_joueurs[0].emit_signal("pressed")
	group_temps[0].emit_signal("pressed")
	group_type[0].emit_signal("pressed")

	
func _connect_buttons(button_group: Array):
	for button in button_group:
		if button is Button:
			# Save the original normal style of the button
			var base_style = button.get("theme_override_styles/normal")
			if base_style:
				default_styles[button] = base_style.duplicate()
			button.connect("pressed", _on_group_button_pressed.bind(button_group, button))

func _on_group_button_pressed(button_group: Array, selected: Button):
	for button in button_group:
		if button != selected:
			# Restore the default normal style
			if default_styles.has(button):
				button.set("theme_override_styles/normal", default_styles[button].duplicate())
				button.button_pressed = false

	# Set the selected button style (copy hover style into normal)
	var hover_style = selected.get("theme_override_styles/hover")
	if hover_style:
		selected.set("theme_override_styles/normal", hover_style.duplicate())
		selected.button_pressed = true

	# Special case: show/hide password field
	if selected.name == "Button_Privee":
		label_mdp.visible = true
		lineedit_mdp.visible = true
	elif selected.name == "Button_Publique":
		label_mdp.visible = false
		lineedit_mdp.visible = false
		
	_update_selected_buttons()

# When the return button is clicked, switch back to the main menu scene
func _on_texture_button_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/main_menu2.tscn")
	var scene = load("res://scenes/Menu/main_menu2.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/main_menu2.tscn")  # 切换到主菜单场景
	else:
		print("Failed to load scene.")
		
func _update_selected_buttons():
	# Check selected on group_players
	for button in group_joueurs:
		if button.button_pressed:
			nb_player_max = button.text
	
	# Check selected on group_temps
	for button in group_temps:
		if button.button_pressed:
			time_sec = int(button.text.replace("min", "")) * 60
			
	# Check selected on group_type
	for button in group_type:
		if button.button_pressed:
			is_private = button.name == "Button_Privee"
			

func _on_create_lobby_pressed():
	var payload = {
		"owner_id": int(UserData.user_id),
		"nb_player_max": nb_player_max,
		"time_sec": time_sec,
		"is_private": is_private,
		"secret": lineedit_mdp.text if is_private else ""
	}
	
	# Client validation
	# Check if Lobby secret is provided if Lobby is private
	if is_private and len(payload["secret"]) == 0:
		message_mdp.text = "Please enter a password for your lobby"
		return
	
	var response = await HttpRequestClient.__post("/lobbies", payload)
	
	if response.result != OK:
		print("An error occurred in the HTTP request.")
		#message_feedback_label.add_theme_color_override("default_color", "#ff2334")
		#message_feedback_label.text = "An error has occurred, please try again.!"
	else:
		print(response.body)
		States.lobby_id = int(response.body["id"])
		States.lobby_max_players = int(response.body["nb_player_max"])
		States.lobby_owner_id = int(response.body["owner_id"])
		WebSocketClient.connect_to_server(States.WS_BASE_URL+ "/" +str(States.lobby_id)+"?user_id="+str(UserData.user_id))
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")
