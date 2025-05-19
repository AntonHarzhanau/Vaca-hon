extends Node

signal player_connected(players)
signal player_disconnected(player_id: int)
signal your_id(player_id)
signal move_player(player_id:int, current_position:int, steps:int, prime:bool)
signal roll_dice(dice1:int, dice2:int)
signal change_turn(player_id:int, nb_turn_jail:int)
signal offer_to_buy(cell_id, price)
signal buy_property(player_id:int, cell_id:int, price:int, current_rent:int)
signal sell_property(player_id:int, cell_id:int, price:int, current_rent:int)
signal pay_rent(player_id:int, cell_owner_id:int, rent:int)
signal buy_house(player_id:int, cell_id:int, current_rent:int)
signal sell_house(player_id:int, cell_id:int, current_rent:int)
signal earn(player_id:int, amount:int)
signal pay(player_id:int, amount:int)
signal utility_rent(player_id:int)
signal go_to_jail(player_id:int)
signal get_out_jail(money:int)
signal offer_to_sell(rent:int)
signal event(message: Dictionary)
signal double_roll(message: String)
signal offer_airplane(message:Dictionary)
signal fly_to_airport(player_id:int, cell_id:int)
signal card_used(succssed: bool)

func _ready() -> void:
	pass

func _on_message_received(message: Dictionary) -> void:
	print(message)
	print("\n")
	var action = message.get("action", "Parsing Error")
	match action:
		"player_connected":
			emit_signal("player_connected", message["players"])
		"user_left":
			emit_signal("player_disconnected", message["user_id"])
		"your_id":
			emit_signal("your_id", message["player_id"])
		"roll_dice":
			emit_signal("roll_dice", message["dice1"], message["dice2"])
		"move_player":
			emit_signal("move_player", message["player_id"], message["current_position"],message["steps"], message["prime"])
		"change_turn":
			emit_signal("change_turn", message["player_id"], message["nb_turn_jail"])
		"offer_to_buy":
			emit_signal("offer_to_buy", message["cell_id"], message["price"])
		"buy_property":
			emit_signal("buy_property", message["player_id"], message["cell_id"], message["price"], message["current_rent"])
		"sell_property":
			emit_signal("sell_property", message["player_id"], message["cell_id"], message["price"], message["current_rent"])
		"pay_rent":
			emit_signal("pay_rent",message["player_id"], message["cell_owner_id"], message["rent"])
		"buy_house":
			emit_signal("buy_house", message["player_id"], message["cell_id"], message["number_of_house"],
			message["current_rent"])
		"sell_house":
			emit_signal("sell_house", message["player_id"], message["cell_id"], message["number_of_house"],
			message["current_rent"])
		"earn":
			emit_signal("earn", message["player_id"], message["amount"])
		"pay":
			emit_signal("pay", message["player_id"], message["amount"])
		"utility_rent":
			emit_signal("utility_rent")
		"go_to_jail":
			emit_signal("go_to_jail", message["player_id"])
		"get_out_jail":
			emit_signal("get_out_jail", message["money"])
		"offer_to_sell":
			emit_signal("offer_to_sell", message["rent"])
		"event":
			message.erase("action")
			emit_signal("event", message)
		"double_roll":
			emit_signal("double_roll", message["message"])
		"offer_airplane":
			emit_signal("offer_airplane", message)
		"fly_to_airport":
			emit_signal("fly_to_airport",
						message["player_id"],
						message["cell_id"]
			)
		"card_used":
			emit_signal("card_used", message["successed"])
		_:
			print("Unknown action from server: ", action)
