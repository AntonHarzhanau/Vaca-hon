@tool
extends PropertyCell
class_name StreetCell
signal nb_houses_changed

const HOUSE1 = preload("res://assets/houses/Maison1.png")
const HOUSE2 = preload("res://assets/houses/Maison2.png")
const HOTEL = preload("res://assets/houses/Maison3.png")

@onready var back_grouund: ColorRect = $BackGround
@onready var _group_color: TextureRect = $BackGround/ColorGroup
@onready var house_container: TextureRect = $BackGround/HouseContainer
@export var group_color: Texture2D


var nb_houses:int = 0
var house_cost:int = 0 

func _ready():
	super._ready()
	_group_color.pivot_offset = _group_color.size / 2
	_group_color.texture = group_color
	_group_color.expand_mode = TextureRect.EXPAND_FIT_WIDTH_PROPORTIONAL

func buy_house(num_of_houses:int, current_rent:int):
	nb_houses = num_of_houses
	set_house_image(nb_houses)
	rent_change(current_rent)
	cell_owner.pay(house_cost)
	emit_signal("nb_houses_changed")

func sell_house(num_of_houses:int, current_rent:int):
	nb_houses = num_of_houses
	set_house_image(nb_houses)
	rent_change(current_rent)
	cell_owner.earn(house_cost)
	emit_signal("nb_houses_changed")
	
func set_house_image(nb_houses:int):
	
	match nb_houses:
		1: 
			house_container.texture = HOUSE1
			house_container.visible = true
		2: 
			house_container.texture = HOUSE2
			house_container.visible = true
		3: 
			house_container.texture = HOTEL
			house_container.visible = true
		_: 
			house_container.visible = false
