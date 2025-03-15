extends Node

signal player_connected(players)
signal player_disconnected(player_id: int)
signal your_id(player_id)
signal move_player(player_id, steps)
signal change_turn(player_id)
signal offer_to_buy(cell_id, cell_name, price, player_id)
signal buy_property(player_id, cell_id)
signal sell_property(player_id, cell_id, price)
signal pay_rent(player_id:int, cell_owner_id:int, rent:int)


func _ready() -> void:
	pass

func _on_message_received(message: Variant) -> void:
	print(message)
	print("\n")
	var action = message["action"]
	match action:
		"player_connected":
			emit_signal("player_connected", message["players"])
		"player_disconnected":
			emit_signal("player_disconnected", message["player_id"])
		"your_id":
			emit_signal("your_id", message["player_id"])
		"move_player":
			emit_signal("move_player", message["player_id"], message["current_position"])
		"change_turn":
			emit_signal("change_turn", message["player_id"])
		"offer_to_buy":
			emit_signal("offer_to_buy", message["cell_id"], message["cell_name"], message["price"])
		"buy_property":
			emit_signal("buy_property", message["player_id"], message["cell_id"], message["price"])
		"sell_property":
			emit_signal("sell_property", message["player_id"], message["cell_id"], message.get("price", 0))
		"pay_rent":
			emit_signal("pay_rent",message["player_id"], message["cell_owner_id"], message["rent"])
		_:
			print("Unknown action from server: ", action)
