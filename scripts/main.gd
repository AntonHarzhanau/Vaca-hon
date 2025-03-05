extends Control

@onready var dices = $dice
@onready var centre = $GameBoard/Centre
@onready var cash = $cash
#@onready var player = $Player
const PLAYER_SCENE = preload("res://scenes/player.tscn")
var list_players = []
var current_player = 0

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
		var message = {"action": "move_player", "player_id": current_player, "steps": score}
		var json_message = JSON.stringify(message)
		WebSocketClient.send_message(json_message)
		
		
# show received messages for debug
func _on_server_response(message: String) -> void:
	var json = JSON.new()
	var data = json.parse(message)
	if data == OK:
		var result = json.data
		print(result)
		if result.has("action"):
			if result["action"] == "player_connected":
				add_player(result)
			if result["action"] == "player_disconnected":
				delete_player(result)
			if result["action"] == "move_player":
				list_players[result["player_id"]].move(centre.get_children(), result["current_position"])
				list_players[result["player_id"]].money
				cash.text = str(list_players[0].money)
			if result["action"] == "change_turn":
				current_player = result["player_id"]
	else:
		print("Error parsing response from server:", data.error_string)

func add_player(result):
	for i in result["players"]:
				var player = PLAYER_SCENE.instantiate()
				player.id = i["id"]
				player.current_position = i["current_position"]
				player.money = i["money"]
				list_players.append(player)
				add_child(player)
				player.global_position = centre.get_children()[0].global_position + Vector2(10,10) * list_players.size()

func delete_player(result):
	for i in list_players:
					if result["player_id"] == i.id:
						i.queue_free()
						list_players.erase(i)

func _on_button_pressed() -> void:
	var message = {"action": "end_turn"}
	var json_message = JSON.stringify(message)
	WebSocketClient.send_message(json_message)
	
			
