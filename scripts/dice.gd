extends Area2D

# declare a signal that transmits the result of the throw
signal dice_rolled(result: int, result2: int)

@onready var dice_sprite: AnimatedSprite2D = $DiceSprite
@onready var dice_sprite2: AnimatedSprite2D = $DiceSprite2
@onready var timer: Timer = $RollTimer

func _ready() -> void:
	# subscribe to the timer
	timer.timeout.connect(_on_timer_timeout)

# The event is fired when the user clicks on the area defined by the CollisionShape2D
func _input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		roll_dice()

# The function starts the animation of the dice roll.
func roll_dice() -> void:
	dice_sprite.play("roll")
	dice_sprite2.play("roll")
	timer.start()

# Function called by timer signal (at the end of animation)
func _on_timer_timeout() -> void:
	dice_sprite.stop()
	dice_sprite2.stop()
	# Get the number of frames in the animation "roll"
	var frame_count = dice_sprite.sprite_frames.get_frame_count("roll")
	var frame_count2 = dice_sprite2.sprite_frames.get_frame_count("roll")
	# Select a random frame from 0 to frame_count - 1
	var final_frame = randi() % frame_count
	var final_frame2 = randi() % frame_count2
	dice_sprite.frame = final_frame
	dice_sprite2.frame = final_frame2

	# Convert the frame number to a cube number (for example, if frames are 0-5, then the result is 1-6)
	var dice_result = final_frame + 1
	var dice_result2 = final_frame2 + 1

	# Send a signal with the throw result
	emit_signal("dice_rolled", dice_result, dice_result2)
