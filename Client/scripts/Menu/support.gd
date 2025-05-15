extends Control

@onready var emoji_1 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot/Emoji_1
@onready var emoji_2 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot2/Emoji_2
@onready var emoji_3 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot3/Emoji_3
@onready var emoji_4 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot4/Emoji_4
@onready var emoji_5 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot5/Emoji_5

@onready var emoji_6 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot/Emoji_6
@onready var emoji_7 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot2/Emoji_7
@onready var emoji_8 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot3/Emoji_8
@onready var emoji_9 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot4/Emoji_9
@onready var emoji_10 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer2/EmojiSlot5/Emoji_10

@onready var label_1 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer/L1
@onready var label_2 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer/L2
@onready var label_3 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer/L3
@onready var label_4 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer/L4
@onready var label_5 = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HBoxContainer/L5

@onready var username = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer_1/LineEdit
@onready var email = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer_2/LineEdit
@onready var phone = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer/HBoxContainer_3/LineEdit
@onready var message = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/LineEdit
@onready var slider = $TextureRect/Panel/MarginContainer/HBoxContainer/VBoxContainer2/RatingScale/VBoxContainer/HSlider
@onready var notif = $TextureRect/Panel/ResetNotif

var emojis_static = []
var emojis_dynamic = []
var labels = []

var default_color = Color(0.737, 0.737, 0.737)
var selected_color = Color(0.110, 0.752, 0.800)

func _ready():
	emojis_static = [emoji_1, emoji_2, emoji_3, emoji_4, emoji_5]
	emojis_dynamic = [emoji_6, emoji_7, emoji_8, emoji_9, emoji_10]
	labels = [label_1, label_2, label_3, label_4, label_5]
	
	# Initialize default state (slider at far left)
	_reset_emoji_and_text()
	_update_emoji_display(0)  # Display first animated emoji by default

	# Auto-fill username and email
	username.text = UserData.user_name
	email.text = UserData.email

	# Connect signal (in case not connected in the editor)
	slider.connect("value_changed", Callable(self, "_on_h_slider_value_changed"))

func _on_texture_button_pressed():
	var scene = load("res://scenes/Menu/home.tscn")
	if scene:
		get_tree().change_scene_to_file("res://scenes/Menu/home.tscn")

func _on_h_slider_value_changed(value):
	_reset_emoji_and_text()
	var index = int(clamp(value, 0, emojis_static.size() - 1))
	_update_emoji_display(index)

func _reset_emoji_and_text():
	for i in range(emojis_static.size()):
		emojis_static[i].texture = load("res://assets/Emoji/%d.png" % (i + 1))
		emojis_static[i].visible = true
		
		emojis_dynamic[i].stop()
		emojis_dynamic[i].visible = false
		emojis_dynamic[i].stream = null  # Release the previously loaded video stream
		
		labels[i].add_theme_color_override("font_color", default_color)

func _update_emoji_display(index):
	# Hide the static emoji at the current index
	emojis_static[index].visible = false

	# Set and play the animated emoji
	var video_names = ["11.ogv", "22.ogv", "33.ogv", "44.ogv", "55.ogv"]
	var video_path = "res://assets/Emoji/" + video_names[index]
	emojis_dynamic[index].stop()
	emojis_dynamic[index].stream = load(video_path)
	emojis_dynamic[index].visible = true
	emojis_dynamic[index].play()

	# Change label text color
	labels[index].add_theme_color_override("font_color", selected_color)

func _on_envoyer_pressed():
	var payload = {
	  "username": username.text.strip_edges(),
	  "email": email.text.strip_edges(),
	  "phone": phone.text.strip_edges(),
	  "rating": labels[slider.value].text.strip_edges(),
	  "message": message.text.strip_edges()
	}	
	# Validate fields
	if payload["email"].is_empty():
		notif.text = "Please enter your email address"
		notif.modulate = Color(1, 0, 0)
		print("Please enter your email address")
		return
		
	if payload["message"].is_empty():
		notif.text = "Please enter your message"
		notif.modulate = Color(1, 0, 0)
		print("Please enter your message")
		return
	
	if not CreeCompte.is_valid_email(payload["email"]):
		notif.text = "Please enter a valid password (Min: 8 characters. At least 1 number and 1 special character)."
		notif.modulate = Color(1, 0, 0)
		print("Please enter a valid email")
		return
	
	print(payload)
	# Post message to the /Users/request-support endpoint
	var response = await HttpRequestClient.__post("/Users/request-support", payload)
	print(response)
	
	if response.response_code == 200:
		#Show Message Feedback
		notif.text ="✅ Your support request has been sent!"
		notif.modulate = Color(0, 1, 0)
		
		# Reset fields
		username.text = ""
		email.text = ""
		phone.text = ""
		message.text = ""
		print("✅ Support Request successfully sent!")
	else:
		#Show Message Feedback
		notif.text = "❌ An error occured while sending your message. Please retry !"
		notif.modulate = Color(1, 0, 0)
		print("❌ An error occured while sending your message. Please retry !")
