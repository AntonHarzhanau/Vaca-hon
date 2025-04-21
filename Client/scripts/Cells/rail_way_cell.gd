@tool
extends PropertyCell
class_name RailWayCell

@onready var texture: TextureRect = $BackGround/TextureRect
var image: Texture2D

func _ready():
	super._ready()
	$BackGround/TextureRect.pivot_offset = $BackGround/TextureRect.size / 2
	texture.texture = image

func buy_property(player:Player, current_rent:int):
	super.buy_property(player, current_rent)

func sell_property(player:Player, current_rent:int):
	super.sell_property(player, current_rent)

func update_group(player, current_rent:int):
	for i in player.properties:
		if i is RailWayCell:
			i.current_rent = current_rent
