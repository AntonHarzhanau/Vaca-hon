extends Panel
class_name  BaseHub
@onready var player_name_lable:Label = $UIcontainer/PlayerName
@onready var player_money_lable:Label = $UIcontainer/PlayerMoney

var player: Player

func set_player(new_player: Player) -> void:
	if new_player:
		player = new_player

func update_hub() -> void:
	player_name_lable.text = player.player_name
	player_money_lable.text = str(player.money)
