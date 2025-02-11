extends Control

@onready var dices = $dice

func _ready() -> void:
	pass

# subscribe to dice roll signal
func _on_dice_dice_rolled(dice1: int, dice2: int) -> void:
	# process duplicates
	if dice1 == dice2:
		$Label.text = "Double" + "dice1="+str(dice1)+ "dice2=" + str(dice2)
		dices.roll_dice()
	else:
		$Label.text = str(dice1 + dice2)
