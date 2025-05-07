extends PopupPanel
class_name PlayerPopup

@onready var close_button = $CloseButton
@onready var stripe = $ColorStripe

@onready var prop_label = $VBox/PropertiesLabel
@onready var building_label = $VBox/BuildingsLabel
@onready var money_label = $VBox/MoneyLabel
@onready var total_label = $VBox/TotalLabel
@onready var bonus_label = $VBox/BonusLabel

const COLORS = {
	1: Color("#a259e6"), # violet
	2: Color("#51c4f0"), # bleu
	3: Color("#65d88e"), # vert
	4: Color("#f2cb05")  # jaune
}

func update_data(
	player_index: int,
	money: int,
	properties_value: int,
	buildings_value: int,
	bonuses: Array[String]
):
	var total = money + properties_value + buildings_value

	prop_label.text = str(properties_value)
	building_label.text = str(buildings_value)
	money_label.text = str(money)
	total_label.text = str(total)

	var bonus_text = ", ".join(bonuses) if bonuses.size() > 0 else "None"
	bonus_label.text = bonus_text

	stripe.color = COLORS.get(player_index, Color.WHITE)

func _on_CloseButton_pressed():
	hide()
