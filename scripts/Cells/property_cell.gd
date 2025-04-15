@tool
extends Cell
class_name PropertyCell
signal property_changed
@onready var label_cost: Label = $BackGround/Cost

@export var price: int
var cell_owner: Player = null: set = owner_change
var rent = 0 : set = rent_change

func _ready():
	super._ready()
	label_cost.pivot_offset = label_cost.size / 2
	if label_cost:
		label_cost.text = str(price)

func activate(player: Player) -> void:
	super.activate(player)

func mortgage_property():
	pass
func rent_change(value:int):
	rent = value
	emit_signal("property_changed")
	
func owner_change(value: Player):
	cell_owner = value
	emit_signal("property_changed")
