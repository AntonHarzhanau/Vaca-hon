extends CanvasLayer

@onready var steps: TextEdit = $VBoxContainer/TestMoveContainer/Steps
@onready var move: Button = $VBoxContainer/TestMoveContainer/MovePlayer
@onready var cell_id: TextEdit = $VBoxContainer/TestHouseContainer/Cell_id
@onready var sell_house_button: Button = $VBoxContainer/TestHouseContainer/SellHouseButton
@onready var buy_house_button: Button = $VBoxContainer/TestHouseContainer/BuyHouseButton

func _on_move_player_pressed() -> void:
	var msg = {"action": "move_player", "steps": int(steps.text)}
	WebSocketClient.send_message(JSON.stringify(msg))

func _on_sell_house_button_pressed() -> void:
	var msg = {"action": "sell_house", "cell_id": int(cell_id.text)}
	WebSocketClient.send_message(JSON.stringify(msg))

func _on_buy_house_button_pressed() -> void:
	var msg = {"action": "buy_house", "cell_id": int(cell_id.text)}
	WebSocketClient.send_message(JSON.stringify(msg))
