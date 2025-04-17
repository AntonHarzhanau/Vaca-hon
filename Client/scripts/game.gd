extends Node

@onready var msg_handler: Node = $Message_handler
@onready var ui:UI = $UI
@onready var board:GameBoard = $GameBoard
# Local data 
var players:Dictionary[int, Player]= {}
var cells:Array[Cell] = []
var colors:Array[Color] = [Color.RED, Color.YELLOW, Color.GREEN, Color.BROWN]

func _ready() -> void:
	# Subscribing GameManager to network signals
	#WebSocketClient.connect_to_server(States.URL)
	WebSocketClient.message_received.connect(msg_handler._on_message_received)
	if States.is_test:
		var test_ui = load("res://Test/test_menu.tscn")
		var test_instance = test_ui.instantiate()
		ui.add_child(test_instance)
	
	cells = board.get_cells()

	# Subscribing UI to GameManager signals
	msg_handler.player_connected.connect(_on_player_connected)
	msg_handler.player_disconnected.connect(_on_player_disconnected)
	#msg_handler.user_left.connect(_on_player_disconnected)
	msg_handler.roll_dice.connect(ui.dice._on_server_response)
	msg_handler.move_player.connect(_on_move_player)
	msg_handler.change_turn.connect(_on_change_turn)
	msg_handler.offer_to_buy.connect(_on_offer_to_buy)
	msg_handler.buy_property.connect(_on_buy_property)
	msg_handler.sell_property.connect(_on_sell_property)
	msg_handler.pay_rent.connect(_on_pay_rent)
	msg_handler.buy_house.connect(_on_buy_house)
	msg_handler.sell_house.connect(_on_sell_house)
	msg_handler.pay.connect(_on_pay)
	msg_handler.earn.connect(_on_earn)
	msg_handler.utility_rent.connect(_on_utility_rent)
	msg_handler.go_to_jail.connect(_on_go_to_jail)
	msg_handler.get_out_jail.connect(_on_get_out_jail)
	msg_handler.event.connect(_on_card_event)
	ui.end_turn_clicked.connect(_on_end_turn_clicked)

func  _on_player_connected(player_data: Variant) -> void:
	for i in player_data:
		var new_player = board.add_player(i)
		new_player.global_position += Vector2(10,10) * players.size()
		#new_player.player_color = colors[new_player.id]
		players[new_player.id] = new_player
		new_player.state_changed.connect(_on_player_state_changed)
		if new_player.id == UserData.user_id:
			ui.create_main_player_hub(new_player)
		else:
			ui.create_guest_hub(new_player)
		print("Player id" + str(new_player.id) +"was created")

func _on_player_disconnected(player_id:int):
	print("here")
	var player = players[player_id]
	for property: PropertyCell in player.properties:
		if property is StreetCell:
			property.nb_houses = 0
		property.cell_owner = null
		property.current_rent = property.initial_rent
		property.player_lable.visible = false
	ui._on_player_disconnected(player_id)
	players[player_id].queue_free()
	players.erase(player_id)
	
func _on_player_state_changed(player:Player):
	ui.update_hubs(player, UserData.user_id)
	var offer = ui.popup_offer
	if player.money >= offer.price:
		ui.popup_offer.accept_btn.disabled = false

func _on_move_player(player_id: int, current_position:int, steps: int, prime:bool) -> void:
	var player = players[int(player_id)]
	if prime:
		player.earn(200)
	player.move(cells, steps)

func _on_offer_to_buy(cell_id:int, price:int) -> void:
	var cell = cells[cell_id]
	var player = players[UserData.user_id]
	ui.popup_offer.price = price
	if player.money < price:
		ui.popup_offer.accept_btn.disabled = true
	ui.popup_offer.show_offer(cell.cell_name)

func _on_buy_property(player_id:int, cell_id: int, _price: int, current_rent:int) -> void:
	var player = players[player_id]
	players[player_id].buy_property(cells[cell_id], _price, current_rent)

func _on_sell_property(player_id: int, cell_id: int, _price:int, current_rent:int) -> void:
	var player = players[player_id]
	player.sell_property(cell_id, _price, current_rent)
	var money = player.money
	var properties = player.properties

func _on_pay_rent(player_id:int, cell_owner_id:int, rent:int):
	players[player_id].pay(rent)
	players[cell_owner_id].earn(rent)
	if player_id == UserData.user_id:
		ui.show_info("you paid "+ str(rent)+ " to player" + str(cell_owner_id))

func _on_buy_house(player_id:int, cell_id:int, num_of_house:int, current_rent:int):
	cells[cell_id].buy_house(num_of_house, current_rent)

func _on_sell_house(player_id:int, cell_id:int, num_of_house:int, current_rent:int):
	cells[cell_id].sell_house(num_of_house, current_rent)

func _on_earn(player_id:int, amount:int):
	players[player_id].earn(amount)

func _on_pay(player_id:int, amount:int):
	players[player_id].pay(amount)

func _on_utility_rent():
	States.dice_active = true
	States.current_context = States.DiceContext.UTILITY
	ui.show_info("dice activate for" + States.current_context)

func _on_change_turn(player_id:int, nb_turn_jail:int):
	if player_id == UserData.user_id:
		players[player_id].nb_turn_jail = nb_turn_jail
		States.dice_active = true
		if nb_turn_jail > 0:
			ui.jail_offre.show_offer()
			States.current_context = States.DiceContext.GET_OUT_OF_JAIL
		else:
			States.current_context = States.DiceContext.MOVE
	States.id_player_at_turn = player_id
	ui._on_change_turn()
	
func _on_get_out_jail(money: int):
	var player = players[UserData.user_id]
	player.pay(money)
	player.nb_turn_jail = 0
	States.dice_active = true
	States.current_context = States.DiceContext.MOVE
	
func _on_go_to_jail(player_id:int):
	players[player_id].go_to_jail(cells)

func _on_end_turn_clicked():
	var bankrupt: bool = false
	if players:
		if players[UserData.user_id].money < 0:
			bankrupt = true
		var msg = {"action": "end_turn", "bankrupt": bankrupt}
		WebSocketClient.send_message(JSON.stringify(msg))
		if bankrupt:
			ui.show_info("Game over!!!!!!!")
			_exit_tree()
			
func _on_card_event(data:Dictionary):
	var event_type = data.get("effect_type", "Error")
	var player = players[int(data.get("player_id"))]
	ui.event_card.descripton.text = data.get("description", "Error")
	ui.event_card.visible = true
	match event_type:
		"gain_money": player.earn(data.get("amount"))
		"gain_from_all": 
			var total = 0
			var amount: int = data.get("amount", 0)
			for p in players.values():
				if p != player:
					p.pay(amount)
					total += amount
			player.earn(total)
		"property_repair":
			var total: int = 0
			for property in player.properties:
				if property is StreetCell:
					total += property.nb_houses * data.get("house_cost", 0)
			player.pay(total)
		"pay_fine": player.pay(data.get("amount"))
		"pay_all": 
			var total = 0
			var amount: int = data.get("amount", 0)
			for p in players.values():
				if p != player:
					p.earn(amount)
					total += amount
			player.pay(total)
		"move_to": player.move(cells, data.get("steps", 0))
		"move_to_nearest": player.move(cells, data.get("steps", 0))
		"move_and_gain": 
			player.move(cells, data.get("steps", 0))
			player.earn(data.get("amount"))
		
	#match type:
		#"gain_money": 
			#players[int(payload["player_id"])].earn(int(payload["amount"]))
		#"pay_fine" : 
			#players[int(payload["player_id"])].pay(int(payload["amount"]))
		"move_steps": player.move(cells, data.get("steps", 0))
		#"get_out_of_jail": pass
		"go_to_jail": player.go_to_jail(cells)
	

func _exit_tree():
	# Disconnect from the server when exiting the game
	WebSocketClient.close_connection()
