extends Node

@onready var msg_handler: Node = $Message_handler
@onready var ui:UI = $UI
@onready var board:GameBoard = $GameBoard

# Local data
var current_player_id: int = -1
var players:Dictionary[int, Player]= {}
var cells:Array[Cell] = []
var id_player_at_turn: int = 0

func _ready() -> void:
	# Subscribing GameManager to network signals
	WebSocketClient.connect_to_server()
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
	msg_handler.change_turn.connect(ui._on_change_turn)
	msg_handler.offer_to_buy.connect(ui._on_offer_to_buy)
	msg_handler.buy_property.connect(_on_buy_property)
	msg_handler.sell_property.connect(_on_sell_property)
	msg_handler.pay_rent.connect(_on_pay_rent)
	msg_handler.buy_house.connect(_on_buy_house)
	msg_handler.sell_house.connect(_on_sell_house)

func _on_your_id(player_id: int) -> void:
	current_player_id = player_id

func  _on_player_connected(player_data: Variant) -> void:
	for i in player_data:
		var new_player = board.add_player(i)
		players[new_player.id] = new_player
		new_player.state_changed.connect(_on_player_state_changed)
		if new_player.id == current_player_id:
			ui.create_main_player_hub(new_player)
		else:
			ui.create_guest_hub(new_player)

func _on_player_disconnected(player_id:int):
	ui._on_player_disconnected(player_id)
	players[player_id].queue_free()
	players.erase(player_id)
	
func _on_player_state_changed(player:Player):
	ui.update_hubs(player, current_player_id)

func _on_move_player(player_id: int, steps: int) -> void:
	var player = players[player_id]
	player.move(cells, steps)

func _on_offer_to_buy(cell_id:int, cell_name:int, price:int, player_id:int) -> void:
	if player_id == current_player_id:
		ui._on_offre_to_buy(cell_id, cell_name, price)

func _on_buy_property(player_id:int, cell_id: int, _price: int) -> void:
	var player = players[player_id]
	players[player_id].buy_property(cells[cell_id])
	if player_id == current_player_id:
		ui._on_buy_property(player.player_name, player.money, player.properties)

func _on_sell_property(player_id: int, cell_id: int, price:int) -> void:
	var player = players[player_id]
	player.sell_property(cell_id, price)
	var money = player.money
	var properties = player.properties

func _on_pay_rent(player_id:int, cell_owner_id:int, rent:int):
	players[player_id].pay(rent)
	players[cell_owner_id].earn(rent)

func _on_buy_house(player_id:int, cell_id:int, num_of_house:int, current_rent:int):
	cells[cell_id].buy_house(num_of_house, current_rent)

func _on_sell_house(player_id:int, cell_id:int, num_of_house:int, current_rent:int):
	cells[cell_id].sell_house(num_of_house, current_rent)


func _exit_tree():
	# Disconnect from the server when exiting the game
	WebSocketClient.close_connection()
