extends Control
class_name Hub

#extends Panel
#class_name  BaseHub
@onready var player_name_lable:Label = $PanelBackground/TopBar/PlayerName
@onready var player_money_lable:Label = $PanelBackground/RightSide/MoneyAmount
@onready var player_bonus: Label = $PanelBackground/LeftSide/AdvantagesContainer/AdvantagesValue
@onready var top_bar: Panel = $PanelBackground/TopBar

var player: Player
var player_color: Color #= Color("a450c7")

func _ready() -> void:
	pass
	#top_bar.self_modulate = player_color
	#var style = top_bar.get_theme_stylebox("panel").duplicate()
	#style.bg_color = player_color
	#top_bar.add_theme_stylebox_override("panel", style)
	#print("hub ready")
	#print(player_color)


func set_player(new_player: Player) -> void:
	if new_player:
		player = new_player
		player_color = new_player.player_color
		
func update_hub() -> void:
	# Update Color
	player_name_lable.text = player.player_name
	player_money_lable.text = str(player.money)
	player_bonus.text = str(player.bonus)
	
	

#const BACKGROUNDS = {
	#1: preload("res://assets/Boarding Cards/Player Boarding Card Violet.png"),
	#2: preload("res://assets/Boarding Cards/Player Boarding Card Bleu.png"),
	#3: preload("res://assets/Boarding Cards/Player Boarding Card Vert.png"),
	#4: preload("res://assets/Boarding Cards/Player Boarding Card Jaune.png")
#}

#func update_panel(
	#player_index: int,
	#player_name: String,
	#player_money: int,
	#departure: int,
	#bonus_summary: int,
	##properties: Array[String]
#) -> void:
	##background.texture = BACKGROUNDS.get(player_index, null)
#
	#if player_name:
		#name_label.text = player_name
	#else:
		#name_label.text = "123"
	#fortune_label.text = str(player_money)
	#position_label.text = str(departure)
	#bonus_label.text = str(bonus_summary)
#
	## Clear old property buttons
	#for child in property_container.get_children():
		#child.queue_free()
#
	## Add new property buttons
	##for name in properties:
		##var button := Button.new()
		##button.text = name
		##button.focus_mode = Control.FOCUS_NONE
		##button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		##property_container.add_child(button)
