extends Control

@onready var player_name_label: RichTextLabel = $PanelContainer/VBoxContainer/PlayerName
@onready var player_token_sprite: Sprite2D = $PanelContainer/VBoxContainer/TokenPanel/PlayerToken

@export var player_name: String = "{{player_name}}"
@export var player_token = preload("res://assets/Players/FLIGHT.png")

func _ready() -> void:
	player_name_label.text = player_name_label.text.replacen("{{player_name}}", player_name)
	player_token_sprite.texture = player_token
