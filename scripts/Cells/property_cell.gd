@tool
extends Cell
class_name PropertyCell

@onready var label_cost: Label = $BackGround/Cost

@export var price: int
var cell_owner: Player = null
var rent = 0

func _ready():
	super._ready()
	label_cost.pivot_offset = label_cost.size / 2
	if label_cost:
		label_cost.text = str(price)

func activate(player: Player) -> void:
	super.activate(player)

func buy_property(player: Player) -> void:
	cell_owner = player
	player.properties.append(self)
	player.money -= price

func mortgage_property():
	pass
