extends Panel
@onready var hub:BaseHub = $Hub

var player_id: int


func update(player_name:String, money:int):
	hub.update(player_name, money)
#func set_player_name(name:String):
	#player_name.text = name 
#
#func set_player_money(money: int) -> void:
	#player_money.text = "Money: " + str(money)
