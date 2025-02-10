@tool
extends PropertyCell
class_name StreetCell

@onready var color_group: ColorRect = $ColorGroup
@export var street_color: Color

var houses = 0
var house_cost = 0

func _ready():
	super._ready()
	if color_group:
		color_group.color = street_color

func buy_house():
	pass

func sell_house():
	pass
