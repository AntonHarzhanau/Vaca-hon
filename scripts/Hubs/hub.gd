extends Panel
class_name  BaseHub
@onready var player_name_lable:Label = $VBoxContainer/PlayerName
@onready var player_money_lable:Label = $VBoxContainer/PlayerMoney

#var player_name: String
#var player_money: int
func _ready() -> void:
	pass
	#player_name_lable.text = player_name
	#player_money_lable.text = str(player_money)

func update(player_name:String, money:int) -> void:
	player_name_lable.text = player_name
	player_money_lable.text = str(money)
