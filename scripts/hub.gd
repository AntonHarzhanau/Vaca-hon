extends Control

@onready var player_money_label = $PlayerMoney
@onready var properties_container = $VFlowContainer
@onready var player_property = $PlayerProperties

signal sell_property_clicked(cell_id: int)

func set_player_money(money: int) -> void:
	player_money_label.text = "Player Money: " + str(money)

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
