extends Control
class_name Waiting_room_player

@onready var player_name_label: Label = $PlayerName
@onready var player_token_sprite:TextureRect = $Panel/Panel2/PlayerToken

var user_id:int
@export var player_name: String
@export var player_color: String
@export var player_token: String

func _ready() -> void:
	player_name_label.text = player_name
	player_name_label.self_modulate = Color.html(player_color)
	#player_token_sprite.texture = load("res://assets/Token/"+player_token+".png")
