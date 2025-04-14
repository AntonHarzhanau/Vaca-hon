@tool
extends PropertyCell
class_name UtilityCell

@onready var texture: TextureRect = $BackGround/TextureRect
@export var image: Texture2D

func _ready():
	super._ready()
	texture.pivot_offset = texture.size / 2
	if image:
		texture.texture = image

func buy_property(player:Player, current_rent:int):
	super.buy_property(player, current_rent)

func sell_property(player:Player, current_rent:int):
	super.sell_property(player, current_rent)

func update_group(player, current_rent:int):
	for i in player.properties:
		if i is UtilityCell:
			i.current_rent = current_rent
