extends Node

@onready var msg_handler = $Message_handler
@onready var ui = $UI
@onready var board = $GameBoard

# Local data
var current_player_id: int = -1
var players = {}  # Dict: player_id:int -> player_data:Player
var cells:Array[Node] = []
var id_player_at_turn: int = 0

func _ready() -> void:
	# Subscribing GameManager to network signals
	WebSocketClient.message_received.connect(msg_handler._on_message_received)
	cells = board.get_cells()

	# Subscribing UI to GameManager signals
	msg_handler.player_connected.connect(_on_player_connected)
	msg_handler.player_disconnected.connect(ui._on_player_disconnected)
	msg_handler.your_id.connect(_on_your_id)
	msg_handler.move_player.connect(_on_move_player)
	msg_handler.change_turn.connect(ui._on_change_turn)
	msg_handler.offer_to_buy.connect(ui._on_offer_to_buy)
	msg_handler.buy_property.connect(_on_buy_property)
	msg_handler.sell_property.connect(_on_sell_property)


func  _on_player_connected(player_data: Variant) -> void:
	for i in player_data:
		var new_player = board.add_player(i)
		players[new_player.id] = new_player
	#TODO: add logic for init ui for all users


func _on_your_id(player_id: int) -> void:
	current_player_id = player_id
	var money = players[player_id].money
	var properties = players[player_id].properties
	#ui.update_hub(money, properties)

func _on_move_player(player_id: int, steps: int) -> void:
	players[player_id].move(cells, steps)
	
func _on_offer_to_buy(cell_id:int, cell_name:int, price:int, player_id:int) -> void:
	if player_id == current_player_id:
		ui._on_offre_to_buy(cell_id, cell_name, price)
		pass

func _on_buy_property(player_id:int, cell_id: int, price: int) -> void:
	var player = players[player_id]
	cells[cell_id].buy_property(player)
	if player_id == current_player_id:
		ui._on_buy_property(player.money, player.properties)

func _on_sell_property(player_id: int, cell_id: int, price:int) -> void:
	var player = players[player_id]
	player.sell_property(cell_id, price)
	var money = player.money
	var properties = player.properties
	if player_id == current_player_id:
		ui.update_hub(money, properties)
