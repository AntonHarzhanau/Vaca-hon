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


func _on_join_lobby_pressed() -> void:
	print("Attempting to load scene: res://scenes/Menu/select_token.tscn")
	var scene = preload("res://scenes/Menu/select_token.tscn")
	if scene:
		print("Scene loaded successfully!")
		get_tree().change_scene_to_file("res://scenes/Menu/select_token.tscn")  # 切换到主菜单场景
	else:
		print("Failed to load scene.")
