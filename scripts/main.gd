extends Control

func _ready() -> void:
	pass


func _on_dice_dice_rolled(result: int) -> void:
	$Label.text = str(result)
