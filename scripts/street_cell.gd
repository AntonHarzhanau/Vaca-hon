@tool
extends PropertyCell
class_name StreetCell

@onready var _group_color: ColorRect = $BackGround/ColorGroup
@export var group_color: Color

var nb_houses:int = 0
var house_cost:int = 0

func _ready():
	super._ready()
	_group_color.pivot_offset = _group_color.size / 2
	if _group_color:
		_group_color.color = group_color

func buy_house():
	pass

func sell_house():
	pass
