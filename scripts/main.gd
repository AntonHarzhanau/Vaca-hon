extends Control

@onready var dices = $dice
@onready var centre = $GameBoard/Centre
@onready var player = $Player

func _ready() -> void:
	WebSocketClient.message_received.connect(_on_server_response)
	player.global_position = centre.get_children()[0].global_position

# subscribe to dice roll signal
func _on_dice_dice_rolled(dice1: int, dice2: int) -> void:
	# process duplicates
	if dice1 == dice2:
		$Label.text = "Double" + "dice1=" + str(dice1) + "dice2=" + str(dice2)
		# TODO: implement the mechanics of duplicates
		player.move(centre.get_children(), dice1+dice2)
	else:
		$Label.text = str(dice1 + dice2)
		player.move(centre.get_children(), dice1+dice2)
		
# show received messages for debug
func _on_server_response(message: String) -> void:
	var json = JSON.new()
	var data = json.parse(message)
	if data == OK:
		var result = json.data
		print(result)
	else:
		print("Error parsing response from server:", data.error_string)
