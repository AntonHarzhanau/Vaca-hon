@tool
extends PropertyCell
class_name RailWayCell

func _ready():
	super._ready()
	$BackGround/Image.pivot_offset = $BackGround/Image.size / 2

func buy_property(player:Player, current_rent:int):
	super.buy_property(player, current_rent)

func sell_property(player:Player, current_rent:int):
	super.sell_property(player, current_rent)

func update_group(player, current_rent:int):
	for i in player.properties:
		if i is RailWayCell:
			i.rent = current_rent
