extends CanvasLayer


const PROPERTY_CARD = preload("res://scenes/UI/Popups/PropertyCard.tscn")
@onready var property_container: GridContainer = $BackGround/MarginContainer2/ScrollContainer/PropertyContainer
@onready var property_card : PopUpPropertyCard = $PropertyCard

@onready var player_name:Label = $BackGround/Player_Name
@onready var properties_cost:Label = $BackGround/MarginContainer/VBoxContainer/Properties/Label2
@onready var money:Label = $BackGround/MarginContainer/VBoxContainer/Money/Label2
@onready var total: Label = $BackGround/MarginContainer/VBoxContainer/TOTAL/Panel/Label2
@onready var total_panel:Panel = $BackGround/MarginContainer/VBoxContainer/TOTAL/Panel
@onready var jail_free_cards: Label = $BackGround/MarginContainer/VBoxContainer/Money2/Label2

func update_info(player:Player):
	update_properties_list(player.properties)
	player_name.text = player.player_name
	money.text = str(player.money)
	total.text = str(player.money + int(properties_cost.text))
	jail_free_cards.text = str(player.bonus)
	var style = total_panel.get_theme_stylebox("panel").duplicate()
	style.bg_color = player.player_color
	total_panel.add_theme_stylebox_override("panel", style)

func update_properties_list(properties: Array[PropertyCell]) -> void:
	var p_cost = 0
	for child in property_container.get_children():
		child.queue_free()

	for prop in properties:
		p_cost += prop.price
		var button = Button.new()
		if prop is StreetCell:
			p_cost += prop.nb_houses * prop.house_cost
			var stylebox := StyleBoxTexture.new()
			stylebox.texture = prop.group_color
			button.add_theme_stylebox_override("normal", stylebox)
			button.add_theme_color_override("font_color", Color.BLACK)
			

		button.custom_minimum_size = Vector2(150,100)
		button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		button.text = prop.cell_name
		button.pressed.connect(func():
			property_card.set_card(prop)
			property_card.visible = true
			add_child(property_card)
		)
		property_container.add_child(button)
	properties_cost.text = str(p_cost)

func _on_close_btn_pressed() -> void:
	self.visible = false
	
func show_property_card():
	property_card.visible = true
	property_card.layer = 100 
