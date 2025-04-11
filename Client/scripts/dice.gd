@tool
extends Control
class_name Dice
# Signal transmitting the result of the throw
signal dice_rolled(result: int, result2: int)


@onready var dice_sprite: AnimatedSprite2D = $DiceSprite
@onready var dice_sprite2: AnimatedSprite2D = $DiceSprite2
@onready var timer: Timer = $RollTimer

#var is_dice_thrown: bool = false  # to block spam by throwing
# TODO: block dice roll until next turn or special events

var server_dice1: int = 0
var server_dice2: int = 0

func _ready() -> void:
	# Allow clicking
	mouse_filter = Control.MOUSE_FILTER_STOP
	# Subscribe to timer signal
	timer.timeout.connect(_on_timer_timeout)
	# Subscribe to the signal of receiving a message from the server
	#WebSocketClient.message_received.connect(_on_server_response)

# Handling the click event
func _gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed and States.dice_active:
		#if !is_dice_thrown:
		States.dice_active = false
		var message = {"action": "roll_dice", "for": States.current_context}
		WebSocketClient.send_message(JSON.stringify(message))
		

# Animation start function
func roll_dice() -> void:
	dice_sprite.play("roll")
	dice_sprite2.play("roll")
	#is_dice_thrown = true
	timer.start()

# Handling timer expiration
func _on_timer_timeout() -> void:
	process_dice_result()

# Processing the response from the server
func _on_server_response(dice1, dice2) -> void:
	server_dice1 = dice1
	server_dice2 = dice2
	roll_dice()


# Function for processing throw results
func process_dice_result() -> void:
	# Stop animation
	dice_sprite.stop()
	dice_sprite2.stop()

	# Set sprite frames according to results
	dice_sprite.frame = server_dice1 - 1  # It is assumed that frames are numbered from 0 to 5
	dice_sprite2.frame = server_dice2 - 1

	# Emitting a signal with the throw results
	emit_signal("dice_rolled", server_dice1, server_dice2)
	#is_dice_thrown = false
