extends Hub
class_name GuestHub

const PLAYER_POPUP = preload("res://scenes/UI/Popups/PlayerPopup.tscn")

@onready var money_label := $PanelBackground/RightSide/MoneyAmount
@onready var player_popup := PLAYER_POPUP.instantiate()

var player_id: int

func _ready() -> void:
	if not has_node("PlayerPopup"):
		add_child(player_popup)
		player_popup.name = "PlayerPopup"
	
func set_player(player: Player):
	super.set_player(player)
	

func update_hub():
	super.update_hub()
	var style = top_bar.get_theme_stylebox("panel").duplicate()
	style.bg_color = player_color
	top_bar.add_theme_stylebox_override("panel", style)
	player_name_lable.text = player.player_name
	player_money_lable.text = str(player.money)

func show_player_popup():
	#var popup = preload("res://scenes/UI/Popups/PlayerPopup.tscn").instantiate()
	#add_child(popup)
#
	#var money = player.money
	#var properties_value = player.properties.size() * 100 # exemple simple
	#var buildings_value = 0 # à calculer si tu as un champ dans PropertyCell
#
	#popup.update_data(
		#player.index,
		#money,
		#properties_value,
		#buildings_value,
		#player.bonuses # doit être Array[String]
	#)
	#popup.popup_centered()
	pass
