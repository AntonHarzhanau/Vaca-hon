extends Control

@onready var dices = $dice
@onready var centre = $GameBoard/Centre
@onready var pop_up = $popup_offre
@onready var pop_up_lable = $popup_offre/Label
@onready var pop_up_yes_btn = $popup_offre/HBoxContainer/yes_btn
@onready var hub = $Hub

const PLAYER_SCENE = preload("res://scenes/player.tscn")
var list_players = []
var current_player = 0
var player_turn = 0
var cells = []

func _ready() -> void:
	WebSocketClient.message_received.connect(_on_server_response)
	cells = centre.get_children()
# subscribe to dice roll signal
func _on_dice_dice_rolled(dice1: int, dice2: int) -> void:
	# process duplicates
	if dice1 == dice2:
		$Label.text = "Double" + "dice1=" + str(dice1) + "dice2=" + str(dice2)
		# TODO: implement the mechanics of duplicates
	else:
		var score = dice1 + dice2
		$Label.text = str(score)
		if current_player == player_turn:
			var message = {"action": "move_player", "player_id": player_turn, "steps": score}
			var json_message = JSON.stringify(message)
			WebSocketClient.send_message(json_message)

func _on_server_response(message: Variant) -> void:
	print("RESPONSE:")
	print(message)
	print("\n")
	if message.has("action"):
		if message["action"] == "player_connected":
			add_player(message)
		if message["action"] == "your_id":
			current_player = message["player_id"]
		if message["action"] == "player_disconnected":
			delete_player(message)
		if message["action"] == "move_player":
			var player = list_players[message["player_id"]]
			player.move(cells, message["current_position"])
		if message["action"] == "change_turn":
			player_turn = message["player_id"]
		if message["action"] == "cell_activate":
			cells[message["cell_id"]].activate(list_players[message["player_id"]])
		if message["action"] == "offer_to_buy":
			if player_turn == current_player:
				var cell_name = message["cell_name"]
				var cell_price =  message["price"]
				pop_up_lable.text = "You want to buy property " + cell_name + " at price price " + str(cell_price)
				if list_players[current_player].money < cell_price:
					pop_up_yes_btn.visible = false
				pop_up.visible = true
			
			
		if message["action"] == "buy_property":
			(cells[message["cell_id"]] as PropertyCell).buy_property(list_players[message["player_id"]])
		if message["action"] == "sell_property":
			list_players[message["player_id"]].sell_property(message["cell_id"], message["price"])
			if list_players[current_player].money >= (cells[list_players[current_player].current_position] as PropertyCell).price:
				pop_up_yes_btn.visible = true
	update_properties_list()
	update_hub()
func add_player(message):
	for i in message["players"]:
				var player = PLAYER_SCENE.instantiate()
				player.id = i["id"]
				player.current_position = i["current_position"]
				player.money = i["money"]
				list_players.append(player)
				add_child(player)
				player.global_position = centre.get_children()[0].global_position + Vector2(10,10) * list_players.size()

func delete_player(message):
	for i in list_players:
					if message["player_id"] == i.id:
						i.queue_free()
						list_players.erase(i)

func _on_button_pressed() -> void:
	var message = {"action": "end_turn"}
	WebSocketClient.send_message(JSON.stringify(message))


func _on_yes_btn_pressed() -> void:
	var message = {"action": "accepted_offre", "player_id": current_player}
	WebSocketClient.send_message(JSON.stringify(message))
	pop_up.visible = false
func update_hub():
	var container = hub.get_node("VFlowContainer")
	var player_properties = ""
	for i in list_players[current_player].properties:
		var button = Button.new()
		button.text = i.cell_name
		button.pressed.connect(func(): send_sell_msg(i)) # Передаём параметр через лямбду
		container.add_child(button)
	hub.get_node("PlayerMoney").text = "Player Money: " + str(list_players[current_player].money)

func send_sell_msg(property:PropertyCell):
	var message = {"action": "sell_property", "player_id" : current_player, "cell_id": property.id_space}
	WebSocketClient.send_message(JSON.stringify(message))
	
func update_properties_list():
	# Удаляем старые кнопки перед обновлением
	for child in hub.get_node("VFlowContainer").get_children():
		child.queue_free()
		
func _on_no_btn_pressed() -> void:
	pop_up.visible = false
