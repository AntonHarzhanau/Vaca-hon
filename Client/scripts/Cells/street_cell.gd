@tool
extends PropertyCell
class_name StreetCell
signal nb_houses_changed

const HOUSE = preload("res://scenes/house/house.tscn")
const HOTEL = preload("res://scenes/house/hotel.tscn")

@onready var back_grouund: ColorRect = $BackGround
@onready var _group_color: TextureRect = $BackGround/ColorGroup
@onready var house_container: GridContainer = $BackGround/HouseContainer
@onready var hotel_container: CenterContainer = $BackGround/HotelContainer
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
	rent_change(current_rent)
	cell_owner.pay(house_cost)
	if nb_houses < 5:
		var house = HOUSE.instantiate()
		house_container.add_child(house)
	else:
		var hotel = HOTEL.instantiate()
		house_container.visible = false
		hotel_container.add_child(hotel)
	emit_signal("nb_houses_changed")

func sell_house(num_of_houses:int, current_rent:int):
	if nb_houses == 5:
		print("nb_houses " + str(nb_houses))
		hotel_container.get_child(0).queue_free()
		house_container.visible = true
	else:
		for house in house_container.get_children():
			house.queue_free()
		for i in num_of_houses:
			var house = HOUSE.instantiate()
			house_container.add_child(house)
	rent_change(current_rent)
	nb_houses = num_of_houses
	cell_owner.earn(house_cost)
	emit_signal("nb_houses_changed")
	
