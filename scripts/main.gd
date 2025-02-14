extends Control

@onready var dices = $dice
@onready var centre = $GameBoard/Centre
@onready var player = $Player

func _ready() -> void:
	
	player.global_position = centre.get_children()[0].global_position

# subscribe to dice roll signal
func _on_dice_dice_rolled(dice1: int, dice2: int) -> void:
	# process duplicates
	if dice1 == dice2:
		$Label.text = "Double" + "dice1=" + str(dice1) + "dice2=" + str(dice2)
		dices.roll_dice()
	else:
		$Label.text = str(dice1 + dice2)
		player.move(centre.get_children(), dice1+dice2)
