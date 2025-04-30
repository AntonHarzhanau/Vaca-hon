extends Control

@onready var player_name_label: Label = $PlayerName
@onready var player_token_sprite: Sprite2D = $PlayerToken

@export var player_name: String = "{{player_name}}"
@export var player_color: String = "#fff"
@export var player_token = preload("res://assets/Token/flight.png")

func _ready() -> void:
	player_name_label.text = player_name_label.text.replacen("{{player_name}}", player_name)
	var new_sb = StyleBoxFlat.new()
	new_sb.bg_color = player_color
	player_name_label.add_theme_color_override("background_color", player_color)

	player_token_sprite.texture = player_token
