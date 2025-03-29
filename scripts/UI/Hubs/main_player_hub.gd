@tool
extends BaseHub
class_name MainPlayerHub

const PROPERTY_CARD = preload("res://scenes/UI/Popups/PropertyCard.tscn")
@onready var properties_container: VBoxContainer= $VBoxContainer/PropertyContainer

#signal sell_property_clicked(cell_id: int)

func set_player(player:Player):
	super.set_player(player)
	

func update_hub():
	super.update_hub()
	update_properties_list(player.properties)
	
func update_properties_list(properties: Array[PropertyCell]) -> void:
	# Delete old button
	for child in properties_container.get_children():
		child.queue_free()

	# Add new buttons
	for prop in properties:
		var button = Button.new()
		button.text = prop.cell_name
		var nb_house:int = 0
		button.pressed.connect(func():
			var property_card:PopUpPropertyCard = PROPERTY_CARD.instantiate()
			property_card.set_card(prop)
			add_child(property_card)
		)
		properties_container.add_child(button)
