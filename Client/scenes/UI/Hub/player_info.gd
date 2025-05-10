extends CanvasLayer


const PROPERTY_CARD = preload("res://scenes/UI/Popups/PropertyCard.tscn")
@onready var property_container: GridContainer = $BackGround/PropertyContainer
@onready var property_card : PopUpPropertyCard = $PropertyCard


func update_properties_list(properties: Array[PropertyCell]) -> void:
	for child in property_container.get_children():
		child.queue_free()

	for prop in properties:
		var button = Button.new()
		button.custom_minimum_size = Vector2(150,100)
		
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.text = prop.cell_name
		button.pressed.connect(func():
			property_card.set_card(prop)
			property_card.visible = true
			add_child(property_card)
		)
		property_container.add_child(button)
		pass

func _on_close_btn_pressed() -> void:
	self.visible = false
