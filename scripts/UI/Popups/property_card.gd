extends CanvasLayer
class_name PopUpPropertyCard

@onready var cell_owner: Label = $BackGround/Description/Cell_owner
@onready var property_name: Label = $BackGround/Description/PropertyName
@onready var property_cost: Label = $BackGround/Description/PropertyCost
@onready var property_rent: Label = $BackGround/Description/Rent
@onready var number_of_house: Label = $BackGround/Description/NumberOfHouse
@onready var sell_btn: Button = $BackGround/SellButton
@onready var buy_house_btn: Button = $BackGround/HBoxContainer/BuyHouseButton
@onready var sell_house_btn: Button = $BackGround/HBoxContainer/SellHouseButton
@onready var house_cost_label: Label = $BackGround/Description/HouseCost 
var card: PropertyCell

func _ready() -> void:
	cell_owner.text = "Owner: " + card.cell_owner.player_name
	property_name.text = "Property name: " + card.cell_name
	property_cost.text = "Property cost: " + str(card.price)
	property_rent.text = "Rent: " + str(card.rent)
	card.property_changed.connect(update_property)
	if card is StreetCell:
		card.nb_houses_changed.connect(update_houses)
		number_of_house.text = "Number of house: " + str(card.nb_houses)
		house_cost_label.text = "House cost: " + str(card.house_cost)
		number_of_house.visible = true
		house_cost_label.visible = true
		$BackGround/HBoxContainer.visible = true

func set_card(cell:PropertyCell):
	card = cell

func update_property():
	self.property_rent.text = "Rent: " + str(card.rent)

func update_houses():
	number_of_house.text = "Number of house: " + str(card.nb_houses)

func _on_close_button_pressed() -> void:
	queue_free()

func _on_buy_house_button_pressed() -> void:
	var msg = {"action": "buy_house", "cell_id": card.id_space}
	WebSocketClient.send_message(JSON.stringify(msg))

func _on_sell_house_button_pressed() -> void:
	var msg = {"action": "sell_house", "cell_id": card.id_space}
	WebSocketClient.send_message(JSON.stringify(msg))

func _on_sell_button_pressed() -> void:
	queue_free()
	var msg = {"action": "sell_property", "cell_id": card.id_space}
	WebSocketClient.send_message(JSON.stringify(msg))
