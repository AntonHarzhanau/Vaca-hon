@tool
extends PropertyCell
class_name UtilityCell

@onready var image = $BackGround/Image

@export var texture: Texture2D

func _ready():
	super._ready()
	image.pivot_offset = image.size /2
	if image:
		image.texture = texture

func buy_property(player:Player, current_rent:int):
	super.buy_property(player, current_rent)

func sell_property(player:Player, current_rent:int):
	super.sell_property(player, current_rent)

func update_group(player, current_rent:int):
	for i in player.properties:
		if i is UtilityCell:
			i.rent = current_rent
