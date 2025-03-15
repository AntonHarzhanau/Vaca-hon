extends Control


@onready var hub:BaseHub  = $VBoxContainer/Hub
@onready var properties_container: VBoxContainer= $VBoxContainer/PropertyContainer

signal sell_property_clicked(cell_id: int)

func update(player_name:String, money:int, properties:Array[Cell]):
	hub.update(player_name, money)
	update_properties_list(properties)

func update_properties_list(properties: Array[Cell]) -> void:
	# Delete old button
	for child in properties_container.get_children():
		child.queue_free()

	# Add new buttons
	for prop in properties:
		var button = Button.new()
		button.text = prop.cell_name
		button.pressed.connect(func():
			var msg = {"action": "sell_property", "cell_id": prop.id_space}
			WebSocketClient.send_message(JSON.stringify(msg))
		)
		properties_container.add_child(button)
