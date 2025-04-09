@tool
extends Cell
class_name PropertyCell
signal property_changed
@onready var label_cost: Label = $BackGround/Cost
@onready var player_lable:ColorRect = $BackGround/PlayerLable

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

func buy_property(player:Player, current_rent:int):
	self.cell_owner = player
	self.player_lable.color = player.player_color
	self.player_lable.visible = true
	player.properties.append(self)
	player.money -= self.price
	self.rent = current_rent
	self.update_group(player, current_rent)
	

func sell_property(player:Player, current_rent:int):
	self.cell_owner = null
	self.player_lable.visible = false
	self.rent = current_rent
	player.money += price
	player.properties.erase(self)
	self.update_group(player, current_rent)

func rent_change(value:int):
	rent = value
	emit_signal("property_changed")
	
func owner_change(value: Player):
	cell_owner = value
	emit_signal("property_changed")

func update_group(player:Player, current_rent):
	pass
