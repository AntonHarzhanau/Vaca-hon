extends Control
class_name Hub

@onready var player_name_lable:Label = $PanelBackground/TopBar/PlayerName
@onready var player_token: TextureRect = $PanelBackground/LeftSide/PlayerFigure
@onready var player_money_lable:Label = $PanelBackground/RightSide/MoneyAmount
@onready var player_bonus: Label = $PanelBackground/LeftSide/AdvantagesContainer/AdvantagesValue
@onready var top_bar: Panel = $PanelBackground/TopBar
@onready var player_info: CanvasLayer = $PlayerInfo

var player: Player
var player_color: Color

func _ready() -> void:
	pass

func set_player(new_player: Player) -> void:
	if new_player:
		player = new_player
		player_color = new_player.player_color
		var style = top_bar.get_theme_stylebox("panel").duplicate()
		style.bg_color = player_color
		top_bar.add_theme_stylebox_override("panel", style)
		player_token.texture = player.player_token
		
func update_hub() -> void:
	# Update Color
	player_name_lable.text = player.player_name
	player_money_lable.text = str(player.money)
	player_bonus.text = str(player.bonus)
