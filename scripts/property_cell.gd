@tool
extends Cell
class_name PropertyCell

@onready var label_cost: Label = $BackGround/Cost
@export var cost: int

var cell_owner = null
var rent = 0

func _ready():
	super._ready()
	label_cost.pivot_offset = label_cost.size / 2
	if label_cost:
		label_cost.text = str(cost)

func buy_property():
	pass

func sell_property():
	pass

func mortgage_property():
	pass
