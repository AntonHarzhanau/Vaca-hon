@tool
extends Hub
class_name MainPlayerHub


const PROPERTY_CARD = preload("res://scenes/UI/Popups/PropertyCard.tscn")
#@onready var properties_container: VBoxContainer = $VBoxContainer/PropertyContainer
#func _ready():
	#super._ready()

func set_player(player: Player):
	super.set_player(player)
	

func update_hub():
	super.update_hub()
	player_info.update_properties_list(player.properties)
	
func _on_panel_background_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		player_info.visible = !player_info.visible
		player_info.update_properties_list(player.properties)
