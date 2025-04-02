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
	WebSocketClient.connect_to_server("ws://127.0.0.1:8000/lobbies/ws")
	WebSocketClient.message_received.connect(msg_handler._on_message_received)
	if States.is_test:
		var test_ui = load("res://Test/test_menu.tscn")
		var test_instance = test_ui.instantiate()
		ui.add_child(test_instance)
	
	cells = board.get_cells()

	# Subscribing UI to GameManager signals
	msg_handler.player_connected.connect(_on_player_connected)
	msg_handler.player_disconnected.connect(_on_player_disconnected)
	msg_handler.your_id.connect(_on_your_id)
	msg_handler.move_player.connect(_on_move_player)
	msg_handler.change_turn.connect(_on_change_turn)
	msg_handler.offer_to_buy.connect(ui._on_offer_to_buy)
	msg_handler.buy_property.connect(_on_buy_property)
	msg_handler.sell_property.connect(_on_sell_property)
	msg_handler.pay_rent.connect(_on_pay_rent)
	msg_handler.buy_house.connect(_on_buy_house)
	msg_handler.sell_house.connect(_on_sell_house)
	msg_handler.pay.connect(_on_pay)
	msg_handler.earn.connect(_on_earn)
	msg_handler.utility_rent.connect(_on_utility_rent)

func _on_your_id(player_id: int) -> void:
	States.current_player_id = player_id

func  _on_player_connected(player_data: Variant) -> void:
	for i in player_data:
		var new_player = board.add_player(i)
		new_player.player_color = colors[new_player.id]
		players[new_player.id] = new_player
		new_player.state_changed.connect(_on_player_state_changed)
		if new_player.id == States.current_player_id:
			ui.create_main_player_hub(new_player)
		else:
			ui.create_guest_hub(new_player)

func _on_player_disconnected(player_id:int):
	ui._on_player_disconnected(player_id)
	players[player_id].queue_free()
	players.erase(player_id)
	
func _on_player_state_changed(player:Player):
	ui.update_hubs(player, States.current_player_id)

func _on_move_player(player_id: int, steps: int, prime:bool) -> void:
	var player = players[player_id]
	if prime:
		player.earn(200)
	player.move(cells, steps)

func _on_offer_to_buy(cell_id:int, cell_name:int, price:int, player_id:int) -> void:
	if player_id == States.current_player_id:
		ui._on_offre_to_buy(cell_id, cell_name, price)

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
	if player_id == States.current_player_id:
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

func _on_change_turn(player_id:int):
	States.dice_active = true
	States.current_context = "move"
	States.id_player_at_turn = player_id
	ui._on_change_turn()

func _exit_tree():
	# Disconnect from the server when exiting the game
	WebSocketClient.close_connection()
