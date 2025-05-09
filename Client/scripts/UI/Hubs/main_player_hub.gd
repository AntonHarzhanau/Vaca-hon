@tool
extends Hub
class_name MainPlayerHub


const PROPERTY_CARD = preload("res://scenes/UI/Popups/PropertyCard.tscn")
#@onready var properties_container: VBoxContainer = $VBoxContainer/PropertyContainer
func _ready():
	super._ready()

func set_player(player: Player):
	super.set_player(player)

func update_hub():
	var style = top_bar.get_theme_stylebox("panel").duplicate()
	style.bg_color = player_color
	top_bar.add_theme_stylebox_override("panel", style)
	super.update_hub()

func update_properties_list(properties: Array[PropertyCell]) -> void:
	#for child in property_container.get_children():
		#child.queue_free()
#
	#for prop in properties:
		#var button = Button.new()
		#button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		#button.text = prop.cell_name
		#button.pressed.connect(func():
			#var property_card: PopUpPropertyCard = PROPERTY_CARD.instantiate()
			#property_card.set_card(prop)
			#add_child(property_card)
		#)
		#property_container.add_child(button)
		pass
