extends Control

@onready var player_name_label: Label = $PlayerName
@onready var player_token_sprite: Sprite2D = $PlayerToken

@export var player_name: String = "{{player_name}}"
@export var player_color: String = "#af52de"
@export var player_token = preload("res://assets/Token/flight.png")

func _ready() -> void:
	player_name_label.text = player_name_label.text.replacen("{{player_name}}", player_name)
	var new_style_box_normal = player_name_label.get_theme_stylebox("normal").duplicate()
	new_style_box_normal.bg_color = Color.html(player_color)
	player_name_label.add_theme_stylebox_override("normal", new_style_box_normal)

	player_token_sprite.texture = player_token
