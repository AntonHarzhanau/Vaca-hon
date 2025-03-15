@tool
extends PropertyCell
class_name StreetCell

@onready var back_grouund: ColorRect = $BackGround
@onready var _group_color: TextureRect = $BackGround/ColorGroup
@export var group_color: Texture2D

var nb_houses:int = 0
var house_cost:int = 0

func _ready():
	super._ready()
	_group_color.pivot_offset = _group_color.size / 2
	_group_color.texture = group_color
	_group_color.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL

func buy_house():
	pass

func sell_house():
	pass
