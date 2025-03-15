extends Panel
class_name  BaseHub
@onready var player_name_lable:Label = $VBoxContainer/PlayerName
@onready var player_money_lable:Label = $VBoxContainer/PlayerMoney

func update(player_name:String, money:int) -> void:
	player_name_lable.text = player_name
	player_money_lable.text = str(money)
