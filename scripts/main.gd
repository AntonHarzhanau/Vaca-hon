extends Control

@onready var dices = $dice
@onready var centre = $GameBoard/Centre
@onready var cash = $cash
const PLAYER_SCENE = preload("res://scenes/player.tscn")
var list_players = []
var current_player = 0
var player_turn = 0

func _ready() -> void:
	WebSocketClient.message_received.connect(_on_server_response)

# subscribe to dice roll signal
func _on_dice_dice_rolled(dice1: int, dice2: int) -> void:
	# process duplicates
	if dice1 == dice2:
		$Label.text = "Double" + "dice1=" + str(dice1) + "dice2=" + str(dice2)
		# TODO: implement the mechanics of duplicates
		#player.move(centre.get_children(), dice1+dice2)
	else:
		var score = dice1 + dice2
		$Label.text = str(score)
		var message = {"action": "move_player", "player_id": player_turn, "steps": score}
		var json_message = JSON.stringify(message)
		WebSocketClient.send_message(json_message)
		
		
# show received messages for debug
func _on_server_response(message: Variant) -> void:
	print(message)
	if message.has("action"):
		if message["action"] == "player_connected":
			add_player(message)
		if message["action"] == "your_id":
			current_player = message["player_id"]
		if message["action"] == "player_disconnected":
			delete_player(message)
		if message["action"] == "move_player":
			list_players[message["player_id"]].move(centre.get_children(), message["current_position"])
			list_players[message["player_id"]].money = message["money"]
			cash.text = str(list_players[current_player].money)
		if message["action"] == "change_turn":
			player_turn = message["player_id"]

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
