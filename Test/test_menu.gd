extends CanvasLayer
@onready var steps: TextEdit = $Panel/HBoxContainer/VBoxContainer/Steps
@onready var move:Button = $Panel/HBoxContainer/MovePlayer




func _on_move_player_pressed() -> void:
	var msg = {"action": "move_player", "steps": int(steps.text)}
	WebSocketClient.send_message(JSON.stringify(msg))
