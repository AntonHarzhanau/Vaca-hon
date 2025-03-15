extends Panel
@onready var hub:BaseHub = $Hub

var player_id: int


func update(player_name:String, money:int):
	hub.update(player_name, money)
