extends Control

@onready var emoji_1 = $TextureRect/Panel/RatingScale/Emoji_1
@onready var emoji_2 = $TextureRect/Panel/RatingScale/Emoji_2
@onready var emoji_3 = $TextureRect/Panel/RatingScale/Emoji_3
@onready var emoji_4 = $TextureRect/Panel/RatingScale/Emoji_4
@onready var emoji_5 = $TextureRect/Panel/RatingScale/Emoji_5

@onready var emoji_6 = $TextureRect/Panel/RatingScale/Emoji_6
@onready var emoji_7 = $TextureRect/Panel/RatingScale/Emoji_7
@onready var emoji_8 = $TextureRect/Panel/RatingScale/Emoji_8
@onready var emoji_9 = $TextureRect/Panel/RatingScale/Emoji_9
@onready var emoji_10 = $TextureRect/Panel/RatingScale/Emoji_10

@onready var label_1 = $TextureRect/Panel/RatingScale/L1
@onready var label_2 = $TextureRect/Panel/RatingScale/L2
@onready var label_3 = $TextureRect/Panel/RatingScale/L3
@onready var label_4 = $TextureRect/Panel/RatingScale/L4
@onready var label_5 = $TextureRect/Panel/RatingScale/L5

@onready var slider = $TextureRect/Panel/RatingScale/HSlider

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
