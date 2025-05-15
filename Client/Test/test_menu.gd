extends CanvasLayer

@onready var steps: TextEdit = $VBoxContainer/TestMoveContainer/Steps
@onready var move: Button = $VBoxContainer/TestMoveContainer/MovePlayer
@onready var double_btn: Button = $VBoxContainer/TestMoveContainer/Double

func _on_move_player_pressed() -> void:
	var msg = {"action": "move_player", "steps": int(steps.text)}
	WebSocketClient.send_message(JSON.stringify(msg))



func _on_double_pressed() -> void:
	if States.dice_active:
		var message = {"action": "roll_dice", "for": States.current_context, "test": true}
		States.dice_active = false
		WebSocketClient.send_message(JSON.stringify(message))
