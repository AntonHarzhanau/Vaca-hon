extends NinePatchRect

@export var lobby_theme: String = "Beach"
@onready var join_lobby = $JoinLobby

var lobby_theme_texture: Texture2D

func _ready() -> void:
	""" Set Texture Based On Lobby Theme"""
	match lobby_theme:
		"Beach":
			lobby_theme_texture = preload("res://assets/Lobby1.png")
		"Snow":
			lobby_theme_texture = preload("res://assets/Lobby2.png")
		_:
			lobby_theme_texture = preload("res://assets/Lobby1.png")
	self.texture = lobby_theme_texture
