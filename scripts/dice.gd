extends Area2D

# Signal transmitting the result of the throw
signal dice_rolled(result: int, result2: int)

@onready var dice_sprite: AnimatedSprite2D = $DiceSprite
@onready var dice_sprite2: AnimatedSprite2D = $DiceSprite2
@onready var timer: Timer = $RollTimer

var is_dice_thrown: bool = false # to block spam by throwing
# TODO: block dice roll until next turn or special events

var server_dice1: int = 0
var server_dice2: int = 0

func _ready() -> void:
	# Subscribe to timer signal
	timer.timeout.connect(_on_timer_timeout)
	# Subscribe to the signal of receiving a message from the server
	WebSocketClient.message_received.connect(_on_server_response)

# Handling the click event on the area (dice roll)
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		if !is_dice_thrown:
			var message = {"action": "roll_dice"}
			var json_message = JSON.stringify(message)
			WebSocketClient.send_message(json_message)
			is_dice_thrown = true

# Animation start function
func roll_dice() -> void:
	dice_sprite.play("roll")
	dice_sprite2.play("roll")
	timer.start()

# Handling timer expiration
func _on_timer_timeout() -> void:
		process_dice_result()

# Processing the response from the server
func _on_server_response(message: String) -> void:
	var json = JSON.new()
	var data = json.parse(message)
	if data == OK:
		var result = json.data
		if result.has("action") and result["action"] == "roll_dice":
			if result.has("dice1") and result.has("dice2"):
				server_dice1 = result["dice1"]
				server_dice2 = result["dice2"]
				roll_dice()
			else:
				print("Incorrect response from the server: required data is missing.")
	else:
		print("Error parsing response from server:", data.error_string)

# Function for processing throw results
func process_dice_result() -> void:
	# Stop animation
	dice_sprite.stop()
	dice_sprite2.stop()

	# Set sprite frames according to results
	dice_sprite.frame = server_dice1 - 1 # It is assumed that frames are numbered from 0 to 5
	dice_sprite2.frame = server_dice2 - 1

	# Emitting a signal with the throw results
	emit_signal("dice_rolled", server_dice1, server_dice2)
	is_dice_thrown = false
